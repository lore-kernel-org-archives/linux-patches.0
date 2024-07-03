Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AEEF16FF2A;
	Wed,  3 Jul 2024 11:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004527; cv=none; b=B8XcjfDCGkXHY3eKBqcI4zcOimyryzkV99zrueXHkH8HLPMpt0jBLfAeuzVK3zakquiaHrzXAxB9pLK8JJI7z4R7DRfcwyOHD0Yzj+VCdoAwxrGt7JsHjCbduPLN+6BNNZ8+39ImZhK48rcQX/oVlTl3pFMMPejjWbhsjHwNQEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004527; c=relaxed/simple;
	bh=wzZpszZU7hIzujAaX8EEqcq/u8gqWGixPTYf/OkAVzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TebbJ9TOPUPGdW0tvxI/VumLSi+Uwhh4jFKqjbGQ3jh9ktp97NYEZbSm5r9L8NMxBDONEmMADsPM6bKzn3cFyXaEh6kLy+HDKnMnC1IaMK+UcXre2P3Z1pU8+A8+8lCDyCY2bUdRbu6G4sCJEBoEQdg5OUGzqjmAdswebXLqx3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fb4923I6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fb4923I6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F2AC2BD10;
	Wed,  3 Jul 2024 11:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004527;
	bh=wzZpszZU7hIzujAaX8EEqcq/u8gqWGixPTYf/OkAVzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fb4923I6NBJ/z1wTnJh25VAYeUHwNj6SqHZgGtTyx7lNqMcAr9sFIMPpv27e6QamS
	 GmKzXAhnlzHbrxSi0yPDRyuAz2BaWBZUt2Xy2qevQdPWgKZCV7mEJhNYWgNZp/4f30
	 wQK2+QgVJxkYtfs3YdGzG1W1w8pmTXVF+DvaBs0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/290] gpio: tqmx86: fix typo in Kconfig label
Date: Wed,  3 Jul 2024 12:37:15 +0200
Message-ID: <20240703102906.243373347@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

From: Gregor Herburger <gregor.herburger@tq-group.com>

[ Upstream commit 8c219e52ca4d9a67cd6a7074e91bf29b55edc075 ]

Fix description for GPIO_TQMX86 from QTMX86 to TQMx86.

Fixes: b868db94a6a7 ("gpio: tqmx86: Add GPIO from for this IO controller")
Signed-off-by: Gregor Herburger <gregor.herburger@tq-group.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/e0e38c9944ad6d281d9a662a45d289b88edc808e.1717063994.git.matthias.schiffer@ew.tq-group.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index 39f3e13664099..b7811dbe0ec28 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1335,7 +1335,7 @@ config GPIO_TPS68470
 	  drivers are loaded.
 
 config GPIO_TQMX86
-	tristate "TQ-Systems QTMX86 GPIO"
+	tristate "TQ-Systems TQMx86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
 	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
-- 
2.43.0



