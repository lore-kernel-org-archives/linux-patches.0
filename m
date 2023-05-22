Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03853171A1
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DCAC433EF;
	Mon, 22 May 2023 19:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684783003;
	bh=SFPij9mW/5QXM/6lAuWCAAFQMhaBu82pBitK6JydqyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CgnJcz7KZcxK6EbWLaCXYImUGR0SR8EOhqv7ZDtDaP3BHXdzP+2rrAZWa2VM6GnO7
	 38swdw28sqhnwYCptSZDlCTFyjo6VJ85UjabknL8XVXEfBfAaJpueSU4xoXyifj+n6
	 KIlnkJc9EDcdn4iorjp+ls3GQKm2trO9kZ3zbENI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fae <faenkhauser@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/203] platform/x86: hp-wmi: add micmute to hp_wmi_keymap struct
Date: Mon, 22 May 2023 20:08:50 +0100
Message-Id: <20230522190357.915193062@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
References: <20230522190354.935300867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fae <faenkhauser@gmail.com>

[ Upstream commit decab2825c3ef9b154c6f76bce40872ffb41c36f ]

Fixes micmute key of HP Envy X360 ey0xxx.

Signed-off-by: Fae <faenkhauser@gmail.com>
Link: https://lore.kernel.org/r/20230425063644.11828-1-faenkhauser@gmail.com
Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp/hp-wmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/hp/hp-wmi.c b/drivers/platform/x86/hp/hp-wmi.c
index 2f06e94ef37f7..8c845d263429f 100644
--- a/drivers/platform/x86/hp/hp-wmi.c
+++ b/drivers/platform/x86/hp/hp-wmi.c
@@ -156,6 +156,7 @@ struct bios_rfkill2_state {
 static const struct key_entry hp_wmi_keymap[] = {
 	{ KE_KEY, 0x02,    { KEY_BRIGHTNESSUP } },
 	{ KE_KEY, 0x03,    { KEY_BRIGHTNESSDOWN } },
+	{ KE_KEY, 0x270,   { KEY_MICMUTE } },
 	{ KE_KEY, 0x20e6,  { KEY_PROG1 } },
 	{ KE_KEY, 0x20e8,  { KEY_MEDIA } },
 	{ KE_KEY, 0x2142,  { KEY_MEDIA } },
-- 
2.39.2



