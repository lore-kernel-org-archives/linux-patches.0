Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E93225D8F9;
	Tue, 11 Mar 2025 15:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705889; cv=none; b=oh23y7Xsi50qShwGzCR5u5Wzcj1yL+wrx30qAoW2e80iTUStCRqwbr/LtR247bk3JY2jFQYI29Da4eGxT8Hbk5GHaykySxXT7Z9LJ6Aw/T4VtI7AolWmFKiUc+iJmXVWpEVZ1MX68/4cfAYJpW/schtTyOi/vWmknSV0X20rPlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705889; c=relaxed/simple;
	bh=m6GNFnZK+EqB+5UwBheXVT/AfejnbgbXUXVznenE/3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqyLqlL67mhCsx/oqAiey4CR/2o10CPA2KCxoqRm4QdZk7Cfb2jg5EPAjWsK86Vphymh6borlOEgpDrDvm+Ji446OQN4FTAxkJidLerce1MO/8PIYMDqeab9WYi5BIx3l/iN3Xz4eMrgS5hRHNlnnt+9kA8icyeEd4z0FgI8pSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mVesuLnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mVesuLnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE8FC4CEE9;
	Tue, 11 Mar 2025 15:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705889;
	bh=m6GNFnZK+EqB+5UwBheXVT/AfejnbgbXUXVznenE/3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mVesuLnlGkAz6ZZoLYKd6CZ7WKyIZGkuRpw4Y4uXAL9BQH3kV/ZLART0HF+eerRoI
	 rhCmuHBE9SnPdIU1cSljSx0WEIkxhso9WiLhmqxqSw8pt/7j7s3wk4F7+OBJnNShG8
	 3qfuCKmy7tPI4c+1aVPs5+edKGT9Osn+GNsH+b4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lei Huang <huanglei@kylinos.cn>,
	stable <stable@kernel.org>
Subject: [PATCH 5.4 182/328] USB: quirks: add USB_QUIRK_NO_LPM quirk for Teclast dist
Date: Tue, 11 Mar 2025 15:59:12 +0100
Message-ID: <20250311145722.135590790@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lei Huang <huanglei@kylinos.cn>

commit e169d96eecd447ff7fd7542ca5fa0911f5622054 upstream.

Teclast disk used on Huawei hisi platforms doesn't work well,
losing connectivity intermittently if LPM is enabled.
Add quirk disable LPM to resolve the issue.

Signed-off-by: Lei Huang <huanglei@kylinos.cn>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20250212093829.7379-1-huanglei814@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -520,6 +520,9 @@ static const struct usb_device_id usb_qu
 	/* Blackmagic Design UltraStudio SDI */
 	{ USB_DEVICE(0x1edb, 0xbd4f), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Teclast disk */
+	{ USB_DEVICE(0x1f75, 0x0917), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Hauppauge HVR-950q */
 	{ USB_DEVICE(0x2040, 0x7200), .driver_info =
 			USB_QUIRK_CONFIG_INTF_STRINGS },


