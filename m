Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E66713C9C4;
	Wed,  5 Feb 2025 14:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764755; cv=none; b=FR8JIeHb+8c5E4Q2/V/y6KryBcGQ1hJKsc5Rhnmp/RGHjfK66JZtlDjSeVHvakQo1lp5Wx7Y+6+0VadsYyVG0LkX6ERwN/vKpcrXh8vQgpA+nd1rVnkOhltQOn+Vo5a8O/XW+JqOJLQfOjq8oqEMJuGqPZ6iv2Dtx/H1cG89bak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764755; c=relaxed/simple;
	bh=zc6QAxHXSQu6tFhOnwwWemlGWyJMnj3HFkgxLNlzbow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tKHN5e88F+h5j9js12YDvuxc6PsKLSiF5uHq2swoYRDwJIUeIMAv1Qcr9OcAMGGX6JEFX7iJA+LQIEYIu0u3YucmclR6VwJqjpYrswHb1WY7pmEWDoSxAxYgcXrc44xN3vS2L9Re+OT7E394JR4zEceYd5RMvQflnvU1NCYrZX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8mB6p5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8mB6p5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCFCC4CED1;
	Wed,  5 Feb 2025 14:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764754;
	bh=zc6QAxHXSQu6tFhOnwwWemlGWyJMnj3HFkgxLNlzbow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8mB6p5x9rmkKdXbwUHUfakGGZzBZoEdm6xP0qcpx21vxR/ja8dpuhSypKyOJw+Kg
	 iq4L9zlVR//dj1J+QrJm3C5v4h/fVwoc20XgRpnTa4KM2+aQYaydUYTKahipJqqpO3
	 0AC0NOEfSiaGSRPb38dFzxwEUEYu/OcTisRlT7xo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joel Stanley <joel@jms.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 155/590] hwmon: Fix help text for aspeed-g6-pwm-tach
Date: Wed,  5 Feb 2025 14:38:30 +0100
Message-ID: <20250205134501.215135860@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 08a3c863f80a2..58480a3f4683f 100644
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



