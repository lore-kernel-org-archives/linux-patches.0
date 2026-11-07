Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060879;
	b=sE/Tf/x4pY+18jgDq8q56oUKiXB4Pl7leJw4yZWFI5dXJMppXu6NGrmU0iH1rZVY4gPm
	 Bh/fTGhqh8mZMlqgvtph2w0OuqomRhZiJQMkPgPQIbYKZPTn2+tl8SBiD4nhhUg1vuKW4
	 TOGz/bMmLByRLUnJ1kN/0RaM35b6kBGR6ENF8Udvni6lq0P8/bOj1j4/LSfJaj/x0PG9E
	 5BosLXtHbhisuf1BI1v5fifDhYZNgDnN336vjHmOLfqGHMosVqeWYgMe+f+GFMz8ZvbVo
	 nP6qLPRar5LD4FOTztn/rHbraliR71rXkp7zsTb9PmrmzWm63MJWhMox3eTa3740jnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YY4/VrQa3aPUxRk8SQvWytkLA3BtP6vfukqBTJd5Zp0=;
	b=mcNQIUNlnfbTuu9Ftqy3D+eJbDArhncV6m/KJOgBvOKriDDX0icgv/Dduf8z5Hfv8ppX
	 te0fn59pq7Mvr2okUq4sLZCMdtgkre8TxVmMTXOJGYLvBiotRlP2Ed7DzoGC2jzFx+cCI
	 SPNW6M5XQsOayPqWvHgOupHmqKmJyeyVwM6fUfaTX0PVmsvJpuskfMuIRgTxYRwEIf1wB
	 iMDM5F+PTRfGhnoLDzwJ1kya85qO4PCcKTw9VgTMp0FtrX787NClIPR+8ee6pDw9yjufk
	 Urm7pkwNDynIYd+XyP7jFfZdDD5MjHDm2GmsK/SVzoiAjC/DSnREtzO8Et5STfb+bBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OA4UpDuO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA40D606D80D;
	Sat,  7 Nov 2026 14:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OA4UpDuO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED241F0089F;
	Sat,  7 Nov 2026 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060878;
	bh=YY4/VrQa3aPUxRk8SQvWytkLA3BtP6vfukqBTJd5Zp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OA4UpDuOReSX3puSvnYt3aWmv4iSGrXaAFSCHRAiRa5IseMQxumT7rNGdn5jWdvcJ
	 zc6yvo//NfoV/m6C9i2MR41hMj6JvKh5KnJnPlYBJGmnVl51WaYvZgJk9AlOjqPxrz
	 Yhj87GouDhliQnKqeM4kvCGoF0rLMHy3wtoFrHOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0259/1536] HID: logitech-hidpp: Add support for G502 X Plus USB mouse
Date: Sat,  7 Nov 2026 08:37:55 -0500
Message-ID: <20261107135004.959773354@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>

[ Upstream commit 6f4b44abe4ccdcfdab75c9493b8c7634fee37133 ]

The wireless dongle is already supported, this adds detection for
the mouse in wired mode. Supports battery reporting.

Signed-off-by: Stuart Hayhurst <stuart.a.hayhurst@gmail.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index c84bd26faea96..25cdf5ebccb3b 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4643,6 +4643,8 @@ static const struct hid_device_id hidpp_devices[] = {
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC082) },
 	{ /* Logitech G502 Lightspeed Wireless Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC08D) },
+	{ /* Logitech G502 X Plus Wireless Gaming Mouse over USB */
+	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC095) },
 	{ /* Logitech G703 Gaming Mouse over USB */
 	  HID_USB_DEVICE(USB_VENDOR_ID_LOGITECH, 0xC087) },
 	{ /* Logitech G703 Hero Gaming Mouse over USB */
-- 
2.53.0



