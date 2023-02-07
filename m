Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19242F39
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF24C433D2;
	Tue,  7 Feb 2023 13:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775492;
	bh=n8Hio6+XVc1JL+1LkjfNJWCmSJmAHqg6Y5zxk4lWsec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yjWpTWXgl9sjZLwUHtAGksxm+PY5kDJeva1Z/e3SrxbnJ6hrTMubFoGmGVSG3JjIX
	 R0kHEAOSDYKwIUqx4HLANOIcTWus1DVLhldxx7zY8FsvbbRwSQWUwLnpWRiTeMvWiZ
	 VJGEFd9iaTD0a3VmhqgC97cUcVeH/VBrIh6IPhkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Kuriakose <kevinmkuriakose@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/120] platform/x86: gigabyte-wmi: add support for B450M DS3H WIFI-CF
Date: Tue,  7 Feb 2023 13:57:10 +0100
Message-Id: <20230207125621.267460194@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kevin Kuriakose <kevinmkuriakose@gmail.com>

[ Upstream commit a410429a3b7e748a9db9f357e71e2e085a21c902 ]

To the best of my knowledge this is the same board as the B450M DS3H-CF,
but with an added WiFi card. Name obtained using dmidecode, tested
with force_load on v6.1.6

Signed-off-by: Kevin Kuriakose <kevinmkuriakose@gmail.com>
Acked-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20230119150925.31962-1-kevinmkuriakose@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index ebd15c1d13ec..0163e912fafe 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -141,6 +141,7 @@ static u8 gigabyte_wmi_detect_sensor_usability(struct wmi_device *wdev)
 
 static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H-CF"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M DS3H WIFI-CF"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B450M S2H V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE AX V2"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550 AORUS ELITE"),
-- 
2.39.0



