Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973D0226D0B;
	Mon, 10 Mar 2025 17:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627899; cv=none; b=p7BBNsCMsYg4XO3Gaq2WtUCKHkJ3+d1TIgR8GgEPF3guJyTLR0H5T+fqBV/0BKP0/KqcHdxurroryXuUG0E2cPQEUKVbdBW07EZ13bEVJrTYejA+WK10Ecx/tJtZfr8IhPvSIuElSUUrqbMw5s7tu4ULCWGbW9PBdkB2DcT6D3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627899; c=relaxed/simple;
	bh=lL1ZHpLixLlPzoi/ujzPbluKeOMDxEHFbkuLBMxcELU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bC1ST5uc+I36Zhnxf0mgZYtTUjcs358d13c9MoigpygSuFz0P6s7RskofsJONX+XbjKXGGpd4DMFvxAMl70mMnEK8p1oruSoj6xu0mJ8snzZIH0ebM9SD+yCS28kLlSpCwMwR9poRbXhDlWjywcgnduD2X4RpPwtZMAR6cQjNUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+bQQ8k8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+bQQ8k8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E5DC4CEE5;
	Mon, 10 Mar 2025 17:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627899;
	bh=lL1ZHpLixLlPzoi/ujzPbluKeOMDxEHFbkuLBMxcELU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+bQQ8k8aNzdDlWDApzNFzsKR/QmyvJTvqWmrbJR865xutY9YWWePw+03zFIzPTr6
	 fR27c+vbGUiBTn7gnFRaBkoIth0gc0DHWvS6fEgp0A6wPKqdkt3Y/tVdgEkfeucOXx
	 nfAdGF+42CM8YpJI00uT9ecSwyancYjpnMKBuizs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/145] riscv: cacheinfo: Use of_property_present() for non-boolean properties
Date: Mon, 10 Mar 2025 18:05:13 +0100
Message-ID: <20250310170435.517417282@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit fb8179ce2996bffaa36a04e2b6262843b01b7565 ]

The use of of_property_read_bool() for non-boolean properties is
deprecated in favor of of_property_present() when testing for property
presence.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Clément Léger <cleger@rivosinc.com>
Cc: stable@vger.kernel.org
Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Link: https://lore.kernel.org/r/20241104190314.270095-1-robh@kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cacheinfo.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/riscv/kernel/cacheinfo.c b/arch/riscv/kernel/cacheinfo.c
index d32dfdba083e1..9fb97c9f9b0be 100644
--- a/arch/riscv/kernel/cacheinfo.c
+++ b/arch/riscv/kernel/cacheinfo.c
@@ -103,11 +103,11 @@ int populate_cache_leaves(unsigned int cpu)
 	if (!np)
 		return -ENOENT;
 
-	if (of_property_read_bool(np, "cache-size"))
+	if (of_property_present(np, "cache-size"))
 		ci_leaf_init(this_leaf++, CACHE_TYPE_UNIFIED, level);
-	if (of_property_read_bool(np, "i-cache-size"))
+	if (of_property_present(np, "i-cache-size"))
 		ci_leaf_init(this_leaf++, CACHE_TYPE_INST, level);
-	if (of_property_read_bool(np, "d-cache-size"))
+	if (of_property_present(np, "d-cache-size"))
 		ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
 
 	prev = np;
@@ -120,11 +120,11 @@ int populate_cache_leaves(unsigned int cpu)
 			break;
 		if (level <= levels)
 			break;
-		if (of_property_read_bool(np, "cache-size"))
+		if (of_property_present(np, "cache-size"))
 			ci_leaf_init(this_leaf++, CACHE_TYPE_UNIFIED, level);
-		if (of_property_read_bool(np, "i-cache-size"))
+		if (of_property_present(np, "i-cache-size"))
 			ci_leaf_init(this_leaf++, CACHE_TYPE_INST, level);
-		if (of_property_read_bool(np, "d-cache-size"))
+		if (of_property_present(np, "d-cache-size"))
 			ci_leaf_init(this_leaf++, CACHE_TYPE_DATA, level);
 		levels = level;
 	}
-- 
2.39.5



