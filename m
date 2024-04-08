Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C5E7481A6;
	Mon,  8 Apr 2024 13:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581559; cv=none; b=pmaof6Q6ZuFVgjQ9HPFYoLBiuPRY2O+c8HZ/aQShoCt693z2kLYRp09w0MkB5zkPHCcP3q+FboHvf8nBV+w/n1oJfS6HZMZ0ZbF6jpZ+cm7IAX57d915zomDY0CG7S9SYxzAfAyFMgWf/HOb1f4HdoS704q7CyU9avCKpLzaG+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581559; c=relaxed/simple;
	bh=m4wZOBGScSxs2hBL/xx4rVTO1VhmEQR7usZtiLC+JJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwvXPg7k9f96YxiDZxJuJejGphH6AoypHKyH8xMdfVlfREaJ4mhmBENanjUEUp8ZbMntbkl0GtdpJYSxp7eQw3Vymclo0N1HIe4KBBk9BMGkRHycwAJGnoK7CWmpClnk8DPSzUo5O7J8vbsQIvaURtOfg8mqlBzW0+Uh2p+rHYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aLyChtja; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aLyChtja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA9CAC433C7;
	Mon,  8 Apr 2024 13:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581559;
	bh=m4wZOBGScSxs2hBL/xx4rVTO1VhmEQR7usZtiLC+JJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aLyChtjaDiMrjOZESE4SWl78SQO5wOrw3U9YIP62X+jJ1H49AALG4SjzuyI1dURcR
	 ulrtpwscQ4Qxfq3BUJx04pMvfB5k4cX16b8L8BUbaBuEWF12QEwvLD4GBnv2Cu61El
	 1aC5NodJbJIsXnrRgsgMxE2u0Ky+HMUSqXACKGXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Toru Katagiri <Toru.Katagiri@tdk.com>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 051/690] USB: serial: cp210x: add pid/vid for TDK NC0110013M and MM0110113M
Date: Mon,  8 Apr 2024 14:48:37 +0200
Message-ID: <20240408125401.372631781@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ff814f9298db0..4183942a1c195 100644
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



