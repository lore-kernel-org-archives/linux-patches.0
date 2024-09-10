Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2741E18FDA9;
	Tue, 10 Sep 2024 10:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963092; cv=none; b=snUZZ6x1Ucv8UJLv2xqOP+vUWmPB+KtlrmG9n+iqnD/0wuVduSbo5BLdfkoXtWD3MjsHhgh2usvKiI1AQVEpP8GAfxjkUTTsq01ssXd0sYgHeauQY4S5iR9oyWhPJwOX/wKt8agHgg7TciN2g2Kh4jtA0GL4+xsm02VaPq13QSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963092; c=relaxed/simple;
	bh=BEBgkgA052Y3MXx63jEY0sWtM3/MfewRy3IOaj6ay2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GArr8gSjQ5F9jSdBi//KiioCjHeXkyBsfikztRvmXmjV/DXtsTlaoPtNWcwEZZslCy6xog6WDfCrjC9HFCnUyeKnvppWZMnp9SKi/MR7nMTG1DD0Z8s2Mbm9QuRqcHoYXUo9RvY3j0jJfHTwNU67vjEVnNUUGXxDm757S36o+Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZnDlkUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZnDlkUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0D9BC4CECF;
	Tue, 10 Sep 2024 10:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963092;
	bh=BEBgkgA052Y3MXx63jEY0sWtM3/MfewRy3IOaj6ay2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZnDlkUE+MRzMF4L5Ii1FBOSIabi3Va/52LkTMp9LHYGdLf1M5Cr9YAm/rYT4kOsn
	 z7/B/FrXgqY1WjII7phfIuh8Wyjq6J2HKvNMbZF0Ujcolflmf2tXyVT+088in1OjCM
	 JFxUXLc9/2aFItuYGziiOKwxVTuDKMsSJ+QeMWlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 132/192] selftests: mptcp: join: check re-re-adding ID 0 signal
Date: Tue, 10 Sep 2024 11:32:36 +0200
Message-ID: <20240910092603.454720077@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

commit f18fa2abf81099d822d842a107f8c9889c86043c upstream.

This test extends "delete re-add signal" to validate the previous
commit: when the 'signal' endpoint linked to the initial subflow (ID 0)
is re-added multiple times, it will re-send the ADD_ADDR with id 0. The
client should still be able to re-create this subflow, even if the
add_addr_accepted limit has been reached as this special address is not
considered as a new address.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: d0876b2284cf ("mptcp: add the incoming RM_ADDR support")
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
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   32 +++++++++++++++---------
 1 file changed, 20 insertions(+), 12 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3387,7 +3387,7 @@ endpoint_tests()
 		# broadcast IP: no packet for this address will be received on ns1
 		pm_nl_add_endpoint $ns1 224.0.0.1 id 2 flags signal
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 42 flags signal
-		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_5 2>/dev/null &
 		local tests_pid=$!
 
 		wait_mpj $ns2
@@ -3409,7 +3409,15 @@ endpoint_tests()
 
 		pm_nl_add_endpoint $ns1 10.0.1.1 id 99 flags signal
 		wait_mpj $ns2
-		chk_subflow_nr "" "after re-add" 3
+		chk_subflow_nr "" "after re-add ID 0" 3
+
+		pm_nl_del_endpoint $ns1 99 10.0.1.1
+		sleep 0.5
+		chk_subflow_nr "" "after re-delete ID 0" 2
+
+		pm_nl_add_endpoint $ns1 10.0.1.1 id 88 flags signal
+		wait_mpj $ns2
+		chk_subflow_nr "" "after re-re-add ID 0" 3
 
 		kill_wait "${tests_pid}"
 		kill_events_pids
@@ -3419,19 +3427,19 @@ endpoint_tests()
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_ESTABLISHED 1
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_ANNOUNCED 0
 		chk_evt_nr ns1 MPTCP_LIB_EVENT_REMOVED 0
-		chk_evt_nr ns1 MPTCP_LIB_EVENT_SUB_ESTABLISHED 4
-		chk_evt_nr ns1 MPTCP_LIB_EVENT_SUB_CLOSED 2
+		chk_evt_nr ns1 MPTCP_LIB_EVENT_SUB_ESTABLISHED 5
+		chk_evt_nr ns1 MPTCP_LIB_EVENT_SUB_CLOSED 3
 
 		chk_evt_nr ns2 MPTCP_LIB_EVENT_CREATED 1
 		chk_evt_nr ns2 MPTCP_LIB_EVENT_ESTABLISHED 1
-		chk_evt_nr ns2 MPTCP_LIB_EVENT_ANNOUNCED 5
-		chk_evt_nr ns2 MPTCP_LIB_EVENT_REMOVED 3
-		chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_ESTABLISHED 4
-		chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 2
-
-		chk_join_nr 4 4 4
-		chk_add_nr 5 5
-		chk_rm_nr 3 2 invert
+		chk_evt_nr ns2 MPTCP_LIB_EVENT_ANNOUNCED 6
+		chk_evt_nr ns2 MPTCP_LIB_EVENT_REMOVED 4
+		chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_ESTABLISHED 5
+		chk_evt_nr ns2 MPTCP_LIB_EVENT_SUB_CLOSED 3
+
+		chk_join_nr 5 5 5
+		chk_add_nr 6 6
+		chk_rm_nr 4 3 invert
 	fi
 
 	# flush and re-add


