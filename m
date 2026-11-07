Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061074;
	b=EhteKAbPcIgk3xVnbkP73Nn1fX/pCiCtVWNPkemCcgbtvqqEPxLNFuRsTIpuh78Of42Z
	 6puC+1iRaUEq7WBEUczMwAFtKwwmbQnawMxs40VlHb59RUmcpWpvV8hXEGXo2aXJzf38B
	 YHMHYHg5V2RH4OAVCT1PRYyEBSVifmlaeugLsvUPaEzaSCKDlOChX8GosUfctauXyeeHT
	 I4hREBni//WTZA/+UAT5LQGuEGv5blDjjmw7ptjzwzgz8HvvhVpQxcYfk1XfF3Zl9Yxv0
	 FV0YT5LI8nyc9dmS1KgJHQ4cpa00+d/uisrpMMq+GfCqKxEBWj47hzy80nw2L3XhMMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5ejBnC4EwKyAAnMKpX2iz/MNaOH8gYcqKZeqU0bhLjY=;
	b=pgISLLkxRiHNkki1q/VUHghiFq3ZuyMt45LcSdF73lN61OI4OTzFtBQVI+FJw4XwISsi
	 hrE1UCNRMKYdblwiph2kvNZeDrsQDu047p6OblVBSiKIhGkEskEQWVcvcshHZ4MgpmK00
	 7a1+4s3fA5TdAGKQ2KBCoKGGsolL1unEcKixqHnSGesHewOiTto7RKAbBf7mWYq4NCAQR
	 U7Z2gzs0gINZ3BtAPPTEoYJ0+ypwx9K1QolZZBVfKKeYGaEgP2Q9XYPSn2F+bZyC2cyJt
	 BGOFmSHt3zFaqX6X1IHNfr+Zu+W1Fp6z7UXAEzDXQ9qP7fGlR3C7qzWWdyU4bsDLAcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uewv+CcK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31858606A33A;
	Sat,  7 Nov 2026 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uewv+CcK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27221F0089F;
	Sat,  7 Nov 2026 14:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061074;
	bh=5ejBnC4EwKyAAnMKpX2iz/MNaOH8gYcqKZeqU0bhLjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uewv+CcKnkz4qCjboP3dP/f3U51QXegXchyw3E1hwD7Ht9vZq06IBLRDNyOnC3QCm
	 odp1bBhgL/WZ6pc5yvF3VpLi1mZAQ4xJ2K3RHxFvpi1p4qzi3wna7VRqU6SXWjLyuy
	 JAd035Qi8bBrF5yREImSX7rNv/de6rOsqTxac8cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Aysel <mehmet4ysel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0399/1536] ASoC: amd: acp-config: Add HVY-WXX9/M1060 DMI quirk
Date: Sat,  7 Nov 2026 08:40:15 -0500
Message-ID: <20261107135008.795526711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



