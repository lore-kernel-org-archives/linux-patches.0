Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43D52E62C;
	Mon,  8 Apr 2024 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581776; cv=none; b=byW17kGUas/vfQ4kbd5Bgycr63rvy1HR5jfNRhA2eRDSYONDYg3gcu79zvErVtpY/9QLEPlIob7nF58o8yq5vpjLaEKsGvZnINx7PgHHwTVZ04YOZwknlhhrcX3qh0rO1APrgfwAEcjxtIiD0jEIMLvU0FcVcB1wCUcWfLkNHBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581776; c=relaxed/simple;
	bh=zcgZ0MQl/v1rmrSzdX1KHRYcTUIZ4UB19ahhpmi8cU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ehl6ILVOmmQgk7w8PTj1sa0vg2gh3U829e5btV7tw0ISZlIiC0eDXqcMXx2aNrkJ5p967sZj0wmREPxgg2bSxqI1t5RmWXQqU28JoMm/Aa0tNhs2Wg3thTxMCk9F6TdmshaYitxO6OcU7QrSxAowT/r2JQ0BZe5WVuW8b0FqsQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cr9XLmZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cr9XLmZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B6AC433C7;
	Mon,  8 Apr 2024 13:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581776;
	bh=zcgZ0MQl/v1rmrSzdX1KHRYcTUIZ4UB19ahhpmi8cU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cr9XLmZiacoQITyiZk+fZXRvM4wWVKVuCZV0F5RIodaeFUBJW1vc1pHFnlJTl1trZ
	 +wdgMXWtbk38V5tx+9gpsCVAVEBjR/BE84A19mN9gp4osuynfRfPhHkJuoi1LOrLFs
	 /a7dATX7kKezC9HQWIzWiYn82nGWgtFoWzp83rCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 051/138] selftests: net: gro fwd: update vxlan GRO test expectations
Date: Mon,  8 Apr 2024 14:57:45 +0200
Message-ID: <20240408125257.815454527@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -239,7 +239,7 @@ for family in 4 6; do
 
 	create_vxlan_pair
 	ip netns exec $NS_DST ethtool -K veth$DST rx-gro-list on
-	run_test "GRO frag list over UDP tunnel" $OL_NET$DST 1 1
+	run_test "GRO frag list over UDP tunnel" $OL_NET$DST 10 10
 	cleanup
 
 	# use NAT to circumvent GRO FWD check
@@ -252,13 +252,7 @@ for family in 4 6; do
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
 


