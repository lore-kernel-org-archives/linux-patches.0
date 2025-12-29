Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C128E331201;
	Mon, 29 Dec 2025 16:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025266; cv=none; b=bBRmtpzt+8b2hvtasz813XL+QyE1xvsZWIKVOHtDk6pMcHg0lQymcP7b3ocpHJg/BHdiWPahKHtZZ4yUHtNhcZ3W4+1KTWG7Zj1VvrfGEyeOj+KHB0siYuRq30daFTnTqbvhQGNXK7GxXkxkyGgf2/P+TljvVRFBkk/vTIyyCTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025266; c=relaxed/simple;
	bh=vU1bU0bA7D1ZXZu3PJ7gy5VxPKE6nX23eWrbhL03SEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqD5IWmhq9WP+zzbZZlOfSQH3iz16gOqOO+wEh/kMKt3bVHi/l9FFiJQptG+UTZO9zCt6EzmHlH1ZtMK9Lltbs6d73zpaaOyQ/t9CNTXD8VNudFGju0kkSa1URkxs5PL3eZxxrjbcGN//RzLAuHXZUk9mVDti4tQf8h8WC1JzQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMNkbb10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMNkbb10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDB4C4CEF7;
	Mon, 29 Dec 2025 16:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025265;
	bh=vU1bU0bA7D1ZXZu3PJ7gy5VxPKE6nX23eWrbhL03SEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMNkbb1052Y5fG70SkFZ0S3h/iBpjvBe0iNwotuUTF/WlHT0WN4muwuoCM4y9nZv/
	 FvqHazv+hvZ3Uz6+h3M9MJT+PYxTRTUwbCIJwYJIFlnjF28eW4uWykluTJwFVngwWq
	 hsmnOT8bTBFA6uF7ulosxeBJzKIUKHT0u/vWZkCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoffer Sandberg <cs@tuxedo.de>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 152/430] Input: i8042 - add TUXEDO InfinityBook Max Gen10 AMD to i8042 quirk table
Date: Mon, 29 Dec 2025 17:09:14 +0100
Message-ID: <20251229160729.953818118@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoffer Sandberg <cs@tuxedo.de>

commit aed3716db7fff74919cc5775ca3a80c8bb246489 upstream.

The device occasionally wakes up from suspend with missing input on the
internal keyboard and the following suspend attempt results in an instant
wake-up. The quirks fix both issues for this device.

Signed-off-by: Christoffer Sandberg <cs@tuxedo.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251124203336.64072-1-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1169,6 +1169,13 @@ static const struct dmi_system_id i8042_
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "X5KK45xS_X5SP45xS"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
+					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
 	 * after suspend fixable with the forcenorestore quirk.


