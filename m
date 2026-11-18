Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048286;
	b=AxZpZ7PMvROnMu9WfEqJD1XvSWoXilNbygGLCrS4nlweMUd+v2HYjwa0PpqfL39eEBIM
	 2dwjNudAtzqfOKu7fNIrf8TmYWAysiqcE2LawittKDDfOZv/c4umig9m509toBMypXhxN
	 Q7BgQkW3PavUhscd/RlYFwtTw1f1EvaKPYMmUxDxjku7zIoi1WoBSe6T7wDEIb1bhx0kF
	 9FjuiFFh4lTTE0D60XoJomZXFxBmBhShqfk9dzTzQ0GY3NAsigXw5PKB4ONxiRBUrJAOV
	 hv9gWX9hMv8M8Cc+NYGzengcSMzeEfYZpnCV4qSp1cezmomL4Q6/QuW5rga1NE/mNgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dkCx19iTQps7APISQkwyu2GtIyzA4yHGSvljCOWVrqA=;
	b=Dkaq0L2Qhf+IBkj+G6K8C+Jppqx239lrNMNcygco7ycw8vBw/XOQrbjPCAGfjOfG2JCi
	 LHoP2OHsjxjsst95MdoktU/eyyow1SdZXBCV10rYVW6IFHLCxaGEoMI8+xsiPjQ5y3ppn
	 T+9sB6SKHOVNia3vUfyLuSU3VdnLj0niMi0sQlolFKrAZmPOn9bKvW+wfmeNCCNoUK67U
	 WVW0LBgDQBUrgnaucWAP3iSWStf9lgvoQiMqZ33XoMn3NDnKQQ2F0bFKSuW2Lhq2EgVDf
	 TCfpVUtC6mi3oKjwqBERXcu5+voYNi0+JFXofi/K0J8qTOXPUFNJh1aYzCrbHqB2wuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1EYjSRRC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79F8A606A31C;
	Thu, 19 Nov 2026 00:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1EYjSRRC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 722461F000C4;
	Thu, 19 Nov 2026 00:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048286;
	bh=dkCx19iTQps7APISQkwyu2GtIyzA4yHGSvljCOWVrqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1EYjSRRCUU5JSxFrsc4/wJCL/j3Sc887hVYP08IPNU8ODsSqWH7Z0MbcMc5MTMQ5m
	 cYP3kIBvH2VOagi7m7pnmZagQG2GQD0xj6fGsAx1svCHEr8tE+fAodIC4v99ARqYSq
	 hHLHgswkxFJ3k/P0Cy2U6nxOBZDxykZsfqRFleTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1903/2857] cpuidle: menu: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:48:57 +0100
Message-ID: <20261118150309.746892717@linuxfoundation.org>
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

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit d594187cafd5ad65afc5f00242f8fa20e1d8c0f1 ]

When idle state 0 is disabled and the PM QoS latency constraint is
zero (latency_req == 0), the first branch of the || in the early-return
condition of menu_select() is taken immediately, so state 0 is returned
regardless of its disable flag.

Address this by making the !disable check a prerequisite for the entire
early-return condition, so that when state 0 is disabled the normal
state selection loop is used instead, which already skips disabled
states.

Fixes: 53812cdc9100 ("cpuidle: menu: Move the latency_req == 0 special case check")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Link: https://patch.msgid.link/20260827094820.3900062-1-luoxueqin@kylinos.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index ef1ff9c36c6de..6a8fe31b03674 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -314,10 +314,10 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	nr_iowaiters = nr_iowait_cpu(dev->cpu);
 	data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
 
-	if (latency_req == 0 ||
-	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
-	      latency_req < drv->states[1].exit_latency_ns) &&
-	     !dev->states_usage[0].disable)) {
+	if (!dev->states_usage[0].disable &&
+	    (latency_req == 0 ||
+	     data->next_timer_ns < drv->states[1].target_residency_ns ||
+	     latency_req < drv->states[1].exit_latency_ns)) {
 		/*
 		 * In this case state[0] will be used no matter what, so return
 		 * it right away and keep the tick running if state[0] is a
-- 
2.53.0



