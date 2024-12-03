Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E4C207A1F;
	Tue,  3 Dec 2024 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240258; cv=none; b=cZgAMUCUbVO3f7a8UtNIqh7RtERZI14BGg7lC43GcfxEHwqUt2Emct7TJSCMhbQeytIhl2lYWYrS+f1AtQdL9GoMtb+OVYgJz2cskgLrMYHob6io3NU+MW5ycbF5oLaNMxfxMMmIgJFFv+xM2kEiKTmAdLr7ThpZD9xNHMm0/30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240258; c=relaxed/simple;
	bh=bzUiGeAid51mNPW9M5cRHlZpwsGE6/vakIwq9bGxEnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkjvGw/6NoTbCv1FTV8QfgOLT0Jn289XvBlspvVvBYXCPY3FXFytINQM4zCaZVEMw48ts65aDxpJsknd02MrkjTXhtzpavPOGce/oKQYg/FJsfcLz97HK+qTBHWHfFh40JNjgC73l8tihu3AqNKcQW16l+/sc3Nh7UN/8Q1xh/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+ZUgzAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+ZUgzAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD708C4CECF;
	Tue,  3 Dec 2024 15:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240258;
	bh=bzUiGeAid51mNPW9M5cRHlZpwsGE6/vakIwq9bGxEnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n+ZUgzAM3Hg6zSJo4LUhoq3lWsDLRzqc886/H6DNHTsq4xB3XiIUPOo+QCZ+pMnRZ
	 rQrGwQSyJcDESW23DZwO9zvuEVWdgecXzijgnNZZMtLEqy7MmCZJgJEJVskI2PqCeK
	 EGkVhak/XR5W4wyqoW5GmBs8CvqLG1WtAfnvJuIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Stange <nstange@suse.com>,
	Michal Suchanek <msuchanek@suse.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.12 078/826] crypto: aes-gcm-p10 - Use the correct bit to test for P10
Date: Tue,  3 Dec 2024 15:36:45 +0100
Message-ID: <20241203144746.512250879@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 3574a5168ff3b6bddc4cd235878491f75967c8d4 ]

A hwcap feature bit is passed to cpu_has_feature, resulting in testing
for CPU_FTR_MMCRA instead of the 3.1 platform revision.

Fixes: c954b252dee9 ("crypto: powerpc/p10-aes-gcm - Register modules as SIMD")
Reported-by: Nicolai Stange <nstange@suse.com>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Michael Ellerman <mpe@ellerman.id.au> (powerpc)
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/crypto/aes-gcm-p10-glue.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/aes-gcm-p10-glue.c b/arch/powerpc/crypto/aes-gcm-p10-glue.c
index 4a029d2fe06ce..f37b3d13fc530 100644
--- a/arch/powerpc/crypto/aes-gcm-p10-glue.c
+++ b/arch/powerpc/crypto/aes-gcm-p10-glue.c
@@ -414,7 +414,7 @@ static int __init p10_init(void)
 {
 	int ret;
 
-	if (!cpu_has_feature(PPC_FEATURE2_ARCH_3_1))
+	if (!cpu_has_feature(CPU_FTR_ARCH_31))
 		return 0;
 
 	ret = simd_register_aeads_compat(gcm_aes_algs,
-- 
2.43.0



