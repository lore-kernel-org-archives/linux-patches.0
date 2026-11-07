Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063512;
	b=EXwHqDqwxjWViWvoWZQVHdIKTjXKCaejEsseHjp0tqSAG4kkodWsUHxoRkjGMTWYNpbc
	 sVRXlwBW+H2KQjOgAfytjKKYMe8yVtdN/dBQKwK2sW7s6Gjnmn2bYqDGmynpe5M36+KY8
	 RWoyU8YEzRX05cQZ+dksTce1bVtVwZwm31Y6OSJ/eoiv25TeIZE2y39g69csZl0dGVTK+
	 4ZfmNrjIPcCqfJ70xoDUWwoiohlQrGnUl/uJzSF21zBuwwzcv0T/stdftv8A0Vf0eyyLU
	 ILuSeeh0YOZQfdreb5FPRMDI4TmmSq8d4vb1kmzQ1VLdYU0SXUcTm448YlXt7RKo9pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X8k0zaA7fm/2mCN5x3M2rScyfsFVPJxrRot0eAcb9b4=;
	b=pc2hAvXeKGt1FZOdaVxEtoOk9I5OZapmZurL/JXcKmHoyLwT+7oqYMhTBjklEG0aELdy
	 bFBChyufb8GGVo4i5idI7SAMNjw7XT7I42XS4mnSnuNy7jPGrmzl7qMpakx97cBqqSmmo
	 mL/kwYbC+wDbLRNDJjx/uiMsEEvEkuel49jTcd8Yy+EuVsX3kc9xoWFkSLlVM3UbbGvvD
	 zK3Z+tWDuLUkMBI3Cl9PGYRZYfuhBX14seDogOsN9fLGDitBvGRP3zVBXfWMF4VDeqMnH
	 BbG2Y8xGL/8vsOa6+J81ucpH60hMBeBkAf41hKRpemnsxv6Cq/6xR8Tu+6dV9JI81VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0Eiv6C4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF980606B8B7;
	Sat,  7 Nov 2026 14:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V0Eiv6C4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4331F008A4;
	Sat,  7 Nov 2026 14:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063511;
	bh=X8k0zaA7fm/2mCN5x3M2rScyfsFVPJxrRot0eAcb9b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V0Eiv6C4M/zfZ4x6KrYvETZozQf9XWAJWGuuL82SX7SLcGMaRjTy69fI/9UBC2AG/
	 bkzT/BbD0uxbEpN4cSuxSBN/2nKCjzUNRsImOmSgt1JAG+kT49i+hg0oeCme26i9dL
	 rSCz8KNludf6PDhCGB67r7M3mlgyxnItnuRYxNLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Kochetkov <al.kochet@gmail.com>,
	Siarhei Volkau <lis8215@gmail.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 655/869] Revert "Input: matrix_keypad - force switch rows to input mode"
Date: Sat,  7 Nov 2026 08:55:37 -0500
Message-ID: <20261107134915.279897234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index e50a6fea9a602..4247772892caa 100644
--- a/drivers/input/keyboard/matrix_keypad.c
+++ b/drivers/input/keyboard/matrix_keypad.c
@@ -135,9 +135,6 @@ static void matrix_keypad_scan(struct work_struct *work)
 
 	memset(new_state, 0, sizeof(new_state));
 
-	for (row = 0; row < keypad->num_row_gpios; row++)
-		gpiod_direction_input(keypad->row_gpios[row]);
-
 	/* assert each column and read the row status out */
 	for (col = 0; col < keypad->num_col_gpios; col++) {
 
-- 
2.53.0



