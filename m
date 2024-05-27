Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC78761FDF;
	Mon, 27 May 2024 19:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838656; cv=none; b=SGzbIeA8fEPDOGTG6iSlQI26MCCvxR68nHMSZgj5EFSZc8qD703lRE00c/U4v9Xq3lgLdPcJisDrQxmxa/n9R5VJ9gGgNnZ65WA6HvXYJrdCfFyDeGAnyRYv6Jf4qMLaCKKtTzbZ+p5zKCEgWR9xCfy8un+qqf7Nrs+Y8OsQWcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838656; c=relaxed/simple;
	bh=PvR8480+yjINrNJpZtQ+2N941f2oahhGmCv9u+KFGjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OYoWUUEN4SQmOPifiVpe9J42Zva1EjYtY1/TvWSYy36Wc83rvQU8bR66e40KNFVOxcmjEkPeAQp8Tr53DX35ZxQ7PA9qFwE5KwGicDLEufbEgm1a/ECSlqzWe1Co9VVdE6yOb3Menqtp2EmlHYJtJx5pj4nVEy9lG/BDNPig1/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x02eMIV/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x02eMIV/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8A8DC2BBFC;
	Mon, 27 May 2024 19:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838656;
	bh=PvR8480+yjINrNJpZtQ+2N941f2oahhGmCv9u+KFGjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x02eMIV/P3ofmJ2/b2u2dLPnrw05FzPEQFEE87MnVMhZLhvSdrzKwYVaKNVGTBARn
	 3A6h51TnTGFVt+zg0i6IvGr28MnRwa4IZJ1TyQV4Ybz/GjMeRKb6Mj55n4UuiCvqkA
	 /IoRo/kL2eOW8ciYLpk2GqHxEI6UA8CnyqPFPhwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 475/493] selftests: net: bridge: increase IGMP/MLD exclude timeout membership interval
Date: Mon, 27 May 2024 20:57:57 +0200
Message-ID: <20240527185645.690759411@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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



