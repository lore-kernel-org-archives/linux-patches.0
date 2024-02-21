Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611927D3F4;
	Wed, 21 Feb 2024 14:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524427; cv=none; b=Rq3bOaUD1fERmkJiRj0S4INozwCobgONZTQvUOABXgGkPLBl2LTG1tnlGtyKm/4/nsbGI/EF6ITwCifWXJzuawrB0kGO3rwczOUV385LE5YE81JiVONraJlRef3XMf3kYv8KKaAcrsq6+rKLxEryvxwz5ppVPuSetEOknj32atI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524427; c=relaxed/simple;
	bh=m687sNx9aupA6NmK4oaxPQuZ5vO8rPuyQMFbG/m8Zuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtkuJZPPavX57b1co6PIT0tKlInQi+JMYDfsvBFNHlAzirXw3wE6GzlIe9LHmbUKb4E5PPKwqIJmVPU3NxhDfcys8h+kf4RG/9RGyBRpSMzrbeNQZdl1ycSy7Ha4n+7Wbg4Mamm7QA01nr1cTh4wmeIZiUbh+F5x6p8QF+n8ui4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zBLrC4KA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zBLrC4KA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3B1BC433F1;
	Wed, 21 Feb 2024 14:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524427;
	bh=m687sNx9aupA6NmK4oaxPQuZ5vO8rPuyQMFbG/m8Zuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zBLrC4KAWoVNWErADx8mF8EwP71yTT0b0FjX9CSZJZPD6f7RAoDwv+xOxf/4+SOGw
	 VChyu04WXiNla6ukaYWBWLfaK95iUdFwAs8lKpThBLQ5tObhepXChOAz4TIOUgL/fw
	 qsFm4Q7Gg+PfvYCqF/BIf1PtHjlDkc5jc3tpQb0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/379] net: sysfs: Fix /sys/class/net/<iface> path
Date: Wed, 21 Feb 2024 14:06:59 +0100
Message-ID: <20240221130002.013784525@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit ae3f4b44641dfff969604735a0dcbf931f383285 ]

The documentation is pointing to the wrong path for the interface.
Documentation is pointing to /sys/class/<iface>, instead of
/sys/class/net/<iface>.

Fix it by adding the `net/` directory before the interface.

Fixes: 1a02ef76acfa ("net: sysfs: add documentation entries for /sys/class/<iface>/queues")
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://lore.kernel.org/r/20240131102150.728960-2-leitao@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/testing/sysfs-class-net-queues        | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net-queues b/Documentation/ABI/testing/sysfs-class-net-queues
index 978b76358661..40d5aab8452d 100644
--- a/Documentation/ABI/testing/sysfs-class-net-queues
+++ b/Documentation/ABI/testing/sysfs-class-net-queues
@@ -1,4 +1,4 @@
-What:		/sys/class/<iface>/queues/rx-<queue>/rps_cpus
+What:		/sys/class/net/<iface>/queues/rx-<queue>/rps_cpus
 Date:		March 2010
 KernelVersion:	2.6.35
 Contact:	netdev@vger.kernel.org
@@ -8,7 +8,7 @@ Description:
 		network device queue. Possible values depend on the number
 		of available CPU(s) in the system.
 
-What:		/sys/class/<iface>/queues/rx-<queue>/rps_flow_cnt
+What:		/sys/class/net/<iface>/queues/rx-<queue>/rps_flow_cnt
 Date:		April 2010
 KernelVersion:	2.6.35
 Contact:	netdev@vger.kernel.org
@@ -16,7 +16,7 @@ Description:
 		Number of Receive Packet Steering flows being currently
 		processed by this particular network device receive queue.
 
-What:		/sys/class/<iface>/queues/tx-<queue>/tx_timeout
+What:		/sys/class/net/<iface>/queues/tx-<queue>/tx_timeout
 Date:		November 2011
 KernelVersion:	3.3
 Contact:	netdev@vger.kernel.org
@@ -24,7 +24,7 @@ Description:
 		Indicates the number of transmit timeout events seen by this
 		network interface transmit queue.
 
-What:		/sys/class/<iface>/queues/tx-<queue>/tx_maxrate
+What:		/sys/class/net/<iface>/queues/tx-<queue>/tx_maxrate
 Date:		March 2015
 KernelVersion:	4.1
 Contact:	netdev@vger.kernel.org
@@ -32,7 +32,7 @@ Description:
 		A Mbps max-rate set for the queue, a value of zero means disabled,
 		default is disabled.
 
-What:		/sys/class/<iface>/queues/tx-<queue>/xps_cpus
+What:		/sys/class/net/<iface>/queues/tx-<queue>/xps_cpus
 Date:		November 2010
 KernelVersion:	2.6.38
 Contact:	netdev@vger.kernel.org
@@ -42,7 +42,7 @@ Description:
 		network device transmit queue. Possible vaules depend on the
 		number of available CPU(s) in the system.
 
-What:		/sys/class/<iface>/queues/tx-<queue>/xps_rxqs
+What:		/sys/class/net/<iface>/queues/tx-<queue>/xps_rxqs
 Date:		June 2018
 KernelVersion:	4.18.0
 Contact:	netdev@vger.kernel.org
@@ -53,7 +53,7 @@ Description:
 		number of available receive queue(s) in the network device.
 		Default is disabled.
 
-What:		/sys/class/<iface>/queues/tx-<queue>/byte_queue_limits/hold_time
+What:		/sys/class/net/<iface>/queues/tx-<queue>/byte_queue_limits/hold_time
 Date:		November 2011
 KernelVersion:	3.3
 Contact:	netdev@vger.kernel.org
@@ -62,7 +62,7 @@ Description:
 		of this particular network device transmit queue.
 		Default value is 1000.
 
-What:		/sys/class/<iface>/queues/tx-<queue>/byte_queue_limits/inflight
+What:		/sys/class/net/<iface>/queues/tx-<queue>/byte_queue_limits/inflight
 Date:		November 2011
 KernelVersion:	3.3
 Contact:	netdev@vger.kernel.org
@@ -70,7 +70,7 @@ Description:
 		Indicates the number of bytes (objects) in flight on this
 		network device transmit queue.
 
-What:		/sys/class/<iface>/queues/tx-<queue>/byte_queue_limits/limit
+What:		/sys/class/net/<iface>/queues/tx-<queue>/byte_queue_limits/limit
 Date:		November 2011
 KernelVersion:	3.3
 Contact:	netdev@vger.kernel.org
@@ -79,7 +79,7 @@ Description:
 		on this network device transmit queue. This value is clamped
 		to be within the bounds defined by limit_max and limit_min.
 
-What:		/sys/class/<iface>/queues/tx-<queue>/byte_queue_limits/limit_max
+What:		/sys/class/net/<iface>/queues/tx-<queue>/byte_queue_limits/limit_max
 Date:		November 2011
 KernelVersion:	3.3
 Contact:	netdev@vger.kernel.org
@@ -88,7 +88,7 @@ Description:
 		queued on this network device transmit queue. See
 		include/linux/dynamic_queue_limits.h for the default value.
 
-What:		/sys/class/<iface>/queues/tx-<queue>/byte_queue_limits/limit_min
+What:		/sys/class/net/<iface>/queues/tx-<queue>/byte_queue_limits/limit_min
 Date:		November 2011
 KernelVersion:	3.3
 Contact:	netdev@vger.kernel.org
-- 
2.43.0



