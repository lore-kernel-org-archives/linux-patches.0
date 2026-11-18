Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023529;
	b=tTyLSJZqqMtoeWyR41JG6WodTN+WJf7obeN3D+/sAH2YIDS6C5O+xOT4N4ZYLN02dVqG
	 ZIJFaMevyL9HEY13LnwIgwUXkWdlCcNUYHujoB6w+L5Fm3LUN/G7Dq6ZUokfxMYn22P3A
	 9+UPNQ4VO6zKrADyF4Su5QMq5xucMjGhwMxo/GKX1PqMJnNyE8wSq3UlQX4fRv7/SFZOT
	 SqXHfettU41KzSVi6p4T37gMOXULBNYil9B4Y3OHHbqkmvtgNDmRkGZqPpcFAKU/Fk/n2
	 RLQR+azYhV+CtVHVdMdqDRWObtxKoHLzivCSN80Tv9JiHm3rSAVelMFHcN8ZK9Vmy1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uU+fBORdd8w+7FN7rQ5uW8Inw3AIloRVHG5YLMttDOU=;
	b=uN69Gvx1jkbJzZ11OL0Cw74hd68gEBPh5p4jHvWn6w1zYlH85Zz4yFeyM+Rypqu2RfnC
	 b9tla7SRU7Qms2RgXiyou8RMZZ+njyz2LougbH6S4xFOg15EWc0fpkV7e4qSw2jho/eXD
	 ps+iUQ76IpoEzUNEDp45UgkOUyNB3t4t/6JKWkWmKuCDzcp4+qVKlumx16FdmmO9cdiR7
	 wsSffE5qijDRdw1/rK1UB+xmXxqc+HcCTYviqZ9BHhyXIaGMeIOk8d3nUbeGJFC1H90i7
	 bGZ2QCJ8vr5EEgUmj4hV7XNPzNTdlK8RJOlH/gTAikAQ75A2pFmXhmKnhZI45xAlU5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iWRzOX/f";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CCD606A320;
	Wed, 18 Nov 2026 17:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWRzOX/f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC2791F000C4;
	Wed, 18 Nov 2026 17:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023529;
	bh=uU+fBORdd8w+7FN7rQ5uW8Inw3AIloRVHG5YLMttDOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWRzOX/fkbIx26caXZZPKo2/JIQsvqobpKd3nwrCBDnHkBhDmq0F9WkQywIctQmsq
	 mGYeaGQTwhCW8ADHOQlVibzkUsReoTgx9lU1q+QzAAgqbI1xk2C1Hh1ni07Lm+FNOr
	 0iCZ6vdLekGGu9wUYH885DlLU08cDA+XzOZEELhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0402/2151] cpuidle: teo: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:35:37 +0100
Message-ID: <20261118150136.707175364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8078eca72ca53..f5b987022470a 100644
--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -413,6 +413,17 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
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



