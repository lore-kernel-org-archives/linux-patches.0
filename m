Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617957;
	b=nzfL87rttt2+am6ce0lmFEYL3wCK/DDc9zS1Z53547F1K/fynRjErDGDzrQyx/UNJNDS
	 krRLqh3CkApGk9mzzvwB/LHlVro5I6wG8VQCxkSy9BG9S/hSOoroj98rlHwnvvSSSmnfr
	 04c64K5ZLuASu2Ue0GDkyqgdaDl7pMe7PpB+zB38Daqsd8W1ewf1yPjXR00wnwVDJfez+
	 E6qXXTWFRU4Fm2ITWhfD2utmaq+wqe0hlB76wVibUKEifqL9I8GxYZZ3xguYY+JtMo5hk
	 RtqL2hJZyFv2odh6JCT0eJucjCh1txofXWpeslCJx7YfATgm4uHypWhaGRs3kIEPWig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617957;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hNoZJZDWFMw+6Iw/5Y/3qfCkmHLh+P3ODIiIETqddDs=;
	b=5G2+fw7sU4QxvH8Xuag07g4AOj9Rv01gmsJ9tc6jJUTZBe2AP3fVn3OZklIMPsyin1QI
	 hlZfcfL5XWuWy9mH8A4iM+sv/otBWrx71e2jqYA2vSxZM3UZloTzb5Hj7ASVXYr1B3Az4
	 sPpl7JfnK/puZ5If83a0z6+0ihTylQkVCIjCs/FdP5dcZEC79EDfk3n4RdwsE5UPqNbTx
	 bhTrsyBuLD0OcfFLJtKxd9qNfbZPtRELYFmUDoWADCHUyXlvC7NvsHLXk0i22xKYfG/ZB
	 JqTygufXPQkq+zvH5F5vf7IQZk/OQn6jvVtE7L5N/rJ1szFxPCXz6Te6MkNtEq6ltAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLjJaNIr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D1F606A31E;
	Wed, 25 Nov 2026 14:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RLjJaNIr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702361F000C6;
	Wed, 25 Nov 2026 14:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617957;
	bh=hNoZJZDWFMw+6Iw/5Y/3qfCkmHLh+P3ODIiIETqddDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RLjJaNIrj48sxc67VDx7xUl5Jy7ABQObP3NMaSuToQ6DUrV8Gzo/wmmXvAQ/IHdt4
	 VgSuMSyRWbDsbITJCyfpt/4J9c2tHiUmcG1VamkzjOEQjMv4gjM45QIe4gm1MNyWW6
	 nuSjosvbcecpNB936s0A0db9mY/ImMvr6IsKUQTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0129/1005] gpio: shared-proxy: Drop the vote of a released proxy on write failure
Date: Wed, 25 Nov 2026 15:24:27 +0100
Message-ID: <20261125143824.760395243@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Shawn Guo <shengchao.guo@oss.qualcomm.com>

[ Upstream commit 53b7b1201964f6f147fa0fa2f61194403a65cdf0 ]

When a proxy that voted for a value change frees the line, it calls
gpio_shared_proxy_set_unlocked() to withdraw its vote. If it is the
last voter and restoring the default value fails, that function
returns early, leaving votecnt incremented and voted_change set.

The consumer is gone, but its vote is not. The line is held at the
non-default value for all remaining users, since votecnt can never
drop to zero again. And the proxy data outlives the request, so
voted_change is still set when the line is requested again. If
another user has reinitialized the line in between, resetting
votecnt to 0, the stale proxy's next vote for the default value
decrements votecnt from 0 and underflows it.

Drop the vote unconditionally on release, after reporting the
failure, since the consumer is going away regardless.

Fixes: e992d54c6f97 ("gpio: shared-proxy: implement the shared GPIO proxy driver")
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Link: https://patch.msgid.link/20261028123448.510401-3-shengchao.guo@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-shared-proxy.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-shared-proxy.c b/drivers/gpio/gpio-shared-proxy.c
index 2e9ccd8a8d835..4eae3c9a5168e 100644
--- a/drivers/gpio/gpio-shared-proxy.c
+++ b/drivers/gpio/gpio-shared-proxy.c
@@ -138,9 +138,13 @@ static void gpio_shared_proxy_free(struct gpio_chip *gc, unsigned int offset)
 
 	if (proxy->voted_change) {
 		ret = gpio_shared_proxy_set_unlocked(proxy, shared_desc->def_val);
-		if (ret)
+		if (ret) {
 			dev_err(proxy->dev,
 				"Failed to unset the shared GPIO value on release: %d\n", ret);
+			/* The consumer is going away regardless, drop its vote */
+			shared_desc->votecnt--;
+			proxy->voted_change = false;
+		}
 	}
 
 	proxy->shared_desc->usecnt--;
-- 
2.53.0



