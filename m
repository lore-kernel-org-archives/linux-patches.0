Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029503;
	b=H+kfSeENMfAq44ZF/5sixOCmjIjAXb4MNf/EdfAVDLXVIG79Sa2CMO8DqqfZoCDXvT9r
	 GB7q4rHzxwEF82NTTGLX8LoCvbATJtwYcexSgvMprdfi9iiZWuZG0piLajj6uor8hOcHi
	 ShHrCiCc1rnJdYExD43qLAeo4iCNbx2QJsUpLzPLqw77ya9GI9VcH+O1vwdO/1jrfIvH7
	 Weid+4OH8WA7lV1Eigfc2PRZBvye0msDx0YF6fh+hyVhdM04aZOGNDCumWzTMVpkRjTWp
	 TW3lyNV8wByVJyfNjXM0Tyt0mLCqhZJ6+tLImddfjOVHxC9CP/FWxrDl0mND/Utjq/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029503;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=67hikhjJ8N1UaWt+RuSgmOjBfU80nPm2/luFKAtpE4s=;
	b=R0lg4eJRUUh/axjMNBITXQk4qSGNVCIHB5rBA/MeK7iW6/ALxcCGPOht11d4wkfgJBAw
	 8CnNk5yBrwULfpKcDPXLE4x8ojcHZkGiWXU7Q6WNQPcN4EWCnqUWPAWysBlPMVoH5PVO1
	 2+Ev3aBeJ8zilYFb4uGxyASMfjQiz1qRH5rnHwCkq+YjYN7gskuBWhKXgxnbnNAfu7tHp
	 XnNtXhnQer3OchC+nKK63aMbJCK1Al0T16bgiw/4zVwZ8zaikvm9FdHWGDfSc5z+ly32J
	 fGquwSQsWtOTV/jTK9jT0P+9q6M4bCrexKl2Md+stdbOTRw+Bt91vEqlu9obKMKHKeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YURWrabE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A736C606A320;
	Wed, 18 Nov 2026 19:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YURWrabE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D581F000C5;
	Wed, 18 Nov 2026 19:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029503;
	bh=67hikhjJ8N1UaWt+RuSgmOjBfU80nPm2/luFKAtpE4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YURWrabEG7MxCiNcr+2cKhW1Tx84TbjRqrXXEasFTM+OSp2xOYwzNiRo2wR8sIcNw
	 w3xietL9r6Z9sUKN19Tj9jb7lHGjbfYCspAG8dcf7OAe/MmKKns97BU4zIRlrVImHG
	 Va2X9q9nrF45llWAMw05iWxGq+NLvOXezkyv/RvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xueqin Luo <luoxueqin@kylinos.cn>,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0370/1756] cpuidle: teo: Do not return a disabled idle state
Date: Wed, 18 Nov 2026 15:41:37 +0100
Message-ID: <20261118150023.177394678@linuxfoundation.org>
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
index 520aa466c2e75..b22c1f8197795 100644
--- a/drivers/cpuidle/governors/teo.c
+++ b/drivers/cpuidle/governors/teo.c
@@ -432,6 +432,17 @@ static int teo_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		goto out_tick;
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



