Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829365;
	b=Y588HsAZVgSnpLhxuZChukvZzJqomdQVcpD0ktccrTa3vNUaKiaisiDDUR1+lCg4uP29
	 6+r9fvMRLReP6pwJaObIv684MbnIHIq6ofF8BUgqEOo0cxVSx8JzgDXXRybPj50EDea4o
	 cw4NrRqi1wD//cjCM9b480QCBQ2X1xmbvGpEELJrpYjW+sXC944Arjh3QJrWOLPZ23Jof
	 sTdnAspa82zcNhf8Hbrq7TpAs+jsSPgnvq4smYJQvDq0CgR2jPc0Do/RcAlvmllNuFZn2
	 nWhc9/JicMZciVDwWciMZUa96S+lNIYeShoNnB/4rnBY9V2ijDS+mU1xB24rx3wyCgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829365;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=etRBwbWZwf2dqkTt7MSe/Bt3rSkDIC9fTTLGUW8pa1Q=;
	b=bfH/Bnfx3j51T78rsODbYX7LP0be+WncK+OjOXX9aucrxVpGPmu2/r1cr9bJf74+o+mP
	 25Gvw73YYFidszRjsiPsNtXpoFpA2RkZidMWayLKCCT34SkOyaMFTivmhWpFa+Slx/r5Y
	 XlxAnmk4DNmULVsPJbsjW0W1M0qFgHdaDk2QznshCDxuWqIDN4kIHmJhxOXrb/RaTFhsI
	 WdCHwCXgEMQzjL1T0LdonkUzPJE5eZk6K3mT+3yWnC8R36ZHTwzNbAMns/oVPBf7IumdD
	 mD6dKo70u70oJa3qT84ecWDIB25hFnIcn3ueSP6G2wi/s0YSt8a45S08eyFkzOkyHjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4UgPmj1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4790360BF2DE;
	Wed,  4 Nov 2026 21:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j4UgPmj1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8161F00919;
	Wed,  4 Nov 2026 21:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829365;
	bh=etRBwbWZwf2dqkTt7MSe/Bt3rSkDIC9fTTLGUW8pa1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4UgPmj1U1aGy7kb5eOh0KCm8rMYbzazJsOnOJrAlKhp3CA+Dd6yYNvFUKXl/ZO03
	 dB+AgdMrefKgbHWwAxvivLEAgCoWZ076/h6xlXeTv25NvzkF4p/EIbGsxxIIUZoIHT
	 i+w8TR6khQ4Ib3tmtndsYCfQwhr/LY5N5rqBUKCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Philip Yang <philip.yang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0079/1005] drm/amdkfd: add sanity check in svm_range_is_valid
Date: Wed,  4 Nov 2026 15:56:52 -0500
Message-ID: <20261104211045.830486538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit aa7e29cf9a37092cf5057a612ee09f28df20258f ]

to prevent svm range to be overflow or underflow.

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Reviewed-by: Philip Yang <philip.yang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 202ed1c456320..1b29dee7948d8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -3421,7 +3421,13 @@ svm_range_is_valid(struct kfd_process *p, uint64_t start, uint64_t size)
 	unsigned long start_unchg = start;
 
 	start <<= PAGE_SHIFT;
-	end = start + (size << PAGE_SHIFT);
+
+	if (size == 0)
+		return -EINVAL;
+
+	if (check_add_overflow(start, size << PAGE_SHIFT, &end))
+		return -EOVERFLOW;
+
 	do {
 		vma = vma_lookup(p->mm, start);
 		if (!vma || (vma->vm_flags & device_vma))
-- 
2.53.0



