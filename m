Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66218186294;
	Fri, 15 Nov 2024 06:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653322; cv=none; b=AJx+6C5GJDMKUDjZSm66VVoiGoctx+w2fatP4BQ687f+XJdnFdBr2lcWTwIhHhoa8XeHJRguCmQ9Set4nQTA9S25LIMIE9Y6pZ6twiKUNoVxQEY1U9ZRJvRIzFVdbJEFDDvlCkhFQU/Yi3p3mNJo5eRSYfDemvkvcAWtb19Z0oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653322; c=relaxed/simple;
	bh=s4S8x/v5Y8vAVJMTfRP3BftDpM5zKNbn7dOak2WRv3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hT0FqHMXj/WVbucRZB8m7i8xycdXx5X+lifeKYi4M6TO8meCNXGt/S9xpMbUeAv+uAJTSLQsHFZonjAfJkZW9dUKuQSMoy5mQ0Ra5GfgV59Sd4D/fR++W2X2WaS4oM1t3iMtMzzMruBzwWp9g6jmwIzvl6YsSpwvFXp0eR0d92A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kl9/Nlue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kl9/Nlue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAABC4CECF;
	Fri, 15 Nov 2024 06:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653322;
	bh=s4S8x/v5Y8vAVJMTfRP3BftDpM5zKNbn7dOak2WRv3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kl9/NluezdmoUzx2MRMpwWr6R9oOHEcTu49MNTkGnKv/tGp+DsaAr/cz8U4gh2PCz
	 c20Uj5mSoiUzvFEhln/BDNkrqlZzxjGoATYAumNTye9h86H9zYgy27hDubDHmoQBBo
	 Z+K8q21h13zOHk6iK82UhNit6Gpw6O9/30PyoFrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yanteng Si <siyanteng@cqsoftware.com.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 52/63] LoongArch: Use "Exception return address" to comment ERA
Date: Fri, 15 Nov 2024 07:38:15 +0100
Message-ID: <20241115063727.790066555@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.892410236@linuxfoundation.org>
References: <20241115063725.892410236@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yanteng Si <siyanteng@cqsoftware.com.cn>

[ Upstream commit b69269c870ece1bc7d2e3e39ca76f4602f2cb0dd ]

The information contained in the comment for LOONGARCH_CSR_ERA is even
less informative than the macro itself, which can cause confusion for
junior developers. Let's use the full English term.

Signed-off-by: Yanteng Si <siyanteng@cqsoftware.com.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/loongarch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/loongarch.h b/arch/loongarch/include/asm/loongarch.h
index 04a78010fc725..ab6985d9e49f0 100644
--- a/arch/loongarch/include/asm/loongarch.h
+++ b/arch/loongarch/include/asm/loongarch.h
@@ -256,7 +256,7 @@
 #define  CSR_ESTAT_IS_WIDTH		14
 #define  CSR_ESTAT_IS			(_ULCAST_(0x3fff) << CSR_ESTAT_IS_SHIFT)
 
-#define LOONGARCH_CSR_ERA		0x6	/* ERA */
+#define LOONGARCH_CSR_ERA		0x6	/* Exception return address */
 
 #define LOONGARCH_CSR_BADV		0x7	/* Bad virtual address */
 
-- 
2.43.0



