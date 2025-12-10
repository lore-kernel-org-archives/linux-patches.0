Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0725921578D;
	Wed, 10 Dec 2025 07:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351914; cv=none; b=NKs3iMAp/qSgZVIObU01JG25EEYdHYRh6iJNjRrFB56KKWWtYHDxL3DrLgHxPuOq4XmCigY/nbCCZJUHtczk3J3LNFhhKPom+tx2GStdZmncjIwVrKyMZru0xTNQ8Etzz3P6X+UW/gQZeeXXCjK/z/9yAvMXGOzo61esE8jXyQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351914; c=relaxed/simple;
	bh=yR8anhAKa3WNu3yp4tLkr0iY0LWHUTefHnMEj7qGerU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WWC4e3YLBp6nkH+W5aH5oGOvZ/u0pPR7xdsZW8PFUMOHqA0joND40TCHb7alXIupjiM+bgnnKQtKmcs6q8uZmE8gutjn0NDjeAJOlDTs4SxjT9LKCRq/cwoyJRGizh2k/CwPXvvu9OlGMYLhrK/xi5OGaR5LCHThF80jh7M1nNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yf9c0xtg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yf9c0xtg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B21C4CEF1;
	Wed, 10 Dec 2025 07:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351913;
	bh=yR8anhAKa3WNu3yp4tLkr0iY0LWHUTefHnMEj7qGerU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yf9c0xtgWMhyyDQbZDGuXy2dque2rG4uobWJVeG35Fe4m6G04dUqzEIbdJSmeUg9A
	 5CZuzgPvsMBO4oCGZ8kQFMiYfHULUq4N003EjW55L8/0GFLCKXYVfw07qt0CYmTXoQ
	 gGkjw1wCNTLKhfJqhYnjI+qFFuGzS9JXk9TU9j8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Barata?= <andretiagob@protonmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 29/49] HID: hid-input: Extend Elan ignore battery quirk to USB
Date: Wed, 10 Dec 2025 16:29:59 +0900
Message-ID: <20251210072948.886357598@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello (AMD) <superm1@kernel.org>

[ Upstream commit 534ca75e8e3b713514b3f2da85dab96831cf5b2a ]

USB Elan devices have the same problem as the I2C ones with a fake
battery device showing up.

Reviewed-by: Hans de Goede <hansg@kernel.org>
Reported-by: André Barata <andretiagob@protonmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220722
Signed-off-by: Mario Limonciello (AMD) <superm1@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index f073d5621050a..fa3efe9701c96 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -386,10 +386,11 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_CHROMEBOOK_TROGDOR_POMPOM),
 	  HID_BATTERY_QUIRK_AVOID_QUERY },
 	/*
-	 * Elan I2C-HID touchscreens seem to all report a non present battery,
-	 * set HID_BATTERY_QUIRK_IGNORE for all Elan I2C-HID devices.
+	 * Elan HID touchscreens seem to all report a non present battery,
+	 * set HID_BATTERY_QUIRK_IGNORE for all Elan I2C and USB HID devices.
 	 */
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, HID_ANY_ID), HID_BATTERY_QUIRK_IGNORE },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ELAN, HID_ANY_ID), HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.51.0



