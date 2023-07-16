Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF218F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF2FC433C8;
	Sun, 16 Jul 2023 20:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540234;
	bh=FyInWm0q1Wkpii3gFFMCFUgbcTHa3j4jUVZVbCaa/6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIZlS6cX0cv5Qsnn4W2HywTuXvP/qzkNqFUs/EWUI1ZhwND1l9EtuuAKXR8DNw0vE
	 P0qxiD7ZB7gA6A5Nh2zAcECTE8v7UCsxlBvJF+wUVXhycWN80fN0HKZMyFMUvyF96F
	 HpbQX7IkjwJJpiOI19BReEB+ltwBXlCrlTDdY/OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 291/591] platform/x86: lenovo-yogabook: Set default keyboard backligh brightness on probe()
Date: Sun, 16 Jul 2023 21:47:10 +0200
Message-ID: <20230716194931.422305644@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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

[ Upstream commit 9e6380d6573181c555ca1b5019b08d19a9ee581c ]

Set default keyboard backlight brightness on probe(), this fixes
the backlight being off after a rmmod + modprobe.

Fixes: c0549b72d99d ("platform/x86: lenovo-yogabook-wmi: Add driver for Lenovo Yoga Book")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230430165807.472798-5-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/lenovo-yogabook-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/lenovo-yogabook-wmi.c b/drivers/platform/x86/lenovo-yogabook-wmi.c
index 5948ffa74acd5..d57fcc8388519 100644
--- a/drivers/platform/x86/lenovo-yogabook-wmi.c
+++ b/drivers/platform/x86/lenovo-yogabook-wmi.c
@@ -295,6 +295,9 @@ static int yogabook_wmi_probe(struct wmi_device *wdev, const void *context)
 	}
 	data->backside_hall_irq = r;
 
+	/* Set default brightness before enabling the IRQ */
+	yogabook_wmi_set_kbd_backlight(data->wdev, YB_KBD_BL_DEFAULT);
+
 	r = request_irq(data->backside_hall_irq, yogabook_backside_hall_irq,
 			IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING,
 			"backside_hall_sw", data);
-- 
2.39.2



