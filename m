Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A8B1CAA6F;
	Wed, 19 Feb 2025 08:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954864; cv=none; b=NQ1lNoNdAeruG1InXiZf5TTh7QhrdJ6tDyQuRqzhgvifd4Tmh2Dp3C4G+P+RhUTqOiD/FagYL12GmzR1QlREpe/FXi8Ulov63PLEYU+HbCQsAZ+TOlWj/eLfBMngYp4HKkVYC8gJWPty5yGwu3t2zdAzJwn8g3Bq7fXYvc10pMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954864; c=relaxed/simple;
	bh=MjdayjylWhOzW7jbx1QOZ78BJwpeOKtMilu/1O3dfjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRZdm4tYDVzSpyV3OYJIj03LjfM7ZwiScc4OgO2snRDSu6Qt99mbHta4rMiXxfyL0vx5g4bPKc62Rkd2/XN9nkv6xdm8SQ7/s94tDwmT67SgyqM+KA0V5q0PD3HAZotynIkHKoFcGQ7rJxQICzdOTEvRF7zPPkKjW9Q195IJ9lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N1cFCMSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N1cFCMSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C71C4CED1;
	Wed, 19 Feb 2025 08:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954864;
	bh=MjdayjylWhOzW7jbx1QOZ78BJwpeOKtMilu/1O3dfjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N1cFCMSIDTatAQ2sgIQb/ToIExdhhYmKgGXz8p97I2bNrDccUXbQVqxFTJTtmPYEw
	 XTTwUkpZtpNDrtZxviUC5Xe88Dy8oGRIpp9fKoKQDyag14INz/ZWwiI4wgvZe5+p2R
	 eGCBtDCAzcq9CgAeUrN/mMLnwWdc3ac/XyB0Z4pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 028/230] LoongArch: KVM: Fix typo issue about GCFG feature detection
Date: Wed, 19 Feb 2025 09:25:45 +0100
Message-ID: <20250219082602.807256878@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibo Mao <maobibo@loongson.cn>

[ Upstream commit bdb13252e5d1518823b81f458d9975c85d5240c2 ]

This is typo issue and misusage about GCFG feature macro. The code
is wrong, only that it does not cause obvious problem since GCFG is
set again on vCPU context switch.

Fixes: 0d0df3c99d4f ("LoongArch: KVM: Implement kvm hardware enable, disable interface")
Signed-off-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kvm/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/loongarch/kvm/main.c b/arch/loongarch/kvm/main.c
index 27e9b94c0a0b6..7e8f5d6829ef0 100644
--- a/arch/loongarch/kvm/main.c
+++ b/arch/loongarch/kvm/main.c
@@ -283,9 +283,9 @@ int kvm_arch_enable_virtualization_cpu(void)
 	 * TOE=0:       Trap on Exception.
 	 * TIT=0:       Trap on Timer.
 	 */
-	if (env & CSR_GCFG_GCIP_ALL)
+	if (env & CSR_GCFG_GCIP_SECURE)
 		gcfg |= CSR_GCFG_GCI_SECURE;
-	if (env & CSR_GCFG_MATC_ROOT)
+	if (env & CSR_GCFG_MATP_ROOT)
 		gcfg |= CSR_GCFG_MATC_ROOT;
 
 	write_csr_gcfg(gcfg);
-- 
2.39.5



