Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF051E86C;
	Mon,  1 Apr 2024 16:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989541; cv=none; b=Vpl370FuFxE/4N4myeLoH/aSIUMEwoMOtN/n6VEuMkqNIYH6V756h1YCXw+zyzVUxR2TwSbHUfJk/IXGO+stI6LGQjjipXQIilBEBnR5MfTDaXZZLBkgjAU8ZNWyVhNdsLhhEk6rjX7ksmjzpAOdBHW0eMnK9e70Xh4TGW1i/yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989541; c=relaxed/simple;
	bh=PVjJgtWMrt0SqM0Js8+gRIBh0y6af2xDj/qspcR7rj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qtLcVua/4w9KkstlTAb5cd9AvnpjWqzMpJj6BA6lGa7xzARkSdMYKBPAFYSpaHN2GQ9NwY7tg7Y13FG1ik7a9xElWj06T6x5zZWtjMtGEXLGu3o07heMGT8Qfy4xILQNbEstP1gb1/g1Nl0JkDracp38SSFMn/KQq7TXqvMnWT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l3KpF0GF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l3KpF0GF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3B9C433C7;
	Mon,  1 Apr 2024 16:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989541;
	bh=PVjJgtWMrt0SqM0Js8+gRIBh0y6af2xDj/qspcR7rj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3KpF0GFCX4U7NqI7BB9aWvrwLRaCxHdo9kd+PhubHPuxIaoqaUZg/2uk+UAO9eeq
	 7PpxzyoPImKbWoktJMHLvVtdjt2o4VAMIxH5h1AOtFruWTbUjvxl8V1cO1PDPTW/Nw
	 t1/SVIKSS/2zmaHWAcBU4sKBhKoQXTesl7nHccC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Toru Katagiri <Toru.Katagiri@tdk.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/396] USB: serial: cp210x: add pid/vid for TDK NC0110013M and MM0110113M
Date: Mon,  1 Apr 2024 17:42:08 +0200
Message-ID: <20240401152550.272583812@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toru Katagiri <Toru.Katagiri@tdk.com>

[ Upstream commit b1a8da9ff1395c4879b4bd41e55733d944f3d613 ]

TDK NC0110013M and MM0110113M have custom USB IDs for CP210x,
so we need to add them to the driver.

Signed-off-by: Toru Katagiri <Toru.Katagiri@tdk.com>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/cp210x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 2169b6549a260..21fd26609252b 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -56,6 +56,8 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x0471, 0x066A) }, /* AKTAKOM ACE-1001 cable */
 	{ USB_DEVICE(0x0489, 0xE000) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
 	{ USB_DEVICE(0x0489, 0xE003) }, /* Pirelli Broadband S.p.A, DP-L10 SIP/GSM Mobile */
+	{ USB_DEVICE(0x04BF, 0x1301) }, /* TDK Corporation NC0110013M - Network Controller */
+	{ USB_DEVICE(0x04BF, 0x1303) }, /* TDK Corporation MM0110113M - i3 Micro Module */
 	{ USB_DEVICE(0x0745, 0x1000) }, /* CipherLab USB CCD Barcode Scanner 1000 */
 	{ USB_DEVICE(0x0846, 0x1100) }, /* NetGear Managed Switch M4100 series, M5300 series, M7100 series */
 	{ USB_DEVICE(0x08e6, 0x5501) }, /* Gemalto Prox-PU/CU contactless smartcard reader */
-- 
2.43.0



