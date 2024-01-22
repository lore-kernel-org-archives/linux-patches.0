Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF12A64AB3;
	Tue, 23 Jan 2024 01:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975063; cv=none; b=pIAMGJwm1IVBuSneGHWH30QnMsng/IKEZY8VrcmCBIrGQacCy60ABR+g+SNrh+HlstCc28ZuoS7L3Sd3MJXsQFd1uajL+BuvXuumolJJXptbn8+P8VLHJvLgG+mssfsGjlCA6fUxDMmifOpdjBgz4i7tiCimQDB7HFgNrMEc+WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975063; c=relaxed/simple;
	bh=NRM9BsmF2YEoVw3SiM9kRDYG6sXktZ1FLUdk+QDyDeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fUk6JHWDiAOcBLBGQRJb8MQ7pzCYH/bHCigMCYJWben22Boe20LrGXMy7nh1XD8p41e9hqRFjQZXZX6F57P8YTlyUz3ncrp+oM0neF73yGNo1i+0DXBXIzbR+nAhEoMgyXlMrKbG84me7Ti2mkAzDKpi2EBeRU2mMg8crbfxaOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySLyOM16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySLyOM16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88466C433F1;
	Tue, 23 Jan 2024 01:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975062;
	bh=NRM9BsmF2YEoVw3SiM9kRDYG6sXktZ1FLUdk+QDyDeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySLyOM16anqCW+ZZWUlwV670Ofmzuhx8Znpc8o1uk/e1vtFTdc6zIRV5+jpLpaiZS
	 Y4G3z79q8VWS8uGlRuy5LL6RnZd94QzRu5UF5mZsbh25+ftQaUDbiiSeSmyBUJ3uyJ
	 oTXWYnyc1D2bwi1LN8jq5GyKPVz5xer+vvqbBKR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/374] tty: change tty_write_lock()s ndelay parameter to bool
Date: Mon, 22 Jan 2024 15:59:32 -0800
Message-ID: <20240122235755.868987643@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit af815336556df28f800669c58ab3bdad7d786b98 ]

It's a yes-no parameter, so convert it to bool to be obvious.

Signed-off-by: "Jiri Slaby (SUSE)" <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/20230810091510.13006-6-jirislaby@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 66aad7d8d3ec ("usb: cdc-acm: return correct error code on unsupported break")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty.h       | 2 +-
 drivers/tty/tty_io.c    | 6 +++---
 drivers/tty/tty_ioctl.c | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/tty.h b/drivers/tty/tty.h
index 72b88aafd536..989986f67263 100644
--- a/drivers/tty/tty.h
+++ b/drivers/tty/tty.h
@@ -63,7 +63,7 @@ int tty_check_change(struct tty_struct *tty);
 void __stop_tty(struct tty_struct *tty);
 void __start_tty(struct tty_struct *tty);
 void tty_write_unlock(struct tty_struct *tty);
-int tty_write_lock(struct tty_struct *tty, int ndelay);
+int tty_write_lock(struct tty_struct *tty, bool ndelay);
 void tty_vhangup_session(struct tty_struct *tty);
 void tty_open_proc_set_tty(struct file *filp, struct tty_struct *tty);
 int tty_signal_session_leader(struct tty_struct *tty, int exit_session);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 3d540dff42ef..12f6ef8d0f45 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -956,7 +956,7 @@ void tty_write_unlock(struct tty_struct *tty)
 	wake_up_interruptible_poll(&tty->write_wait, EPOLLOUT);
 }
 
-int tty_write_lock(struct tty_struct *tty, int ndelay)
+int tty_write_lock(struct tty_struct *tty, bool ndelay)
 {
 	if (!mutex_trylock(&tty->atomic_write_lock)) {
 		if (ndelay)
@@ -1173,7 +1173,7 @@ int tty_send_xchar(struct tty_struct *tty, char ch)
 		return 0;
 	}
 
-	if (tty_write_lock(tty, 0) < 0)
+	if (tty_write_lock(tty, false) < 0)
 		return -ERESTARTSYS;
 
 	down_read(&tty->termios_rwsem);
@@ -2507,7 +2507,7 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 		retval = tty->ops->break_ctl(tty, duration);
 	else {
 		/* Do the work ourselves */
-		if (tty_write_lock(tty, 0) < 0)
+		if (tty_write_lock(tty, false) < 0)
 			return -EINTR;
 		retval = tty->ops->break_ctl(tty, -1);
 		if (retval)
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 1736130f9c39..dac1e2568803 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -427,7 +427,7 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 		if (retval < 0)
 			return retval;
 
-		if (tty_write_lock(tty, 0) < 0)
+		if (tty_write_lock(tty, false) < 0)
 			goto retry_write_wait;
 
 		/* Racing writer? */
-- 
2.43.0



