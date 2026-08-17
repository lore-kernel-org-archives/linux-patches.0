Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A20E439F98;
	Mon, 17 Aug 2026 13:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974032; cv=none; b=O7XGW3rYtepfYm/nzZ1fWX3KSwD/ZweNriYaeIu3ViJrFyMIGAto6qguKl9XlA3ITCe5np97Q4WMBV2YUMG+L7FNOr1nhgBV5Xz4eGwQvrNiayhgLaMNtbmlarGUU+RCzKagyb/5MN7KOt+FZZCF+TUGiZt7xDs5rv6pwOezD7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974032; c=relaxed/simple;
	bh=uzn8iDerMGbeBFm6DRw5n4VKLZKa1ZF3rynp4rtej+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlB3CTlNvH1iEQvYRWoKXBNc+V3LZT44LHJGg5YA6N12uCaV75k8dqill3bBMtWNk5Uqzw5jbwC7N1gVscJT1QxF5uQWSzNLQd7VhMUI3e0y0+4PubhXIGBj9Sxtb4n2MoZyI/XoqngnfF/FQgnF4nlqBTPFe5rsDWUmj2ZGouk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEb3CzL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEb3CzL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBB01F00A3A;
	Mon, 17 Aug 2026 13:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974028;
	bh=LGc9BzqXUujZYpTe7SDHdLaVvGi/k5hY51PPSHsLz/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SEb3CzL+RZRohIzxQUCGd02Qmx6oXbT+SPqaVV4EBHi0zchBsEeXmNRwNWkSsRpgF
	 ymxbM7hTzKOPe7EyuGOuc/VGIORj2/du/O0aW9LsAJuazoEXpaLyUQwyfJAZQaaFC0
	 IQB36FZWC0ehn/TxoVHzpNPmL74ZvcBJahzOc+Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian van den Berg <faxuser@proton.me>,
	Rong Zhang <i@rong.moe>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 064/271] ALSA: usb-audio: Add QUIRK_FLAG_MIXER_GET_CUR_BROKEN for Logitech PRO X 2 LIGHTSPEED
Date: Mon, 17 Aug 2026 15:29:49 +0200
Message-ID: <20260817132539.375555340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rong Zhang <i@rong.moe>

[ Upstream commit c973e61895db8fe4a69d8b33de92068d135cafd8 ]

The UAC mixer of the Logitech PRO X 2 LIGHTSPEED has broken mixer
GET_CUR behavior but otherwise works fine.

Add a quirk table entry matching VID/PID=0x046d/0x0af7 and apply the
MIXER_GET_CUR_BROKEN quirk flag to make the mixer usable again.

Quirky device sample (after applying the quirk flag):

  usb 3-2.1: New USB device found, idVendor=046d, idProduct=0af7, bcdDevice= 1.00
  usb 3-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
  usb 3-2.1: Product: PRO X 2 LIGHTSPEED
  usb 3-2.1: Manufacturer: Logitech
  usb 3-2.1: SerialNumber: 0000000000000000
  usb 3-2.1: 2:0: broken mixer GET_CUR (-18944/0/256 => -2662)
  usb 3-2.1: 6:0: broken mixer GET_CUR (-18944/0/256 => 0)

Fixes: 86aa1ea1f15c ("ALSA: usb-audio: Do not expose sticky mixers")
Suggested-by: Brian van den Berg <faxuser@proton.me>
Reported-by: Brian van den Berg <faxuser@proton.me>
Link: https://lore.kernel.org/all/370007e6-b73b-4bfc-8410-a860781c7ad7@proton.me/
Signed-off-by: Rong Zhang <i@rong.moe>
Link: https://patch.msgid.link/20260731-uac-lg-pro-x-2-ls-v1-1-268eaefe66ab@rong.moe
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/quirks.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 688993bfa8fd1..e97038cf5271e 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2249,6 +2249,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 	DEVICE_FLG(0x046d, 0x0a8f, /* Logitech H390 headset */
 		   QUIRK_FLAG_CTL_MSG_DELAY_1M |
 		   QUIRK_FLAG_MIXER_PLAYBACK_MIN_MUTE),
+	DEVICE_FLG(0x046d, 0x0af7, /* Logitech PRO X 2 LIGHTSPEED */
+		   QUIRK_FLAG_MIXER_GET_CUR_BROKEN),
 	DEVICE_FLG(0x0499, 0x1506, /* Yamaha THR5 */
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0499, 0x1509, /* Steinberg UR22 */
-- 
2.53.0



