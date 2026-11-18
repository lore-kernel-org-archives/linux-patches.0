Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048387;
	b=DBdXZ4XCbAyTt4hf/6q+YtKZTehuCcDURgQZR1quFUcZ6a715bz957yy/MZrrl9HTOQM
	 9r+ObeD9NHfly33jAurDDIeKdzzrsNf3kDEiTOblc88H1n0jS4JZtDa7ySUlAjqqaM+Ab
	 7D++DXyL/7hjoiwnyJPbsYt9j/FmwSULNpJEuAS6c6EZqRbxzH9PSBTTgm4DNp2aaqT/m
	 kTmE4nQNlnvm4EShJ1eGfqJw4UxutcJ4GakNRf6IPtJDD1AKrCv52e1Dh6jD8YPMKfB9K
	 vcSbhOkp4WMk67wmqoQaAekrke4KbzETeuiOxqJKDmBGC6UX8c1gc5dOYYweGWTkChw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=za5JzrJYyEd6YfyznOk0TkW/uBx6iuNsTR5Y+UgSuSU=;
	b=KW/Gbz4kJhQPNEQwotTckGdssBekBu5TXBFm2EV4IokfskNbvArz7QmrpeWtXWN3zw1Q
	 lSUbmjZjdIaDDIX2gNU+kMd59sIrmpegoORMHoTA0qjVpQtE3E9UM3UETrdpnrLFwPruk
	 UazQfKkI7WKwdifRAexgvyRpszdZe80HIiDvMEIMO9z2Sb9lKj3Z2009nUIRtQY7abKz7
	 KAIatvM9P0w5md7j8JMse880rKGZv6kXqQU5flZ0nwS+R+N38u6CO/xOQG7TPZWFEBGLv
	 4IQKSowwBx9qpujIhMGKd7K8myA6zKQOfqtck9BIC6HzioDMEdBuHd7GTWK2WYVNDcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6dO8Z6J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095B560A2634;
	Thu, 19 Nov 2026 00:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6dO8Z6J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AF941F000C9;
	Thu, 19 Nov 2026 00:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048386;
	bh=za5JzrJYyEd6YfyznOk0TkW/uBx6iuNsTR5Y+UgSuSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6dO8Z6JSaDX5/E24lckajmriGIYeqcoLDxH21xyO/P5U3wFu7o8CJAgzZzZU09xU
	 by+q/rjZTMx6Q0wJPs8h8Ha1rX4KrHIN1XQzZnQWivKg9gOGQVXaADPen/b2rjfgsv
	 fsUgA21L/mEFyNcF0nyFquVULZhCrdFXs9ZVyEiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Triet Hoang <triet.hoang.dev@gmail.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1975/2857] clk: raspberrypi: Handle cpufreq device registration failure
Date: Wed, 18 Nov 2026 15:50:09 +0100
Message-ID: <20261118150312.500378330@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Triet Hoang <triet.hoang.dev@gmail.com>

[ Upstream commit e98e3d712023859af7cd78bb7fdb87ea3a9ffb83 ]

Check the return value of platform_device_register_data() when
registering the raspberrypi-cpufreq device and propagate the error
if registration fails.

This prevents the clock driver from reporting a successful probe
when the cpufreq device could not be registered.

Signed-off-by: Triet Hoang <triet.hoang.dev@gmail.com>
Reviewed-by: Stefan Wahren <wahrenst@gmx.net>
Fixes: e2bb18347c8e5 ("clk: raspberrypi: register platform device for raspberrypi-cpufreq")
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index a7e18789839fe..1fdfcc5e7dd1e 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -456,6 +456,8 @@ static int raspberrypi_clk_probe(struct platform_device *pdev)
 
 	rpi->cpufreq = platform_device_register_data(dev, "raspberrypi-cpufreq",
 						     -1, NULL, 0);
+	if (IS_ERR(rpi->cpufreq))
+		return PTR_ERR(rpi->cpufreq);
 
 	return 0;
 }
-- 
2.53.0



