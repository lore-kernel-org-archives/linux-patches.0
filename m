Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039654;
	b=BCb7LQKXb3g/UocAKApyunKkWrSmg3kCJmaeqngi5sr+q6SMlLVqxm/uR+hfehMUeL8h
	 Lj4omlGQ8/UW+UW3FDmjAUxWgss9VALoBY13k2Sh5tM3R5gE8YCfcPRQ9H5SUGCdog9OE
	 NykAPpEtu3v3Wq0Z24aZhiI1fVtCPlvMWpSzglRP7KpAIVynYPFj1wgATSCVqdk0Ycb6k
	 PUjePJBxc9LwER/92zcQ44Bz4t5KVmmtOEwzTNuLTJeThg7ldr2CXou+Qe4QPE/drEmfS
	 kz8xCIHwYOEjC7xcHK/a3S62960PV90o3srj8B+orejOCnqkrM/cAl0ZURisALNdoLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=etbPkIuAmabbLZ3pfDwSOhOCVvVoW7WgAZabc7Fz9aw=;
	b=jW09lSDyLFkiG3aWE7zA21rz7XXtIsAWoNPt9hOiFSPzKIEHPvRBEgp3GVA5i9mHU7HX
	 SDRFTrVXgUupPPppakzWmp2jelLxYfV0ZrhNRHaqdLbBxTDkJHcVPGQ7sJ3N2zrclXWNk
	 rWs4j0RJTXBrXLQqd5ilA3di7KjR5tVYba4iYcx1bi3surBjI1ZqmHvcKvJBMO1D3ZCFx
	 snZQk4rPN1ttJ9dPGysetoo2M8d6BQ3wBAY4whcv/GqjN1moZyelray32UDEajnAYlGZv
	 zoEW5mFfpmF0yvDuXyQTEtGRU9ZmGc/4Q1NMeNdE6ycphOzsovoSvyhjt90qYHXmUWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3YzPJk1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E236C606A31C;
	Wed, 18 Nov 2026 22:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3YzPJk1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EACC1F000C4;
	Wed, 18 Nov 2026 22:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039653;
	bh=etbPkIuAmabbLZ3pfDwSOhOCVvVoW7WgAZabc7Fz9aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3YzPJk1lCNA1oCiaxt9++tuwNDksfFRsD1pA5VOW/KqF5BNLWeK+oHCowv2cnMlM
	 UBTzByVGDbLJTUr6Wn4vVYkpE97reMPGdQMkTE8ndTarFa7lxvK1i/A0X+y0GWVSNg
	 glPNG2we+F4BIUryXc2YfffnsQvYbkYXE9u3/NeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2176/3318] cpuidle: menu: Remove incorrect unlikely() annotation
Date: Wed, 18 Nov 2026 15:46:38 +0100
Message-ID: <20261118150427.254792853@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit fcbd7897b871e157ee5c595e950c8466d86c0cd5 ]

The unlikely() annotation on the early-return condition in menu_select()
is incorrect on systems with only one idle state (e.g., ARM64 servers
with a single ACPI LPI state). Branch profiling shows 100% misprediction
on such systems since drv->state_count <= 1 is always true.

On platforms where only state0 is available, this path is the common
case, not an unlikely edge case. Remove the misleading annotation to
let the branch predictor learn the actual behavior.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260105-annotated_idle-v1-1-10ddf0771b58@debian.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: d594187cafd5 ("cpuidle: menu: Do not return a disabled idle state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index bedf6c4b8d1b5..7325939b1d123 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -311,7 +311,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->bucket = which_bucket(KTIME_MAX);
 	}
 
-	if (unlikely(drv->state_count <= 1 || latency_req == 0) ||
+	if (drv->state_count <= 1 || latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



