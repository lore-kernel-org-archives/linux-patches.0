Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065038;
	b=RSD4h6oVCVLA7Oqe7ASOc0u81rfxJsjRgRHnPz0P9h+uLU/hmNc3RmK0YSc/LWKQZ7RC
	 v6WKfkYnaddpf9fVwspo4KLoGmiSUasvRIpYngV8i1QV0nV1GhZoRMFX3mgMyL7fiVOWC
	 xeT2OXmJHcghoDo3io1NxmGuYt9k//sUbKKeuTENhMchBawgRfCFm9PZj87J8Og+LXPVy
	 yrBSYUIepdd3+TwPnqrUR334CMiXIj81itw+iXxBlYb5MDudHf3RBhzYsl0MCjHSwClSU
	 GsB7ovmqWOFCBfm1ypnTewm3ALpgG7bDMnl0bMGZAopuX9m8ASSEE5tSMutHfUid6Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rCKUJ0tINMm/0o3ITwuuE0d+7b8wOnCj1bBhOvarSX8=;
	b=NHOMuEGIdA+IuOyV0G/amc5vNdGZQlQ6V6wpUUVxVmKQQVFhve8G6SXVp9c1CC83+p2V
	 0TJlXw2Gc5SdDchYW6BvpICLEByX45dFPssKLW1oM9V0G4XIoYIooHeVFy/3nc7z/MonQ
	 9eem7K06wxsp3DkPbWGot3qQ9kbz/YcXo2+GYb+oux3ZlKVp1/fjek5j0gRftNl+hRo91
	 qdEXoDPm500z88eA2/9TX8MFCyPRyGCvNn7MlVilGpEqOSaFXkTx1Vsz5LKDcfiUlyum9
	 qnkyxT5KLmN+S0SEa+hrXg2Hw5+2F5Ylwc49ite3FFuHARI9RtrUYLn35iq9ylwDADQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0kejwO0f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CF7606A9C1;
	Sat,  7 Nov 2026 15:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0kejwO0f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3ED51F0089F;
	Sat,  7 Nov 2026 15:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065038;
	bh=rCKUJ0tINMm/0o3ITwuuE0d+7b8wOnCj1bBhOvarSX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0kejwO0f1Uxd6vhq4QiyJlWFTpm2rt0VekQfxg5nLJTGzgYULMNYTvpIMsxOo9Bi9
	 wTgDIfQTHVfNT7xHGPBW9OMq4zbzag+fzpVMd20S16HXnJqi7SHOASlESpyrCtfds1
	 aQb303W8YQXpTWZTS3fmyHP5S51gLNmHuGiobvLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kochetkov <al.kochet@gmail.com>,
	Siarhei Volkau <lis8215@gmail.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0894/1257] Revert "Input: matrix_keypad - force switch rows to input mode"
Date: Sat,  7 Nov 2026 08:53:10 -0500
Message-ID: <20261107135004.016654815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Kochetkov <al.kochet@gmail.com>

[ Upstream commit 1527451f87dfe368b8ddeeb501c24ac9bde6b589 ]

This reverts commit 01c84b03d80aab9f04c4e3e1f9085f4202ff7c29.

The commit makes every scan call gpiod_direction_input() on the row
GPIOs. On pin controllers where GPIO input and interrupt are separate
pinmux functions this switches the row pins out of interrupt mode, and
enable_row_irqs() does not switch them back: it only unmasks the
interrupts. Row interrupts then never arrive and the keypad stops
working. Seen with a matrix keypad on an Allwinner A64 board (PINE
A64-LTS); it works again with the commit reverted.

The workaround is not needed on Ingenic either: the author of the
reverted commit re-tested all available JZ47xx SoCs and they all report
the live pin state in interrupt mode, see the thread in Link.

Fixes: 01c84b03d80a ("Input: matrix_keypad - force switch rows to input mode")
Link: https://lore.kernel.org/all/4130C026-2A83-408B-836A-ECA044491C47@gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Acked-by: Siarhei Volkau <lis8215@gmail.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patch.msgid.link/20261002100935.449473-1-al.kochet@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/matrix_keypad.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 8863b741d1a32..cda2888b2e562 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -134,9 +134,6 @@ static void matrix_keypad_scan(struct work_struct *work)
 
 	memset(new_state, 0, sizeof(new_state));
 
-	for (row = 0; row < keypad->num_row_gpios; row++)
-		gpiod_direction_input(keypad->row_gpios[row]);
-
 	/* assert each column and read the row status out */
 	for (col = 0; col < keypad->num_col_gpios; col++) {
 
-- 
2.53.0



