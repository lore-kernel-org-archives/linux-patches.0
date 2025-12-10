Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167DF302CBD;
	Wed, 10 Dec 2025 07:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352058; cv=none; b=G6tTKrLYomhpYvgd4bP44kEV1NbIZy+2J2aRXp0zlMGwrNZQdrmhywq3GzcKGXtlKqr+J6Gq/aNFadK0fdB/w0L9mpvGdZy9FaD0ReATOrZh+FlXuA2lx/a6gvOasxVb80CZR/LKVdc0E+LI5FrgWDYjekx2pg+wjciaaqyHjDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352058; c=relaxed/simple;
	bh=dE76XS3AKDBd7s7cQisW6e5eY6MsqPIz+8IZtheSOk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tgmvfH7NCuV2wfq/YJpLlfZhKHb5hW4Dh1oTjKDe68vugTvm07adDvkuVfQw4re5wErwI0jtJcZCFMENKI+ya3seO0QAKbjU089vQjA6YX4B5AgtzpUjg+f37dPCiZ5jZB/X7yiK01nGEAEwcc3lCtO/kpjmXyOxh2ym1y39YDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ks9sM/St; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ks9sM/St"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6BFC4CEF1;
	Wed, 10 Dec 2025 07:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352058;
	bh=dE76XS3AKDBd7s7cQisW6e5eY6MsqPIz+8IZtheSOk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ks9sM/StF5mWIAKSzYb+rJH7OKaIkRwAxEW0epC9L5TrxDYdCsbcP+Vajs/IVs9Tk
	 uDDt/+rrUhzvnZ7thSDhQ5MPm9Dl5U5iU0Cvy1638FIQs8J58lbXUHP9erXXUpnUAB
	 zOzioivrPPYs3P6pXpvhVJapx9AnloxZdhXkzT6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hansg@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Barata?= <andretiagob@protonmail.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 33/60] HID: hid-input: Extend Elan ignore battery quirk to USB
Date: Wed, 10 Dec 2025 16:30:03 +0900
Message-ID: <20251210072948.649915759@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 2c743e35c1d33..bc7de9ef45ecd 100644
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



