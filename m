Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046841;
	b=yvZiEe7imIvOYAgMbRpkkOg5AZG+ouvXE7DZsuSfX6MJJ6pUzyNZgNh2RZMBL8lOX7HA
	 zZtBva0MuD9kA/JrnYjzXPrWdOVkc9gjxr/4sP5bgz03+aZS4Cfhj/7ypeUJ+ObWkbNSx
	 hFLmKF+GJ68xgo3Px/h3HDkbbq5peecWozpqEyoWtIcM9GlMZsyiAigFF5pRblJ8L/fUA
	 6INt4vRKuakTmaiy3EIqkYzKbnYVsfykTMjISPXK6/qwjMHRppQgAK2XqMVHj3KP55FJB
	 +ADTm2Iv47I3LB85/7adVW5w3BLtC+vwAyqQYRhIi0yjfTdxnehSNAdAFx7JI0a9Ong==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HDEdIyNJIOjShAIK/VnkLgHhw+OolfWcFCyLDYZrxT8=;
	b=nXhn4HGxOA1RcJ4Fnc6QFauy1E/JUK4pPFqQxS1Q0JguiVwY9sPQT/wbhZRZd+xVzxlY
	 nkgfRhI6AoEjss3DDF04SnBAb18EyEhf9I7kY6NuXFdHQiEdqYeQO1fvsCcLqcimnQspw
	 f7cubcnB2HSBhtoZ+TylExagCt+ELGUTg4KPCMIywpSzYnS8h7VRxX2KsRFooxMV2Dc90
	 hu5VqeCRjmsb2yYSHsvzC6dFJpeGQvXb9deprk0jXNh5zx98xBSfVu/V9tmS6bs7xaJIK
	 4ELrhUvqAUKVOsEfqR9A+JUS9+ewzI+/oAcLp6hqFPrUe1sNv1B01DERIThWz1Ab0jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7Axh5ZP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A54E606A325;
	Thu, 19 Nov 2026 00:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u7Axh5ZP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90AB71F000C4;
	Thu, 19 Nov 2026 00:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046841;
	bh=HDEdIyNJIOjShAIK/VnkLgHhw+OolfWcFCyLDYZrxT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u7Axh5ZPX+nvtO30PGpjD5C3LR1c61cmeNqng9tVigRx6R/9htcKCg6pOIbGoQbdF
	 37TGzrk64WUtskqP2zpNrCINb4kLPFTwzU7r8sa+M/+x5NmiB0yP43dvC/sPXy2uUh
	 bU7hH6zfwZd9BBBwR3lncx3deShwLgQmw3IjdzFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1385/2857] hte: tegra194-test: shut down timer before GPIO release
Date: Wed, 18 Nov 2026 15:40:19 +0100
Message-ID: <20261118150251.236992635@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit 30167fadbf87fa901a2fee49c30a5c5a506a43e8 ]

tegra_hte_test_remove() releases GPIO descriptors before stopping
hte.timer. gpio_timer_cb() accesses hte.gpio_out and rearms the timer, so
a callback concurrent with remove can use a released descriptor and rearm
after teardown.

Shut down the timer before releasing the GPIO descriptors.
timer_shutdown_sync() waits for a running callback and prevents it from
being rearmed.

Fixes: 9a75a7cd03c9 ("hte: Add Tegra HTE test driver")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Acked-by: Dipen Patel <dipenp@nvidia.com>
Signed-off-by: Dipen Patel <dipenp@nvidia.com>
[ sashal: adjusted context around del_timer_sync() in the int-returning remove callback ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hte/hte-tegra194-test.c b/drivers/hte/hte-tegra194-test.c
index 60f0ef2cb324f..d15f358aa4e4b 100644
--- a/drivers/hte/hte-tegra194-test.c
+++ b/drivers/hte/hte-tegra194-test.c
@@ -219,10 +219,10 @@ static int tegra_hte_test_remove(struct platform_device *pdev)
 {
 	(void)pdev;
 
+	timer_shutdown_sync(&hte.timer);
 	free_irq(hte.gpio_in_irq, &hte);
 	gpiod_put(hte.gpio_in);
 	gpiod_put(hte.gpio_out);
-	del_timer_sync(&hte.timer);
 
 	return 0;
 }
-- 
2.53.0



