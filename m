Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029486;
	b=ik4/Hpa8Xj9S98x5k7Rt34j1p8ZxiIwZWU9JXUohqIAjyuc84fEPQdeR/Hdqlh2JHoSD
	 m+mFxTgpJ/IWfrgQFh/MCE/4qRJcHEeHjP6gwuSpl9H9flJgva81xKsNGnruGEzUohIqt
	 TSMfZMawlJHtYIo59xSDnsOK4nIs86jd00nTb2pQMSe0Z44izNO4tqVcOi9EJ69he2zX8
	 yFzRAPvyueUP3ocQ8yajK5GI6djTd+t4CekBtOZSCBUN+S1ShUH2lLmYYnoLzm2b21U2p
	 ofwT23f5t9d5PRo9CRBSGSzxodJt28TmUws4x+QxRcJ8vPgD8xTOrhqfKLGivAziXAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029486;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Orb3BsCTDOaTMlaph0vsTE8SInCfqhOs9i1V57GME4M=;
	b=Hz157LlF8+1CBcUYt+d5Vk3iOBJAOvZ4sanjdDOXRU0cX3LqhIIAxG6sp7NgVThxmL8i
	 13TQ7c3e/fAchXLwn3ZKjiIbLhJ9soPaItGjqjQLGWZAgQqq54QrGpeCVEye/kc9Se3vX
	 xuqjsC6pzE8qtOuuz17JtC/r5SxwvO6orXdnKsPE9tBd2++3If3Zmh/gh2ZNINUAZN43b
	 zxaKgYDNKjbBY2zWWSXxxIxzyP1sOGdngD73heyveEy/oVWNZEfXv8YNyrrkgB2qJM1vt
	 eDduYW111aO9U1oYXuUOf55KXRKCl/MsDx86ZyVlBhHtivXx+dsgDMZSbd5UPpH5Ndg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d++lbus/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 923F8606A31C;
	Wed, 18 Nov 2026 19:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d++lbus/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E792B1F000C4;
	Wed, 18 Nov 2026 19:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029486;
	bh=Orb3BsCTDOaTMlaph0vsTE8SInCfqhOs9i1V57GME4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d++lbus/3N4KNSKdHdc+rEO//CBGZHck2Z9dNMEGvOlz7wdJW1HDXQ8itCcbQo8VV
	 YF1eYUOWfXJ74ah1s2M8JTnjJfMDfQ5AucRffN36+PboqLIX7cPUGcMGSAL4wTQBIg
	 BFVd/Apoh/SwZudqywqjUzajKO9ZyCTW1FbN+Zxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Loehle <christian.loehle@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0365/1756] cpuidle: menu: Remove single state handling
Date: Wed, 18 Nov 2026 15:41:32 +0100
Message-ID: <20261118150022.842617323@linuxfoundation.org>
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
index 88b87ad5557a7..3c135e40bf20d 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -287,7 +287,7 @@ static int menu_select(struct cpuidle_driver *drv, struct cpuidle_device *dev,
 		data->bucket = which_bucket(KTIME_MAX);
 	}
 
-	if (drv->state_count <= 1 || latency_req == 0 ||
+	if (latency_req == 0 ||
 	    ((data->next_timer_ns < drv->states[1].target_residency_ns ||
 	      latency_req < drv->states[1].exit_latency_ns) &&
 	     !dev->states_usage[0].disable)) {
-- 
2.53.0



