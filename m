Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829740;
	b=sXJ0GzBposuDQP+pvh5TS+FGPjzBEzgvdjIrn/xNxENMDgm6o5VNJQD6j0TSYX+MAmJJ
	 af1NZ5oH9zbAOy7rMIGUcQI2UeBjyMHVSGJc++6nBuHhcE8KL80kRFR8KN54rWPUvAKez
	 RQBSfvWC9o3mKlLO0pGkTBhfwzvg0aDKIDzXIHkHCz+yPu1BA6IBn8hWCF43F5lqk0RQU
	 FUAuw6pU17EZjZ62MNe+iN6kF/5k9qLvPKMIT6UKfw8sryw8J+F1Db/sLtEnFttTIt3VO
	 wT0xiYW5SciqFT8MT3z2LxXwdYvqyGOMHcXWDvrO+dR0X1NT4KQdJp+DRcBmvFXUdfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iUnkf1oPuDDX5qTG1BpLK8ykYI9o+1S4Ti6ylj1L3+I=;
	b=A+VofDC0t/Lr03F3ca0XMHu/X7HGhI8zwk9D+DdtiPLrYpsLgBbwiAxdfWRNrjQWqTqV
	 rbe7++YimdxkTAvzlBp9lDGCMVf3+/jI0lspdp9X+fFcvMuPs5EHaZ2pSz339vT59odMs
	 x3eMxiyH+nSVZvDuMH9a1OkQV3oz1GKfnL4ttc8TZzg/LysH9a9SLzkrEoQlctMrZN6Mq
	 yrKyOQ7UgejoRQbhTvrJ+GZ/eUjD9AzAIFBViozXxD90ykBJPJ3nybSSyHNX7vIgll2rQ
	 ud8P7CNpYYPwfO/B9duZdgcv4hyyj7BoIxG3LP75gustvLPLPY0m2Zc9G4L9sCR5WZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDiZanCn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC75606BA25;
	Wed,  4 Nov 2026 22:02:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oDiZanCn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2CE1F00A15;
	Wed,  4 Nov 2026 22:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829740;
	bh=iUnkf1oPuDDX5qTG1BpLK8ykYI9o+1S4Ti6ylj1L3+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oDiZanCnZ88chaUicKkMjoVTEzaZvRJfTaQqZsoTJAOKGe7lBpfvUDsFhFU/x8cY3
	 V6rhosi3XClDJ7mMeE8fJQKVJCEEmYJqNSt0F3Rh9/9dG1bXtPtbQZtqXSmmGFBwNn
	 yuZD/2wNs7f5E75H8zqKnG5mqlFNSVP0JXlueM8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stuart Hayhurst <stuart.a.hayhurst@gmail.com>,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0314/1005] HID: logitech-hidpp: Add support for G502 X Plus USB mouse
Date: Wed,  4 Nov 2026 16:00:47 -0500
Message-ID: <20261104211052.728440362@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a2bb7d8b15b69..a931713a9cb69 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4615,6 +4615,8 @@ static const struct hid_device_id hidpp_devices[] = {
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



