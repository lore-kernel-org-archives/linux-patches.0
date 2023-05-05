Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CB819A
	for <patches@lists.linux.dev>; Sat,  6 May 2023 00:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB816C433D2
	for <patches@lists.linux.dev>; Sat,  6 May 2023 00:19:06 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=system76.com header.i=@system76.com header.b="EcZAUYMa";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="VrKscWGE"
Resent-From: Mark Brown <broonie@finisterre.sirena.org.uk>
Resent-Date: Sat, 6 May 2023 09:19:04 +0900
Resent-Message-ID: <ZFWc+GWUvE0CvPXj@finisterre.sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Fri, 05 May 2023 17:15:58 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=MwR7=A2=system76.com=tcrawford@kernel.org>)
	id 1puy66-00En1A-T5
	for broonie@sirena.co.uk; Fri, 05 May 2023 17:15:58 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 67A0663F0D
	for <broonie@sirena.co.uk>; Fri,  5 May 2023 16:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id E06CDC433EF; Fri,  5 May 2023 16:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A7E9C433D2
	for <broonie@kernel.org>; Fri,  5 May 2023 16:15:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 3A7E9C433D2
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=system76.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=system76.com
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.nyi.internal (Postfix) with ESMTP id 31D195C022D;
	Fri,  5 May 2023 12:15:50 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 05 May 2023 12:15:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=system76.com; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to; s=fm3; t=1683303350; x=1683389750; bh=A6EN8YSiV6
	gv5iSARizot8tHgSmTROTbBSMxUb3UYwo=; b=EcZAUYMa2xwIAO0qgaoYHlS+VQ
	XaHxxB4DplXbhNTlUi5bbbUQVUBu7/kJa1EEZlDiI2Fu6ApsgV48mhVwDILWJa4/
	xWnfBbrX5Qz4HtAjcS1s+9wkt8C0QsYfRxpo5dmSbuE7QBIet8EATKDYnQOnklKh
	WFxrUzPuagH7305NiMEcohX8we6z7VrVbeAntZ3nJYYPKz+CNTVbw2Jv8aT5tgY/
	4x/e0MGGgYWhsx7pKR5++CYzltf3oAATCwz2rqclxVX2jfzdA7NFoRgapEH/ISq1
	dxszqadBgt8vugAl6mUreyQ69Uq/Y7CHYbgUx9cnS1I9FKV7NVkXHFc/U1cA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683303350; x=1683389750; bh=A6EN8YSiV6gv5
	iSARizot8tHgSmTROTbBSMxUb3UYwo=; b=VrKscWGEhLh4ywR2+edQpzNGbJyIx
	1CrSiXXkcH8b0IDxVv2bwBGB9AKGgmJ6pcUz/FRWt+ScIruHiHYgqzlrU1E++SwH
	jMTvKlMu7/itsAtv+U9C0R+u/ka35He0vyc52BhL8ERqrSlY+SM07NjqzWBdt0sI
	9smWXdCnO7n8tKVNaeAr55Glu6Zta3b4QEzE2zGdeEhQcWK4jMYJRGdpnbu+vWpk
	B0P/0poKxp1AVBOmaZ+ilMX4tj78QsXxkrjeY96OMKRExv2zJOoZfH9mcVsb36aH
	+mXxxv1AvfKXS1zmmVvDmU1qNeukeilD2cCBFH9CFXD7OoIcAGUl/lnVA==
X-ME-Sender: <xms:tStVZANxOgSu9MUfd4onFYvjEC1Q-ecjIuzdMIBsbByPeiyeL_OXnQ>
    <xme:tStVZG_sJF_mXQYiTYUr6frtokXiWpaXmY3t2Z31V1yk75Wp8PanY-uxYB45oyJDH
    iborKZjmf0w9e4GtA>
X-ME-Received: <xmr:tStVZHS92N4MpGCrM3h5gsb4EOR2gpLRjnuZRkAl89fvQbMtePNDyClU6XjzlQCuQJPaJXv1b9nF9yZeWAHZdjqeNBkMP52zovedTOIqiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeefvddguddttdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefvihhmucev
    rhgrfihfohhrugcuoehttghrrgiffhhorhgusehshihsthgvmhejiedrtghomheqnecugg
    ftrfgrthhtvghrnhepkefgteefvdeivdfhffdtfffgieffhfetgeduudekieefueeutdel
    fedtveeuheefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepthgtrhgrfihfohhrugesshihshhtvghmjeeirdgtohhm
X-ME-Proxy: <xmx:tStVZItOUiAJfmKedefgPpdFuGgxmyOykqTyhiTYWUMXHNRzcYYSHw>
    <xmx:tStVZIcXBOSxbiKdqhnC_cWMP9r4encyeK-zIRky2bIKGUcWS-2kQA>
    <xmx:tStVZM3qOwbEh553ucsQSWfxM0ibdY_0QTiO3ncOwtjUclWrhyG5dw>
    <xmx:titVZA791yyQVEj5aWAQsLpZ5qkUOKb7ucgafKo6DmUHYrDOMC3UxA>
Feedback-ID: i1761444e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 5 May 2023 12:15:49 -0400 (EDT)
From: Tim Crawford <tcrawford@system76.com>
To: alsa-devel@alsa-project.org
Cc: broonie@kernel.org,
	productdev@system76.com,
	Jeremy Soller <jeremy@system76.com>,
	Tim Crawford <tcrawford@system76.com>
Date: Fri,  5 May 2023 10:14:58 -0600
Message-Id: <20230505161458.19676-1-tcrawford@system76.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=MwR7=A2=system76.com=tcrawford@kernel.org
Subject: [PATCH] ASoC: amd: yc: Add DMI entry to support System76 Pangolin 12
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: kT11BFbxR9OY

From: Jeremy Soller <jeremy@system76.com>

Add pang12 quirk to enable the internal microphone.

Signed-off-by: Jeremy Soller <jeremy@system76.com>
Signed-off-by: Tim Crawford <tcrawford@system76.com>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index b9958e555367..84b401b685f7 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -297,6 +297,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8A22"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "System76"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "pang12"),
+		}
+	},
 	{}
 };
 
-- 
2.40.1

