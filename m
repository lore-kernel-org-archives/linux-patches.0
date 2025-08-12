Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A222FFDC0;
	Tue, 12 Aug 2025 18:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025082; cv=none; b=u8hZ2jZuw+YdRWJyhrgsu5qdiCaLq5UPUpa7AI74bDFbpCa+P3pvYkl19QzGQQEPhrNMavoxvzwWsYijgbltPPIFJvpD/VQUKxEmfR55NT3g+099vnxohyXr8m5ud8Kd6uyN0D6S0ZaYE8TVRFc1+UgrUrEGWjVoUiKp5itRvww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025082; c=relaxed/simple;
	bh=uITnNJqEBd6DmNkWdFwuul00psZu52X3PKFUDQ8gOGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NcjzXsDzl1IwItu/34+i9KODKs6FxNX+OhkwAgg+qggYyqIwYvAH0azYNJF8ipA+lZxJ1OyYcX/IgmLigs3rIU5ADdqCNcG8S01sQYpDFR+y/knhdCuc3h4eszerMAZdCllJA17rHu++oRx6pvWIo8e1Ms056ZcKl9loIp3aErs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROn8h4rc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROn8h4rc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A43C4CEF0;
	Tue, 12 Aug 2025 18:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025082;
	bh=uITnNJqEBd6DmNkWdFwuul00psZu52X3PKFUDQ8gOGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ROn8h4rc9wksHAJEJ498VOolAN8CRfbZbxnI25qab4y+xNVhemLOD2xPqPWyMflc9
	 qtGtcJACteR5TY2SG36cTmdlEssuQi2kvYRKl9ksbmMfAwxrc2BKIrjZSOW60P93rO
	 dbs5emBfloOB/3v6MBYT8ZXQIvj1/5DtvHrrZlRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Dong Chenchen <dongchenchen2@huawei.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 531/627] selftests: avoid using ifconfig
Date: Tue, 12 Aug 2025 19:33:46 +0200
Message-ID: <20250812173452.116262250@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7cbd49795d4ca86fba5830084e94fece3b343b79 ]

ifconfig is deprecated and not always present, use ip command instead.

Fixes: e0f3b3e5c77a ("selftests: Add test cases for vlan_filter modification during runtime")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Dong Chenchen <dongchenchen2@huawei.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20250730115313.3356036-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/vlan_hw_filter.sh | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/net/vlan_hw_filter.sh b/tools/testing/selftests/net/vlan_hw_filter.sh
index 0fb56baf28e4..e195d5cab6f7 100755
--- a/tools/testing/selftests/net/vlan_hw_filter.sh
+++ b/tools/testing/selftests/net/vlan_hw_filter.sh
@@ -55,10 +55,10 @@ test_vlan0_del_crash_01() {
 	ip netns exec ${NETNS} ip link add bond0 type bond mode 0
 	ip netns exec ${NETNS} ip link add link bond0 name vlan0 type vlan id 0 protocol 802.1q
 	ip netns exec ${NETNS} ethtool -K bond0 rx-vlan-filter off
-	ip netns exec ${NETNS} ifconfig bond0 up
+	ip netns exec ${NETNS} ip link set dev bond0 up
 	ip netns exec ${NETNS} ethtool -K bond0 rx-vlan-filter on
-	ip netns exec ${NETNS} ifconfig bond0 down
-	ip netns exec ${NETNS} ifconfig bond0 up
+	ip netns exec ${NETNS} ip link set dev bond0 down
+	ip netns exec ${NETNS} ip link set dev bond0 up
 	ip netns exec ${NETNS} ip link del vlan0 || fail "Please check vlan HW filter function"
 	cleanup
 }
@@ -68,11 +68,11 @@ test_vlan0_del_crash_02() {
 	setup
 	ip netns exec ${NETNS} ip link add bond0 type bond mode 0
 	ip netns exec ${NETNS} ethtool -K bond0 rx-vlan-filter off
-	ip netns exec ${NETNS} ifconfig bond0 up
+	ip netns exec ${NETNS} ip link set dev bond0 up
 	ip netns exec ${NETNS} ethtool -K bond0 rx-vlan-filter on
 	ip netns exec ${NETNS} ip link add link bond0 name vlan0 type vlan id 0 protocol 802.1q
-	ip netns exec ${NETNS} ifconfig bond0 down
-	ip netns exec ${NETNS} ifconfig bond0 up
+	ip netns exec ${NETNS} ip link set dev bond0 down
+	ip netns exec ${NETNS} ip link set dev bond0 up
 	ip netns exec ${NETNS} ip link del vlan0 || fail "Please check vlan HW filter function"
 	cleanup
 }
@@ -84,9 +84,9 @@ test_vlan0_del_crash_03() {
 	ip netns exec ${NETNS} ip link add bond0 type bond mode 0
 	ip netns exec ${NETNS} ip link add link bond0 name vlan0 type vlan id 0 protocol 802.1q
 	ip netns exec ${NETNS} ethtool -K bond0 rx-vlan-filter off
-	ip netns exec ${NETNS} ifconfig bond0 up
+	ip netns exec ${NETNS} ip link set dev bond0 up
 	ip netns exec ${NETNS} ethtool -K bond0 rx-vlan-filter on
-	ip netns exec ${NETNS} ifconfig bond0 down
+	ip netns exec ${NETNS} ip link set dev bond0 down
 	ip netns exec ${NETNS} ip link del vlan0 || fail "Please check vlan HW filter function"
 	cleanup
 }
-- 
2.39.5



