Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45AC330B11;
	Fri, 17 Oct 2025 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715930; cv=none; b=BmHqLgPeFPoPXM9wHIc9d0qHNXjRoov76ajBu0ukMlGVBZHRut1zLlt6CGfQQ7lsNPRLm7UZ7S5b6+byIxnlWWElFY5zptbeZOPM+waht5FmzbrTw9sTrACjiwxK5qR8EAVbrt42n4NnTg/Ybe477RLGQhhq2lay0MRYDOvGVeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715930; c=relaxed/simple;
	bh=ef0tNlA7cAIdctSPCQ8Asipp4V8BDelAfpE6SKsa5Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=px890NFi1fvi8DYJppRsxKQveK1+OmgEkSeoP+Kp+WOpB/xQe8QkdXYaUR/CZaWXBwxdHM0MBUSAbb58VrwkWmbypL2+l6fex9vKxIrm6+1GbCJABUTKeVG9cmPdEliuHee+tpCScY/AeECkQXXPELqGZ2GKMcyN8zmwuVzIjSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZKGzTIxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZKGzTIxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46FA8C4CEE7;
	Fri, 17 Oct 2025 15:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715930;
	bh=ef0tNlA7cAIdctSPCQ8Asipp4V8BDelAfpE6SKsa5Ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZKGzTIxJksauzoCSkvn6gjsOTqvcpJ/syLSCxFKAuPQaarjmdwYo55ukfU8pKGmwl
	 QEpX/EDBZLfVN+uPdex12LqRpK9MhuydQhW2JGcCtQwrysfNOLO32hro8MHIIdhPFU
	 4ioQF09mEzKyZwf3IxkxR5abHgAGhwmMIHg4IiT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 5.15 015/276] serial: stm32: allow selecting console when the driver is module
Date: Fri, 17 Oct 2025 16:51:48 +0200
Message-ID: <20251017145142.957688222@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>

commit cc4d900d0d6d8dd5c41832a93ff3cfa629a78f9a upstream.

Console can be enabled on the UART compile as module.
Change dependency to allow console mode when the driver is built as module.

Fixes: 48a6092fb41fa ("serial: stm32-usart: Add STM32 USART Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Link: https://lore.kernel.org/r/20250822141923.61133-1-raphael.gallais-pou@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/serial/Kconfig
+++ b/drivers/tty/serial/Kconfig
@@ -1438,7 +1438,7 @@ config SERIAL_STM32
 
 config SERIAL_STM32_CONSOLE
 	bool "Support for console on STM32"
-	depends on SERIAL_STM32=y
+	depends on SERIAL_STM32
 	select SERIAL_CORE_CONSOLE
 
 config SERIAL_MVEBU_UART


