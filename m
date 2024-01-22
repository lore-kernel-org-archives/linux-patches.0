Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80E733097;
	Tue, 23 Jan 2024 00:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969650; cv=none; b=Pf61kkXCrOEeaviVbEg3ynZSpVfyme8iiwNn8DwtE3GceYbkxLJajYiprd095ujulWCgbnlqtcrYe/34JZ4EiphAGA88CeNCReG5XiQqO+F5OXjOFTKHSxJW/IeKxleGUlCLc2lWHEumcfZBJDjCkDFAuBD4M3iwZ5CvR6jdSOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969650; c=relaxed/simple;
	bh=L1ikKfvU+4tuz7LEKmruo3wkUNxYh/PjdNmloDKaJrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kfwyW38Nwu3nOMI1+3oAe+Ycza3Go0JIxt465lvw7D4l3x8qFvBUhRQO6ovVtu5wB4tiIUdhL8OHvIvUs3ugOA1g2FISVgBle6xSNcIB4rsMEb1gfREj9v5VzILMF6tso3DojYCr6/+f72SRo47hIg0z0UuZb6FC8zJXn/ZTgLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tR8KhgcG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tR8KhgcG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64F74C43390;
	Tue, 23 Jan 2024 00:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969650;
	bh=L1ikKfvU+4tuz7LEKmruo3wkUNxYh/PjdNmloDKaJrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tR8KhgcG9ZF4TRlvqF6LzeOvsT1RE/u+smgdCkDJvg6zBhRxiPNYx5OKUcrR7vRKC
	 /Zz5y/6rAvSaW8yVco6JpY9td4lrjdkTujQFkx6487WyS+Q0dfjhD3hSUmzgYfL8kF
	 jjVfZZLEDyHPxp43aquC2l/ptApzZBuAvuwkYd4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.7 383/641] Input: atkbd - use ab83 as id when skipping the getid command
Date: Mon, 22 Jan 2024 15:54:47 -0800
Message-ID: <20240122235829.941194900@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 58f65f9db7e0de366a5a115c2e2c0703858bba69 upstream.

Barnabás reported that the change to skip the getid command
when the controller is in translated mode on laptops caused
the Version field of his "AT Translated Set 2 keyboard"
input device to change from ab83 to abba, breaking a custom
hwdb entry for this keyboard.

Use the standard ab83 id for keyboards when getid is skipped
(rather then that getid fails) to avoid reporting a different
Version to userspace then before skipping the getid.

Fixes: 936e4d49ecbc ("Input: atkbd - skip ATKBD_CMD_GETID in translated mode")
Reported-by: Barnabás Pőcze <pobrn@protonmail.com>
Closes: https://lore.kernel.org/linux-input/W1ydwoG2fYv85Z3C3yfDOJcVpilEvGge6UGa9kZh8zI2-qkHXp7WLnl2hSkFz63j-c7WupUWI5TLL6n7Lt8DjRuU-yJBwLYWrreb1hbnd6A=@protonmail.com/
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240116204325.7719-1-hdegoede@redhat.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -791,9 +791,9 @@ static bool atkbd_is_portable_device(voi
  * not work. So in this case simply assume a keyboard is connected to avoid
  * confusing some laptop keyboards.
  *
- * Skipping ATKBD_CMD_GETID ends up using a fake keyboard id. Using a fake id is
- * ok in translated mode, only atkbd_select_set() checks atkbd->id and in
- * translated mode that is a no-op.
+ * Skipping ATKBD_CMD_GETID ends up using a fake keyboard id. Using the standard
+ * 0xab83 id is ok in translated mode, only atkbd_select_set() checks atkbd->id
+ * and in translated mode that is a no-op.
  */
 static bool atkbd_skip_getid(struct atkbd *atkbd)
 {
@@ -811,6 +811,7 @@ static int atkbd_probe(struct atkbd *atk
 {
 	struct ps2dev *ps2dev = &atkbd->ps2dev;
 	unsigned char param[2];
+	bool skip_getid;
 
 /*
  * Some systems, where the bit-twiddling when testing the io-lines of the
@@ -832,7 +833,8 @@ static int atkbd_probe(struct atkbd *atk
  */
 
 	param[0] = param[1] = 0xa5;	/* initialize with invalid values */
-	if (atkbd_skip_getid(atkbd) || ps2_command(ps2dev, param, ATKBD_CMD_GETID)) {
+	skip_getid = atkbd_skip_getid(atkbd);
+	if (skip_getid || ps2_command(ps2dev, param, ATKBD_CMD_GETID)) {
 
 /*
  * If the get ID command was skipped or failed, we check if we can at least set
@@ -842,7 +844,7 @@ static int atkbd_probe(struct atkbd *atk
 		param[0] = 0;
 		if (ps2_command(ps2dev, param, ATKBD_CMD_SETLEDS))
 			return -1;
-		atkbd->id = 0xabba;
+		atkbd->id = skip_getid ? 0xab83 : 0xabba;
 		return 0;
 	}
 


