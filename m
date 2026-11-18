Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038150;
	b=vhCsyO0OWloRUgLF8xALt+0ypJsXdGYAqqQxXhz5HUODbHs9EjLn4XvX2I0hawOHRi9/
	 3flD1p9ygL+mzcI4zVYpzuiPpZIESiYQgtsJXL0dywxLtevwkX1vT6bf5rrbc6fhxlOEX
	 FcU9iLquKrz+lapD1AxTXX+eJexyUtFDAH8RRrClMIBIIA78SBDIsU+VGs1sfvqSQAIhL
	 u9cC+RynN3vHynjIzEpayHefKwIRhUdGRL/EEIujA2mywBEjWj5fCymcWsCFFLDE7prai
	 JbKvOVVRhyPSWjWpgdmHisWAXd0irw9Ta0Em9Ai1FF0132YQYnRt3UhUKiN/L7Hkbkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FlDCVF7YZGsbsIk8/qF00Nzw8P7r18mBBQsnV9FD+lU=;
	b=sJw2iEwYZhhw7Nvwmu3SqKRRAaDmS7STfCZOKbRJ47izgK3IEohqHSpp1H/Wt94y6YTK
	 fAcsFkTf66POWkwgiL2sNlzjifNS7mIAxh5vktAH+249etUFsh3XHyulQczDLzYexIWqr
	 0PXAgMdE31vyvmsnylF8CbZ5fgvv7VoH9sA/8RgDEc0nktFKLsVReS0qXO6B+vk25v1xV
	 jc8gUfByD4gb/QaUUiIU6gM8lV5jktFZI7qfAttYUf24yfQ8cjMUPS9C94fqC/Ispj066
	 Wzj+d/eheSn9gwerDmAX1W2lCTSMyJh5QYbaIOPXHlsF7zMy2qRjDHUheAWCkHpqeHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAc2XO9b;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60011606A31C;
	Wed, 18 Nov 2026 21:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAc2XO9b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F2E1F000C5;
	Wed, 18 Nov 2026 21:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038150;
	bh=FlDCVF7YZGsbsIk8/qF00Nzw8P7r18mBBQsnV9FD+lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAc2XO9b3iIpvlbG7e6ODUdKSAAEz9i9vfdl8MnCNd6GtzKbmrDRYELH9K6ra9ifW
	 ZlWDGcgbOrvA1KpSh+r5Y4K4JRdOulDueMjBJH2v4RgEddNkkvrUGb6LiueHFxDTQU
	 q4FTSNDK/xnUf1JNX9Fu2VZXkYrAYY+G/rUZnB20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Dipen Patel <dipenp@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1642/3318] hte: tegra194-test: shut down timer before GPIO release
Date: Wed, 18 Nov 2026 15:37:44 +0100
Message-ID: <20261118150411.022284976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context to remove del_timer_sync() while retaining the int remove callback and return 0. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hte/hte-tegra194-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hte/hte-tegra194-test.c b/drivers/hte/hte-tegra194-test.c
index ab2edff018eb6..d9adcd64a263a 100644
--- a/drivers/hte/hte-tegra194-test.c
+++ b/drivers/hte/hte-tegra194-test.c
@@ -218,10 +218,10 @@ static int tegra_hte_test_remove(struct platform_device *pdev)
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



