Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051405;
	b=YX4gdLd8aj0mjoPJWAk2YL6XtjNoN7NbAedFwugOOpwsH61s1YAbErE8uhodI2Nwet9Z
	 O4lIfcixKbowgc2OKdwVrrjrQo3oPBDv5SCtXTxRsY6Na74ONk5yPJ7+Z9RerCEX003gg
	 Ln80pheuUdCjhxH3slMVpv9nDGnPXIF7msQs5603Nyqf3PhBmyM6IwO+0WePWRAsn/UjE
	 prRbb1sIUXvwhYEqf1pJtc0GKO6i43cC/kPU4yHrDW+nro2vfdtL9KVKVtYQPBhmB8LMJ
	 CEJYfwqfSZwqQlUIz+EWdt9fAO39mIpjLu9KMCs3Mgf6QYQdpUb5V1U9PwzkI2VPIag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PWJVOoM1HojjqkaukplT+01ayqV8U3S6XL4PP+gT/Pw=;
	b=r7wjUymEht95QeTdpcNi2A3CFg8FLO0QDTN0wWbmzzkSy1IyKhPfLkPNo+5l6sNnS93n
	 j7KhfMQjmlAQeD8OX+/cZn8BnNqR+BmNMclDEa4lrstHRyuWt9Dbz4RXp+UkOMmj6Y1ys
	 RIZx3Td/yRbQEoh6nv+8yzOmwqzDXbuGkATSaQnriE+P5D2h3KcRPjUPRK56FGjA8ejOm
	 hjYncsCS0HED/F6ZgIEUFP2aIIkVqNPGH+3Gdbryk9G71m6R6ws+xbdTtE3RMGmX1gBMH
	 jtVYM+S73A7/N2UXlmFr3cDZkEnMkkvAHJC2HbKmnkIU98AMU9UNea4gCDgO44HpiXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soCk15BP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432DF606A336;
	Thu, 19 Nov 2026 01:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=soCk15BP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A4DD1F000CA;
	Thu, 19 Nov 2026 01:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051404;
	bh=PWJVOoM1HojjqkaukplT+01ayqV8U3S6XL4PP+gT/Pw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soCk15BPJMa1XjyMlV7f0GRNES6sqxdB/yXwOCkdlzSOF6PaSrpRPxdZlNcO0sGjS
	 EGCLvghHGIZzfU6do/GUQygN5i8YymOoQirGe/lCvzUl02zAvdcpmyOgpyBzhkSTcD
	 w+WSA3ZNvbiWoZs38PYbnWBWVfXrZlNPRDEtBovE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhe Liu <liuzhe1@kylinos.cn>,
	Tao Cui <cuitao@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0196/2214] docs: cgroup-v2: fix stale "io" controller introduction
Date: Wed, 18 Nov 2026 15:31:12 +0100
Message-ID: <20261118150018.035838717@linuxfoundation.org>
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
index 4d8c27eca96be..7ea4c0eec8ad0 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1552,9 +1552,13 @@ IO
 
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



