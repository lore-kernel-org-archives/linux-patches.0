Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A276E32E124;
	Mon, 27 Oct 2025 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590956; cv=none; b=V2Q/55PLfgrFaVgi7ZWGYqRv1OX9aT+JtJ50jGfHtKcQSFqIanV6FCprKmKFODVBAbFYQa3jLJcqxGU4dspAkgZTdkMRqbCeDYV3L6zmqrP/9XH4D2TK0KnI+elrqNce5ltM45GsQpPkK715O4S/9pYIyiGZbNFJsrhFibAv84M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590956; c=relaxed/simple;
	bh=URFfdFewBFf9l1XU6GLcS4g1u31cFt6mAP2PDqtRP6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oiezppzOSnYyoTioBwmWN9PN/dmu/YZNjHh0M9X1f2ahJjmQ4I+XIYac42xnpsV6HGj5kFn6NaX6fAs+YzA1Icgznu1qL1HlE8qFJRJgxNmVgh5cgOA7KkPmT1k+pJMh23lU7Hw3Hk3Q7zqfWZOaxgh8zeHeq18uZCjWmpSVrGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COZ99ikh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COZ99ikh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E057C4CEF1;
	Mon, 27 Oct 2025 18:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590956;
	bh=URFfdFewBFf9l1XU6GLcS4g1u31cFt6mAP2PDqtRP6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=COZ99ikhFGzet8uOSTYHarKCL5atZcf8n67+GoiYiVLxIHQcI4eYKBA9n51lPYlj4
	 HyF26z94+8ofEb/jLahbSUjBVgzMS78XrUZluPDThP2DqdZ5b7c5tOjN0lWtzwn+pV
	 RAGnXJzEdagBQbI1rWAPS6ZuPz0C4LYphVbv5uko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 5.10 013/332] serial: stm32: allow selecting console when the driver is module
Date: Mon, 27 Oct 2025 19:31:06 +0100
Message-ID: <20251027183524.970694160@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1494,7 +1494,7 @@ config SERIAL_STM32
 
 config SERIAL_STM32_CONSOLE
 	bool "Support for console on STM32"
-	depends on SERIAL_STM32=y
+	depends on SERIAL_STM32
 	select SERIAL_CORE_CONSOLE
 
 config SERIAL_MVEBU_UART


