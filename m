Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F9F28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A80C433EF;
	Mon, 30 Jan 2023 14:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088098;
	bh=Fcn/r9dV8QpXQTFkywTGZbaqDngZT74aX043HmOWkqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwGrTf5l2tAC8jU7tZhTf0WPGf7CMoYgJSKuVS2SHiP2SP1EiMFnP5gWHpNdyUipW
	 7OkAPqnGOxztsnsw88inQPjrzsd4nl1fFUab13w21Ubr2VxJ9Mnm/4e0b6R/PbHL7h
	 g1diLeQMM7N+NEEKo6m1pfb6dtmUB0taIKIk484w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nemcev Aleksey <Nemcev_Aleksey@inbox.ru>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/204] platform/x86: asus-nb-wmi: Add alternate mapping for KEY_SCREENLOCK
Date: Mon, 30 Jan 2023 14:51:20 +0100
Message-Id: <20230130134321.518130070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit db9494895b405bf318dc7e563dee6daa51b3b6ed ]

The 0x33 keycode is emitted by Fn + F6 on a ASUS FX705GE laptop.

Reported-by: Nemcev Aleksey <Nemcev_Aleksey@inbox.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230112181841.84652-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-nb-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/asus-nb-wmi.c b/drivers/platform/x86/asus-nb-wmi.c
index a81dc4b191b7..4d7327b67a7d 100644
--- a/drivers/platform/x86/asus-nb-wmi.c
+++ b/drivers/platform/x86/asus-nb-wmi.c
@@ -521,6 +521,7 @@ static const struct key_entry asus_nb_wmi_keymap[] = {
 	{ KE_KEY, 0x30, { KEY_VOLUMEUP } },
 	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
 	{ KE_KEY, 0x32, { KEY_MUTE } },
+	{ KE_KEY, 0x33, { KEY_SCREENLOCK } },
 	{ KE_KEY, 0x35, { KEY_SCREENLOCK } },
 	{ KE_KEY, 0x40, { KEY_PREVIOUSSONG } },
 	{ KE_KEY, 0x41, { KEY_NEXTSONG } },
-- 
2.39.0



