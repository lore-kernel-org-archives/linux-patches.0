Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C0F91350CA;
	Tue, 23 Jan 2024 01:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971938; cv=none; b=sZcx6+Cb9SmDfC//SRPHcT34PeqE1jUhjS0dawEiZin1nkqXR+jWtkjhua4dzuuIZg3hzOSHSJR4OQO+92CSztRQZYiZqe20tPj3YcUWBzFyxe8Q0ghesbCGiTXM+8ThntXU5vUdLYr5Tko5VpAiYBiApprBPqQvSmpUGhtHPUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971938; c=relaxed/simple;
	bh=J7hyuUdyHtBM5X46H3cUanTRLME4igCwM26WT2qNOfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQzhWDUOpswWX7znKOLR4J3uW1o4vLxkllXEVwZbRYhqXDOU4kNqzBxtxmA+TVryjr9jHqtHDHlqx4pCHmdkAA9xe1fgH1iNIjnBDmmVy2O8grKL4ONQN+I0NVq5pLdk1Ja7/pMzuYZUs4rsWxdLiNuBUTC6p/H0pzsAP+Xp3Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LVm3F2he; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LVm3F2he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8EDC433F1;
	Tue, 23 Jan 2024 01:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971938;
	bh=J7hyuUdyHtBM5X46H3cUanTRLME4igCwM26WT2qNOfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVm3F2hegpE5F6OflQw65SZAlyjLowZo5WMfeaBuBu9ox1BnNsIOtvM4tJdsPYA54
	 ZG1IiDaAKviKIAsEArG13SRkH+OA2LzeG8YEk9fSMCClKln5LkblxNUgol/J+aPlsp
	 +HZPCc1/f6awFGRGx+V6CUTUm5FVbisDGtSpW+Sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 356/417] tty: change tty_write_lock()s ndelay parameter to bool
Date: Mon, 22 Jan 2024 15:58:44 -0800
Message-ID: <20240122235804.142544683@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c5ee21912755..91515e1ebc8d 100644
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
index 8fb6c6853556..860990719d14 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -939,7 +939,7 @@ void tty_write_unlock(struct tty_struct *tty)
 	wake_up_interruptible_poll(&tty->write_wait, EPOLLOUT);
 }
 
-int tty_write_lock(struct tty_struct *tty, int ndelay)
+int tty_write_lock(struct tty_struct *tty, bool ndelay)
 {
 	if (!mutex_trylock(&tty->atomic_write_lock)) {
 		if (ndelay)
@@ -1153,7 +1153,7 @@ int tty_send_xchar(struct tty_struct *tty, char ch)
 		return 0;
 	}
 
-	if (tty_write_lock(tty, 0) < 0)
+	if (tty_write_lock(tty, false) < 0)
 		return -ERESTARTSYS;
 
 	down_read(&tty->termios_rwsem);
@@ -2475,7 +2475,7 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 		retval = tty->ops->break_ctl(tty, duration);
 	else {
 		/* Do the work ourselves */
-		if (tty_write_lock(tty, 0) < 0)
+		if (tty_write_lock(tty, false) < 0)
 			return -EINTR;
 		retval = tty->ops->break_ctl(tty, -1);
 		if (retval)
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index ad1cf51ecd11..8767c504b95d 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -506,7 +506,7 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 		if (retval < 0)
 			return retval;
 
-		if (tty_write_lock(tty, 0) < 0)
+		if (tty_write_lock(tty, false) < 0)
 			goto retry_write_wait;
 
 		/* Racing writer? */
-- 
2.43.0



