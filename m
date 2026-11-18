Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039671;
	b=Vj8XUug2uETWkjff060P53Mx07+pHD+0OjFvCFoPi7GVvlo7CtOX069gqKHeNh1+emiq
	 iBxjDhqRsd2YeE7dZV+wCjRZVt2nT8nm9wznvXt2eU8d2rQS1yZ+VySObZ1ItBphXZqIt
	 XxqBaQ918kKhiiaaKL2+VQ7ATA6G4+2OyX3QoCE6tumSWRUWGTcrGtmmih1pzjb39+Mva
	 pIO/tQjiVbG1KXj0D0CFBNiaQvYB4q6Z71He8fQ0yWrctMY06Y4pWyHXFgDJfqCbcmiyw
	 JBTj7PhnN4MXonwukFsm0Z/hPkp08n9DjJJaeryIj5YKJQIZNslFohwaPOb7t2ZWegg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039671;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zz516gfF0rD/6C/le2M0AEpoGFmivEZTIZTvTnN3quo=;
	b=moa8mAGUbkvhqQdTnBQ3KxgD1m5vRHl/BwkoxxFuDldKR4lFOl3RJ9rbonxMEquVOgr4
	 PeMR5ttkhP5gjum9bplny7bCb9ID4lqtIJ9qTG/0ldi8bD7p5gu1u8KlFKwawU8Ex/TEK
	 pIsqmzIrPhkLmaK3kxfmQ3n5BU/SNzzTxcXAThFLMqed6w8bABG6OlQdLF7UP9mq9vlko
	 HV6cmtkrCXrizASnQ8Y6aNWPJMb0RDN6W95abklzNutlIrLJpdoJMeFAYopO4NgFXQfFH
	 /qAH4rK+rc3gBReqaDo3rYo1BTutGR86kQLHRV5P/XHrRGzz0HWJShgwH+MrEKwnsbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yiyOqD3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A63C60A2602;
	Wed, 18 Nov 2026 22:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yiyOqD3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277591F00934;
	Wed, 18 Nov 2026 22:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039670;
	bh=zz516gfF0rD/6C/le2M0AEpoGFmivEZTIZTvTnN3quo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yiyOqD3YpZQhXIWr35mjN7BHBkJ83JbX3bhOp1e1lT55TCdpuPv8DpfGJDu5TUVKX
	 3I26hNzG+mwWKKgn4A8jMTkOHohY9bs9Z7Pr+IFWX2krpVpRws3sNa96LesQ+aLemk
	 zOfAFCbn6ZG5/P4XGKeS2Fnn/OPz3Ey/Z/jFuWaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2181/3318] cpuidle: teo: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:46:43 +0100
Message-ID: <20261118150427.396239818@linuxfoundation.org>
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
index 3a06ac29316d7..f91068b0a8747 100644
--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -553,6 +553,17 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
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



