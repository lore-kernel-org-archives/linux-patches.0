Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F1D7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBC4C433EF;
	Mon, 24 Apr 2023 13:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343001;
	bh=3dVPcMbV3ggeR+q8y8Q6SKl2kZ8tYqnwVf4u6VuwgMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXbZ2zyzPpeHMrYXBOCFbV7au2i7gvDonC6C7aa+1H0geafRfnKyo/rIEkIECgNnN
	 J2YhmYix7hDZDAHYJZnaKppy/u9zhKqXj/xTIFDbTOf4QOsKyoRDwlWkhPAIvxJURg
	 eRL2BDzyTlt9L6TPWjESP4mDDrgU+kIqnWImSG3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Crawford <frank@crawford.emu.id.au>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 040/110] platform/x86 (gigabyte-wmi): Add support for A320M-S2H V2
Date: Mon, 24 Apr 2023 15:17:02 +0200
Message-Id: <20230424131137.665636232@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frank Crawford <frank@crawford.emu.id.au>

[ Upstream commit b7c994f8c35e916e27c60803bb21457bc1373500 ]

Add support for A320M-S2H V2.  Tested using module force_load option.

Signed-off-by: Frank Crawford <frank@crawford.emu.id.au>
Acked-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20230318091441.1240921-1-frank@crawford.emu.id.au
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 322cfaeda17ba..4dd39ab6ecfa2 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -140,6 +140,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 	}}
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("A320M-S2H V2-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
-- 
2.39.2



