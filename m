Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055020;
	b=d6kWvzF29XHHlXDXBLASOCBGvp1fqRuiBzFvGp7kXHkHkF54gTcJcr7pAagudLVb3t3R
	 5oXQd56hmCUlLg5gghCGrdatsAIWRv5CEc9ds5rZ13nSMat41e9s0JxU2JJgKqw9HUv++
	 6Bb9DYhY0aBg77G5C2YpUVRb3HcOSu/rckfaW9I0p9blzfe/grhMv4sU3IFSJ+QkFdq4K
	 vLu4+70LPciVDUsrlnzfuy67bkTgs1SCohc/i7KCu+3QycXladku3cMh2h8H89LVdEQaa
	 b2zW1QH9eAaxyuw7tFst1EyfG2OAKoErioVLmsw4BYnckS+s18l9gQb5PEGXnWxZN/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1YSnlrU5MRAsSZUizwnRXTEEj7R3fVhqTSYAXzCO2DU=;
	b=lJzHt7XOK2+4KiSZahMMhxymRUV3MZ6KrgXscp0eHB2BJStpCpG2MVmO3bHhgUwnQey1
	 bu8sgut9eTmKjTwrWonZGoMY6JRlCTV4VR+zXcTjjn5DwqOj8O4o3cjisJ4JqrFc05sjH
	 W6tFuMXnJI6f/m598fVhhvcxa3tw1dtG7w67Cwku4Euob13CD7TGVcLM+1FVlFDl1UGhH
	 1pfsvavfWNZcPa6NRtjDJk04WskgjUYpznhxd3ez9GTSlRUPJx9chByCaYnMDyCOq8Uol
	 aBCgP3dS4muDqBHFdmWtuz1B2z2YAjhjwHsMQmnJUabL+TgKxFS0paTJkUZ7O2QpFvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1uYKwRB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C192B606A31C;
	Thu, 19 Nov 2026 02:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1uYKwRB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E8E1F000C4;
	Thu, 19 Nov 2026 02:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055020;
	bh=1YSnlrU5MRAsSZUizwnRXTEEj7R3fVhqTSYAXzCO2DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1uYKwRBjnjiUjaiJ8Z5e37nYogO0Xh1XWecV9HoQ1kPYWuSkwpJPQ33xhj7NaQ1D
	 b80ms9lLWSwnRY0wmYk3RM0KOeSbQivup8uhrQhjot+B22KOaILCB98QpuswcoOI9K
	 1jYPlHbfM4uQjW6ppfn/QV18Db6JJPANbixO3mdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1482/2214] cpuidle: menu: Remove single state handling
Date: Wed, 18 Nov 2026 15:52:38 +0100
Message-ID: <20261118150110.430435381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3188c55612ce7..c764e9f8d1bc2 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -314,7 +314,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 	nr_iowaiters = nr_iowait_cpu(dev->cpu);
 	data->bucket = which_bucket(data->next_timer_ns, nr_iowaiters);
 
-	if (drv->state_count <= 1 || latency_req == 0 ||
+	if (latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



