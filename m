Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA40113E037;
	Wed, 19 Jun 2024 13:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803848; cv=none; b=kW3AJYOETnYfmgXMISiQyhat5vdqr9BtyePfMXo33365zPtpi03ffQ4BUoBcHaIkXk3UZzgkVZvIt5R2D5R3pDJqzbW6jlm3jSEWRClpraZVqLfXmjI7wmuEGp2FGoaXkql2zTfqOX69dVz6J4WnMuJ+QRZHfUU7tLOyiGo0WhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803848; c=relaxed/simple;
	bh=5LP6ugaENPboJpGg/mbNgCn6BOc0bd72cruJSYFhonk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsWpp1oYghTQ4mUlZm0FjXPToXvbbeZb4HY4EJ7wyTPn2n+cbzZZcBN829F+GgMj+URVlpn7t1RcmczjD7IR8F0Qbt+olFm5N49hmagVCD9HuJzj+uSoeeJm1Aa58VR1eClKvPLMRflmvQ9JaX44YzAa47RNd56jZXFgPEwvUpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kGqR585X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kGqR585X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602B0C2BBFC;
	Wed, 19 Jun 2024 13:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803848;
	bh=5LP6ugaENPboJpGg/mbNgCn6BOc0bd72cruJSYFhonk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGqR585XMoTMVzubzTkGksH5TKVsQLW5CyMIrH/rjivdfev3XqUBEUFtsrGeyxfOs
	 GUiWCnsfbn9FMY6bgn76ikW4+q6f6fN1iPBKQoK+kDzXy5Rr5QQ9mFe+/UrKFSGc9D
	 tMPwlDFsxLZKlgmZeCUAta83Bi5P2FBU2no532/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gregor Herburger <gregor.herburger@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 124/217] gpio: tqmx86: fix typo in Kconfig label
Date: Wed, 19 Jun 2024 14:56:07 +0200
Message-ID: <20240619125601.474116857@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 700f71c954956..b23ef29f56020 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -1416,7 +1416,7 @@ config GPIO_TPS68470
 	  are "output only" GPIOs.
 
 config GPIO_TQMX86
-	tristate "TQ-Systems QTMX86 GPIO"
+	tristate "TQ-Systems TQMx86 GPIO"
 	depends on MFD_TQMX86 || COMPILE_TEST
 	depends on HAS_IOPORT_MAP
 	select GPIOLIB_IRQCHIP
-- 
2.43.0



