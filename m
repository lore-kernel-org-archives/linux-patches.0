Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831112;
	b=QWSYVJGJQReU3VQ/DpS8E8YXdn3O97ffVfCaQMRNt0oYGGBmPfobWJkxnPR2nFKJ0+6t
	 POs98O4hBc5ByLLqPHKPJ5TeRuxqzVanmXKRomXxwVewsRLKzqIDKDIDLv5hrCdbeX3yG
	 KYFWFgSmx9iH1XZ6nWNfYZvcNQZqntq9bnt4xFki58PCedcrz22RSmKQJBIwgTgkKI3V1
	 zlb2UeuuXWA/m7s9ZcdbF9AyglKgH8f3gVrSA441E9tmRbowFtmvMAemfkd8GrRdWjxxi
	 s2/pFexqr0q7d3Q84pbTBnnRmgadBi2Htb1PGJSlJZ+Yo0kN8SGt+yAZZXAWKTyUHlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q8eB8AEqYpdyE6xqHgQno1+IwUgGmNKS7cASiWAg6rU=;
	b=5sduMOPB0BPb+qSe+2SSzk2z40+9WRRsEegkwXP2CV8tKqLDvG/LsaCyWbG7iXn/6bqp
	 znNm37L8k3/fjVKFLKsXT0uQz3uQexBZ2ta69kkblJtZNeM2MCIWOZH6IWLWORqOWNTkw
	 NrcTVpSWNVKTTC1ANV1FbG+paUi39QUlldALpAtYgZelATXmSC/+yQUBuFBRmSf2VGbkC
	 A+YnQs+KiCawBIDHE+5eUiE/cRs57NSdgGzLSe0GbxXL9zMAQ7i8055UWz9Hf19r/baGs
	 Ead97g0jqGRhInF5cNKP2hKUZD9Z+dcKvZ16hRr33t0jQzwSV5b+zfc3YrPHeoo5dOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o3VGx/Lg";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AE24606B2D8;
	Wed,  4 Nov 2026 22:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o3VGx/Lg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75DD1F000C1;
	Wed,  4 Nov 2026 22:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831112;
	bh=q8eB8AEqYpdyE6xqHgQno1+IwUgGmNKS7cASiWAg6rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o3VGx/Lg9raS5UPGaXsDGzkueRMLfyKwAv9ozMoerCv40AOZFip//R4k1tcPUIJBo
	 y4aXEcvGz41D2jOzlWJC3oPCJiFrY/TQdJcPtBwM3CHRHCS2xKGMoE+nHcqLaeGCcM
	 txtxSXBWGUvlkYR1HLa73yfvVWsIfFZezFPgM18c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Aysel <mehmet4ysel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0471/1005] ASoC: amd: acp-config: Add HVY-WXX9/M1060 DMI quirk
Date: Wed,  4 Nov 2026 16:03:24 -0500
Message-ID: <20261104211057.205152468@linuxfoundation.org>
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

From: Mehmet Aysel <mehmet4ysel@gmail.com>

[ Upstream commit 032bb633e0c34a88b70a4bfc65ebd4e2b510f706 ]

Add DMI match table entry for HUAWEI HVY-WXX9 board, product version
M1060, a MateBook D16 2021 (Ryzen 5 4600H) revision not covered by the
existing M1010/M1020/M1040 entries. This board uses the same
FLAG_AMD_LEGACY / ACP_PCI_DEV_ID configuration as the other HVY-WXX9
variants.

Signed-off-by: Mehmet Aysel <mehmet4ysel@gmail.com>
Link: https://patch.msgid.link/20260825092432.56292-1-mehmet4ysel@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp-config.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/sound/soc/amd/acp-config.c b/sound/soc/amd/acp-config.c
index 365209ea53f36..653e8ce946082 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -159,6 +159,20 @@ static const struct config_entry config_table[] = {
 			{}
 		},
 	},
+	{
+		.flags = FLAG_AMD_LEGACY,
+		.device = ACP_PCI_DEV_ID,
+		.dmi_table = (const struct dmi_system_id []) {
+			{
+				.matches = {
+					DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "HUAWEI"),
+					DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "HVY-WXX9"),
+					DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "M1060"),
+				},
+			},
+			{}
+		},
+	},
 };
 
 static int snd_amd_acp_acpi_find_config(struct pci_dev *pci)
-- 
2.53.0



