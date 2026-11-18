Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048255;
	b=ZGxuDPUlSOMC6Dsi+88hbw6Kg52GnZBaF8BqGA0evHunAQeMqzYcAebGAeCpDOCMINS+
	 lXyLpfy7BEXnltWK0GcnJSVvWQq01WMEDjD0PydOF+/10ZwWsD4uwF+uvbSVzIqwXzzuu
	 MYrttsFKZ4h1FG6TW6JuHqUKBb/8lkPHsgvIcKSLASBPSqAVYJdCYcu7myh3RhkITGIXA
	 kEZFipoiioG8B/WXe6027W3SGma4A6rCeL/F4zfQQzOJ4ff8UFIs6XY1agQ95O3Pd3Kay
	 vHuKLTuj4jZ0oUaxb0aWjgqvBw1DzmM1SpbIwxvITmF78R4kqNmiU2cxPcSadyUFvOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKIMUz9na7zRoJYKeCAahLk9eLR18czF+CPSgxuhsJY=;
	b=VCjqGRa/lZvBlkdcaubD/HXBMdP6qwaf20OBVAJRaVi4a8SyeiVKbiVn9oTRLLL+ksPc
	 N4FTYfbwSbUUV6mF1JqfXA1jwZMIfPbVJwgaLNqGD+mfTRDPHW4a2/NXZ4B4DZP7DpFgD
	 qI6hQr3PKIYyBb4JX+c4wIEzeEdLLg18xX5me35PvmCh8hWwAFWBBldaZJBqNPFPUf8/z
	 QuVvNE+uFmr5hEd8YMPL/fn1mI0Oy2fhQHsuiGbRfj0mYbFRxA+bx6Uxn35cazhigueSL
	 QeSkeXymXVKFIgwYaxd440cd2SiyJhkk4mv6DimCTY+jPTVy690uZb8PJvMhkOCUsvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RjcIUiau;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E359F606A320;
	Thu, 19 Nov 2026 00:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RjcIUiau
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482451F000C6;
	Thu, 19 Nov 2026 00:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048254;
	bh=kKIMUz9na7zRoJYKeCAahLk9eLR18czF+CPSgxuhsJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RjcIUiauVXbZ5aK4FaY2xK9k+8ecXaRe59Kgf7K2zP6GqbIc7egbl1XJZT/DUnPbM
	 okOqX2idaENxlRc4B5FYJmxYmLsm4NAj+uRdHStb1rbKKqeYyXsFTFd6iX5LbbIDYT
	 pSKGj5dB5m6YBMXyGoG3YM3uzSd5IQSiTzloZnyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1902/2857] cpuidle: menu: Remove single state handling
Date: Wed, 18 Nov 2026 15:48:56 +0100
Message-ID: <20261118150309.714979371@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 93983a9f3beea791c21d77c2425488ad327d4fda ]

cpuidle systems where the governor has no choice because there's only
a single idle state are now handled by cpuidle core and bypass the
governor, so remove the related handling.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
[ rjw: Rebase on top of the cpuidle changes merged recently ]
Link: https://patch.msgid.link/20260216185005.1131593-5-aboorvad@linux.ibm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: d594187cafd5 ("cpuidle: menu: Do not return a disabled idle state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 5bdef6470ca12..ef1ff9c36c6de 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -314,7 +314,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	nr_iowaiters = nr_iowait_cpu(dev->cpu);
 	data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
 
-	if (drv->state_count <= 1 || latency_req == 0 ||
+	if (latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



