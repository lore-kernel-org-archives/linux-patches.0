Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181E1AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D3AC433EF;
	Wed,  4 Jan 2023 16:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849370;
	bh=3BGaD82kiYMk6MEGp8L5K/lw5Pyr41ws2r/LCvbbx5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NmxMMRAJr9wnVeC7k3Vrust70Jlvvad9qKlKcD8gDU0EyNhPlfRxtHfkzeOPh9U2n
	 Ob312GWktW6+axrUM3k8JNQSj05LA9yibFaARQZQk3TeZmwyReRNCgu2t5qKHfXbI+
	 6REgl98c1qJ8kkH98z4m8JYokN1ScM9BZLSqWrhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rijo-john Thomas <Rijo-john.Thomas@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 6.0 110/177] crypto: ccp - Add support for TEE for PCI ID 0x14CA
Date: Wed,  4 Jan 2023 17:06:41 +0100
Message-Id: <20230104160510.977145823@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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
@@ -381,6 +381,15 @@ static const struct psp_vdata pspv3 = {
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
@@ -426,7 +435,7 @@ static const struct sp_dev_vdata dev_vda
 	{	/* 5 */
 		.bar = 2,
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
-		.psp_vdata = &pspv2,
+		.psp_vdata = &pspv4,
 #endif
 	},
 	{	/* 6 */


