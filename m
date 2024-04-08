Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C977F496;
	Mon,  8 Apr 2024 14:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712585049; cv=none; b=dFRHfoTeHhjrSzZuyVh3Ljmhp1OyOtPCUkAiUeB7PEmgpG1LgFdNmd1r4j/6W9KHLt/w3ZnHg04YTrgd+pwPjVe4q1HSVVYiBCyoY+djfOCnXViHEKvTrTxGfIFMzKo7kJoKJhhAaTtVDQLr4VMp2IaryKwrF8N2GnpXjkiItIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712585049; c=relaxed/simple;
	bh=NxRQuqugex1EqV87o78wWK8PVC5zM/GlEGpPs9KTrB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1FM2mZhPbDtOP+0HRPEYMUu/DKcdQRtdyzLGQT+0ekPY4r045Qyr7UWrib/1ruVg4Dv7tv5cjQJ1zv9lJEl7exQzD5ZQwJGHFey5zZyJZq8bRpomQ8BB+1CrzqmEDanH7w/yFiRD7WJAlzK2rB6smmfsemnXfBgTgpRMPdhrP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSXmXgJj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSXmXgJj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3714C433F1;
	Mon,  8 Apr 2024 14:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712585049;
	bh=NxRQuqugex1EqV87o78wWK8PVC5zM/GlEGpPs9KTrB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSXmXgJjRzTP4HsT72g6wIXUFRigfuuiuk5tzpKThsVXD1W//HDq4j9zrA/AusmMy
	 Z7v+4ByQ4fB8zNqy8OaRsfe9yG6bu0dCQjiorSSgOsImTVKvXVby33d1BiFbAJcuAo
	 qlimIGAyyxCuBPz272MNi6FUqA2jwrHZq1oqPMTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 644/690] selftests: net: gro fwd: update vxlan GRO test expectations
Date: Mon,  8 Apr 2024 14:58:30 +0200
Message-ID: <20240408125422.985521863@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

commit 0fb101be97ca27850c5ecdbd1269423ce4d1f607 upstream.

UDP tunnel packets can't be GRO in-between their endpoints as this
causes different issues. The UDP GRO fwd vxlan tests were relying on
this and their expectations have to be fixed.

We keep both vxlan tests and expected no GRO from happening. The vxlan
UDP GRO bench test was removed as it's not providing any valuable
information now.

Fixes: a062260a9d5f ("selftests: net: add UDP GRO forwarding self-tests")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/udpgro_fwd.sh |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/net/udpgro_fwd.sh
+++ b/tools/testing/selftests/net/udpgro_fwd.sh
@@ -238,7 +238,7 @@ for family in 4 6; do
 
 	create_vxlan_pair
 	ip netns exec $NS_DST ethtool -K veth$DST rx-gro-list on
-	run_test "GRO frag list over UDP tunnel" $OL_NET$DST 1 1
+	run_test "GRO frag list over UDP tunnel" $OL_NET$DST 10 10
 	cleanup
 
 	# use NAT to circumvent GRO FWD check
@@ -251,13 +251,7 @@ for family in 4 6; do
 	# load arp cache before running the test to reduce the amount of
 	# stray traffic on top of the UDP tunnel
 	ip netns exec $NS_SRC $PING -q -c 1 $OL_NET$DST_NAT >/dev/null
-	run_test "GRO fwd over UDP tunnel" $OL_NET$DST_NAT 1 1 $OL_NET$DST
-	cleanup
-
-	create_vxlan_pair
-	run_bench "UDP tunnel fwd perf" $OL_NET$DST
-	ip netns exec $NS_DST ethtool -K veth$DST rx-udp-gro-forwarding on
-	run_bench "UDP tunnel GRO fwd perf" $OL_NET$DST
+	run_test "GRO fwd over UDP tunnel" $OL_NET$DST_NAT 10 10 $OL_NET$DST
 	cleanup
 done
 


