Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029880;
	b=QXadq/1v79v0MhmUiwCo52UeYTFab6JbpsXuSoz2shZCx6sLaJ1wd5eRSniKXY4H3r/L
	 pea3ZMoovX87QobYUm+VUh/F+UYgx1UNny84pXXL0VHRg1GH+sw3/GMf6o/JvEzPRj9Ob
	 6SzJu/Nt8uZ605ghS8825PvZ0/5aUZaRCu0s2ApknHXK+LslPpXLBopL63PvSfxCs6WXf
	 GBjXOQz4hUuji1mP9imUmHyUY0dDPgLD19552kMHLj5UG3SdWElK7EUN+b9N4siZ/kYPe
	 2N745kWHjRESrlGrDh6HXYtsB6Tonp8IdzRilMqgta70/sW+uTx6u627tGjdDjSUgvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/t0XbjA3LDMLPScgmEVmbjxe0xsPT2kC/Q77nLE+sU0=;
	b=tSvgoOUu14aR3WZM0XCE0DiBSOVCW3xl1aUeH/RKYC5Pg86X71OMkKBZRJvTQ3O9xlAx
	 wQeALcvwnSTiyRp4GJxjM/9gt8Q/oJfHWvjYeT206/0WmFz5qHhIugYMmWO5GzS5MAVt9
	 R2CZ5wAaPxwZDJN+F9g9uUTW78nprxyS2YVUVhXJwBsEgLdcjZBgC9BJ+Ib4mutTDQAes
	 qXS9jRytH/hbfjtp2N1GmCOMcheQcLBIKXev73YxDYCgy+JYv+N/l6NDe87eHXQjtXx3Q
	 3R05hw6lgNTuZat5nLjp8W9YZ6HozBkqFlVB7GRcllCSHMdWqfm3ICoPoVUc13kP7mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xNKG/Crt";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D10C5606A31C;
	Wed, 18 Nov 2026 19:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xNKG/Crt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF2D1F000C4;
	Wed, 18 Nov 2026 19:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029880;
	bh=/t0XbjA3LDMLPScgmEVmbjxe0xsPT2kC/Q77nLE+sU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNKG/CrtwruH0VzHc506P6zPAORtAz3eL/JSYmLRQMqrVATayhSgpRoFBDGEgY2nt
	 Mk8ZqQvnlsNGY3LQ4XsaYbB6t3tjzHTwC7cItOb8+FOZvQLDffZ7PgKM2pr1uUnF59
	 sQYdr3M878YrxVnrQ/a61US8uAD5ajZlCxaX4x7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Triet Hoang <triet.hoang.dev@gmail.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0470/1756] clk: raspberrypi: Handle cpufreq device registration failure
Date: Wed, 18 Nov 2026 15:43:17 +0100
Message-ID: <20261118150027.585030292@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6cb26b6e7347d..8fe2256e787ec 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -437,6 +437,8 @@ static int raspberrypi_clk_probe(struct platform_device *pdev)
 
 	rpi->cpufreq = platform_device_register_data(dev, "raspberrypi-cpufreq",
 						     -1, NULL, 0);
+	if (IS_ERR(rpi->cpufreq))
+		return PTR_ERR(rpi->cpufreq);
 
 	return 0;
 }
-- 
2.53.0



