Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591366;
	b=iKGsVYZ9dToCQJ8ylBrb7MOvdxf91T3t77YaPFf4LAJm/VSLBlMjT9XwVG6i9k4n1lZI
	 YKpiw3tPysnID5m3imJTjyb81EllnGZTfpIl855d1MPjGTo7/U0BKCNjyn46qm1SJte0s
	 5J4XXdVFyB93mTfyauSYbHd37+PLqoePp2fRzhaj9+Q6dGpPqOuOqAiaxwPh5hQ3lGMjq
	 sI4zLR5qhitPumncIWIyGHoIGWMgxW98elBQt4CTaxZyaPfM3mPbb+2XKKNkwHtccZefr
	 WTslIUuVA2KAByPR1pXx+vGFzs0UX9nDlk1tRCMlqEoXb2S1qsNXz+HvAP9dmpRgxzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591366;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6Lp4AQluq9I0Z2H4C8t4bZ9UFZR6W6ylOgvLI92XESA=;
	b=Gs/CQsHJLCTsK7sFMRegTYqup07uaGNT9HUrBM0Vkg7sO+aPx+51DRH20eqZkToBJU8m
	 jNoP+y76/2R2aKzqbw0Ja0ei2SXmj1Zw8WHq6f/ieFqS3IB0g9/hVW7kRajqZiobbckn3
	 ZnllZaInMZYyNchLI+8X+A1o8U3uWxhqkYihZFz0WaewYdqYYQ5AEAgi8G0rIpKuk0hVe
	 LUj8gTHs+RmGTkk7eQzjULo1a/Q8GVoiNKY/GCILi8jfJbnctmROGyeR3lPW9pfmNeYxi
	 GIX9CY7d8HW4Yf4j1jOdvzDhshVu3/qhbARpu1SgKvfOLf0E+kEwKBy/ujPzL/zOo4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pykGhDtO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB7D606B22B;
	Fri, 13 Nov 2026 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pykGhDtO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1714A1F000C5;
	Fri, 13 Nov 2026 17:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591366;
	bh=6Lp4AQluq9I0Z2H4C8t4bZ9UFZR6W6ylOgvLI92XESA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pykGhDtOOuWxGu8LmN3gHM2cxJRUcG5UEhhSBaJhI5TD0G/WRVR1wUA+bQPfJXJFd
	 5QBq6vRiYV+abk+ijtzCXqcaGe5EIbczSmwgyIDF21spSJz8N+GezmNVmKCs8vwSd3
	 ckZCO3fQ0/qVFUPWYcQ9ch1CQZY1Cp5l5eJZtjnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 468/670] hte: tegra194-test: shut down timer before GPIO release
Date: Fri, 13 Nov 2026 10:50:32 -0500
Message-ID: <20261113153827.827188991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
[ sashal: Adjusted the deleted call from timer_delete_sync() to del_timer_sync() to match the existing API name. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hte/hte-tegra194-test.c b/drivers/hte/hte-tegra194-test.c
index df631b5100d23..0bec696774c17 100644
--- a/drivers/hte/hte-tegra194-test.c
+++ b/drivers/hte/hte-tegra194-test.c
@@ -218,10 +218,10 @@ static void tegra_hte_test_remove(struct platform_device *pdev)
 {
 	(void)pdev;
 
+	timer_shutdown_sync(&hte.timer);
 	free_irq(hte.gpio_in_irq, &hte);
 	gpiod_put(hte.gpio_in);
 	gpiod_put(hte.gpio_out);
-	del_timer_sync(&hte.timer);
 }
 
 static struct platform_driver tegra_hte_test_driver = {
-- 
2.53.0



