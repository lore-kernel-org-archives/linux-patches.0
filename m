Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA9E76C81;
	Mon, 29 Jan 2024 17:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548656; cv=none; b=MrbvaoNh2bY6QtD27O/HMkweOU6VFPfDOY0IenvUEnIxqlRNYOyEDMAV6oNlEoDGlG2hWp/Cy3W0Gk+NWmC8SJwGSlD3ewIe8FgxRjbZCyAvI3RzCkAVE1n8OeC/XlGJei5M+WdX26RnbbLKU+kSb2NM2l5hCgr901MGyUP7Gm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548656; c=relaxed/simple;
	bh=Us/p2Kb8UWMp7cf7OHmF17HempDkaA0GdhoElvOp8PY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HR+7Tvn6NTfnJE6Tp1j1bw0lPUQ55uRmOqzksFcOiovo4g1uR4DhDxw5RZfeeIn6gCVV0YdF9acS3PrFPhfeZ++IVdR1claDD7CsMCjTGSqqbqqTmw2/bSdl9APq0t6FtYUYWZ3pWPk/KUXfqweiYizp0Bf3xYXqmmPpdqxcWgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GjsjKwuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GjsjKwuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24376C433F1;
	Mon, 29 Jan 2024 17:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548656;
	bh=Us/p2Kb8UWMp7cf7OHmF17HempDkaA0GdhoElvOp8PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GjsjKwuS6zY5CQtTJ9rCsfw3tMjVwr7yfx89hszvHFmYH2XOCqhSKDvoL3bw46BmY
	 jymjp/RziQuSWssbMLRfv2Cuw9qsHhIA/+xdAnPq7bb0lVuzAftYp76aZv72TWbgSa
	 F8sE9Dtjq3KUX3cKstlhLEp1EPNFu3QzuStBMm5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Ogness <john.ogness@linutronix.de>,
	linux-serial@vger.kernel.org,
	Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 6.6 330/331] serial: core: fix kernel-doc for uart_port_unlock_irqrestore()
Date: Mon, 29 Jan 2024 09:06:34 -0800
Message-ID: <20240129170024.539674891@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -658,7 +658,7 @@ static inline void uart_port_unlock_irq(
 }
 
 /**
- * uart_port_lock_irqrestore - Unlock the UART port, restore interrupts
+ * uart_port_unlock_irqrestore - Unlock the UART port, restore interrupts
  * @up:		Pointer to UART port structure
  * @flags:	The saved interrupt flags for restore
  */


