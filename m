Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0752F290C;
	Fri, 10 Oct 2025 13:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760102513; cv=none; b=UeEw+t9tcoezRJLaXDXwdc3FsWlSFbLTmih73YjE/Uj23haCMViZuW0y9t+xwcOx76+beL1SDHhT42gTwXaj5MpMHBpttARkqw5R7PaAYOkSVZT9ult0+tUAbvBEz3ESwJK7SXSPHPvpKvNxV81skVP8oXOtG3j9+/ow5wOo7+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760102513; c=relaxed/simple;
	bh=jcy4ZMm+lc1P2ONlGgUZ88uv9Z9+bQajzziK6y1704g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkppBsinBELxt+PGYnnmhIb+yiM3T1ojWBGQxK4ODFSpLh5zXvAzL+MWWs/9sVbirXnPL2oOeISGDQGGARY9cVLqsVjZSLYypjpclxTYup1xfMZsLyUB2hgDri74i/YMoTIhZzoAH8JXTAmfJLg0lKWmpxoPV+wQplMf0mAAeTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaHEzGmN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaHEzGmN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC05BC4CEF1;
	Fri, 10 Oct 2025 13:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760102513;
	bh=jcy4ZMm+lc1P2ONlGgUZ88uv9Z9+bQajzziK6y1704g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaHEzGmNGNbPlU0jC2uZsPtvUgcU0YL15oC8US7sxE5Ye2YAMxB5QzltHbEYlnagy
	 c1GYLwJf3wURnITY+FQSshlKUIDkwdcLuSVJzRXzj9WNLPE0PZ22N+l+DQOMGqb5rp
	 eUMO9SrlBoA4OHMuVVmNEeZJp7uEYoDt8oJWSnwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Subject: [PATCH 6.12 28/35] serial: stm32: allow selecting console when the driver is module
Date: Fri, 10 Oct 2025 15:16:30 +0200
Message-ID: <20251010131332.807968138@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251010131331.785281312@linuxfoundation.org>
References: <20251010131331.785281312@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1401,7 +1401,7 @@ config SERIAL_STM32
 
 config SERIAL_STM32_CONSOLE
 	bool "Support for console on STM32"
-	depends on SERIAL_STM32=y
+	depends on SERIAL_STM32
 	select SERIAL_CORE_CONSOLE
 	select SERIAL_EARLYCON
 


