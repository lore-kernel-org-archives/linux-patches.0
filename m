Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE4FF23EA92;
	Mon, 27 Oct 2025 19:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593502; cv=none; b=PdMNkV8SnK8t3aABvGx7PZP9/V7sPj/mcXdznLJ62k1izjvqSxw6MDfjqcxEJ56+c9bLXBFgM8MtOrgqAg4QfmnNSJS033Jr93DaFjWhH32wwA/H16wGDgVF+E9U78qusjKYCNkpIGaNRPC6ClSJAyNC1TpBl1bzuHlLvVPf0P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593502; c=relaxed/simple;
	bh=tymrxLwtcXEH6V7L/NItgAlG468UVodCtOsfEVahOUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHCPKX2tLiR5MLT3AYrwHoqcy7J0XYRjgjm9aQ7r2SI5Nn40Z3UqCsNxYbPr2FTvDbGbgxMO5I4GFUYai0V/bZ1wLQbmpOcqX/PRDPOh3uuKpqQDMv4zlwrLFU6g9d6IgPK+AJyiiQ99ZoRDjFymtAquM7hDBwGQa9rWLbpFOlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=su50qCdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="su50qCdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F680C4CEF1;
	Mon, 27 Oct 2025 19:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593502;
	bh=tymrxLwtcXEH6V7L/NItgAlG468UVodCtOsfEVahOUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=su50qCdOD0CLtloy+/joIAPqhk8gQjn9rsHyIY/XFJNw9Z5lYgfzhdcM96ptXhG83
	 PNXhent1cuFMNTFziBn+E9R2K4/IY6mPJdat0PCgh26d9V7Pbc2co8nc+5d8C75vbz
	 7rVee1TwRicwO3cYemvB484TPWqiNfGbrV1lxVPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tim Guttzeit <t.guttzeit@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>
Subject: [PATCH 6.17 152/184] usb/core/quirks: Add Huawei ME906S to wakeup quirk
Date: Mon, 27 Oct 2025 19:37:14 +0100
Message-ID: <20251027183519.025590491@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>

commit dfc2cf4dcaa03601cd4ca0f7def88b2630fca6ab upstream.

The list of Huawei LTE modules needing the quirk fixing spurious wakeups
was missing the IDs of the Huawei ME906S module, therefore suspend did not
work.

Cc: stable <stable@kernel.org>
Signed-off-by: Tim Guttzeit <t.guttzeit@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20251020134304.35079-1-wse@tuxedocomputers.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -467,6 +467,8 @@ static const struct usb_device_id usb_qu
 	/* Huawei 4G LTE module */
 	{ USB_DEVICE(0x12d1, 0x15bb), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
+	{ USB_DEVICE(0x12d1, 0x15c1), .driver_info =
+			USB_QUIRK_DISCONNECT_SUSPEND },
 	{ USB_DEVICE(0x12d1, 0x15c3), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
 


