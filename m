Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034132;
	b=S6rkduV2H16A9/EQLQ31YlLz8Uo/HXDVEaUqz+kkPvJjDAO3gzXmWvo0q+0Xei7yABzt
	 qzYP0OKXKNUNuw/B/nSc20PvyL3t0slPPH2jtAJdGpiC6+XllWQK782TDXewvLFRSlOn6
	 R4EY+396owa3RIn/iH8/WZmrWVercO16d5eeiG50Z7vG+We8suBEuvmB+UpEiR5nvoDQx
	 /NgtFGdIdkpXnRQcpHEHgMPNcA5MEHYg+NSgC2Cru4hu9PGcWETKU1unn9rIYWxnVEmzB
	 W6k63xBmoJjwqasECcEy5RLZHqCO0X+Wg11XkPCsbopyIiA0KYk19dfitBdMLz1573w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uqFzWtjMk3mLiRfub1AZttb1guKEXOs2CE+iX7bYiFc=;
	b=eopDY++WHB8CnSWRscXIJ9CpD11X4LgJNA2ilcjIpVs9aYtAlGCcf85P1vRlZ1oqXkFI
	 /Z+Ox8RioHuIYL7hteHGqKWPldOdEh512ISAhaJ8TG8P++N7uM/uXtwery4h+cxBVfEE+
	 YRWGfWQbiN498tJb8hOztEYAh1JqehxHiU/rUmBPRGII/cZZHp3aDmKSBaN6D/cYubhzm
	 H+aZRq2Yf57qrnY+hB7Rn4nA1ocnHyqkSjh1eOlCYFZDL5tlPfyUAs0OZt7BlQb7ieT6N
	 TdrV6NddW7MSuiYI6CX5XVydtci5Zp12ddR/wo5miKZBefTlYlPN1/c/dZ591vykCeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Knb8KLJK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843D0606A33E;
	Wed, 18 Nov 2026 20:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Knb8KLJK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2BFD1F000C4;
	Wed, 18 Nov 2026 20:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034132;
	bh=uqFzWtjMk3mLiRfub1AZttb1guKEXOs2CE+iX7bYiFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Knb8KLJKGqDaqWwnSk0YNNDor9oa76uUrev4jQU4kbwbaOKbT04oSxqkt/wm27QTB
	 RKxjh/1Vxj+R9FpwFkfr+9ncX/HKdyl8K64Lc3RH6ar5pZz5rGy72HYGDUgcp8BzMO
	 TCHli6IgufDVS/X4NS0OUYR/KsAPg5rTMjjTL19c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0262/3318] docs: cgroup-v2: fix stale "io" controller introduction
Date: Wed, 18 Nov 2026 15:14:44 +0100
Message-ID: <20261118150323.242835442@linuxfoundation.org>
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
index 622a7f28db1fd..0d027b848f1ca 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1698,9 +1698,13 @@ IO
 
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



