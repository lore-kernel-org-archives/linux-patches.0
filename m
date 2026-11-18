Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043657;
	b=cG+v7kQw5CzvRcOvxp0JeIKxs+I2xpJcT/Gyzd++PVQ11tNm7rHay/4kZrq6bmpBka2h
	 XkmsSRLAI1qMKdmuhsqLwi4PdB6R5avg6/Xc+EmALsmiWdK8gvuedcwfAtdcvXre1VeX2
	 W2qOfdxLpkA2b7Plyk6Zv8UIwY+6voruzuCyA6c9F4Od1qS7qirShWPJZNux1YzV/k+Jg
	 Ps01r+ZJnsfHkCeiq1ftiY20zLrfJPcghWVdwv/LFBeXjYS/wOvXuXmdTDT+yirapE/0Z
	 cGdkZvoCpDw7RO5gP9Ru4FiLrw5bSGW8+TPRdi+guTx+z5lkr6E/+bCf79t+NUzccQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7SXRObYJ6RdmGPJqWywES56IOfRKVOz5uF+5rilANFM=;
	b=GKLT96Zqs9zxod/N8wb4pGeBBV741rGh1TWLM6qB3zZLiiBrM+8yvEuHLKY8edPW6XhI
	 5juMLWCCRu1sucwfu8vPHnW6Kftm+yMczmU8AiIvhLbS8OEGjVphs9YOcpZPbCBdk292N
	 wXkvQn3E9QqyzXW1eVuXaeZV0Gttpa+3RVC1C33B+Im2KtjrNyRE7VYMqktLDyBD34xz9
	 Cg/6sojfyCKiPDaMxo5Rlc9f52yyEJuR59Llgz7vyxtVwNnRn9mJs4U+lIO1hopQAbX+I
	 k/rDHojeRDkJQluJaZmFkBP2QvXDeywCrA+tRRttJUG11fXkvGxzNcWFkt0tu+fr04Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oY8TVVxa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A410606A320;
	Wed, 18 Nov 2026 23:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oY8TVVxa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CC91F000C4;
	Wed, 18 Nov 2026 23:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043657;
	bh=7SXRObYJ6RdmGPJqWywES56IOfRKVOz5uF+5rilANFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oY8TVVxaRmhxw6ro4jWG5XDBooRVCegAyMJZrNizHbZehILhA8gDxsdLBrQwsvmuM
	 /sBFa41C712jGZTjuN6xOxuvVJiJxUVEHEkVZ/ki4pOIsNARpi+tBAxMCwvTtOYG9p
	 resBlc6L6uAoM2Dm5urJ1mzszs8l//CAqDejz5Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Ortiz <letargopausado@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0289/2857] ASoC: amd: yc: Add DMI quirk for Lenovo V15 G6 ARP
Date: Wed, 18 Nov 2026 15:22:03 +0100
Message-ID: <20261118150211.821916994@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Ortiz <letargopausado@gmail.com>

[ Upstream commit d395e1b62d9694f2e4add9122f8d473eacd374aa ]

The Lenovo V15 G6 ARP (product name 83UU) uses the ACP6x PDM interface
for its internal digital microphone array. Its firmware exposes neither
the AcpDmicConnected _DSD property nor the _WOV method, so acp6x_probe()
falls through to the DMI check and returns -ENODEV, leaving
acp_yc_mach.0 unbound and no capture device registered.

Add a DMI quirk entry for this model. With it, the machine driver binds
and the DMIC capture device is created:

  acp_yc_mach acp_yc_mach.0: Enabling ACP DMIC support via DMI
  card 2: acp6x [acp6x], device 0: DMIC capture dmic-hifi-0

Capture was verified working with arecord and PipeWire.

Signed-off-by: Daniel Ortiz <letargopausado@gmail.com>
Link: https://patch.msgid.link/20260920011920.2482786-1-letargopausado@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 8046030dc9576..6cc6dc56b89d3 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -360,6 +360,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "83Q3"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83UU"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



