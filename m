Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A15A2A
	for <patches@lists.linux.dev>; Tue, 25 Oct 2022 12:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04041C433D6
	for <patches@lists.linux.dev>; Tue, 25 Oct 2022 12:32:44 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jNSWdfu1"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 25 Oct 2022 13:32:41 +0100
Resent-Message-ID: <Y1fXaWTS1txRi6/H@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 24 Oct 2022 18:42:47 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=UIV/=2Z=gmail.com=mendiebm@kernel.org>)
	id 1on1TJ-005K9n-3x
	for broonie@sirena.co.uk; Mon, 24 Oct 2022 18:42:47 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id ABFDBB8119C
	for <broonie@sirena.co.uk>; Mon, 24 Oct 2022 17:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 6F117C433D6; Mon, 24 Oct 2022 17:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 84B65C433B5
	for <broonie@kernel.org>; Mon, 24 Oct 2022 17:42:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 84B65C433B5
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id e18so32850070edj.3
        for <broonie@kernel.org>; Mon, 24 Oct 2022 10:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=XVuWbfAQNF7o8tY+FUjntd4BtEqKHgEbwYupJmXfPzQ=;
        b=jNSWdfu1c1zIwJqfwTl2ypRfT5G0cT7KaHsjoZMSo5EX5QsBYFbu3oloYWzPxYuMqS
         alBRLws2jcsc/gf1nPOE64Mn2XKyFkRXVMaFq3WE+FvP77g6Rb+mhwPExUcm7peIB4vW
         ONiRssssRFy8nqxJESJEPy6RzuGsQuxdgq+vXhZGHcdtPDkPxSIdlD5D6vitU1TETMyl
         G3SNO0Ix3YeQP+T4Zz+tVz5v39pfX7tjLMHkw/RmJCXh4vFqRAddxirQfNNyfEOEsbH8
         xxjQoDK8SFI9/dNXvbjn3Bjejf0N7SirIMM6qY4wmYsOLV/397yPaB2mWSNqU+lnB6T9
         12Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XVuWbfAQNF7o8tY+FUjntd4BtEqKHgEbwYupJmXfPzQ=;
        b=rpNeXHaEFcdEozTRgKTvkBzbfrMW4QXOUM8hjK9U5L92CGIrwBlJRlYuwZBVZiWydp
         fOTX6M+WsiJMxEwvRpStFq2NVmZ8G5DrAdPFq2EOy7zEsA3/Nc26H82fQYaZeE+xt2rb
         Ux6nneSTGd+g2es0HRLORbZyr6cPtyRCDKw/wQ5gawFP4DLT4w0WMjKKW0btcKpn71vU
         teoh4BfKPWMdGjFbIOqzOHR6kbTajwldh2ge9rec3AqKghJpyOKvJD5rw3vL1lx40AXd
         aCLu/ZnhtOiXgnKqrHxXBvson8kzxAS3oua6DYlX2a1K8g7J/T+U1L6pMJFrzEi8qzz+
         7Vyw==
X-Gm-Message-State: ACrzQf3qV1e2QPOzvoc4mavPH2wCPlsQ5j4bOPbWTjsjLbUjD8mzWPva
	MosEXvidWXHN43y8CIXWkCY=
X-Google-Smtp-Source: AMsMyM7LPndgC61ilqd4BgQfiaWkB0clqS6ENrbal3vIDrdwMTiaaYaVYxzrTfo1Ziq4jnC2G69I3w==
X-Received: by 2002:a05:6402:2794:b0:461:d60c:30c7 with SMTP id b20-20020a056402279400b00461d60c30c7mr4316218ede.392.1666633360755;
        Mon, 24 Oct 2022 10:42:40 -0700 (PDT)
Received: from aw-m17.localdomain (cpc91250-cmbg18-2-0-cust153.5-4.cable.virginm.net. [82.8.243.154])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090640c700b0073d7bef38e3sm191219ejk.45.2022.10.24.10.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 10:42:40 -0700 (PDT)
From: Brent Mendelsohn <mendiebm@gmail.com>
To: alsa-devel@alsa-project.org
Cc: mario.limonciello@amd.com,
	Syed.SabaKareem@amd.com,
	broonie@kernel.org,
	Brent Mendelsohn <mendiebm@gmail.com>
Date: Mon, 24 Oct 2022 18:42:27 +0100
Message-Id: <20221024174227.4160-1-mendiebm@gmail.com>
X-Mailer: git-send-email 2.37.3
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=UIV/=2Z=gmail.com=mendiebm@kernel.org
Subject: [PATCH] ASoC: amd: yc: Add Alienware m17 R5 AMD into DMI table
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: M/4Ocga/4qyk

This model requires an additional detection quirk to enable the
internal microphone - BIOS doesn't seem to support AcpDmicConnected
(nothing in acpidump output).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=216590
Signed-off-by: Brent Mendelsohn <mendiebm@gmail.com>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 2cb50d5cf1a9..a868a890f00c 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -185,6 +185,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "UM5302TA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Alienware"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Alienware m17 R5 AMD"),
+		}
+	},
 	{}
 };
 
-- 
2.37.3

