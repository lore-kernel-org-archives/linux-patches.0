Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6ED913C3F6;
	Wed,  5 Feb 2025 14:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765256; cv=none; b=Zs6ALCm8QV5D1QsAH1F+5MffOwQHj9uGcZ8vCNGd099+t635TLrfDWdewW7qZ0h4RiUxuvbpEtTj0cpbTmElQxDmKWY9/kaKdbHqy6FkQ/dnEtJNuHbCMuCPt2duzudjW1KDdPybUwxW4j9A29rev91x4JKf+j5x/32JdZb3q/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765256; c=relaxed/simple;
	bh=y8u3lP9UMTxeXtkTiWXQmfN3IGOm9eDHXcYdJGju+TE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ndEntpyLHKquy0cNyO7nLpxh8XTOY1r4Bj70KQos2AClRy2oep1LU0FOdErrKobbWMnHGL+tVaXOAmx175JtvFB7TQljYqTnku0KTGo0G4g4TL2kdy2pprgbPVkNVucG0vDBE8JeW7hpZ2zLNPz75g1rl+3ufk5Xn7biGMftRvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O/Yl4A/2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O/Yl4A/2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C02BC4CED1;
	Wed,  5 Feb 2025 14:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765255;
	bh=y8u3lP9UMTxeXtkTiWXQmfN3IGOm9eDHXcYdJGju+TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O/Yl4A/2K0SH32munXaGpewvSCnYGIwiJVtluR5NHb+oLEYM+sXhC5lAsgdF+wGt7
	 Fd3MLxhtAfUac8VeQS5irbLuw+SOCMKITvXZtwQJxBX+Sk9DI39II8jK0BOBElgvDn
	 6x4pDS+EzysWrJh61o2KaUZ+HJn1LiV4OYGhVV1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 160/623] hwmon: Fix help text for aspeed-g6-pwm-tach
Date: Wed,  5 Feb 2025 14:38:22 +0100
Message-ID: <20250205134502.356787890@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joel Stanley <joel@jms.id.au>

[ Upstream commit c8571eab11131cce6dcce76b3345c1524e074071 ]

The help text has the wrong module name mentioned, and the capitalisation
of the title is inconsistent.

Fixes: 7e1449cd15d1 ("hwmon: (aspeed-g6-pwm-tacho): Support for ASPEED g6 PWM/Fan tach")
Signed-off-by: Joel Stanley <joel@jms.id.au>
Link: https://lore.kernel.org/r/20250110114737.64035-1-joel@jms.id.au
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index dd376602f3f19..9afa70f877cc1 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -413,7 +413,7 @@ config SENSORS_ASPEED
 	  will be called aspeed_pwm_tacho.
 
 config SENSORS_ASPEED_G6
-	tristate "ASPEED g6 PWM and Fan tach driver"
+	tristate "ASPEED G6 PWM and Fan tach driver"
 	depends on ARCH_ASPEED || COMPILE_TEST
 	depends on PWM
 	help
@@ -421,7 +421,7 @@ config SENSORS_ASPEED_G6
 	  controllers.
 
 	  This driver can also be built as a module. If so, the module
-	  will be called aspeed_pwm_tacho.
+	  will be called aspeed_g6_pwm_tach.
 
 config SENSORS_ATXP1
 	tristate "Attansic ATXP1 VID controller"
-- 
2.39.5



