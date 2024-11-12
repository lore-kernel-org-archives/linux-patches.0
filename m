Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91BD21FA839;
	Tue, 12 Nov 2024 10:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407925; cv=none; b=LgWlv8Y+AOYL53YZf+0jXeE31BqCoSX4qefCgcjS+LportNxelbPHVmbJ6YCJLGDBP45MQdcQT+2fK9MEON1rBfxi+30ovNuwZNzybIZVzRuNMhS6zC2sDZa56qaqV0R/IeZPcvYdae5lUXCq5O9pGY1sfiG32eCkNrAktZURuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407925; c=relaxed/simple;
	bh=0NHtFmaGh+N0hgeZg2go9m7Tzuc2xa2M/GtIcfyB+HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1OlBiOvLJr9s2GjiMidGJrUQKEWLqHRDxoxVmWTZ0HILD9YCedzaUMVXB58Z2gV5uWWwtkjQCM4/5hvN6knZqYmmGzPPBfaD7Rr8cORO6DwnP/vUIkmf6LFJ2UIt7kSZgK69SwitdW5vOjWts+rzKyWPtcF0qEqn6blK/emsm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxw2MhEy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxw2MhEy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E739CC4CECD;
	Tue, 12 Nov 2024 10:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407925;
	bh=0NHtFmaGh+N0hgeZg2go9m7Tzuc2xa2M/GtIcfyB+HQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nxw2MhEycNbER3lOZ6bHr9hL5HgEvfuIdwvpQGrWwI/br2AwMfhAB0E6HMkPM+X6+
	 M//UVfYR+xQqNINtKE9M+EOSTFmSdVlLhflKPvX+nncDsJXr3pJaZ24Sch2a4Ohsqa
	 1T0gb3W3UjwlhCOCp7uAqg82YgVflfAd0QGiipX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>
Subject: [PATCH 6.6 100/119] Revert "selftests/bpf: Implement get_hw_ring_size function to retrieve current and max interface size"
Date: Tue, 12 Nov 2024 11:21:48 +0100
Message-ID: <20241112101852.544106351@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pu Lehui <pulehui@huawei.com>

This reverts commit c8c590f07ad7ffaa6ef11e90b81202212077497b which is
commit 90a695c3d31e1c9f0adb8c4c80028ed4ea7ed5ab upstream.

Commit c8c590f07ad7 ("selftests/bpf: Implement get_hw_ring_size function
to retrieve current and max interface size") will cause the following
bpf selftests compilation error in the 6.6 stable branch, and it is not
the Stable-dep-of of commit 103c0431c7fb ("selftests/bpf: Drop unneeded
error.h includes"). So let's revert commit c8c590f07ad7 to fix this
compilation error.

  ./network_helpers.h:66:43: error: 'struct ethtool_ringparam' declared
    inside parameter list will not be visible outside of this definition or
    declaration [-Werror]
      66 | int get_hw_ring_size(char *ifname, struct ethtool_ringparam *ring_param);

Signed-off-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/network_helpers.c           |   24 ----------------
 tools/testing/selftests/bpf/network_helpers.h           |    4 --
 tools/testing/selftests/bpf/prog_tests/flow_dissector.c |    1 
 tools/testing/selftests/bpf/xdp_hw_metadata.c           |   14 +++++++++
 4 files changed, 15 insertions(+), 28 deletions(-)

--- a/tools/testing/selftests/bpf/network_helpers.c
+++ b/tools/testing/selftests/bpf/network_helpers.c
@@ -465,27 +465,3 @@ int get_socket_local_port(int sock_fd)
 
 	return -1;
 }
-
-int get_hw_ring_size(char *ifname, struct ethtool_ringparam *ring_param)
-{
-	struct ifreq ifr = {0};
-	int sockfd, err;
-
-	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
-	if (sockfd < 0)
-		return -errno;
-
-	memcpy(ifr.ifr_name, ifname, sizeof(ifr.ifr_name));
-
-	ring_param->cmd = ETHTOOL_GRINGPARAM;
-	ifr.ifr_data = (char *)ring_param;
-
-	if (ioctl(sockfd, SIOCETHTOOL, &ifr) < 0) {
-		err = errno;
-		close(sockfd);
-		return -err;
-	}
-
-	close(sockfd);
-	return 0;
-}
--- a/tools/testing/selftests/bpf/network_helpers.h
+++ b/tools/testing/selftests/bpf/network_helpers.h
@@ -9,11 +9,8 @@ typedef __u16 __sum16;
 #include <linux/if_packet.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
-#include <linux/ethtool.h>
-#include <linux/sockios.h>
 #include <netinet/tcp.h>
 #include <bpf/bpf_endian.h>
-#include <net/if.h>
 
 #define MAGIC_VAL 0x1234
 #define NUM_ITER 100000
@@ -63,7 +60,6 @@ int make_sockaddr(int family, const char
 		  struct sockaddr_storage *addr, socklen_t *len);
 char *ping_command(int family);
 int get_socket_local_port(int sock_fd);
-int get_hw_ring_size(char *ifname, struct ethtool_ringparam *ring_param);
 
 struct nstoken;
 /**
--- a/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
+++ b/tools/testing/selftests/bpf/prog_tests/flow_dissector.c
@@ -2,6 +2,7 @@
 #define _GNU_SOURCE
 #include <test_progs.h>
 #include <network_helpers.h>
+#include <linux/if.h>
 #include <linux/if_tun.h>
 #include <sys/uio.h>
 
--- a/tools/testing/selftests/bpf/xdp_hw_metadata.c
+++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
@@ -288,6 +288,20 @@ static int verify_metadata(struct xsk *r
 	return 0;
 }
 
+struct ethtool_channels {
+	__u32	cmd;
+	__u32	max_rx;
+	__u32	max_tx;
+	__u32	max_other;
+	__u32	max_combined;
+	__u32	rx_count;
+	__u32	tx_count;
+	__u32	other_count;
+	__u32	combined_count;
+};
+
+#define ETHTOOL_GCHANNELS	0x0000003c /* Get no of channels */
+
 static int rxq_num(const char *ifname)
 {
 	struct ethtool_channels ch = {


