Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016120;
	b=Wt6YN+e3UwxX+eetlizrIiWz729lyfL7ALIQkusG0VkU6Xvgm2GYPA9ky7tHNBizDVBh
	 uNrLLR2z+xddvGy1FQgIjAr1VxEghbr6tgFPdRWQn7JBL3CUVC6HqtBKJ+9MfEzjrRmMn
	 ZC/OpIJ2nLnPf1rJeAtfS5sp8oV+kvuCjPaiy+ZIClSbhH95cQh6LazEpn1kxX1d1/Jyl
	 QuxWO9RBpiVKEhTDVsjctbAab5hmnDqD1ddqmgx3LZffAF5mgxm4smDJsOQZO7H6EBS8S
	 a5m587oQ+2ejoceahaQusmaI6Fd/d/jm9iH+PuIMX0F9g/ctIUN0yhBodrla3VC2qiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016120;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=B6JZ2OxkoPubCpgXZLBvHOu0xpu/YybeaF7wLziuWx0=;
	b=C7bbFoxGXKF4sMfy+F81iDeDI7dp4KRjsiYWdh4H2jnZNQRnp/ZdOlesCLj+fxQ1hLTJ
	 5ooBcOnFivHwKYBQ7g4c9y/hJQNBsrBNK2D//jv4qIvj0ibg/bbw8gOD+pR+FhpBu++9g
	 P27QkP0M++Z52Dlo7HqZSbq0cqnSq+7IeZQtVazZgUcWRcSXbyhDIYarSil9Hbtt9CmRc
	 n9a26RCuet9Msi1Pjdya0e/8SLQzxFzLnCDOdSAgEO+NHLmPkeFz6QXizdgL6eq+lBRg/
	 gyx+jpFJY/vQI5scMA9Lk3hKjA5MqHhsPs7oloh58QU9fn//NXaWqe3/Y1NGL0LYiWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvJAfqmY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4EA606A31C;
	Wed, 18 Nov 2026 15:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SvJAfqmY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003B51F000C4;
	Wed, 18 Nov 2026 15:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016120;
	bh=B6JZ2OxkoPubCpgXZLBvHOu0xpu/YybeaF7wLziuWx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SvJAfqmYUZPsQI/3PdCp3AHJ6WKlZwIpUyZtyZXv6LIdC69E71Drb8YQ209Kr7IwJ
	 qS04O9JWW26yS7Mqjaqu9Urf1wU2JWKj2S0UD5LQyVpTO3C2BNcadBGSdLa0D2czpl
	 wXO9rG8KDbPqCi9vsvzCz3+kV8yhn5NxL2wrYjUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0415/2651] cpuidle: teo: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:27:35 +0100
Message-ID: <20261118150302.774880647@linuxfoundation.org>
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

From: Xueqin Luo <luoxueqin@kylinos.cn>

[ Upstream commit 60d5fca628f94f8f23398ad62d80aa284dae6571 ]

If idle state 0 is disabled and none of the enabled idle states satisfies
the PM QoS latency constraint, constraint_idx in teo_select() stays at its
initial value of 0, because the loop that updates it starts at state 1,
and so the candidate state index is capped at state 0, which is disabled,
and that state is returned to the caller.

The cpuidle core does not validate the returned state index against the
per-state disable flags, so the CPU ends up entering the disabled state 0.

To address this, ensure that constraint_idx is at least equal to the index
of the first enabled idle state (idx0), so that the candidate state is
never capped to a disabled one.

Fixes: c410a9a142f1 ("cpuidle: teo: Change the main idle state selection logic")
Signed-off-by: Xueqin Luo <luoxueqin@kylinos.cn>
Reviewed-by: Christian Loehle <christian.loehle@arm.com>
Link: https://patch.msgid.link/20260828032457.2317326-1-luoxueqin@kylinos.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/teo.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/cpuidle/governors/teo.c b/drivers/cpuidle/governors/teo.c
index ac43b9b013b3f..906f4f89e3659 100644
--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -426,6 +426,17 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		}
 	}
 
+	/*
+	 * If the latency constraint does not allow any of the enabled idle
+	 * states to be used, the candidate state index will be capped to 0
+	 * by the check below, but state 0 may be disabled.  To prevent the
+	 * selection of a disabled state in that case, ensure that
+	 * constraint_idx is at least equal to the index of the first
+	 * enabled idle state.
+	 */
+	if (constraint_idx < idx0)
+		constraint_idx = idx0;
+
 	/*
 	 * If there is a latency constraint, it may be necessary to select an
 	 * idle state shallower than the current candidate one.
-- 
2.53.0



