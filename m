Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD70D12B16C;
	Tue, 14 May 2024 11:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715685478; cv=none; b=rJAHjH8SKiYz2I48NEm6Lz8JEHxhz3Fk8lfDqqffup9Jd3rb7KsiL7vA/dDnsdMztThw0126CXb2uopekfI3hbCoZuvVVEAEJR4cVB1H07HPmAeIwp03H3WCThEkHkWWFJA2dNdjrSr1qD0ywmk5ptg55cj9ijto0zIg04aX0AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715685478; c=relaxed/simple;
	bh=+9nG5EKoYDwQOTIimORUUpP9pYtUocgY4SOiRv4A9B0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vwtd4mQ1Tmv6vbR2i1L4Jrbagof8JpVXn/sALoBujFv11gWsGhz3+jsAQ1rqRAUE4ES+nveqp5n4+7eopzxgJwNrlGvruvsgE8cWFwvgmzF0wO7qQo/y4xKBqx6YJuc0RIG3BM+9I8pd8QfbyzvCO9dTu67ilH4BgbhRJzOg0fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRA+LROm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRA+LROm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8519C2BD10;
	Tue, 14 May 2024 11:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715685477;
	bh=+9nG5EKoYDwQOTIimORUUpP9pYtUocgY4SOiRv4A9B0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRA+LROmemZZYFMJrP+eVWPK4UGCGg+56z0sRKUlOgxEXhyGq+1DIL+StosS2iici
	 dtO1UVReSOE/M/vQdKP/9386SGSiP8BiJ95wIxtmdlGnkxbIsqW+ZPwW1UN1fvQ4cy
	 mKDaTuCSOcQ6qaF5hlhfSmUcQ0YKYPKijw5soI00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/301] gpio: crystalcove: Use -ENOTSUPP consistently
Date: Tue, 14 May 2024 12:17:15 +0200
Message-ID: <20240514101038.449515835@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit ace0ebe5c98d66889f19e0f30e2518d0c58d0e04 ]

The GPIO library expects the drivers to return -ENOTSUPP in some
cases and not using analogue POSIX code. Make the driver to follow
this.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-crystalcove.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-crystalcove.c b/drivers/gpio/gpio-crystalcove.c
index 1ee62cd58582b..25db014494a4d 100644
--- a/drivers/gpio/gpio-crystalcove.c
+++ b/drivers/gpio/gpio-crystalcove.c
@@ -92,7 +92,7 @@ static inline int to_reg(int gpio, enum ctrl_register reg_type)
 		case 0x5e:
 			return GPIOPANELCTL;
 		default:
-			return -EOPNOTSUPP;
+			return -ENOTSUPP;
 		}
 	}
 
-- 
2.43.0



