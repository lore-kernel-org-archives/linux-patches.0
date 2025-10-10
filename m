Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF5B32F6585;
	Fri, 10 Oct 2025 13:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102402; cv=none; b=osIJb3wsVXBBn07AcrxdqXxknAl3RJw4bTTz79qdJtRzTe2pN1zIEAtlh4rhlTueehdC0tvFRqhYLV1Wx3s+DHZUhIGsTFnRnKKiByD2QUaOBP3Klh2DAHr9g2Y8KGqYA0L/R/hvtGCG0ftMCnajviKQhLIPkiDU/LDp37cNwQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102402; c=relaxed/simple;
	bh=Npi6jpXvwnbsAQ6AGrp4Lu41mPWY7KZRLB3kZqlARTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fBy02OMnhqOsfpP+WdFJmiUJ8oziNabpOA+A0jTwfz4F7qAXZeR36LwTXCCQWFTmklguDJJZkWyroatAZKjA6gEHx6GXuJb+phpDNT1TFyr94DzX36U68fNFksnEPCTam1P0qrsmcQSETSBpgyRnlKxIInYh1YQAXa9c4gKEhTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxaGVoQw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxaGVoQw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B40BC4CEF1;
	Fri, 10 Oct 2025 13:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102402;
	bh=Npi6jpXvwnbsAQ6AGrp4Lu41mPWY7KZRLB3kZqlARTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxaGVoQw4q0FOrb9pWfUl2nDgFIARg2qUR++wVNQAUw2HjCzDb87JixFs8BFQm1za
	 xD7uwUhPg1KbNJsLQSPgySgawlPu2L0FcG+INtlGFT0Zd2E/6GivTWjGM2f7Dmfo5l
	 JFTvqc1c6K7RUaCHYAPUJPN/CBC4f4jOysB7CP/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 6.16 32/41] serial: stm32: allow selecting console when the driver is module
Date: Fri, 10 Oct 2025 15:16:20 +0200
Message-ID: <20251010131334.576515969@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
References: <20251010131333.420766773@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1405,7 +1405,7 @@ config SERIAL_STM32
 
 config SERIAL_STM32_CONSOLE
 	bool "Support for console on STM32"
-	depends on SERIAL_STM32=y
+	depends on SERIAL_STM32
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_EARLYCON
 


