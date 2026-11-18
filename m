Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060816;
	b=OawgwukLQa7XYcAr0MK7y3jXg4BkLhyBBRVfRT5BT9IjOLNUTWiK1D9GSVMkMWwMKm8b
	 3td0FiCG2tHXfZHgVbrFIBKk13IjRfBeixgFOrHoMNw7NOoq75+p4lEHUbIpEFXNpOLNM
	 k6zgAkcwExa5glodXJqxKdwAnGIZeYmL1gJNYseNXsCcVJwK4n7hsbyFgfDNRtlrqQePt
	 Lv2Mt3X4IYBmskFBNiRoGVwL4YxZpZAC21f5m4nm8EPi4qGghv3WttwgymvWHhaO2xwwH
	 KLc65A1PCSgFymayzGJsqDQ/tX7DfYbgYgNsAgST0z13HuX+Z2FEcGaJx8MP/S4H8NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5dXcXKU5qJyFQe7h1n/mBrSxdhVdeDhNn/02F4qtkws=;
	b=WVbrhZN2g1/Enj6rVYKL7FHpVv8GV6CRXXxpMILyF41jinTrlKuy7C7VHBYU0IBXhMMi
	 4yfAxZWPYJ2JRL5vmTvm0Y1GakzLNP6VGXO4XBvF6JQ0o9LnYJmUJ86ZkCMnn5A0YnAy8
	 7QnS9Skc0rwHwA37U/hwSxZzyG354EhhKI29QChdpHn558V9CLLWy1g5S41Pe4ijD1lMA
	 4SgtQLeErBJaAHId/3LRyNZgwH7/I2Bo4rzHh+56+nBwUBMsS5liK7SwIEtQH0MNHe+9o
	 +j/Ccy3BQExrL6FRLiHEp2ShWB+A1e2l1orLd9I5VvSOQbjfP8RgyQeCqQWQqd+cuDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Gqt/BLv8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C29606A33B;
	Thu, 19 Nov 2026 04:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gqt/BLv8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9DB1F000C7;
	Thu, 19 Nov 2026 04:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060816;
	bh=5dXcXKU5qJyFQe7h1n/mBrSxdhVdeDhNn/02F4qtkws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gqt/BLv8iOOJcHdnE1AOlr0+ZjK/EEJ2IzfEi+6/rTv5/2SrJAEZjizEP4OoLFcXG
	 vsvIfW4YjPXNsEQNass4496JgXwig6qzpeIk4k4Ijv7cY82iycYzZeuZUbPmmVHTmp
	 lqiv7NoM/ZfSqwrfdorKeqdHDsl58HRGeStMcTQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Triet Hoang <triet.hoang.dev@gmail.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1284/1848] clk: raspberrypi: Handle cpufreq device registration failure
Date: Wed, 18 Nov 2026 15:55:22 +0100
Message-ID: <20261118150013.348191488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f6e7ff6e9d7cc..09cd50de41402 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -351,6 +351,8 @@ static int raspberrypi_clk_probe(struct platform_device *pdev)
 
 	rpi->cpufreq = platform_device_register_data(dev, "raspberrypi-cpufreq",
 						     -1, NULL, 0);
+	if (IS_ERR(rpi->cpufreq))
+		return PTR_ERR(rpi->cpufreq);
 
 	return 0;
 }
-- 
2.53.0



