Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD1D1494DB;
	Thu,  5 Sep 2024 10:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530529; cv=none; b=qXi2VGHw4PUJfwJZ2wdA5lGXUHiKjfUTUduy1UzWTIFrNKg6drmMNulQdTJqQ4MycQpM9lzZWGjKoalJb2q4tLqG6Ng2N/zIO1k5CeipkbLKhcoGoC5Rxj4fsRvVMu42agLB6izIUIcx1aBQg1BBNld9b28Hj0vBg5KBsBkhF9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530529; c=relaxed/simple;
	bh=KpC3LFjEZzv3Y+hO2hV9EFEkgmsLkPGtVdaQcmannh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHkZONtgmnIsyX6ZdrX+7tOafOzW+aS73OWRTW6X8M3tBNvox3S+fnEynPB3cObsDGOignf/hg8tEr5sSIP7qXuqPj4uTJYma0C//9X4MG6vCqUdNvjIUfc3R14TNFMD8NrEhoqdoPqSJbsxHgDhM6U5L1OBmaXt/+9CorxcKZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t41JSKJY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t41JSKJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE335C4CEC3;
	Thu,  5 Sep 2024 10:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530529;
	bh=KpC3LFjEZzv3Y+hO2hV9EFEkgmsLkPGtVdaQcmannh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t41JSKJY0MjpDSpOxZH4nNgjQ3TDJNX9MsrT+HyKkbr8a8F1ZqA9+oyCEsvsycoMV
	 t4Gl8DPmkI4Ksdkz94N2VRRWnkFo1g5xpCyXZKOanJqpEKhRJtaSAFmfgIREN5oI8X
	 nAR6T2nXdlz7pYcwu3g+l5RPiksgWD26bauyG9DA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 025/101] selftests: mptcp: join: check removing ID 0 endpoint
Date: Thu,  5 Sep 2024 11:40:57 +0200
Message-ID: <20240905093717.106729406@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 5f94b08c001290acda94d9d8868075590931c198 upstream.

Removing the endpoint linked to the initial subflow should trigger a
RM_ADDR for the right ID, and the removal of the subflow. That's what is
now being verified in the "delete and re-add" test.

Note that removing the initial subflow will not decrement the 'subflows'
counters, which corresponds to the *additional* subflows. On the other
hand, when the same endpoint is re-added, it will increment this
counter, as it will be seen as an additional subflow this time.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: 3ad14f54bd74 ("mptcp: more accurate MPC endpoint tracking")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Conflicts in mptcp_join.sh, because the helpers are different in this
  version:
  - run_tests has been modified a few times to reduce the number of
    positional parameters
  - no chk_mptcp_info helper
  - chk_subflow_nr taking an extra parameter
  - kill_tests_wait instead of mptcp_lib_kill_wait ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3337,19 +3337,20 @@ endpoint_tests()
 
 	if reset_with_tcp_filter "delete and re-add" ns2 10.0.3.2 REJECT OUTPUT &&
 	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
-		pm_nl_set_limits $ns1 0 2
-		pm_nl_set_limits $ns2 0 2
+		pm_nl_set_limits $ns1 0 3
+		pm_nl_set_limits $ns2 0 3
+		pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
 		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
 
 		wait_mpj $ns2
 		pm_nl_del_endpoint $ns2 2 10.0.2.2
 		sleep 0.5
-		chk_subflow_nr needtitle "after delete" 1
+		chk_subflow_nr needtitle "after delete id 2" 1
 
 		pm_nl_add_endpoint $ns2 10.0.2.2 id 2 dev ns2eth2 flags subflow
 		wait_mpj $ns2
-		chk_subflow_nr "" "after re-add" 2
+		chk_subflow_nr "" "after re-add id 2" 2
 
 		pm_nl_add_endpoint $ns2 10.0.3.2 id 3 flags subflow
 		wait_attempt_fail $ns2
@@ -3361,10 +3362,18 @@ endpoint_tests()
 		wait_mpj $ns2
 		chk_subflow_nr "" "after no reject" 3
 
+		pm_nl_del_endpoint $ns2 1 10.0.1.2
+		sleep 0.5
+		chk_subflow_nr "" "after delete id 0" 2
+
+		pm_nl_add_endpoint $ns2 10.0.1.2 id 1 dev ns2eth1 flags subflow
+		wait_mpj $ns2
+		chk_subflow_nr "" "after re-add id 0" 3
+
 		kill_tests_wait
 
-		chk_join_nr 3 3 3
-		chk_rm_nr 1 1
+		chk_join_nr 4 4 4
+		chk_rm_nr 2 2
 	fi
 }
 


