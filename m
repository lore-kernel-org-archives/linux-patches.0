Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CEE33EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:55:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9141AC433EF;
	Mon, 16 Jan 2023 15:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884552;
	bh=LG4frrVJORsNpCZ6nTILE+NzxiZUgNPrZQQkD3/1uo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nWq6VAGoykAYcLDB9YZN4uEHquVo3vlR7AgSZX8OXr7ZKYRlSD7XpJUKQjC8tPw0V
	 FWoAmhlOJLoGOw9Vq5Fty8HUJqwj0B853S1VCSZYW5BKQ3L+Hg7YEppW1aXTc8RRDL
	 fXiLmyatu7V7IoCqLMqM++N3d2LOUX5zJ7T3qfVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 050/183] platform/x86: asus-wmi: Dont load fan curves without fan
Date: Mon, 16 Jan 2023 16:49:33 +0100
Message-Id: <20230116154805.481130975@linuxfoundation.org>
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

From: Thomas Weißschuh <linux@weissschuh.net>

commit 01fd7e7851ba2275662f771ee17d1f80e7bbfa52 upstream.

If we do not have a fan it does not make sense to load curves for it.
This removes the following warnings from the kernel log:

asus_wmi: fan_curve_get_factory_default (0x00110024) failed: -19
asus_wmi: fan_curve_get_factory_default (0x00110025) failed: -19

Fixes: a2bdf10ce96e ("platform/x86: asus-wmi: Increase FAN_CURVE_BUF_LEN to 32")
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20221221-asus-fan-v1-3-e07f3949725b@weissschuh.net
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-wmi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2436,6 +2436,9 @@ static int fan_curve_check_present(struc
 
 	*available = false;
 
+	if (asus->fan_type == FAN_TYPE_NONE)
+		return 0;
+
 	err = fan_curve_get_factory_default(asus, fan_dev);
 	if (err) {
 		return 0;


