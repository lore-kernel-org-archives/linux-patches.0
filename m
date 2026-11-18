Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033567;
	b=WyCAhfuwK+BRzSTLGA1jkI68wG+SArpAbGimF4r4PqyqknJ2Poe3oI2z87ohg2bZxsul
	 YitTxUffROyv19QoKwmq7ZAamIhwMoJdF0l6GrIRovaxqfmE19XwJ0/o5KlUXOmmmI70r
	 m8uonI9kn1e+6w/EG/pMDyapbz0jT+FCW194/LJos9woD1J5ha21WxGWSyhnC73gqpw9V
	 bKd4o3109R9ldyH/Un+rt6gwq5gEun4CVeWKpYG/6gWVDCq4xwtjMjO4w9rkGeWZULZlP
	 nvLmQq93wFLLPUUaJM34Y8RkRlm6TqK3KgkrehxBdsetpzZAbVtRmE5m7QRIUm0SUgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0uF+Qu6Joq2mcffW+r88BZj8VINH552Vre5Xp7hcZP0=;
	b=HYeQPY1DA1dqV5x25px/Ot9vMa9sOVdG+1iK/NWWKCB/nH1dHl0+KptSatSIJmqHW9mF
	 4pAZH1wrHHeAN6dN3Do6nGpHrM7kDGY0fXv7NIO578SqcYzLjOAZdp6sXNPJSFdAjw4c0
	 sRSAcdMXN3aJ8Y6v/TkdS5l3BbiKPOT+5zRFiZg+qMRbTvli7LXW7iOVzqnfMNB/Mab2Y
	 lP54/Yk15rZwekwq8s212iKo4naJp4tq7eaFmrMo4Ussi5LgY84dg3/sOTjsYV1Yq+xhG
	 l4yyyac3UFsFQBYhUORTaCRSBeI8UnBDSI2nnMqFq4cbXcsJh0n4N5lmVrrs3p7Iy8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2eJi/4yq";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21DE606A335;
	Wed, 18 Nov 2026 20:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2eJi/4yq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A021F000C5;
	Wed, 18 Nov 2026 20:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033566;
	bh=0uF+Qu6Joq2mcffW+r88BZj8VINH552Vre5Xp7hcZP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2eJi/4yqjhY5WQtesuIOTFQ856l96bfMqvbGnBiqi86+1eIXVqv2gLxpI4OGfzmTZ
	 dLZd+PIOMxwC3dXZBIvP/ao94tzQmsIxD1OyMoWLrKT6oaufskfwenCqvp32sqV6zk
	 2azApWxm220DbjT2ijnHB0eZrd9bbntnd2gBBe5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0059/3318] soundwire: dmi-quirks: Disable ghost Realtek on Asus Expertbook
Date: Wed, 18 Nov 2026 15:11:21 +0100
Message-ID: <20261118150315.733847895@linuxfoundation.org>
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 90af3209742db61a7f9d7d054a16165818cfc6d8 ]

The Asus Expertbook B9406CAA also has a Realtek device in the ACPI that
doesn't exist in the physical hardware. This confuses the machine driver
into attempting to create DAI links for the device. Add a quirk to
remove this device.

Closes: https://github.com/thesofproject/linux/issues/5828
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260630081132.3294488-1-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 32a46a2d90f7c..2a98fc8c104d6 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -178,6 +178,13 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		.driver_data = (void *)hp_omen_16,
 	},
 	/* PTL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "B9406CAA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
-- 
2.53.0



