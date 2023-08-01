Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD431F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B7EC433C7;
	Tue,  1 Aug 2023 09:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881855;
	bh=ES4hQIMiHVRB2EQsC3aovMUBCfHyct5GGy/wJIH9VHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVrjNYs4K30vJd0Ja+G0uMLObCt1EfzLYhGahETMwhMgfb/VjGpgdpGWXGwkhp6yk
	 5XDnHNPHigaIJ9k7nYtZ0o7cYlRXy2ZHlD5VX4dQbVtsXmmGksRkTpQWlxBcIuW0RW
	 ZB1jQvA60klqe8A6h8WiAM9PtMYnIPiVo/H0FT3o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jiri Slaby <jirislaby@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/155] n_tty: Rename tail to old_tail in n_tty_read()
Date: Tue,  1 Aug 2023 11:18:56 +0200
Message-ID: <20230801091911.065288524@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 947d66b68f3c4e7cf8f3f3500807b9d2a0de28ce ]

The local tail variable in n_tty_read() is used for one purpose, it
keeps the old tail. Thus, rename it appropriately to improve code
readability.

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Link: https://lore.kernel.org/r/22b37499-ff9a-7fc1-f6e0-58411328d122@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4903fde8047a ("tty: fix hang on tty device with no_room set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_tty.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 891036bd9f897..8f57448e1ce46 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -2100,7 +2100,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	ssize_t retval = 0;
 	long timeout;
 	bool packet;
-	size_t tail;
+	size_t old_tail;
 
 	/*
 	 * Is this a continuation of a read started earler?
@@ -2163,7 +2163,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	}
 
 	packet = tty->ctrl.packet;
-	tail = ldata->read_tail;
+	old_tail = ldata->read_tail;
 
 	add_wait_queue(&tty->read_wait, &wait);
 	while (nr) {
@@ -2252,7 +2252,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 		if (time)
 			timeout = time;
 	}
-	if (tail != ldata->read_tail)
+	if (old_tail != ldata->read_tail)
 		n_tty_kick_worker(tty);
 	up_read(&tty->termios_rwsem);
 
-- 
2.39.2



