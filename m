Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062055;
	b=5c/qtN8Er0sMlaPa3zT+aQwYoKZDyMIhtqZk83vxx8TaAPTVE7NnJrYOjCaUa/BjP3zy
	 4draGt9dgecbw2t1Hs7V2mVi05eVesVO1oyIZkUoyv6mn7DAZir8f4uEXPHdlbOO2D5dT
	 /eJrF3Bd1/JF49xCndwb18x+u8qqbOnFvtGZZq6gaHXJ/fsDKBnmG8qK2jx0DCJZDwwtT
	 2BN1lVSG5y+artto9ts1g2QqmAs8tDS4N4iC+HkuY0vH69Gaa3t9NCVM2A8cFyVeYTRp5
	 icnuSVycUZyOUdNDNRdeE9LSR2aYB/wx1igXt5sJtZ904hZuYoLEA7WJlfe8klOBDKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4UPCP8E7+6zzVyafAOHx+g4x7QJsiwNT74L8N1bn31k=;
	b=3PHg1/v8TzNIsA8uJMf5O2GW++rtP3y0afDjx2BoRI2eJ69L/jtHrrZU0R8s1UdSKqT6
	 RbyHJmNZ2svY0fFstJW2RO4f0bkoCStWaQRP5N9Gk/gLzl8vTwdkdjPDgzU6/y4dgMGDb
	 LrH2q1tNJOuHSuUYnBZ5vCk15HIhpt0S4vFvXLfjhKdBvYGVFCorOenweJATF1TXyfSkz
	 zM3wI24zEnGcNlGrmxNrMueCfbDBlqyTbCqM4kHKsv0J8Is9Fiz9PIcGZIaBtA0pQu6+s
	 vGS4zeqDyg984knydaGcyJx72nRzampQ3ZOINU3T/fXUBAHzUaSmqoLgjDmkLxReYCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeNpixR9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811AA606A337;
	Sat,  7 Nov 2026 14:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SeNpixR9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F54C1F0089F;
	Sat,  7 Nov 2026 14:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062055;
	bh=4UPCP8E7+6zzVyafAOHx+g4x7QJsiwNT74L8N1bn31k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeNpixR9MSptzhW0jFC3Eq6l1MVU7XKGD3jpGR7YKOfcunOMnf8HI51pRuYYv4tJf
	 8GzMh0pKQp91LApd3mei8G4fH5W2BaHW74PfOzPd9XLK/Hy6Q6nUXFbntDvXf2IW4U
	 4bLzW73HocQvBTOQV4hdhjQkU16SBSK64qzW7tkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0988/1536] media: i2c: alvium-csi2: balance runtime PM usage count on remove
Date: Sat,  7 Nov 2026 08:50:04 -0500
Message-ID: <20261107135025.407614874@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 0d2ca640318612402ae1c640d2da56b2914ff994 ]

alvium_probe() increments the runtime PM usage count with
pm_runtime_get_noresume() before enabling runtime PM. The probe error
path correctly balances this reference with pm_runtime_put_noidle(),
but the normal remove path only disables runtime PM.

pm_runtime_disable() does not decrement the usage count, so a
successful probe followed by driver removal leaves the runtime PM
usage count unbalanced.

Add the missing pm_runtime_put_noidle() to the remove path, matching
the existing probe error cleanup.

This issue was found by manual code inspection.

Fixes: 0a7af872915e ("media: i2c: Add support for alvium camera")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/alvium-csi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/alvium-csi2.c b/drivers/media/i2c/alvium-csi2.c
index 5f365674b91c3..6b7193a7cec55 100644
--- a/drivers/media/i2c/alvium-csi2.c
+++ b/drivers/media/i2c/alvium-csi2.c
@@ -2527,6 +2527,7 @@ static void alvium_remove(struct i2c_client *client)
 	 * make sure to turn power off manually.
 	 */
 	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
 	if (!pm_runtime_status_suspended(dev))
 		alvium_set_power(alvium, false);
 	pm_runtime_set_suspended(dev);
-- 
2.53.0



