Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029489;
	b=4xpRJsuimL7wRE/9UU5Inam9NMs0dk+LODfDiV3G6w2tVbCPzd20fasoSoH4OudRPaa2
	 BHN2rEjYajlkMr7l/YtFMXp3B2eS7rbSVJ2z2eUaYPD0VQqukSd2cDn1a1Qd0dNN+/pyv
	 e7CYvm9azFiTa5nOOd20K0H2xE2yvda5k5ZKRRE66o/M5/Nm/g1Im/sKUGIhd/HoDYabn
	 X9vL3DFmhJbN3E8dio4RYRN66SPYL4plrHw85A2ZeBkXsF7pXdq+oS9gNFZLe+wsj6TnQ
	 KMM8MkKysc6hrK2gHgEYDQJyNmqP1FqUjP3IEw0TNWT2oWGYKfAb8IR2ctZfGHYIjuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029489;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FebWplz2IlF8ZS9kunIzHvcDoNz9zztGhN42M4mlJyw=;
	b=nf2zv5Go4RnhWTTIwsmAx5Kmpr9Kug9Ku31wrdm79vElYdjZ76Hkw9M2Y4ygcOQqyAZW
	 IHY6ojLIFbza6WrERvjvqRxHKXs8Cqs3/WoL8MNPlvOY5+kowJxKWfpzsGe80JFKuOi61
	 KnGMKydlF+GydMfKxEZwJzr4F9TUzDBI3PNLXO3FCjcWpbaOSHRjIttBSB5nujfZaFzQ6
	 xHAvw/HFm2UQ1oXWhzaQoV66H5cSKOF1o8V3OSLL+084puklvsANGtzftpfl4GrAsp88U
	 b/F22w5Q4Mt9SoNWM+e+bVe+wtNKjWhfUJHpuEZWCBLqnhPUszywNw/RndaUOJ2B4LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BvhitI5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DFA606A31C;
	Wed, 18 Nov 2026 19:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BvhitI5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD2E1F000C6;
	Wed, 18 Nov 2026 19:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029489;
	bh=FebWplz2IlF8ZS9kunIzHvcDoNz9zztGhN42M4mlJyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BvhitI5alW5HjPzbDzLgn+xfh1KmEFYKM4H698l8LdPAIqUxp3wZagHB+tRQcdPk
	 kZ39p5XfOMqbBrvLliSDr6qekRX0q23SPSElo5tL+rwGCpeTlzly7F+mVuxO0BYW/C
	 cPAZPuLPk2L1prOgEBgiZP4dDx7AhKXGxq3S6sNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0366/1756] cpuidle: menu: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:41:33 +0100
Message-ID: <20261118150022.907364010@linuxfoundation.org>
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
index 3c135e40bf20d..713d7118dd135 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -287,10 +287,10 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->bucket = which_bucket(KTIME_MAX);
 	}
 
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



