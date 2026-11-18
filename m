Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039656;
	b=gLwhp6+apS0MCf4ADHw+H9ey5SmOhE3Kkn9rV4PVW1Quy+agADEdT+W+nvAGcV+/Hs2l
	 wqhBwYPYflxx/xn/6ULBei3CYtNlnHmxyDrXv4yWI2XCVgJoBmfM+KsS5faKwgSKkEuP3
	 NXZ52ii7bjvjuNZ8UUUgsMwFBAPR/FuVMvC3Jj9iVRWq/EMQgFdvq8p+ZOdcYJj+vPMLI
	 vOVcdm5NmGIyCbCFIcbVjK0YAFd5HfstTIS+7zLFTizh1Jq9iUHiZZKcTuO2jpsWxWO2+
	 3oDs8ggmsTgz/dbTvOXUUvNUCJqscDLr8zD3905v/K86G2lFk7PPZDRoH2zATDISfkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hKf1qUcFLDZCozIvWcQ2zXpBIzQiADJXHN87SbJkXQo=;
	b=En9ze+639Ao+qTIRq5oSKc5YiojeKd35s+NLT60dH5lEj9EeGqVF9Sl9WcNs3SPly0SB
	 2i2oCXsDovAkIoz5oxO/UDl0gYBm5yTqlvkt41nak8/7CvNrlXtl3rW0PIjZFvUrQMvNo
	 85nCUKT80c2PZHSR1iR9fh3s9Sqp9asSC+OmwA95ktLGmH/TZ0MNbfb38MnVjdmBlP7BL
	 gfXbMKLhwyfPTZc5AvkiSgZzg9iiigYipUbaEAeFByaxI/WwMGI+kH5Z0YgNhlbF3bCDX
	 AlQwvBwb0LFM4rJBVHc5+gC92EEq/Gp4omCpxpdcxX93VvPET/mhHsfgHVNL5do84RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bcN+hRC6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D096606A31C;
	Wed, 18 Nov 2026 22:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bcN+hRC6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32B81F000C4;
	Wed, 18 Nov 2026 22:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039656;
	bh=hKf1qUcFLDZCozIvWcQ2zXpBIzQiADJXHN87SbJkXQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcN+hRC6iRznL3wtb2YgAWcrNilAe1u2LQ73pr0Uj4rrp4/MiODvsX61NdZSLkpuH
	 oXZjkgDC5tEpwZeBAEE3LJ4Eet+DPAbNG0DaawbFFbKKXgfeLpcNgJ+ZyWXlUHUcIJ
	 Y81xqnsWRb7qDm07Kzjmhq4mjUEfM9V72tuF6wGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2177/3318] cpuidle: menu: Remove single state handling
Date: Wed, 18 Nov 2026 15:46:39 +0100
Message-ID: <20261118150427.281845438@linuxfoundation.org>
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

From: Christian Loehle <christian.loehle@arm.com>

[ Upstream commit 93983a9f3beea791c21d77c2425488ad327d4fda ]

cpuidle systems where the governor has no choice because there's only
a single idle state are now handled by cpuidle core and bypass the
governor, so remove the related handling.

Signed-off-by: Christian Loehle <christian.loehle@arm.com>
[ rjw: Rebase on top of the cpuidle changes merged recently ]
Link: https://patch.msgid.link/20260216185005.1131593-5-aboorvad@linux.ibm.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: d594187cafd5 ("cpuidle: menu: Do not return a disabled idle state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpuidle/governors/menu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 7325939b1d123..54bc2ccdf8e06 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -311,7 +311,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->bucket = which_bucket(KTIME_MAX);
 	}
 
-	if (drv->state_count <= 1 || latency_req == 0 ||
+	if (latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



