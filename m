Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A72B8801;
	Tue, 30 Apr 2024 11:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475986; cv=none; b=M5oMwb309ekRWWhFmbANUr+s4XwSAwsFtOgNco6IH+HZzTFc2Y7unvk6PgTUEr3TQ5PlfGJNmOIpGJlQ9lHnTqaw0JLV2dffqQDkdIbqa0rioGIm8Cc11uZBMcQpyrvmykwk3NVnxxTcvoXXnZYWN+eEtf+ErHJid5OIJnb0VJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475986; c=relaxed/simple;
	bh=e7lmMAoooBIsS3GhES4i+/l/rUQj523bARBNVn1yhDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjJh0vyGBxy4KrT9xioXpxR2Nu7qQZQYOjweCvR4ac+rSbtZmgyXWA07osD4RrR1gb1zunIZzHI1zwE1LuyPlY+k8rSEbfdsDpJTYe7T+QTPA3GZmP3Mv8s5qb63tY7xOTfF7yfEmbgUnJczf+1G7sXXCcesoG3kK8lhcnnreZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFwAUYtW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFwAUYtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD5CFC2BBFC;
	Tue, 30 Apr 2024 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475986;
	bh=e7lmMAoooBIsS3GhES4i+/l/rUQj523bARBNVn1yhDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hFwAUYtWkkRvfmXwhhdquTRLf2vU6JgYwwnYzWyHp2G5WWsslXnP0BgJNerNJW9ge
	 nzVSG7p1HY92ldvJFGCoai1DQohBS57NfPWgNnd3OOSuAfcfwdnqAEnMRdM9LBV87X
	 58XcEbdld8xG5a92F0XuPJtb3xOiD4eWadxpv7X8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Ogness <john.ogness@linutronix.de>,
	linux-serial@vger.kernel.org,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.15 80/80] serial: core: fix kernel-doc for uart_port_unlock_irqrestore()
Date: Tue, 30 Apr 2024 12:40:52 +0200
Message-ID: <20240430103045.771719842@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

commit 29bff582b74ed0bdb7e6986482ad9e6799ea4d2f upstream.

Fix the function name to avoid a kernel-doc warning:

include/linux/serial_core.h:666: warning: expecting prototype for uart_port_lock_irqrestore(). Prototype was for uart_port_unlock_irqrestore() instead

Fixes: b0af4bcb4946 ("serial: core: Provide port lock wrappers")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: John Ogness <john.ogness@linutronix.de>
Cc: linux-serial@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Reviewed-by: John Ogness <john.ogness@linutronix.de>
Link: https://lore.kernel.org/r/20230927044128.4748-1-rdunlap@infradead.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/serial_core.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -330,7 +330,7 @@ static inline void uart_port_unlock_irq(
 }
 
 /**
- * uart_port_lock_irqrestore - Unlock the UART port, restore interrupts
+ * uart_port_unlock_irqrestore - Unlock the UART port, restore interrupts
  * @up:		Pointer to UART port structure
  * @flags:	The saved interrupt flags for restore
  */


