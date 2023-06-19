Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22073538F
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:58:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F832C433C0;
	Mon, 19 Jun 2023 10:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687172289;
	bh=cvUXelMzF38OTQJtlUNiI1s3Y/1GcJFa15Toj7XBVvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oFWElOdik6r9dxmBSc9sOdqFiLSArEJ/4Aqo5rT5RoEKZ+Tpj0ea2TouX2mO5Pho/
	 Pg80dNovJ5CD2PSrF3+FSZ7EVh3CgUi46UztD5/jo29yHghJN87OIfp6VPmxq1r51/
	 z2kRoiJCtZV7DHNVQZGsWsvwoRSkCQelpZPO5NEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandru Sorodoc <ealex95@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/107] platform/x86: asus-wmi: Ignore WMI events with codes 0x7B, 0xC0
Date: Mon, 19 Jun 2023 12:29:59 +0200
Message-ID: <20230619102142.264318151@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102141.541044823@linuxfoundation.org>
References: <20230619102141.541044823@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandru Sorodoc <ealex95@gmail.com>

[ Upstream commit 362c1f2ec82cb65940e1c73e15a395a7a891fc6f ]

On ASUS GU604V the key 0x7B is issued when the charger is connected or
disconnected, and key 0xC0 is issued when an external display is
connected or disconnected.

This commit maps them to KE_IGNORE to slience kernel messages about
unknown keys, such as:

    kernel: asus_wmi: Unknown key code 0x7b

Signed-off-by: Alexandru Sorodoc <ealex95@gmail.com>
Link: https://lore.kernel.org/r/20230512101517.47416-1-ealex95@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index 4d7327b67a7db..2c43801a18a28 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -550,6 +550,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x71, { KEY_F13 } }, /* General-purpose button */
 	{ KE_IGNORE, 0x79, },  /* Charger type dectection notification */
 	{ KE_KEY, 0x7a, { KEY_ALS_TOGGLE } }, /* Ambient Light Sensor Toggle */
+	{ KE_IGNORE, 0x7B, }, /* Charger connect/disconnect notification */
 	{ KE_KEY, 0x7c, { KEY_MICMUTE } },
 	{ KE_KEY, 0x7D, { KEY_BLUETOOTH } }, /* Bluetooth Enable */
 	{ KE_KEY, 0x7E, { KEY_BLUETOOTH } }, /* Bluetooth Disable */
@@ -575,6 +576,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0xA6, { KEY_SWITCHVIDEOMODE } }, /* SDSP CRT + TV + HDMI */
 	{ KE_KEY, 0xA7, { KEY_SWITCHVIDEOMODE } }, /* SDSP LCD + CRT + TV + HDMI */
 	{ KE_KEY, 0xB5, { KEY_CALC } },
+	{ KE_IGNORE, 0xC0, }, /* External display connect/disconnect notification */
 	{ KE_KEY, 0xC4, { KEY_KBDILLUMUP } },
 	{ KE_KEY, 0xC5, { KEY_KBDILLUMDOWN } },
 	{ KE_IGNORE, 0xC6, },  /* Ambient Light Sensor notification */
-- 
2.39.2



