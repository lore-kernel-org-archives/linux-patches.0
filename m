Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016637;
	b=Pn8AeLaO+mx/P0ZF5oqcuFjBfLk4G9LRSMwt7se6Dm2ufVSrzhZBiPey1nZ2pOvazi4W
	 KovCjzZFvla812ndcEskDzDjV92gn0Z6/65JSllE0nuMWigDZeMq8uVZdzrInyqPb2bTz
	 FGv8b5EfSM7Stf3SNcdzWdfLvvUcAtxt30DCDPaR+Iqgw3qCCaboKfMFUCbJVQztWbGyT
	 v7UWf3acCDOcrSU2L1oMXKRtY/wjXK7DdsGHyDN3Je76M24H4LXwmJnK2C1sqnxmHI5pu
	 XnHTNhMWyWhJdH2QZP0qQcSdTA8z0Tbsd7nlQtUD94niEbgP8J0kdnouBcMaTARsvTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7+qMIjk1AO9V034bZAGI0g9sdOEUtgToo7kXEUJ3X0I=;
	b=GUhexCjvGRI3FJq5qErOfo8TxzbfE/08Q2uq1v1VFpiBr4U2xfET5XOE5MrloFX4gurw
	 nCIcu+5gFwlWgwzINyMVt1Kbd0KvoNNKhQn2Hjb4HhRJmvTqtcztCrchoRUF2YQOlQOH1
	 /eMMNGk89KY85R9NxsvWcX5asP4WcPX9cX5kyoshA2amVqFoQkevUC9qYXJc/fqkjXr6f
	 UhLHph7T7OPJtsbEvniy2tj/nyjqEoTBYTJ7jW2VHegK+oc2imwcr4bo/lF5NVFc1wEFi
	 YBcqDmlWMD8Z0Ela23zHF5IuIgo5x5auU7mM40Y5tgcMJSwdafoOyPSBHM35BrZopsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcnQRUiD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3A3606A320;
	Wed, 18 Nov 2026 15:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CcnQRUiD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B456E1F000C4;
	Wed, 18 Nov 2026 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016637;
	bh=7+qMIjk1AO9V034bZAGI0g9sdOEUtgToo7kXEUJ3X0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CcnQRUiDE4cgNi1JgG/6Nx8Q0KpJ/f+C+f//ZQOLO8jOG+0a8ulxQChOY89oRsys6
	 xcsKk39sEik0yr1XngnqhHn7jnl5Yr4HwUFE4CmqMw8srVnwxKxrg7RuyZDdxJJAlH
	 9f2dHLy7ZGkXgntncU0XuFrwwKj/d9vdgfLiHTKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Triet Hoang <triet.hoang.dev@gmail.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0598/2651] clk: raspberrypi: Handle cpufreq device registration failure
Date: Wed, 18 Nov 2026 15:30:38 +0100
Message-ID: <20261118150309.251605393@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f1a99de6de4f1..9882f243d6813 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -553,6 +553,8 @@ static int raspberrypi_clk_probe(struct platform_device *pdev)
 
 	rpi->cpufreq = platform_device_register_data(dev, "raspberrypi-cpufreq",
 						     -1, NULL, 0);
+	if (IS_ERR(rpi->cpufreq))
+		return PTR_ERR(rpi->cpufreq);
 
 	return 0;
 }
-- 
2.53.0



