Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830880;
	b=NpNEnBGWbLtMVMtBVSFEc5T0H3bicsEvpeTcYjwe5+bt59mTV7idnR/HpC4OHKMk1cX7
	 smjtyQvEeH6ZxxYZA4JkCjEf3HNJ7eRWIM7YXT/8GQI3M+SGhusyOb07deu8b9ur31U33
	 TExjOmNroWq09UO5tGbCnenoF1nEvNAa7BUKczF5qg43h2ot0hOJo+t7TftI2pK0H1j+N
	 dHNifoWivQCxjCtID2PcAAnugn8C6PK2NwwlxDnOwc3uWlbuD64vwwV1o0g3ve1nijsEM
	 jnHgKjUepChNCtIYuisxEpg4Rcp3AEf14utrsUX/Fdh03Jf9wCOIUNbdiWiMQA60bGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dSi/FoBQG2Yxjit5Hvvi2xk0G+My+ZHMQ2+AM6bURMw=;
	b=NGsNq53RgQF7+5y4CynP2S7TEQ6ymT9iwRuqyAa0xbJn9DEshDCkcjaluvx8JL5RGYA5
	 mWMC9kaSazBV+eJhWVU+PQeK3SzYxxHLCiHA1Kcqh9PWJ31Yvgu6KyJoGKxedkc455cn9
	 vrVPGc7YB7lF922m6lHILXPBXDpTEB1phnc57+zziGTCoYUVffGkK/SLqupJZelmAR/+F
	 jjqUXD4zov6dF8grrG36mfFWYOOCctQYipkme24mNEVob8cIrgTWfm1g33hj1RS9v9tBz
	 +SzI3Qm3y9jiia/wQXCWh5aDdNGwlinzNdev1YoIVBEBmehMW8P925eeg187Jai0mIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="lQh/7jyI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8460606E82B;
	Wed,  4 Nov 2026 22:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQh/7jyI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DFE1F0093A;
	Wed,  4 Nov 2026 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830879;
	bh=dSi/FoBQG2Yxjit5Hvvi2xk0G+My+ZHMQ2+AM6bURMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQh/7jyIwxBVVqby7fDBkbidBOmeBXuKSxKMaBXaSsCP7mLUk/YeIzxXL/CcZuvSx
	 RaD3QMrNyH30LukYPUMmPlRky6ICfpWX414rRolRLCW+TO8G886vaEvxjevUE5D8EV
	 VCsojGItz9DPzgXmQV7KLY363p6YBNS4a151Z6Pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0376/1005] docs: cgroup-v2: fix stale "io" controller introduction
Date: Wed,  4 Nov 2026 16:01:49 -0500
Message-ID: <20261104211054.623730360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Zhe Liu <liuzhe1@kylinos.cn>

[ Upstream commit 3345c7248a9e2a91cb9e2477c29af16881706f4f ]

The introductory paragraph for the IO controller still states that
weight based distribution is "available only if cfq-iosched is in use"
and that "neither scheme is available for blk-mq devices".  This text
dates from when the cgroup v2 documentation was first written (2015)
and was correct at the time, but is no longer accurate:

  * cfq-iosched was removed in v5.0;
  * blk-mq is now the only block I/O path, and both the absolute limit
    scheme (io.max via blk-throttle) and the weight based scheme
    (io.weight via iocost, or io.bfq.weight under BFQ) work on it;
  * latency based protection (iolatency) and I/O priority (ioprio)
    controllers have since been added.

The rest of the section already documents io.weight, io.max,
io.cost.{qos,model}, io.latency and io.prio.class correctly, so the
introduction is the only part that contradicts them.  Rewrite it to
reflect the current state.

Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/cgroup-v2.rst | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index edcd125d6992f..a62505e55dd07 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1959,9 +1959,13 @@ IO
 
 The "io" controller regulates the distribution of IO resources.  This
 controller implements both weight based and absolute bandwidth or IOPS
-limit distribution; however, weight based distribution is available
-only if cfq-iosched is in use and neither scheme is available for
-blk-mq devices.
+limit distribution.  Absolute BPS and IOPS limits are enforced by
+blk-throttle and apply to all devices, while weight based proportional
+distribution is provided by the iocost cost model controller
+(CONFIG_BLK_CGROUP_IOCOST) and, when the BFQ I/O scheduler is in use
+for a device, by BFQ's own cgroup support.  Latency-based protection
+(CONFIG_BLK_CGROUP_IOLATENCY) and I/O priority assignment
+(CONFIG_BLK_CGROUP_IOPRIO) are also available.
 
 
 IO Interface Files
-- 
2.53.0



