Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062506;
	b=G2JYJByMLxkdQ7uWKsiXqvbqz3YhfQ56KzCh4ZC8eyKsFS/4LSA33/bNnsVOLlFijCmV
	 QSM6+aOxINREKCaYakVQq1ST/+qTPjodhv4Xa09Lk4PsIz9axu5XCdiMhZgyI7ZCSpae1
	 NjTSnO5Gz+uUXvDsYURQxaCaY8NjsN9n7x4XZwHh361GT57mYZ0E3K6zE4qrfAdiBTGy8
	 tR4IxukhzogJdoAF4PGLHs7hDIUtUWnzAqSr8bVm16/LlbQp3ZHt2Dl8R06s5skzGI8dT
	 gpH9MT1uL2RGSUJz/31Skl2emXfWE+h0C74VHqW/ioXlvyg0juDS6zaOFJcdH/WgawQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062506;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tLHZnwpwiSvqM/7n9v5tA7JbyVII5TpWojF8LkQ5CEs=;
	b=rh/Xof/6Ad8CiuQ9LhdtXsOvbwSNKSKzdrcsnnP+4y5ymr0ykCEtVxfNbiZUuEjWogXF
	 q74HoDlX9PTSaj18RVIdNYx+zXekzFqGRkBdMoLOWTBGOEvxt6xIIX3bJV5kxLyXlZ2fb
	 CERq1Ga+ahVLkeoUzmq/tG/abgaqfYS8sNTnls2YOwcvju3WAwFrod/v28XD5enEtlIH7
	 ja3zIBC7fDG9/VU9xUmRt9AEAIylBjmjCjpH1oDd671J2XC8z3jjNXa+3AeukpZy+dIgL
	 INkfX8e81uVa96kMmPXDHTM5Vi9N9l7xx5fNoqsS7t7VnEV+HZB0pH+QeJyV10AYHHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2iGQ7Pri;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3901D606A330;
	Sat,  7 Nov 2026 14:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2iGQ7Pri
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA7D1F0089F;
	Sat,  7 Nov 2026 14:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062506;
	bh=tLHZnwpwiSvqM/7n9v5tA7JbyVII5TpWojF8LkQ5CEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2iGQ7Prig9HKUqM1IrAINJUJyaqtnF+6qoCZOte3BpZKBl5USjoqVxcNLY1som2uN
	 0GNQt5hf8NDjIKW7p5DVJ+T7bEUAoGtifX1WbpFPVJrA852+GzhqGMwEwRrx5EaShV
	 C8sOGY6qNIhC8MPRHHJ2SQJDeqr+eTZBrDd9Zbqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kochetkov <al.kochet@gmail.com>,
	Siarhei Volkau <lis8215@gmail.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1365/1536] Revert "Input: matrix_keypad - force switch rows to input mode"
Date: Sat,  7 Nov 2026 08:56:21 -0500
Message-ID: <20261107135036.173953924@linuxfoundation.org>
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
index 3c38bae576edd..c502ee266d1a8 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -118,9 +118,6 @@ static void matrix_keypad_scan(struct work_struct *work)
 
 	memset(new_state, 0, sizeof(new_state));
 
-	for (row = 0; row < keypad->num_row_gpios; row++)
-		gpiod_direction_input(keypad->row_gpios[row]);
-
 	/* assert each column and read the row status out */
 	for (col = 0; col < keypad->num_col_gpios; col++) {
 
-- 
2.53.0



