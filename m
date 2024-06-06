Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C181A0B14;
	Thu,  6 Jun 2024 14:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683661; cv=none; b=uGGPQ52/Ck/lEOP2IYpNQsxVfcdPAX1mx1ReP5dH6TXNuhfXCqn9f1VpN7ladKKoga88ZUNnwMYknwm0yCG1HRXATjNnhbBoskjj+G9LIQTShHepfLHlHVdxQcYC+nFWSoNV2jUk8HhLMm/a+OYl8xyJH3ZSvCSX8Uuy7y4rk6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683661; c=relaxed/simple;
	bh=HN1WbdLgdseWk4gGVD99e22W4/lCPpR8gTyWJlsHdLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RCPw4LcVXjlLnDjfpvmHWuW0tXQ9tvV9tWAko8uFxXX63mk8EctjdP2r7P4hEc0UpXdXe56zM7wvRQXA9BjDR9Z/j0st0uGYcMxX+oo5Spl//LlIBAM+uF2y6QvitHavBF3N28CEeIaE4sNuKp0m+GgnDkpvf5EexMgCTQ3ZpLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIzHEro9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIzHEro9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC17C32782;
	Thu,  6 Jun 2024 14:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683660;
	bh=HN1WbdLgdseWk4gGVD99e22W4/lCPpR8gTyWJlsHdLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIzHEro9FzZA3aCp1/XOmS0IRqN3eOnIAuc/klH9TQN+/glOZHeeOIp/l/M+6vxeC
	 LgYiIzg7Gx26CGPbhJP77oL++tnTR8MG4yQuZPXWu/xxhzwzld5GaJ5fQeAJT/Vmxg
	 P+qceTCGnb8cBEpXUYDoOE9PXDRwjWxITA+6GeD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 541/744] s390/boot: Remove alt_stfle_fac_list from decompressor
Date: Thu,  6 Jun 2024 16:03:33 +0200
Message-ID: <20240606131749.806526155@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit e7dec0b7926f3cd493c697c4c389df77e8e8a34c ]

It is nowhere used in the decompressor, therefore remove it.

Fixes: 17e89e1340a3 ("s390/facilities: move stfl information from lowcore to global data")
Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/startup.c | 1 -
 arch/s390/kernel/setup.c | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/s390/boot/startup.c b/arch/s390/boot/startup.c
index d08db5df60913..655bbcff81ffd 100644
--- a/arch/s390/boot/startup.c
+++ b/arch/s390/boot/startup.c
@@ -31,7 +31,6 @@ unsigned long __bootdata_preserved(max_mappable);
 unsigned long __bootdata(ident_map_size);
 
 u64 __bootdata_preserved(stfle_fac_list[16]);
-u64 __bootdata_preserved(alt_stfle_fac_list[16]);
 struct oldmem_data __bootdata_preserved(oldmem_data);
 
 struct machine_info machine;
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index de6ad0fb2328a..d48c7afe97e62 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -155,7 +155,7 @@ unsigned int __bootdata_preserved(zlib_dfltcc_support);
 EXPORT_SYMBOL(zlib_dfltcc_support);
 u64 __bootdata_preserved(stfle_fac_list[16]);
 EXPORT_SYMBOL(stfle_fac_list);
-u64 __bootdata_preserved(alt_stfle_fac_list[16]);
+u64 alt_stfle_fac_list[16];
 struct oldmem_data __bootdata_preserved(oldmem_data);
 
 unsigned long VMALLOC_START;
-- 
2.43.0



