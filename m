Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145EF79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB84C433C1;
	Wed, 30 Nov 2022 18:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833137;
	bh=r8taBK0juFTsm9rFk+xkwG9CEgBXIN5Wo0LyZmOehcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhsIfcT0GN89fqSuUmjj/6psbzd6/Yo40nWR7o/aLMF6GW/146cIGwqO6Do6aIFlZ
	 0SClTQ0/+uFX6UGSowDQ0QWCxlLzL1MsGYRanFE6B/OmcJm0kp3+F7gyM03qvwXRpC
	 Q2ytDvk0wNoMMS6K/kdNgnRssYeL/6DAOGs5h4OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/162] Input: soc_button_array - add Acer Switch V 10 to dmi_use_low_level_irq[]
Date: Wed, 30 Nov 2022 19:23:37 +0100
Message-Id: <20221130180532.171977470@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
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

[ Upstream commit e13757f52496444b994a7ac67b6e517a15d89bbc ]

Like on the Acer Switch 10 SW5-012, the Acer Switch V 10 SW5-017's _LID
method messes with home- and power-button GPIO IRQ settings, causing an
IRQ storm.

Add a quirk entry for the Acer Switch V 10 to the dmi_use_low_level_irq[]
DMI quirk list, to use low-level IRQs on this model, fixing the IRQ storm.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221106215320.67109-2-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/misc/soc_button_array.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/input/misc/soc_button_array.c b/drivers/input/misc/soc_button_array.c
index 46ba8218de99..31c02c2019c1 100644
--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -77,6 +77,13 @@ static const struct dmi_system_id dmi_use_low_level_irq[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire SW5-012"),
 		},
 	},
+	{
+		/* Acer Switch V 10 SW5-017, same issue as Acer Switch 10 SW5-012. */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "SW5-017"),
+		},
+	},
 	{
 		/*
 		 * Acer One S1003. _LID method messes with power-button GPIO
-- 
2.35.1



