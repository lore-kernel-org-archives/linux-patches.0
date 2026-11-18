Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034407;
	b=E6eEncXMoYjyoh6m8NGvLrP93qgzsjLFIe9KCZQdqJ+LFFWrYO3MgoLeKHx4uHqW+zRJ
	 ppRVJ5jJ0AQMoCrmRYAWOlB9ItEGwIHf3ADGwT1VeI0gNRCRXNLHxJqDpZqUaZFMzwIkp
	 rXiYeouWjnP9jUxK84ldktPW2HIMtC2/ElX9q7nQFTdG6XkpDqZ+W7ylZaRC6Z3uHwZOe
	 irnFEWV7snOcs6ETDpftCGt9gedmi3RUeOf6il2R+I9kXlTE3QRDyaPMamej42ldfjb0j
	 5jqAHQ3ExHshcWS+dW2hL/jO97c2CNC0Rpk3jTgm39VjPuNEYEJivbe13eiDTXNjj4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bR2MJ2A+/9Vcg2kiicEGv2FxSIT9xCgDjBgUhDOTeGI=;
	b=TFFqRPqnBelsmV0NaXWmDarlHWBQSTf2My91U3Hp//Log1TLaKCGkpNPRkCa7nT0wFrU
	 JQEQjvwUumWX3ScAcDByNjgb70eEKWf64Y6oKNf79P7fFXy1xQ7CY2cNmXSK0RHYELIOw
	 h9ABeKC5qy2X7rdOICrp8Ub6HZv6/P2yifSZdfD3v4pKrhGCHPc5EkVdQtSqK+g969cJr
	 AziwjoKLpO/r7NQgAngP9wLM45ptU1/2vpn2EyJCCE9KRvDcbtk85bH2eWhBiK40s7Raz
	 XbTTQk/7kgI4dD+QOE7DnN1qSFuhmnfubhC/w/ClcFG/GKtOg5B0IETRSylU/kLQfyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSWwn2O5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E543606A31C;
	Wed, 18 Nov 2026 20:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GSWwn2O5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8E41F000C4;
	Wed, 18 Nov 2026 20:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034406;
	bh=bR2MJ2A+/9Vcg2kiicEGv2FxSIT9xCgDjBgUhDOTeGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSWwn2O51xsZnJ36rAbYOTlBa2Uvdl/0JAtYibO342dqq38aN+OnvVBy5SeCVUCQP
	 OTyn2+VdKB+l+L48BIdM7BtWBPew9M5C5Ddf0RGb7gp+btPggdxj7NXOqznyM9dAiE
	 L6h+p3JNirv8Q/wADhpXEHaihWEAn7QHzPmDFwiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mehmet Aysel <mehmet4ysel@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0331/3318] ASoC: amd: acp-config: Add HVY-WXX9/M1060 DMI quirk
Date: Wed, 18 Nov 2026 15:15:53 +0100
Message-ID: <20261118150325.854305550@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f27c275800091..5ca8001fa420f 100644
--- a/sound/soc/amd/acp-config.c
+++ b/sound/soc/amd/acp-config.c
@@ -61,6 +61,20 @@ static const struct config_entry config_table[] = {
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
 
 int snd_amd_acp_find_config(struct pci_dev *pci)
-- 
2.53.0



