Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D9112FB31;
	Wed, 19 Jun 2024 13:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802320; cv=none; b=JkQWHh+KHQ+MJyYjqRYuEgYYavf+mcOzZo6jytBX5XcVSTREGeHLFa+rbfkhFE3CUhjSu2FJVhqe2luV6+oZPmSLxRaHrXdDEwPRyAYgeY3ImuPbkFKRSTHG37RRihbxhJ6rPaUgUIJ7oUTetqGq1oGSfODmgBb+XqpomZCWpQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802320; c=relaxed/simple;
	bh=ATAZIlNZqKxh+Mcl3uUO93AypmoXUy0/qW8xXZjcq9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFP1xCWzB1hRT78HrJOC1jTvZkneynIW1rxDCBfCDpihmgLLt5HEovolqTz/y7GcVtqT+xp0XEFNqVWRI7KNfB4C1L4JZ5IKLene3briYb4VGubIB+Ob0UkAcsxTMQEeTOpMlAAFmnC16Bnz7QXRLb0NDhagCouZKqjI4TOWkFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yCaE4+xN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yCaE4+xN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77D7C2BBFC;
	Wed, 19 Jun 2024 13:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802320;
	bh=ATAZIlNZqKxh+Mcl3uUO93AypmoXUy0/qW8xXZjcq9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yCaE4+xNn098CZAlwY9OTCE2s+P/iDE9nIS1IGwdi0or1qEbFKjJY63sJrKQF9jjL
	 A86Dcz9tZcS9frRrzdAx7avFSJRLwt+gya0LtY1LnMad8K6nHPCteRS7tY7wJju5Tf
	 ZqLLG6FWsWFLTpr+3C4R7nrkQwKd65XuErCNI5cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/267] gpio: tqmx86: fix typo in Kconfig label
Date: Wed, 19 Jun 2024 14:54:36 +0200
Message-ID: <20240619125611.147496525@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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
index d56b835359d3b..ebd4e113dc265 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1507,7 +1507,7 @@ config GPIO_TPS68470
 	  are "output only" GPIOs.
 
 config GPIO_TQMX86
-	tristate "TQ-Systems QTMX86 GPIO"
+	tristate "TQ-Systems TQMx86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
 	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
-- 
2.43.0



