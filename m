Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDCB3212
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:03:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF0BC433EF;
	Tue,  7 Feb 2023 13:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775001;
	bh=WN5XNCcaUp6nqDzams28+vaOqySgO2F7e2eKuBhrBE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ISNDaEQcJSHkgqyYZQnw75ydEKEBBasS7HqqxwRnIienBUwBqvxaBrKMxcbwr/0ET
	 4a4pDERraMEMlnZqAYdqxgxZiH5uBoLejADcwJG86S2PbVj4TqPhlMqusvyCAUx2Xe
	 XfbloW4l3g3QR3SOUSymg22ODzlEG6E5OagQs4Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koba Ko <koba.ko@canonical.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/208] platform/x86: dell-wmi: Add a keymap for KEY_MUTE in type 0x0010 table
Date: Tue,  7 Feb 2023 13:55:58 +0100
Message-Id: <20230207125639.062586660@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Koba Ko <koba.ko@canonical.com>

[ Upstream commit 83bcf3e52e9cfc727df33f1055ef0618c91719d0 ]

Some platforms send the speaker-mute key from EC. dell-wmi can't
recognize it.

Add a new keymap for KEY_MUTE in type 0x0010 table.

Signed-off-by: Koba Ko <koba.ko@canonical.com>
Link: https://lore.kernel.org/r/20230117123436.200440-1-koba.ko@canonical.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/dell/dell-wmi-base.c b/drivers/platform/x86/dell/dell-wmi-base.c
index 0a259a27459f..502783a7adb1 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -261,6 +261,9 @@ static const struct key_entry dell_wmi_keymap_type_0010[] = {
 	{ KE_KEY,    0x57, { KEY_BRIGHTNESSDOWN } },
 	{ KE_KEY,    0x58, { KEY_BRIGHTNESSUP } },
 
+	/*Speaker Mute*/
+	{ KE_KEY, 0x109, { KEY_MUTE} },
+
 	/* Mic mute */
 	{ KE_KEY, 0x150, { KEY_MICMUTE } },
 
-- 
2.39.0



