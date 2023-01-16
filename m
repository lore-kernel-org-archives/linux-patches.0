Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA6833EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73165C433D2;
	Mon, 16 Jan 2023 15:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884594;
	bh=HunJVoJrF7ZlDAtfoBMu3YMO+F3WCy/IKfBjDMahwp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keJrar1ppJcs2IVLw2uXowWk4Wqh/Apq4Q5le1Mu4bx76ogFcjDWptHWPH9n4dkC0
	 KG1wTLXmT7/pO50zctBRQ7bw8ueL3yVP+iQDu7MyahZZUeDGp6YQGDtcX4+JnD13b6
	 00xZxVB7kVSnZZFXHYB1gYFkjtXgzIxEF8nJisiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 065/183] platform/x86: ideapad-laptop: Add Legion 5 15ARH05 DMI id to set_fn_lock_led_list[]
Date: Mon, 16 Jan 2023 16:49:48 +0100
Message-Id: <20230116154806.097214103@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

commit f4b7f8febd4d9b615fbec2a06bf352b9c3729b11 upstream.

The Lenovo Legion 5 15ARH05 needs ideapad-laptop to call SALS_FNLOCK_ON /
SALS_FNLOCK_OFF on Fn-lock state change to get the LED in the Fn key to
correctly reflect the Fn-lock state.

Add a DMI match for the Legion 5 15ARH05 to the set_fn_lock_led_list[]
table for this.

Fixes: 81a5603a0f50 ("platform/x86: ideapad-laptop: Fix interrupt storm on fn-lock toggle on some Yoga laptops")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221215154357.123876-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/ideapad-laptop.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -1615,6 +1615,12 @@ static const struct dmi_system_id set_fn
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Legion R7000P2020H"),
 		}
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo Legion 5 15ARH05"),
+		}
+	},
 	{}
 };
 


