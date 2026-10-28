Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216529;
	b=1hG2SFsSviThXpAFaXP8BwTWq0PnZK6CVJp0vanqlLiWH1WAWsSKlc5xS3w6zLtfueyL
	 nSWxlDpTDn5XQzVmMFqLRilT9Sp4t3jRuINuX40+neEOFXzY+T/hobdeMFZKbUjgA+h2g
	 vgzl0dltyG7O1bijtC/GEH1MGRvMBN2ZhbM4omFEblhfSKsIB1skX0LLKQBxUjongwMua
	 Ju5FVgshB7yf04EtA/nzirGL4POnBv4vw9VStTLEj0QyH275IhqcCPUs0flC/OsZRXCTJ
	 SyMZyC5MRKsU/HjzCKaXUWVp4bwslN0mapdeqdbCJmqvJDX+GN6IHOwktrrpAZse4Dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216529;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P9e2mtw15x5zYfHWmxINpu5rVDT25onHh8m588CqK+0=;
	b=cwHucTCG4X9tfNa6TnuM4XFJVdxF6y1BbDo8eL6q5owrIjwDqFrHXot0U5TNxTvfcUaC
	 VWq/t3qFUEmbNRkhjnA1HKL+4ariL5CjSahtCrCvoaIu+4YqYz9adV0RLsxpVBfR4lQVz
	 0y3rFmeqelkr5OfPZ6xcH4VoB89nCYh+KyMEumu6AS/6wg2RlUimSY5fBJg+riD3L9u2N
	 F0C4QhdypRPQ3XdnbcJwkb8d3GoJ03fFf6NVr2OCjt+GbuRQLbv4ZpyQaWPnIYZG2WIEz
	 cFTTtYZFSY7qOGmOEnVZMMlRxQIrwT0orqTUdgWORd6bQCmzipi/Ls8M3U4u/6Sg9pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvBRsywx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38400606A325;
	Wed, 28 Oct 2026 19:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PvBRsywx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4AF1F01825;
	Wed, 28 Oct 2026 19:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216528;
	bh=P9e2mtw15x5zYfHWmxINpu5rVDT25onHh8m588CqK+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PvBRsywxCE6YNuaX2pRyxLCOvMX4pwTs+WW+fzFPSZ2ejPWCitkts1NBekqAxHYua
	 dwG29eO2MX5Cox7+y5oBVo5IE9nDGKY5wGI4bFMTRJNSMlijtA6X1UXPiNvWcdC09Z
	 5jhM6e6ij2QNLtAo7icwnJs+zU9p9HpQPwcojeko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1587/1887] wifi: cfg80211: stop PMSR before P2P and NAN teardown
Date: Wed, 28 Oct 2026 18:01:23 +0100
Message-ID: <20261028170535.583203527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 6c5fc504d0d6934132637aa3db4b9b58148eaa78 ]

PMSR request teardown must abort active measurements while the
wireless_dev is still present in the driver. cfg80211_leave_locked() and
cfg80211_stop_pd() already do this before invoking the driver's stop
callback, but cfg80211_stop_p2p_device() and cfg80211_stop_nan() do not.

Those helpers are also called directly by nl80211, rfkill shutdown, and
wireless_dev unregister paths. If one of these paths stops a P2P device
or NAN interface with a pending request, it removes the mac80211
subinterface from the driver first. Subsequent request cleanup cannot
reach the lower driver's abort callback, but cfg80211 frees the request
regardless. Driver state can then retain a stale request and use it when
it later reports a result.

Call cfg80211_pmsr_wdev_down() before stopping the P2P device or NAN
interface. This keeps lower-driver request state and cfg80211 request
ownership in sync for all of the helpers' callers.

Fixes: 9bb7e0f24e7e ("cfg80211: add peer measurement with FTM initiator API")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260731071103.73563-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index a781893473afe..1cd214a743428 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -232,6 +232,9 @@ void cfg80211_stop_p2p_device(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	wdev_lock(wdev);
+	cfg80211_pmsr_wdev_down(wdev);
+	wdev_unlock(wdev);
 	rdev_stop_p2p_device(rdev, wdev);
 	wdev->is_running = false;
 
@@ -257,6 +260,10 @@ void cfg80211_stop_nan(struct cfg80211_registered_device *rdev,
 	if (!wdev_running(wdev))
 		return;
 
+	wdev_lock(wdev);
+	cfg80211_pmsr_wdev_down(wdev);
+	wdev_unlock(wdev);
+
 	rdev_stop_nan(rdev, wdev);
 	wdev->is_running = false;
 
-- 
2.53.0



