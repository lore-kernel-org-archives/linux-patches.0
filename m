Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048303;
	b=1YtyzJ8isNWMlcyfLikSUiUFj2QfMIW9hgeHPLgjhNlIW8qyM423YutEmWXk3sZs05RY
	 FRzO1vAV/GJjCpz8+bv5V6BJGxHrzCnfEghed+rF7/TtXye6YlK0UM1X0lW1z2e5X2lX/
	 vUDlMBfULCMS9LvUIiCCkxBdn/kFQHJh+c/0IsJL1G3BDwESaFpgc4LgO4I6uoLpO2zpy
	 2MBSxvfXClXnxth3NMs1Pk8LeeaeUwtRo7NnzIVub2ffYBf1yaMbTed18D6ovSTN6Qmt6
	 M9ViLeIaTfrr/5IyyhFvTUZ8ph2AfYizblC3iGn8uQEY+qViDBFx39w3ys4vq96Z3gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048303;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C4AeTWvS3XrxD1XZgsAjMOU8LFKJQqyYCyafQbx1rvs=;
	b=pFQ/flkSUPPma33gCo0lC1FXAWUGIEF9aBW55DUIleyBiE4V0zpWg3uIFYBnseAcmPrc
	 0yYf9a6KYumR4dO5wVq5RrpRNkhMJxKiwT82ZlXkcpv55VokF7aKOG2+piyMPopIx2prV
	 t5mIJbCudyERaxMByem5wPXp6L/iEROfCTYQCsoxE1M6kd8qXUfUe5z2C+Ov8SKEnwE7k
	 cbS3wzaawcLL9DTjvUs1HtZSdkDRmgnrmUL+xPLKtsgdBNslx43D2jvKOvzVua5ptdDqV
	 i0cXkgeUsTngxN/QGEYJITwjltAFKm41uSVByHO2+kP+ZDAtvt4ufyYmAyYQgHJakMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1mrAEnm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089C5606A33B;
	Thu, 19 Nov 2026 00:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I1mrAEnm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189B71F000C4;
	Thu, 19 Nov 2026 00:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048302;
	bh=C4AeTWvS3XrxD1XZgsAjMOU8LFKJQqyYCyafQbx1rvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I1mrAEnmE4tguVQsBm9tCg1PjuQDsvIXcSnd3g3sgXyf4ZdiEWfn7XD9BOkR+88PF
	 HVertgZGH3Wsi1jqOLgW/uU5gVVBZcm6oqLq4ydm8irZcVjin5c7ynS+Eae4n4+XMs
	 szlsrY9jT4kqK9UD5MuOQuumMjwT60Mx8wo6iqVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1905/2857] cpuidle: teo: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:48:59 +0100
Message-ID: <20261118150309.814966819@linuxfoundation.org>
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
index d9262db79cae5..8de499ca89ea7 100644
--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -445,6 +445,17 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
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



