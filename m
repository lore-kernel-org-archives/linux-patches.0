Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D9496FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C36CC433EF;
	Tue, 10 Jan 2023 18:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375254;
	bh=1GYX4rcTlTlO4xZYif1UtAs4At3lx9yHql0m5LHf4JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5qPJogOnPkyyPSNKjMhkaqGPuJC9r2Iif1atxRB9BaCbQOiVU+WDJV4cpujdqF+m
	 8k2OaOVjTVSF/vTcpL4XLegbnyYgEkVQQ/MY0COT3dnnkOWgl8ITogR8u0oKVMtupl
	 84fbhpklRsuwqJNGl80F3sDV2qLPG4beBDwznyGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rijo-john Thomas <Rijo-john.Thomas@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15 128/290] crypto: ccp - Add support for TEE for PCI ID 0x14CA
Date: Tue, 10 Jan 2023 19:03:40 +0100
Message-Id: <20230110180036.246152950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

commit 10da230a4df1dfe32a58eb09246f5ffe82346f27 upstream.

SoCs containing 0x14CA are present both in datacenter parts that
support SEV as well as client parts that support TEE.

Cc: stable@vger.kernel.org # 5.15+
Tested-by: Rijo-john Thomas <Rijo-john.Thomas@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/ccp/sp-pci.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -320,6 +320,15 @@ static const struct psp_vdata pspv3 = {
 	.inten_reg		= 0x10690,
 	.intsts_reg		= 0x10694,
 };
+
+static const struct psp_vdata pspv4 = {
+	.sev			= &sevv2,
+	.tee			= &teev1,
+	.feature_reg		= 0x109fc,
+	.inten_reg		= 0x10690,
+	.intsts_reg		= 0x10694,
+};
+
 #endif
 
 static const struct sp_dev_vdata dev_vdata[] = {
@@ -365,7 +374,7 @@ static const struct sp_dev_vdata dev_vda
 	{	/* 5 */
 		.bar = 2,
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
-		.psp_vdata = &pspv2,
+		.psp_vdata = &pspv4,
 #endif
 	},
 };


