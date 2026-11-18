Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055565;
	b=cMUMWIU4RDk+TpdWw7hKUITFsMGuZZzJHRkK5tQv3dFtXJbfnNCcDWW0tqohu6WinqEM
	 9RWaDVqzD5/zSgbIPXmAnRZu4KPExYTFJPgpNJ9Ek9M7QG5hzfdYsFcD4PpI3f+D1CJ4d
	 NGY7xPa3REndp91UvETzlVZJ/W8hZHEgXLEtI6xSjkaSlcQWkpRLuM4IsXcpVguECSiWS
	 QUziPfVloweZogFevcxAS8j02wlhdmswlIWG/Eh9WLGs408BaogtfTLAeRnW/Pz/11ntc
	 XPFXRCNZKQlmyuR0KdpmNQvEX1v7rdckfBiTmT/FdEct7E6WfXF87xNfX+CtrF9wINw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nrWWMsMGu91gXHSAjNzblPgZDD61CY2Cd8Tz/2wQTNs=;
	b=zUVPG1DIWE0z36PipBrzetQUr13Mpw++IfixDOfqLagMiFGMgCC5ujM5RTLpggWghec9
	 MhM0OWUK5TN7HNYRNSuXsk+aF5Xfw5WRwBpRmmWnDqbnA9hGoFIxVJvk6RTLcrTNZbkuq
	 N9UUaVUxLAof/wP+wPozxF7QYbYr1oway9UIMT19n9EDC/jrHVj5BADsLup4lZUEgZ14r
	 ZXxi2Z4N04a7RK804D/H8eJ/pFBqHdm35Y0MEM2fdmwWZccCFQpU1euSbAUVtJNrTZc0o
	 sS63lnPtUWgrwDqcNbzVnA1nGFwXyARUebSGOaBYgdtg20NNLBIGz/oFLkqzgfIIvlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkUHjLGF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CFE606A339;
	Thu, 19 Nov 2026 02:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fkUHjLGF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AB81F000CC;
	Thu, 19 Nov 2026 02:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055565;
	bh=nrWWMsMGu91gXHSAjNzblPgZDD61CY2Cd8Tz/2wQTNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fkUHjLGFP2a7RTiiAr2VlZASZO5V7gaYXsh2ifmjd00uy9Ln5Rz4JL4mM2F2bI9R1
	 6iGu7Fv2bKSnT8H5ci433NCFHskdCldkcBhDdB8hlQyAOsb/sFle8PWSd8ARLGOXNb
	 UhEhfEyKxAROtEI0Bp3Uuo9zkItfNzNLT0zBzlBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niko Huuskonen <niko.huuskonen.00@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1640/2214] ALSA: caiaq: Fix the Kore controller key map
Date: Wed, 18 Nov 2026 15:55:16 +0100
Message-ID: <20261118150117.536605645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niko Huuskonen <niko.huuskonen.00@gmail.com>

[ Upstream commit c0508fc6895137f9e2dd43c1a09cc834254cc149 ]

keycode_kore does not match the hardware in two places:

- Softkeys 5 to 8 are listed in reverse order, so pressing the fifth
  softkey reports BTN_8, the sixth BTN_7 and so on. Softkeys 1 to 4 are
  correct. The OpenKoreBridge project, which drives a Kore 2 through
  this driver, works around the same reversal in userspace.

- On the first Kore controller the touch sensors of the eight knobs are
  scrambled: touching knob 1 reports KEY_BRL_DOT6, knob 2 KEY_BRL_DOT8,
  knob 3 KEY_BRL_DOT2, knob 6 KEY_BRL_DOT7, knob 7 KEY_BRL_DOT1 and
  knob 8 KEY_BRL_DOT3. Only knobs 4 and 5 are right.

Put the softkeys in order for both controllers, and give the first Kore
controller its own touch sensor order, so that BTN_n and KEY_BRL_DOTn
belong to the n-th knob. The touch sensor order of the Kore 2 is left
alone, as it could not be checked.

Userspace that compensates for the old order needs to follow. It can
read the key map with EVIOCGKEYCODE, which also makes it possible to
support kernels with and without this change.

Tested on a Kore controller (USB ID 17cc:4711).

Link: https://github.com/OpenKoreBridge/OpenKoreBridge
Fixes: 8e3cd08ed8e5 ("[ALSA] caiaq - add control API and more input features")
Assisted-by: LLM
Signed-off-by: Niko Huuskonen <niko.huuskonen.00@gmail.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260927003532.289468-3-niko.huuskonen.00@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/input.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/sound/usb/caiaq/input.c b/sound/usb/caiaq/input.c
index 6a5adb8d1e6a7..aee526e0da36a 100644
--- a/sound/usb/caiaq/input.c
+++ b/sound/usb/caiaq/input.c
@@ -41,11 +41,11 @@ static const unsigned short keycode_kore[] = {
 	BTN_3,
 	BTN_2,
 	BTN_1,
-	BTN_8,
-	BTN_7,
-	BTN_6,
 	BTN_5,
-	KEY_BRL_DOT4,   /* touch sensitive knobs */
+	BTN_6,
+	BTN_7,
+	BTN_8,
+	KEY_BRL_DOT4,   /* touch sensitive knobs (Kore 2 order) */
 	KEY_BRL_DOT3,
 	KEY_BRL_DOT2,
 	KEY_BRL_DOT1,
@@ -55,6 +55,21 @@ static const unsigned short keycode_kore[] = {
 	KEY_BRL_DOT5
 };
 
+/* index of the first touch sensor in keycode_kore */
+#define KORE_TOUCH_KEYS	24
+
+/* the first Kore controller reports its touch sensors in this order */
+static const unsigned short keycode_kore1_touch[] = {
+	KEY_BRL_DOT4,
+	KEY_BRL_DOT8,
+	KEY_BRL_DOT3,
+	KEY_BRL_DOT7,
+	KEY_BRL_DOT2,
+	KEY_BRL_DOT6,
+	KEY_BRL_DOT1,
+	KEY_BRL_DOT5
+};
+
 #define MASCHINE_BUTTONS   (42)
 #define MASCHINE_BUTTON(X) ((X) + BTN_MISC)
 #define MASCHINE_PADS      (16)
@@ -656,6 +671,12 @@ int snd_usb_caiaq_input_init(struct snd_usb_caiaqdev *cdev)
 		input->absbit[BIT_WORD(ABS_MISC)] |= BIT_MASK(ABS_MISC);
 		BUILD_BUG_ON(sizeof(cdev->keycode) < sizeof(keycode_kore));
 		memcpy(cdev->keycode, keycode_kore, sizeof(keycode_kore));
+		BUILD_BUG_ON(KORE_TOUCH_KEYS + ARRAY_SIZE(keycode_kore1_touch) >
+			     ARRAY_SIZE(keycode_kore));
+		if (cdev->chip.usb_id ==
+		    USB_ID(USB_VID_NATIVEINSTRUMENTS, USB_PID_KORECONTROLLER))
+			memcpy(cdev->keycode + KORE_TOUCH_KEYS, keycode_kore1_touch,
+			       sizeof(keycode_kore1_touch));
 		input->keycodemax = ARRAY_SIZE(keycode_kore);
 		input_set_abs_params(input, ABS_HAT0X, 0, 999, 0, 10);
 		input_set_abs_params(input, ABS_HAT0Y, 0, 999, 0, 10);
-- 
2.53.0



