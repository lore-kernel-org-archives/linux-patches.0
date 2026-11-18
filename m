Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023507;
	b=Zjka9Y72Yz5pvSrrMZBmfnXQufLoPRNzEBEDAvoZP3WDsotLAxrEcbTwwPmsISR2xNDU
	 ymtuEWPWsqC6ato2dFXUn6ix1fHSg4K3P35qaxg/b26A7RSC9SvCAbaM+US/02jF971AY
	 vuH09mrmrWzW11Qc9A9aMuWjOOK05NJBG6N8EWhMpxgJWZVXLjhK80k6Gj14nTNsz1h56
	 897kn3p4XnXV8d9/D0nw0Wo81MRR2S2vuVa2ayw9c479mrkeuekLGJK39TMWmMdkCCE3a
	 G1PtwL+TSMVEBV2zZqZyvoqjQASpBnR55z2Gs5oc18bvCjbuvNzF1tUQJGYobGZDJ2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mISkGH9tm8+yJp5U9odch6AsAYhDlSeV0NWdBWjNyOY=;
	b=dGSjUR8I5zmqCPCLfiT+u47Xv2X1u0/P5qRec1Gbw4xBlZo/+w0ztXENSD28rVTi5AZ1
	 Sd23sRly95JvjqjwEo7HNiGHBveJ/31mN26jKOIjblfH85kAR7+LDcYUdq+iVDZ4y/OjQ
	 2dpiI/gveJ0Zy8xnObjjbMLn5pMD+puMimeFIKnf55QKLA8nEi4d+ECkd1QaOgV3aTP/N
	 bhaqn93SXgCBbf510esjgFmQavU/pmoo5jS6BLMAUTAE1e0tn1uZPZF8WRJ9E+5hWkE4p
	 v68sOAvf3i2k2m69MvS5TNdtkbNnUseSkvLEX4w+GF98g4lJo8kYYCaxv7rM/fAiNSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPmrwMC4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0975160A2601;
	Wed, 18 Nov 2026 17:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RPmrwMC4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F8011F000C5;
	Wed, 18 Nov 2026 17:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023506;
	bh=mISkGH9tm8+yJp5U9odch6AsAYhDlSeV0NWdBWjNyOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RPmrwMC4P2F77rzhfr3GCtM7QohoIMdqVz0H+Ie7GU6UInQo8bYPHvvuoYaVYodpA
	 DqInBY/hidMBRMqRc4W7AOl6fgQhZphxKQT5btDQ4KYJ31cN4yDi/QYQBMyT8MlOuR
	 hz/c7RkQRt58zPhHl9vf24P7piEJj4zC1sVAZ+iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0395/2151] cpuidle: menu: Remove incorrect unlikely() annotation
Date: Wed, 18 Nov 2026 15:35:30 +0100
Message-ID: <20261118150136.450191349@linuxfoundation.org>
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
index ca863ba03d454..c6052055ba0f9 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -281,7 +281,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->bucket = BUCKETS - 1;
 	}
 
-	if (unlikely(drv->state_count <= 1 || latency_req == 0) ||
+	if (drv->state_count <= 1 || latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



