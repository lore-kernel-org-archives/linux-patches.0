Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7748F57
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B67C433EF;
	Mon, 13 Feb 2023 14:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300083;
	bh=AxAluxM/BK+fXKw04pUKix1NYp6feId1wrRaWhDTZB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2JvP05n6RZdSWxafHN6ooy3l7hsOZCxfD/dijXKwxXhK/oF2AQ12rXXd4lIuFlMYH
	 4Bd18/GfzeuzUF7bvBSiZuuLQazlKl6boWE+ODPHcM4LTe+9SV54oWtmnBfOYIhTEG
	 8JQ4fX2zMWnFJGCMIbmvDdibRgSgK+f6frhfFH8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/114] selftests: Fix failing VXLAN VNI filtering test
Date: Mon, 13 Feb 2023 15:48:12 +0100
Message-Id: <20230213144745.171076697@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit b963d9d5b9437a6b99504987310f98537c9e77d4 ]

iproute2 does not recognize the "group6" and "remote6" keywords. Fix by
using "group" and "remote" instead.

Before:

 # ./test_vxlan_vnifiltering.sh
 [...]
 Tests passed:  25
 Tests failed:   2

After:

 # ./test_vxlan_vnifiltering.sh
 [...]
 Tests passed:  27
 Tests failed:   0

Fixes: 3edf5f66c12a ("selftests: add new tests for vxlan vnifiltering")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://lore.kernel.org/r/20230207141819.256689-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/net/test_vxlan_vnifiltering.sh   | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/tools/testing/selftests/net/test_vxlan_vnifiltering.sh b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
index 704997ffc2449..8c3ac0a725451 100755
--- a/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
+++ b/tools/testing/selftests/net/test_vxlan_vnifiltering.sh
@@ -293,19 +293,11 @@ setup-vm() {
 	elif [[ -n $vtype && $vtype == "vnifilterg" ]]; then
 	   # Add per vni group config with 'bridge vni' api
 	   if [ -n "$group" ]; then
-	      if [ "$family" == "v4" ]; then
-		 if [ $mcast -eq 1 ]; then
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group $group
-		 else
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote $group
-		 fi
-	      else
-		 if [ $mcast -eq 1 ]; then
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group6 $group
-		 else
-		    bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote6 $group
-		 fi
-	      fi
+		if [ $mcast -eq 1 ]; then
+			bridge -netns hv-$hvid vni add dev $vxlandev vni $tid group $group
+		else
+			bridge -netns hv-$hvid vni add dev $vxlandev vni $tid remote $group
+		fi
 	   fi
 	fi
 	done
-- 
2.39.0



