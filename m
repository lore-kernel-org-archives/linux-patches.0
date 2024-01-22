Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C3C133435;
	Tue, 23 Jan 2024 01:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971882; cv=none; b=kQf+rfQ3Bi+W869Jq30PidsqaI58+97QRyVNYPx+WgM4zFB0unJsSKir8IvdHMsNTpaWE+P14Mvf8RHY6jh3P4TAauJpoOMaFEcQc1R8I8/JuYR7PyZccLJcYHjBWyU5AYhNABSO+ALn2wlp68l7mQlg4jNdPEwzEtFrLkFBJmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971882; c=relaxed/simple;
	bh=9jjt9EG6W4CP2GgL9O+0b3QFFpe2cXlxnrU54sgtWBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tLk5oznbcMAXmxC2wnuALUHKL7KVPQ7jzpgzqrM92e2N5tueOFW1Uv5RDmP6ZL7nBUgIEHKbJCQQsCkjVoZJ7mjLS1BgndMhyakBVpe6+IJmn7VsXTjUDk2uL7og90cduBdujx+aXx197vY71DTtPpF75lIRipLClN5cQ0t6Pgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V6iZ+bP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V6iZ+bP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9EDDC433C7;
	Tue, 23 Jan 2024 01:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971881;
	bh=9jjt9EG6W4CP2GgL9O+0b3QFFpe2cXlxnrU54sgtWBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V6iZ+bP611NdUh7reMiTZ0PajthJJC23zhk5B+eNIzz2y6oJ7HxJT+0PzhXZ60rbC
	 neiqoYyTdURF2Q/t0MSR+hmVtyl8o186pvCAaUyqitE6phfCoD4HTFw5A0VSrSTcQK
	 pn7jxC4AIknAljR9f42N2VURB+cAGC8fEry7qF+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 253/286] tty: change tty_write_lock()s ndelay parameter to bool
Date: Mon, 22 Jan 2024 15:59:19 -0800
Message-ID: <20240122235741.789307320@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1908f27a795a..3d2d82ff6a03 100644
--- a/drivers/tty/tty.h
+++ b/drivers/tty/tty.h
@@ -64,7 +64,7 @@ int tty_check_change(struct tty_struct *tty);
 void __stop_tty(struct tty_struct *tty);
 void __start_tty(struct tty_struct *tty);
 void tty_write_unlock(struct tty_struct *tty);
-int tty_write_lock(struct tty_struct *tty, int ndelay);
+int tty_write_lock(struct tty_struct *tty, bool ndelay);
 void tty_vhangup_session(struct tty_struct *tty);
 void tty_open_proc_set_tty(struct file *filp, struct tty_struct *tty);
 int tty_signal_session_leader(struct tty_struct *tty, int exit_session);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 094e82a12d29..38877489f700 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -948,7 +948,7 @@ void tty_write_unlock(struct tty_struct *tty)
 	wake_up_interruptible_poll(&tty->write_wait, EPOLLOUT);
 }
 
-int tty_write_lock(struct tty_struct *tty, int ndelay)
+int tty_write_lock(struct tty_struct *tty, bool ndelay)
 {
 	if (!mutex_trylock(&tty->atomic_write_lock)) {
 		if (ndelay)
@@ -1167,7 +1167,7 @@ int tty_send_xchar(struct tty_struct *tty, char ch)
 		return 0;
 	}
 
-	if (tty_write_lock(tty, 0) < 0)
+	if (tty_write_lock(tty, false) < 0)
 		return -ERESTARTSYS;
 
 	down_read(&tty->termios_rwsem);
@@ -2473,7 +2473,7 @@ static int send_break(struct tty_struct *tty, unsigned int duration)
 		retval = tty->ops->break_ctl(tty, duration);
 	else {
 		/* Do the work ourselves */
-		if (tty_write_lock(tty, 0) < 0)
+		if (tty_write_lock(tty, false) < 0)
 			return -EINTR;
 		retval = tty->ops->break_ctl(tty, -1);
 		if (retval)
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 68b07250dcb6..12a30329abdb 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -404,7 +404,7 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 		if (retval < 0)
 			return retval;
 
-		if (tty_write_lock(tty, 0) < 0)
+		if (tty_write_lock(tty, false) < 0)
 			goto retry_write_wait;
 
 		/* Racing writer? */
-- 
2.43.0



