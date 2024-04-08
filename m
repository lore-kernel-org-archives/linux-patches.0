Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7964D2E405;
	Mon,  8 Apr 2024 13:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582813; cv=none; b=FmJJp8MvY+yJRJslOY/IAxMUZ/gmGPHlURY6FqWX6lNdZ3Ug7BdT1NezSxywYFH85e7s/BWChLY97EWbVLHMXbMP4iu8qhjQS8Tm1iafjs1z119L9O/ffhUyZcnq01D1VOVdETDZg5sVcY9j2LF0vrUm5MmWOtzsQtAgUsOCptI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582813; c=relaxed/simple;
	bh=Clgkv931SKIAnvc/0aDywO/CBBZbuK5gxpZUUTjL1CA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ9kyTg7pgODM29ds+2zud60JetDfq7ZgUJVqavZThUE8NuCrlB5UNy73uxwlFDXiyIysOfU9IHbxHO8XyKRGAVycD53A16QY0+Lti3TMLxLcrUssEMNoNv0Gd2PZbBBnADMzrFJ3HDxYy6Q/6mnJrF6P7dUqwETu/dETggTx/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YfX9aNkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YfX9aNkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 002ADC433C7;
	Mon,  8 Apr 2024 13:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582813;
	bh=Clgkv931SKIAnvc/0aDywO/CBBZbuK5gxpZUUTjL1CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YfX9aNklcrD/nqVfHVPrs1L9jXscJqH2oqX1g6eQXwMC8Ji/S8FddpZ19oVznXRTo
	 7pGXDlKmzx6J6+Wl6iS5/GSMMiVV+1tojPkzwVPEFD0Rda7xDRnRdCWE/mIy37eqMP
	 qKB/afcwgt3ml3vGVjl/BQ2tXMr3LJd5g5LwYmHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 107/273] selftests: net: gro fwd: update vxlan GRO test expectations
Date: Mon,  8 Apr 2024 14:56:22 +0200
Message-ID: <20240408125312.628465219@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
 


