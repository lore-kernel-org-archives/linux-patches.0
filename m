Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687ED7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE481C433D2;
	Mon, 24 Apr 2023 13:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343014;
	bh=myqHm/MN7G6R3HZTpB1HDaYKPLd2W5Hp9SmjuR0tUOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4fq7+OG8s1AuG8V/h4P6zxIW1gyLYFx2jFmsa+a8q0n13VRgk/zsxTR9aAqfgIpk
	 h5mWosm6Qc1xA75T2/ws5xcVynBY5pbjKZmrpiG2JM1r3gkSUsARz3xq7QWnrD7M47
	 A/UipMuSEZypZlaW3f7wlbwrSWvbWUTwVXWQE49E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	got3nks <got3nks@users.noreply.github.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 045/110] platform/x86: gigabyte-wmi: add support for B650 AORUS ELITE AX
Date: Mon, 24 Apr 2023 15:17:07 +0200
Message-Id: <20230424131137.893445186@linuxfoundation.org>
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

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 441d901fbf669f6360566a4437b1e563b854de4a ]

This has been reported as working.

Suggested-by: got3nks <got3nks@users.noreply.github.com>
Link: https://github.com/t-8ch/linux-gigabyte-wmi-driver/issues/15#issuecomment-1483942966
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20230327-gigabyte-wmi-b650-elite-ax-v1-1-d4d645c21d0b@weissschuh.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/gigabyte-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/gigabyte-wmi.c b/drivers/platform/x86/gigabyte-wmi.c
index 4dd39ab6ecfa2..5e5b17c50eb67 100644
--- a/drivers/platform/x86/gigabyte-wmi.c
+++ b/drivers/platform/x86/gigabyte-wmi.c
@@ -151,6 +151,7 @@ static const struct dmi_system_id gigabyte_wmi_known_working_platforms[] = {
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550I AORUS PRO AX"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M AORUS PRO-P"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B550M DS3H"),
+	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B650 AORUS ELITE AX"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B660 GAMING X DDR4"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("B660I AORUS PRO DDR4"),
 	DMI_EXACT_MATCH_GIGABYTE_BOARD_NAME("Z390 I AORUS PRO WIFI-CF"),
-- 
2.39.2



