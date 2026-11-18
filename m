Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038543;
	b=tK1DJPgA7UkjGQnUlZ1Vil0yp920Ce1w6Z4DFDsuXIMpaVZotpT6O0MAxEKC9ArEj/Ce
	 yGWKXNSyv0EQhT1t6bTiOcOwreoPocZwl27Ktr/nNCJ8Mu8HblptmuZJ/BHffwR7eIVbi
	 I0I2k4U25YR6eQqlbxbuuDtAbuUhRpcL1197sr0tKUB2KOSnbkBMqDepWEl7x/lQTMyax
	 0LZf3H1O3pKcQSfHoV+ypiUDT12e99rihkQsyD8CiCXEzW7yf7bT7SCVLa9lcAfRlREqZ
	 UJPe3kG1xq1k/8WVNXJZIgpqPpeMhknwUCQaX2kCqk6O723JYSa6AsGAx+i/v/05s8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NCWiUXHCRBO+zaoEom8gXVNajcu5aaxFWqLjmGzO8Ps=;
	b=xDRWqXS6rSZ9GzXfSFhiA7uCHLmlRn0K52PijEQiy0Vm9uRbEIzi+XKjFnCWJbIRsukU
	 cjMcYJfa7pcgg16pXfdA7vneEveBuSOpXImK/0Wi4v/Zp+2eQbUJ5j8ZgDY333Z3NU+Yz
	 jIKlNErlK8FGAeEriOgSJ5BAkb4YD05FQpsHzaaHdjjQg1FXooRPlNtlq7rnbUUyoFwXE
	 5TEk59nIbEAPbQrrtViilPVECmb3YfcM9iLp+iR0cXUyqymvrXKjG6OxJBPkC2RFriK+j
	 MKfczbk79osLjHp4vY2UKpXdQwkeSW9Nce1x4FVifgitWBmskq6gX0wX18JAwVzpyeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehMYqSF+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806AC606A320;
	Wed, 18 Nov 2026 21:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ehMYqSF+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89971F000C4;
	Wed, 18 Nov 2026 21:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038543;
	bh=NCWiUXHCRBO+zaoEom8gXVNajcu5aaxFWqLjmGzO8Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ehMYqSF+z/uBHS4/SnrNbIuVYRdc2YLG6h5XcxaNaso1Saqy+E+ZRhYlMMQ2sev8J
	 8Mw7d6TjxShfGej/ODbueQ3UUJJQI4l9/M2Lll5mofFyCbFcE429mkGUJteRlwzn4g
	 fOAOSHTNpmbw2q5xxTzii3NwNjYbiDaxgBok0SQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kochetkov <al.kochet@gmail.com>,
	Siarhei Volkau <lis8215@gmail.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1778/3318] Revert "Input: matrix_keypad - force switch rows to input mode"
Date: Wed, 18 Nov 2026 15:40:00 +0100
Message-ID: <20261118150415.199611991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the loop removal from gpiod_direction_input() with keypad fields to gpio_direction_input() with pdata fields. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/matrix_keypad.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/input/keyboard/matrix_keypad.c b/drivers/input/keyboard/matrix_keypad.c
index 9e6837217f441..d0787a568058d 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -118,9 +118,6 @@ static void matrix_keypad_scan(struct work_struct *work)
 
 	memset(new_state, 0, sizeof(new_state));
 
-	for (row = 0; row < pdata->num_row_gpios; row++)
-		gpio_direction_input(pdata->row_gpios[row]);
-
 	/* assert each column and read the row status out */
 	for (col = 0; col < pdata->num_col_gpios; col++) {
 
-- 
2.53.0



