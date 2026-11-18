Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039662;
	b=2yFE8TvMsX77fjZYP0ax7jCp+PRpxAcduh/u7T4sdlAKT++TmKtH6NqmTE8NcWWK4V3A
	 r3v/etTi6CkfnCqSlLMlSDSLLKmZ2ublb4VHJM4akRphERe8vHmUGSwuaQJ14hCVtzjXK
	 LsH57vpvUemj3ryuXyAjci/26qmOXJP039elbFeSk9Rn9COSrvwn9Ldwlebbls2DzWTx3
	 IklFj5VrLcVFeV5Lzd2JXzbDKuJmqEvsGAEUIudXHFKF4Y38Qa2PsDlh7xr7QDBQGQByd
	 6j/+MEw6EAOh1PsIIPrSqcwNpoItqLBsuRstEu9hqbz2vi5EFmUmaBkJrO0dEhz5KnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7xwG0Z4xhwS7a4xoCpxIE1EgUFoZnBzOzmQXccongNE=;
	b=YjGsg6i2qQkavjuB0Fm1MJFTUTv+khHSG5VWOqcCESfpR/Faw3iggyVSNG/K+IbvubH6
	 5MA6LCmgBVOc1Yny1ZlKuDBggtagrLiSk0DjwsR3Z5h2xFb0+rSvEZPXqgeWv8/TlCH+J
	 8CY1HkF1Yd1VPqjM8/+Oai8VqA6A/kPhbZIgoJyVT0u0/u3IwchRr+bygdzwGzA5opOfx
	 qrZsKJn5IadO6xMIfnplFqwHpai8Xe5CzqA53cUV7NrFSh7etW/9dtqt8POXfPA9/nNVL
	 riEThhRWYtHsbi9YdjeOgs1aZK7dUir36xRaqd5LjjDDXStVAFyEPV6CLK8YnRycnpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TowtX0Bn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DCC606A33F;
	Wed, 18 Nov 2026 22:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TowtX0Bn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA5D71F000C5;
	Wed, 18 Nov 2026 22:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039662;
	bh=7xwG0Z4xhwS7a4xoCpxIE1EgUFoZnBzOzmQXccongNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TowtX0BnIwzo9OE7HZhh3DfE4jpVxqBKVMXHOzoBfOlO66e3G9tivLWNnsl0HAuaH
	 MTFXMufzUIgkyY2medad7VGcIxJR72SeAmOFBlrMSbdYdqyezKonPap+ffMGRNV2zh
	 yjKyKDQ8/1JxlACgbWUGU7Wd4tdAaXSMPtHIcdr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2178/3318] cpuidle: menu: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:46:40 +0100
Message-ID: <20261118150427.309953468@linuxfoundation.org>
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
index 54bc2ccdf8e06..f00c65ce274bd 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -311,10 +311,10 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
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



