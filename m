Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87779129E81;
	Tue, 30 Apr 2024 10:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473904; cv=none; b=oRiFKGJhiggqZJmxObKTFUEFFQ02uwjvDsIfoMDcL1ko3dG1zcW/2HNxngOELQe2sx70MaHv/5bU1e9vRuI2iUsOnR5Mra/isL0uoLufxj9g0rqRHrnUBpUS1pebNF/X//dawuLjG90wd7vOtaGSV1kb1aP8afWkEHQ0OJn8suI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473904; c=relaxed/simple;
	bh=sLZ5SCbbu+PdzxHRGKBfGu3oSNBZVOfHUfBb6pClKLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BmCBt+2dw47uQZDnAKltH05Dh+sYZkEiysltr0FEncr5I3wujHCFYie1u6D8zMTEwZENCzacTAaMHHZlSXceHq2u/nzxnJghp0tZ9lEBVXjlio9YhQB9rR0WlDOaDLkPOy3XQAtT0cyqfCuSxo5/gt5WJ5xoE7gXU/cTTVWbz9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NQM98zha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NQM98zha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3D8C4AF1C;
	Tue, 30 Apr 2024 10:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473904;
	bh=sLZ5SCbbu+PdzxHRGKBfGu3oSNBZVOfHUfBb6pClKLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NQM98zha1kgdWPoOixCLK/hKneYkQXcQHsuUj/hue0kZkbWmHJt/phKn5/Yfx52IS
	 nXB7bqlgQHU8VxOlJuY+xD+Mg6qctUK6Hu1kvh2lW4gp648irYpcRhmXkvIxemtp/K
	 R7BD+tPnz2rZk5i3dN4Wkr5UZmHQUiM05RC5i9+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Ogness <john.ogness@linutronix.de>,
	linux-serial@vger.kernel.org,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 4.19 77/77] serial: core: fix kernel-doc for uart_port_unlock_irqrestore()
Date: Tue, 30 Apr 2024 12:39:56 +0200
Message-ID: <20240430103043.415003630@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -334,7 +334,7 @@ static inline void uart_port_unlock_irq(
 }
 
 /**
- * uart_port_lock_irqrestore - Unlock the UART port, restore interrupts
+ * uart_port_unlock_irqrestore - Unlock the UART port, restore interrupts
  * @up:		Pointer to UART port structure
  * @flags:	The saved interrupt flags for restore
  */


