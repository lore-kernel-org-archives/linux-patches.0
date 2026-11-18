Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053618;
	b=zuBfWMRnKI9xkASaXWP98+UlNu8UCqGLY5+T6E2LbRdY1dBUoUmXgdfTvLiPftqYHXUd
	 ySx7qFNwX6tMNNWZT/HwPk1MyULzjoLRiy2ofO/oN6+ymavWNvWPSBeWQLuoYtoVLTqVO
	 KYzn7siRYS3qKmsulw4elImQn9nBp29rtTcAB/gh0/6505ZuAssPdQPpwUsgCzDrMLgY7
	 TLSO8W1SpE5giUeOwj4BsIvbMnZJdn8x7tadWE3plWLUnsy+8yXrSmslXyeCMkwSCrdpk
	 f3FINTaFXxMYVxpCiZONPwvgOVgFZIR50gDFRxeeVw917rZS+KiRSeugohXQlP8U4Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jojB0VRxFyGYA7ulDuRxVzrh8EReNo01W1oqaGPw8Tk=;
	b=cQr0fxsCV2S61I+vwrFl/hRFtoSdQnJnyzlbiPuPE4WTsyo+BBu5Jt6H1R5NY2ocHQ+i
	 O0ll0rCeep92n5w9GG1fG405XyXAWrtMLELy14bqLFhqEp6WkYd+OL6jnSnUb4UPRPWoZ
	 b4WVEmasD6deZ5qFksXqPphb1ZDskyhbx4SCk77cyNio1KwSYjksVn8uV+Ca2vXmdxgEp
	 g7GvA//CXdbx+FVN9bqpMf6mRtm5u+10lKt6F8zHMnbx2W0kGJ6c27PogS44uPVF35OCr
	 poPPqdgKx5v036486plEE1cq8NFEFwi7k5JD5WBxQuKtbczYWauwJIOF1yV2mxtLVVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riMOQv9Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80030606A325;
	Thu, 19 Nov 2026 02:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=riMOQv9Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CECD51F000C4;
	Thu, 19 Nov 2026 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053618;
	bh=jojB0VRxFyGYA7ulDuRxVzrh8EReNo01W1oqaGPw8Tk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=riMOQv9QdHLczVXK24XzkGyWct/u6oB+9NbUrLbjjllbAQV53pZL2kTIATPpB5h7c
	 mJNk7vc0VrOsTS0zz3nRIP4iW8RZBRviLIq8VPfUh/tPF+gYhYJTqZ10bptBaF047i
	 DfjH7j18yLQ0TCZDyFM/oIlOf7OMYub1dP7+DjbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Frey <sf@techfak.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0942/2214] vxlan: Stop rejecting dynamic FDB entries with a nexthop ID
Date: Wed, 18 Nov 2026 15:43:38 +0100
Message-ID: <20261118150050.039386966@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 7308ef8b4a6779a39f68d053c19b53a5c584a663 ]

Commit 98fc57d16744 ("vxlan: reject dynamic fdb entries that reference a
nexthop id") started rejecting FDB entries that point to FDB nexthops
unless they are configured as "permanent" or "static". The intent was to
prevent such entries from being aged out by vxlan_cleanup(), which runs
without RTNL and can therefore race with other VXLAN devices that modify
the same per-nexthop FDB list.

However, FRR installs remote MACs that are behind a multihomed Ethernet
Segment (EVPN-MH) as dynamic FDB entries that point to an FDB nexthop
group. Since the above commit, these entries are rejected and traffic
towards the corresponding MACs is flooded to all the remote VTEPs.

These entries are also marked as externally learned ("extern_learn")
and are therefore skipped by vxlan_cleanup(), but exempting externally
learned entries from the checks is not enough: vxlan_cleanup() reads
the state and flags of an entry without the hash lock, so an entry that
is concurrently changed from dynamic and externally learned to static
can still be aged out.

Instead, remove the checks added by the above commit and make
vxlan_cleanup() skip FDB entries that point to FDB nexthops. Such
entries can only be configured from user space, cannot be learned and
cannot roam, so there is no reason to age them out. The nexthop pointer
of an FDB entry is set before the entry is linked and is only cleared
after it was unlinked and an RCU grace period has passed, so it can be
checked without the hash lock.

Adjust the test cases added by the above commit and add a test case
that checks that dynamic FDB entries that point to FDB nexthops are not
aged out. Without the fix:

 # ./fib_nexthops.sh -t "ipv4_fdb_grp_fcnal ipv6_fdb_grp_fcnal"

 IPv4 fdb groups functional
 --------------------------
 [...]
 TEST: Fdb mac add with nexthop group and dynamic state              [FAIL]
 TEST: Fdb mac add with nexthop group and extern_learn               [FAIL]
 TEST: Fdb mac without nexthop group aged out                        [ OK ]
 TEST: Fdb mac with nexthop group not aged out                       [FAIL]
 [...]

 IPv6 fdb groups functional
 --------------------------
 [...]
 TEST: Fdb mac add with nexthop group and dynamic state              [FAIL]
 TEST: Fdb mac add with nexthop group and extern_learn               [FAIL]
 TEST: Fdb mac without nexthop group aged out                        [ OK ]
 TEST: Fdb mac with nexthop group not aged out                       [FAIL]
 [...]

 Tests passed:  44
 Tests failed:   6
 Tests skipped:  0

With the fix:

 # ./fib_nexthops.sh -t "ipv4_fdb_grp_fcnal ipv6_fdb_grp_fcnal"

 IPv4 fdb groups functional
 --------------------------
 [...]
 TEST: Fdb mac add with nexthop group and dynamic state              [ OK ]
 TEST: Fdb mac add with nexthop group and extern_learn               [ OK ]
 TEST: Fdb mac without nexthop group aged out                        [ OK ]
 TEST: Fdb mac with nexthop group not aged out                       [ OK ]
 [...]

 IPv6 fdb groups functional
 --------------------------
 [...]
 TEST: Fdb mac add with nexthop group and dynamic state              [ OK ]
 TEST: Fdb mac add with nexthop group and extern_learn               [ OK ]
 TEST: Fdb mac without nexthop group aged out                        [ OK ]
 TEST: Fdb mac with nexthop group not aged out                       [ OK ]
 [...]

 Tests passed:  50
 Tests failed:   0
 Tests skipped:  0

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Fixes: 98fc57d16744 ("vxlan: reject dynamic fdb entries that reference a nexthop id")
Cc: stable@vger.kernel.org
Reported-by: Sascha Frey <sf@techfak.net>
Closes: https://lore.kernel.org/netdev/20261028142928.GA8406@techfak.de/
Tested-by: Sascha Frey <sf@techfak.net>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20261030133750.28668-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ idosch: fixed a small conflict in vxlan_fdb_add(), adjusted the
  vxlan_cleanup() hunk to the per-bucket FDB iteration in this tree and
  open-coded the wait in fdb_entry_aged() since slowwait() is not
  available to fib_nexthops.sh in this tree ]
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c              | 14 ++-----
 tools/testing/selftests/net/fib_nexthops.sh | 46 +++++++++++++++------
 2 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 162a329be4477..ee002e790b289 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1070,12 +1070,6 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 		return -EOPNOTSUPP;
 	}
 
-	if (rcu_access_pointer(f->nh) &&
-	    !(state & (NUD_PERMANENT | NUD_NOARP))) {
-		NL_SET_ERR_MSG(extack, "Cannot make a nexthop fdb dynamic");
-		return -EOPNOTSUPP;
-	}
-
 	/* Do not allow an externally learned entry to take over an entry added
 	 * by the user.
 	 */
@@ -1328,11 +1322,6 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	if (err)
 		return err;
 
-	if (nhid && !(ndm->ndm_state & (NUD_PERMANENT | NUD_NOARP))) {
-		NL_SET_ERR_MSG(extack, "A nexthop fdb cannot be dynamic");
-		return -EINVAL;
-	}
-
 	if (vxlan->default_dst.remote_ip.sa.sa_family != ip.sa.sa_family)
 		return -EAFNOSUPPORT;
 
@@ -3031,6 +3020,9 @@ static void vxlan_cleanup(struct timer_list *t)
 			if (f->flags & NTF_EXT_LEARNED)
 				continue;
 
+			if (rcu_access_pointer(f->nh))
+				continue;
+
 			timeout = READ_ONCE(f->used) + vxlan->cfg.age_interval * HZ;
 			if (time_before_eq(timeout, jiffies)) {
 				netdev_dbg(vxlan->dev,
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 68183d840e2f3..4d40f6e76eb08 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -396,6 +396,20 @@ stop_ip_monitor()
 	return $rc
 }
 
+fdb_entry_aged()
+{
+	local mac=$1
+	local dev=$2
+	local i
+
+	for i in $(seq 20); do
+		$BRIDGE fdb get to $mac dev $dev self &> /dev/null || return 0
+		sleep 1
+	done
+
+	return 1
+}
+
 check_nexthop_fdb_support()
 {
 	$IP nexthop help 2>&1 | grep -q fdb
@@ -480,14 +494,18 @@ ipv6_fdb_grp_fcnal()
 	log_test $? 0 "Fdb mac add with nexthop group and static state"
 
 	run_cmd "$BRIDGE fdb add 02:02:00:00:00:16 dev vx10 nhid 102 self dynamic"
-	log_test $? 255 "Fdb mac add with nexthop group and dynamic state"
+	log_test $? 0 "Fdb mac add with nexthop group and dynamic state"
 
-	run_cmd "$BRIDGE fdb add 02:02:00:00:00:17 dev vx10 nhid 102 self"
-	run_cmd "$BRIDGE fdb replace 02:02:00:00:00:17 dev vx10 dst 2001:db8:91::11 self dynamic"
-	log_test $? 255 "Fdb mac replace with nexthop group and dynamic state"
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:17 dev vx10 nhid 102 self dynamic extern_learn"
+	log_test $? 0 "Fdb mac add with nexthop group and extern_learn"
 
-	run_cmd "$BRIDGE fdb append 02:02:00:00:00:17 dev vx10 dst 2001:db8:91::11 self dynamic"
-	log_test $? 255 "Fdb mac append with nexthop group and dynamic state"
+	run_cmd "$IP link set dev vx10 up type vxlan ageing 1"
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:18 dev vx10 dst 2001:db8:91::11 self dynamic"
+	fdb_entry_aged 02:02:00:00:00:18 vx10
+	log_test $? 0 "Fdb mac without nexthop group aged out"
+
+	run_cmd "$BRIDGE fdb get to 02:02:00:00:00:16 dev vx10 self"
+	log_test $? 0 "Fdb mac with nexthop group not aged out"
 
 	run_cmd "$IP -6 ro add 2001:db8:101::1/128 nhid 66"
 	log_test $? 2 "Route add with fdb nexthop"
@@ -574,14 +592,18 @@ ipv4_fdb_grp_fcnal()
 	log_test $? 0 "Fdb mac add with nexthop group and static state"
 
 	run_cmd "$BRIDGE fdb add 02:02:00:00:00:16 dev vx10 nhid 102 self dynamic"
-	log_test $? 255 "Fdb mac add with nexthop group and dynamic state"
+	log_test $? 0 "Fdb mac add with nexthop group and dynamic state"
+
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:17 dev vx10 nhid 102 self dynamic extern_learn"
+	log_test $? 0 "Fdb mac add with nexthop group and extern_learn"
 
-	run_cmd "$BRIDGE fdb add 02:02:00:00:00:17 dev vx10 nhid 102 self"
-	run_cmd "$BRIDGE fdb replace 02:02:00:00:00:17 dev vx10 dst 10.0.0.3 self dynamic"
-	log_test $? 255 "Fdb mac replace with nexthop group and dynamic state"
+	run_cmd "$IP link set dev vx10 up type vxlan ageing 1"
+	run_cmd "$BRIDGE fdb add 02:02:00:00:00:18 dev vx10 dst 10.0.0.3 self dynamic"
+	fdb_entry_aged 02:02:00:00:00:18 vx10
+	log_test $? 0 "Fdb mac without nexthop group aged out"
 
-	run_cmd "$BRIDGE fdb append 02:02:00:00:00:17 dev vx10 dst 10.0.0.3 self dynamic"
-	log_test $? 255 "Fdb mac append with nexthop group and dynamic state"
+	run_cmd "$BRIDGE fdb get to 02:02:00:00:00:16 dev vx10 self"
+	log_test $? 0 "Fdb mac with nexthop group not aged out"
 
 	run_cmd "$IP ro add 172.16.0.0/22 nhid 16"
 	log_test $? 2 "Route add with fdb nexthop"
-- 
2.53.0



