Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7039F76C99;
	Wed, 21 Feb 2024 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523797; cv=none; b=kaJ+tIq51/uYoRWfsCzq3rlprzph/rqf/wLN1PF+TUoGMkee956RRb4J4BuWFE7ASILmEDu/v2MhtJmEsKxR8CbPWRmHMmCRJLD235a/YYHcZD3Y4/+vs9oW1NSRb9x/lpgkqf9xl/EujXkEoSfZ9vSvfP/SMPQKqU9cf5gKwH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523797; c=relaxed/simple;
	bh=CA0jkG+glLyQncRHTfkIiLSVFXtaWheqDkIu44hAySQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0MRVAeIaBgj9YbuKpEjPSrk29B5INRqLHAxvJHRE/qo9/JY4w3W3ctyCk9kXKYarPUhujSk39TTFvRwoBWvqmbOmi6ZO5vWqJnH0M//m7ZGNhVPIlXJYE3vmWGEWdb9pFlOmKLQsf1yFh6m0nLS/F/ueDCd6sSwzdDTxF31ZWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xl9fYd40; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xl9fYd40"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F00C433F1;
	Wed, 21 Feb 2024 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523797;
	bh=CA0jkG+glLyQncRHTfkIiLSVFXtaWheqDkIu44hAySQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xl9fYd40bohT9fyEOqsLQCdyTuWBmh9auqlW+39VQTJZJ0c5ruNQPmlfso7hrLuWa
	 uk4Nt8tP3EfjKO0f/tU3UC4E607lZqje4ntvFJGG7GH6tEZbCxSkAE586K8t3Az57B
	 JS5wryZz1AwaTwvvKxMPINgCM7CCIe+QL0g+gryw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 059/379] selftests: netdevsim: fix the udp_tunnel_nic test
Date: Wed, 21 Feb 2024 14:03:58 +0100
Message-ID: <20240221125956.659733908@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 0879020a7817e7ce636372c016b4528f541c9f4d ]

This test is missing a whole bunch of checks for interface
renaming and one ifup. Presumably it was only used on a system
with renaming disabled and NetworkManager running.

Fixes: 91f430b2c49d ("selftests: net: add a test for UDP tunnel info infra")
Acked-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240123060529.1033912-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/drivers/net/netdevsim/udp_tunnel_nic.sh    | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
index 1b08e042cf94..185b02d2d4cd 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/udp_tunnel_nic.sh
@@ -269,6 +269,7 @@ for port in 0 1; do
 	echo 1 > $NSIM_DEV_SYS/new_port
     fi
     NSIM_NETDEV=`get_netdev_name old_netdevs`
+    ifconfig $NSIM_NETDEV up
 
     msg="new NIC device created"
     exp0=( 0 0 0 0 )
@@ -430,6 +431,7 @@ for port in 0 1; do
     fi
 
     echo $port > $NSIM_DEV_SYS/new_port
+    NSIM_NETDEV=`get_netdev_name old_netdevs`
     ifconfig $NSIM_NETDEV up
 
     overflow_table0 "overflow NIC table"
@@ -487,6 +489,7 @@ for port in 0 1; do
     fi
 
     echo $port > $NSIM_DEV_SYS/new_port
+    NSIM_NETDEV=`get_netdev_name old_netdevs`
     ifconfig $NSIM_NETDEV up
 
     overflow_table0 "overflow NIC table"
@@ -543,6 +546,7 @@ for port in 0 1; do
     fi
 
     echo $port > $NSIM_DEV_SYS/new_port
+    NSIM_NETDEV=`get_netdev_name old_netdevs`
     ifconfig $NSIM_NETDEV up
 
     overflow_table0 "destroy NIC"
@@ -572,6 +576,7 @@ for port in 0 1; do
     fi
 
     echo $port > $NSIM_DEV_SYS/new_port
+    NSIM_NETDEV=`get_netdev_name old_netdevs`
     ifconfig $NSIM_NETDEV up
 
     msg="create VxLANs v6"
@@ -632,6 +637,7 @@ for port in 0 1; do
     fi
 
     echo $port > $NSIM_DEV_SYS/new_port
+    NSIM_NETDEV=`get_netdev_name old_netdevs`
     ifconfig $NSIM_NETDEV up
 
     echo 110 > $NSIM_DEV_DFS/ports/$port/udp_ports_inject_error
@@ -687,6 +693,7 @@ for port in 0 1; do
     fi
 
     echo $port > $NSIM_DEV_SYS/new_port
+    NSIM_NETDEV=`get_netdev_name old_netdevs`
     ifconfig $NSIM_NETDEV up
 
     msg="create VxLANs v6"
@@ -746,6 +753,7 @@ for port in 0 1; do
     fi
 
     echo $port > $NSIM_DEV_SYS/new_port
+    NSIM_NETDEV=`get_netdev_name old_netdevs`
     ifconfig $NSIM_NETDEV up
 
     msg="create VxLANs v6"
@@ -876,6 +884,7 @@ msg="re-add a port"
 
 echo 2 > $NSIM_DEV_SYS/del_port
 echo 2 > $NSIM_DEV_SYS/new_port
+NSIM_NETDEV=`get_netdev_name old_netdevs`
 check_tables
 
 msg="replace VxLAN in overflow table"
-- 
2.43.0



