Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE56780620;
	Mon,  8 Apr 2024 13:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582684; cv=none; b=aa23uNCyiJwVjha+IyzRLtocGB+NgSG4TuRbzDEbEuoKnp9pAGXv+Ar2CazI1k48RAWEBlLGlXBM9JnUwf8puwc4kb4VucYuk9eKXmV/OEjUNlnh1O34PoomrZWc+7TZXQ1/PKjYphOWpBAUgPN29W93jZheNQps1epVkp91VeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582684; c=relaxed/simple;
	bh=xSys25Oo3PUto6m1MopX8d+BY3RR9fOfHaR8fQxd6zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8y5sGM+ZNJwvA+O3HgrLq8HNJ6fisPW5a3Ylrttb5+n5J01/oxRyONKRfhKTCqD7bLBxfI1Le9u8D3Bc2SdyiJCRw5267d+r0tDBKKE/oCyUBkImuBTpksIOVbmtLAdZgtoK3jvoo2yZfdZQIWMBMivNqzNSv4s85Fgdcur4Xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJohPAV9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJohPAV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 412A3C433C7;
	Mon,  8 Apr 2024 13:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582684;
	bh=xSys25Oo3PUto6m1MopX8d+BY3RR9fOfHaR8fQxd6zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lJohPAV9g6DQlEdP8cra/2iVdkWYyqEkjp7V+75WvKngP8pG83Qz140g72MGxYaQ2
	 IHMPx/DlvHYCvsW+SCepnsg1fyY4UmCZJj37V4bqbPWhVcRmIQoEch745rwqrRhXhE
	 r/8z9kw5/3Srvn9SRNu/1RAqq7ngGWqQjkCZdrus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 112/252] selftests: net: gro fwd: update vxlan GRO test expectations
Date: Mon,  8 Apr 2024 14:56:51 +0200
Message-ID: <20240408125310.113443539@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
@@ -241,7 +241,7 @@ for family in 4 6; do
 
 	create_vxlan_pair
 	ip netns exec $NS_DST ethtool -K veth$DST rx-gro-list on
-	run_test "GRO frag list over UDP tunnel" $OL_NET$DST 1 1
+	run_test "GRO frag list over UDP tunnel" $OL_NET$DST 10 10
 	cleanup
 
 	# use NAT to circumvent GRO FWD check
@@ -254,13 +254,7 @@ for family in 4 6; do
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
 


