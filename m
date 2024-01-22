Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 647ED6FB3;
	Tue, 23 Jan 2024 00:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968451; cv=none; b=YQAT+zuYzgkHWmEJquUBkoAo1h22UWTb6R/Rmn9hJ+tw7hHoudJgjWEw+IFfA5gcG4DztxEecz2U9ahTqu2VGnclYJ4Glm9HTNWXvGMKpGRi66gqN63lVo3J8cDsS0vs5CH7tl+UpCrCOXZN4iz8GYyemB9KHgrz/4iJTUIf48g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968451; c=relaxed/simple;
	bh=gD79Gy3pf3U8W+X3FV0492uh9QPbp9wKZxCsmr2ZFa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dkq4vfE07w/mnSBPOfPF/jvsOmdBWM28Yx15fR66ylE/GhYxFa3HQtLEGREf3Ox7HVnpjcAFsiJZJzQu/aM6jdOUFSPDeC1+fSv/ZmRlggUmGAes7Y2wdk3xkt+INiOPZmy3fyqAJbTTit5Mm4rTIB2lFD7wVQvss3Wwn5bJTUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LszIR84R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LszIR84R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3975C433F1;
	Tue, 23 Jan 2024 00:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968451;
	bh=gD79Gy3pf3U8W+X3FV0492uh9QPbp9wKZxCsmr2ZFa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LszIR84RL6o7k6pHZr98mjz+fK0lANSdJFwvvfj4dEIOHX5czF71WmUljqPQLfyGO
	 KCH0f7Fz9Y+xUkC9XR0mX0dnHsECJRrT5U8B8wiVNR/awPUQSvYskMn9rZyRB6AIvM
	 unHp8tH0EeefP2i+u30ytLbNE7KQ/Dphvd+dWYoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.19 113/148] Input: atkbd - use ab83 as id when skipping the getid command
Date: Mon, 22 Jan 2024 15:57:49 -0800
Message-ID: <20240122235717.038244768@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -743,9 +743,9 @@ static bool atkbd_is_portable_device(voi
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
@@ -763,6 +763,7 @@ static int atkbd_probe(struct atkbd *atk
 {
 	struct ps2dev *ps2dev = &atkbd->ps2dev;
 	unsigned char param[2];
+	bool skip_getid;
 
 /*
  * Some systems, where the bit-twiddling when testing the io-lines of the
@@ -784,7 +785,8 @@ static int atkbd_probe(struct atkbd *atk
  */
 
 	param[0] = param[1] = 0xa5;	/* initialize with invalid values */
-	if (atkbd_skip_getid(atkbd) || ps2_command(ps2dev, param, ATKBD_CMD_GETID)) {
+	skip_getid = atkbd_skip_getid(atkbd);
+	if (skip_getid || ps2_command(ps2dev, param, ATKBD_CMD_GETID)) {
 
 /*
  * If the get ID command was skipped or failed, we check if we can at least set
@@ -794,7 +796,7 @@ static int atkbd_probe(struct atkbd *atk
 		param[0] = 0;
 		if (ps2_command(ps2dev, param, ATKBD_CMD_SETLEDS))
 			return -1;
-		atkbd->id = 0xabba;
+		atkbd->id = skip_getid ? 0xab83 : 0xabba;
 		return 0;
 	}
 


