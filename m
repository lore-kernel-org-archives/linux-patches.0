Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976431B3F39;
	Thu,  6 Jun 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683437; cv=none; b=WWcUPLs5yhRwI7AzxcQ5/rhGdF65iWp4b9N6xbqAdrPbM28PChdL1hINDL7YSTba1LclXlBdqqxyzP+aI7EWq7yc3B10xxuX1i9/5TUFLs1yk9ObemP4ryUDhSYyoeKqustPyzSHmszjI44Dx71cRn/UyZHLnDtXhiRdfu+17ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683437; c=relaxed/simple;
	bh=bjZb01F3+BeIGp0dcmUyHx62ejAM1xn5R/yONlbrsV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2d8amYpTI1IaLEXn4HSaQ4UZsU3Mu1pKRwctAYRqtf4rq/oV41mRUb5eHibggdnlhHkf0LOXYU16rfmU7WgQlvZ+1l6nMzcuft8Xe2z8+smVt+0bPDC2ZdPp0xTBlcl2ZmU6gXZAweCK3URwTpIGa+tTvWSBnj63t0FAZHr6Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SlDwlLBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlDwlLBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A89C2BD10;
	Thu,  6 Jun 2024 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683437;
	bh=bjZb01F3+BeIGp0dcmUyHx62ejAM1xn5R/yONlbrsV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlDwlLBv5rAvMpEtL1kTXz0Jj/VXehJ1IvdAuBswf0UlEmdfZ+nF+BdVLNWTxATNz
	 qLYweaHhBaSWISAMkt6o9S7q7rcy4OlENrmPxB8c4zQfViruWVJEKWslmQ6TcSjjsl
	 LvLauHksSlNQ4RUDTNe2KpVdm9+4bb4FiLHK0W2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 382/744] selftests: net: bridge: increase IGMP/MLD exclude timeout membership interval
Date: Thu,  6 Jun 2024 16:00:54 +0200
Message-ID: <20240606131744.722784906@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 06080ea23095afe04a2cb7a8d05fab4311782623 ]

When running the bridge IGMP/MLD selftests on debug kernels we can get
spurious errors when setting up the IGMP/MLD exclude timeout tests
because the membership interval is just 3 seconds and the setup has 2
seconds of sleep plus various validations, the one second that is left
is not enough. Increase the membership interval from 3 to 5 seconds to
make room for the setup validation and 2 seconds of sleep.

Fixes: 34d7ecb3d4f7 ("selftests: net: bridge: update IGMP/MLD membership interval value")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/bridge_igmp.sh | 6 +++---
 tools/testing/selftests/net/forwarding/bridge_mld.sh  | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/forwarding/bridge_igmp.sh b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
index 2aa66d2a1702b..e6a3e04fd83f3 100755
--- a/tools/testing/selftests/net/forwarding/bridge_igmp.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_igmp.sh
@@ -478,10 +478,10 @@ v3exc_timeout_test()
 	RET=0
 	local X=("192.0.2.20" "192.0.2.30")
 
-	# GMI should be 3 seconds
+	# GMI should be 5 seconds
 	ip link set dev br0 type bridge mcast_query_interval 100 \
 					mcast_query_response_interval 100 \
-					mcast_membership_interval 300
+					mcast_membership_interval 500
 
 	v3exclude_prepare $h1 $ALL_MAC $ALL_GROUP
 	ip link set dev br0 type bridge mcast_query_interval 500 \
@@ -489,7 +489,7 @@ v3exc_timeout_test()
 					mcast_membership_interval 1500
 
 	$MZ $h1 -c 1 -b $ALL_MAC -B $ALL_GROUP -t ip "proto=2,p=$MZPKT_ALLOW2" -q
-	sleep 3
+	sleep 5
 	bridge -j -d -s mdb show dev br0 \
 		| jq -e ".[].mdb[] | \
 			 select(.grp == \"$TEST_GROUP\" and \
diff --git a/tools/testing/selftests/net/forwarding/bridge_mld.sh b/tools/testing/selftests/net/forwarding/bridge_mld.sh
index e2b9ff773c6b6..f84ab2e657547 100755
--- a/tools/testing/selftests/net/forwarding/bridge_mld.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mld.sh
@@ -478,10 +478,10 @@ mldv2exc_timeout_test()
 	RET=0
 	local X=("2001:db8:1::20" "2001:db8:1::30")
 
-	# GMI should be 3 seconds
+	# GMI should be 5 seconds
 	ip link set dev br0 type bridge mcast_query_interval 100 \
 					mcast_query_response_interval 100 \
-					mcast_membership_interval 300
+					mcast_membership_interval 500
 
 	mldv2exclude_prepare $h1
 	ip link set dev br0 type bridge mcast_query_interval 500 \
@@ -489,7 +489,7 @@ mldv2exc_timeout_test()
 					mcast_membership_interval 1500
 
 	$MZ $h1 -c 1 $MZPKT_ALLOW2 -q
-	sleep 3
+	sleep 5
 	bridge -j -d -s mdb show dev br0 \
 		| jq -e ".[].mdb[] | \
 			 select(.grp == \"$TEST_GROUP\" and \
-- 
2.43.0



