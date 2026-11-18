Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042235;
	b=Yta68rX3teGXiBTcYGc2QmWAhZbAg7dFOyJbhYOV0nVmq7UjYu6dpnwGCLKjEoLSz47U
	 GDCCXc0swjWCCD8OJbVvjvF3VwwKqX0SGgiD/s2MPtueFr7b3+ZAMj6c0JBPUeRTOYNME
	 whoVpMZFNhHTWBbZYBvyTLP+D5oxYSSBGS4sa+Kd55xvrEQ+DvhNCYazoWZBGpjO6mljJ
	 AeMWe3b2T7GJN6+DkKYd+9ZuVsxAOLyCtbv/CRHzNREvZW/YIcu2WOWHKCfh1yHmwyQoW
	 gtAzhZJulIq/wkMk5THPkSxhSHW3MlT6/oqEKO8SdJOIAwqtYb9/OgY75+JlRb8Oo8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qRZ6FlXWcVmpSbhQn20HvjnSgMIA3ncKNHj8mrPcFFI=;
	b=Z2Zedh8gZczZuI3NBUzhKdXonWIjt5DNNaxizv6A+xsBQqP3K9aLkdhp0LAkHeVN+F45
	 aGzbG2AQFFqBCCaIVBC6JEBsHq7MIPzJ0T8QJimHOih2ur4m9zgGnel7ekkVtvdDJfd8V
	 6ccRfoTggsRcP/ORltUuJeUtq2A83Jbsa8ycK8zE4c+P4TyTHni7Kr5NvU3IbFrWKPEHG
	 KUMOETaIu9MoHgRfCCxaY5r9SBMAXJs76ncOAYX+rY8gY0JNagXnJjh89M1mNru46JjBz
	 ti0aPbmVhDh3EGRXWYBR6oS6nn8Ev8pR8iqVlwiAMciBODqHMtoWQ10OsO33/m5v99Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o20ZyLcL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF46A606A31C;
	Wed, 18 Nov 2026 22:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o20ZyLcL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156551F000C4;
	Wed, 18 Nov 2026 22:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042235;
	bh=qRZ6FlXWcVmpSbhQn20HvjnSgMIA3ncKNHj8mrPcFFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o20ZyLcLcEuGIgdWuX7ktlhXwPUuo3BEPauKOfxedTlhVjT4sofKU6H9SNiq1q6ML
	 OGbjm2qWEBiIYJS6sYLnMbRQpnFDVfvZ7/73IJ4Nxc+rfQ1jcOWFa8V/Wt+GK4KtKv
	 HYeygBwYAsP6Aqfsdsgpgp0vrATtvbNoQdJj+QVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot+sashiko@kernel.org>,
	Henry Hu <huhai@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3097/3318] ksmbd: report IPv4 and IPv6 addresses independently in iface query
Date: Wed, 18 Nov 2026 16:01:59 +0100
Message-ID: <20261118150452.922711004@linuxfoundation.org>
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

From: Henry Hu <huhai@kylinos.cn>

[ Upstream commit bb0326a5806015fb7e5a6a721a50ff172c92c6e4 ]

fsctl_query_iface_info_ioctl() appends an entry before checking that a
usable address was found, so it advertises unspecified-address
placeholders: an entry containing 0.0.0.0 when an in_device exists but
has no primary IPv4 address, and an entry containing :: when an
inet6_dev exists but its address list is empty or every address is
tentative or deprecated.

The loop also couples IPv6 reporting to IPv4 success: when
__in_dev_get_rtnl() returns NULL it continues to the next interface,
skipping the IPv6 pass, so an interface without an in_device is dropped
even if it has a usable IPv6 address.

Query IPv4 and IPv6 independently and append an entry only when an
address is found. Factor out the common entry initialization and query
the link speed once per interface instead of once per address family.

Fixes: e2f34481b24d ("cifsd: add server-side procedures for SMB3")
Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
Link: https://sashiko.dev/#/patchset/20260910090818.24479-1-15815827059%40163.com
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Henry Hu <huhai@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 127 ++++++++++++++++++++++------------------
 1 file changed, 70 insertions(+), 57 deletions(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d3558afc3f933..24cc713276ac7 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8175,6 +8175,27 @@ static __be32 idev_ipv4_address(struct in_device *idev)
 	return addr;
 }
 
+static struct network_interface_info_ioctl_rsp *
+ksmbd_iface_entry_init(struct smb2_ioctl_rsp *rsp, int nbytes,
+		       struct net_device *netdev, unsigned long long speed)
+{
+	struct network_interface_info_ioctl_rsp *nii_rsp;
+
+	nii_rsp = (struct network_interface_info_ioctl_rsp *)&rsp->Buffer[nbytes];
+	nii_rsp->IfIndex = cpu_to_le32(netdev->ifindex);
+	nii_rsp->Capability = 0;
+	if (netdev->real_num_tx_queues > 1)
+		nii_rsp->Capability |= RSS_CAPABLE;
+	if (ksmbd_rdma_capable_netdev(netdev))
+		nii_rsp->Capability |= RDMA_CAPABLE;
+	nii_rsp->Next = cpu_to_le32(152);
+	nii_rsp->Reserved = 0;
+	nii_rsp->LinkSpeed = cpu_to_le64(speed);
+	memset(nii_rsp->SockAddr_Storage, 0, 128);
+
+	return nii_rsp;
+}
+
 static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 					struct smb2_ioctl_rsp *rsp,
 					unsigned int out_buf_len)
@@ -8189,7 +8210,12 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 
 	rtnl_lock();
 	for_each_netdev(&init_net, netdev) {
-		bool ipv4_set = false;
+		struct inet6_ifaddr *ifa;
+		struct inet6_dev *idev6;
+		struct in_device *idev;
+		struct in6_addr ip6 = { };
+		bool have_ip6 = false;
+		__be32 ip4 = 0;
 
 		if (netdev->type == ARPHRD_LOOPBACK)
 			continue;
@@ -8200,25 +8226,6 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 		flags = dev_get_flags(netdev);
 		if (!(flags & IFF_RUNNING))
 			continue;
-ipv6_retry:
-		if (out_buf_len <
-		    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
-			rtnl_unlock();
-			return -ENOSPC;
-		}
-
-		nii_rsp = (struct network_interface_info_ioctl_rsp *)
-				&rsp->Buffer[nbytes];
-		nii_rsp->IfIndex = cpu_to_le32(netdev->ifindex);
-
-		nii_rsp->Capability = 0;
-		if (netdev->real_num_tx_queues > 1)
-			nii_rsp->Capability |= RSS_CAPABLE;
-		if (ksmbd_rdma_capable_netdev(netdev))
-			nii_rsp->Capability |= RDMA_CAPABLE;
-
-		nii_rsp->Next = cpu_to_le32(152);
-		nii_rsp->Reserved = 0;
 
 		if (!__ethtool_get_link_ksettings(netdev, &cmd) &&
 		    cmd.base.speed && cmd.base.speed != SPEED_UNKNOWN) {
@@ -8228,60 +8235,66 @@ static int fsctl_query_iface_info_ioctl(struct ksmbd_conn *conn,
 				    "speed is unknown, defaulting to 1Gb/sec");
 			speed = SPEED_1000;
 		}
-
 		speed *= 1000000;
-		nii_rsp->LinkSpeed = cpu_to_le64(speed);
 
-		sockaddr_storage = (struct sockaddr_storage_rsp *)
-					nii_rsp->SockAddr_Storage;
-		memset(sockaddr_storage, 0, 128);
+		/*
+		 * Query IPv4 and IPv6 independently; emit an entry only when a
+		 * usable address exists, so an interface missing one family is
+		 * still reported for the other and 0.0.0.0 / :: placeholders are
+		 * never advertised.
+		 */
+		idev = __in_dev_get_rtnl(netdev);
+		if (idev)
+			ip4 = idev_ipv4_address(idev);
 
-		if (!ipv4_set) {
-			struct in_device *idev;
+		idev6 = __in6_dev_get(netdev);
+		if (idev6) {
+			rcu_read_lock();
+			list_for_each_entry_rcu(ifa, &idev6->addr_list, if_list) {
+				if (ifa->flags & (IFA_F_TENTATIVE | IFA_F_DEPRECATED))
+					continue;
+				memcpy(&ip6, ifa->addr.s6_addr, sizeof(ip6));
+				have_ip6 = true;
+				break;
+			}
+			rcu_read_unlock();
+		}
 
+		if (ip4) {
+			if (out_buf_len <
+			    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
+				rtnl_unlock();
+				return -ENOSPC;
+			}
+
+			nii_rsp = ksmbd_iface_entry_init(rsp, nbytes, netdev, speed);
+			sockaddr_storage = (struct sockaddr_storage_rsp *)nii_rsp->SockAddr_Storage;
 			sockaddr_storage->Family = INTERNETWORK;
 			sockaddr_storage->addr4.Port = 0;
-
-			idev = __in_dev_get_rtnl(netdev);
-			if (!idev)
-				continue;
-			sockaddr_storage->addr4.IPv4Address =
-						idev_ipv4_address(idev);
+			sockaddr_storage->addr4.IPv4Address = ip4;
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
-			ipv4_set = true;
-			goto ipv6_retry;
-		} else {
-			struct inet6_dev *idev6;
-			struct inet6_ifaddr *ifa;
-			__u8 *ipv6_addr = sockaddr_storage->addr6.IPv6Address;
+		}
+
+		if (have_ip6) {
+			if (out_buf_len <
+			    nbytes + sizeof(struct network_interface_info_ioctl_rsp)) {
+				rtnl_unlock();
+				return -ENOSPC;
+			}
 
+			nii_rsp = ksmbd_iface_entry_init(rsp, nbytes, netdev, speed);
+			sockaddr_storage = (struct sockaddr_storage_rsp *)nii_rsp->SockAddr_Storage;
 			sockaddr_storage->Family = INTERNETWORKV6;
 			sockaddr_storage->addr6.Port = 0;
 			sockaddr_storage->addr6.FlowInfo = 0;
-
-			idev6 = __in6_dev_get(netdev);
-			if (!idev6)
-				continue;
-
-			rcu_read_lock();
-			list_for_each_entry_rcu(ifa, &idev6->addr_list, if_list) {
-				if (ifa->flags & (IFA_F_TENTATIVE |
-							IFA_F_DEPRECATED))
-					continue;
-				memcpy(ipv6_addr, ifa->addr.s6_addr, 16);
-				break;
-			}
-			rcu_read_unlock();
+			memcpy(sockaddr_storage->addr6.IPv6Address, ip6.s6_addr, 16);
 			sockaddr_storage->addr6.ScopeId = 0;
 			nbytes += sizeof(struct network_interface_info_ioctl_rsp);
 		}
 	}
 	rtnl_unlock();
 
-	/*
-	 * nii_rsp may point to an entry not included in nbytes if the IPv4
-	 * or IPv6 device lookup failed. Clear Next in the last returned entry.
-	 */
+	/* Clear Next of the last committed entry to terminate the list. */
 	if (nbytes > 0) {
 		nii_rsp = (struct network_interface_info_ioctl_rsp *)
 			  &rsp->Buffer[nbytes - sizeof(*nii_rsp)];
-- 
2.53.0



