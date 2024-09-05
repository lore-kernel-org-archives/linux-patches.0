Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A905B83CDB;
	Thu,  5 Sep 2024 10:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530420; cv=none; b=HounLm2uolEp8KKHCM0ng2CxpCzeiV4sQzRMGffr84nxr23kJD+jM938ahcvjjpidChy/XRSkYzlyMNDhpM3AIbqatp2Z9UkMmnQ0bril1Xd3L5s/X9bq/8dh+IZI1CKBR6QC6bwAFMo7Cgnj2H9hofOmfZROzbPxmi9BTXMPvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530420; c=relaxed/simple;
	bh=kc6+13sybU3C+H/rtndVv8bJS0x/dLtcqhw4v/a2FFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+Rt48m5HluFGpNCoOQFG9NIjVvSAKKi9UFyU2q25AnXrQsNPNmbMIeVLVOSiqZ014uEaRdt/xTFxuWhRz18RYkZWoZHxWqCy4rrQKejniS4a+tZ7IUHW/aMV3rvULEdyVBn6FO1yiMed5k0n/Tram7T0cA9nSS4EN9z/igP9a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bvf6ppjJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bvf6ppjJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B903C4CEC3;
	Thu,  5 Sep 2024 10:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530420;
	bh=kc6+13sybU3C+H/rtndVv8bJS0x/dLtcqhw4v/a2FFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvf6ppjJnvCSpXz42RRrFf1bZ8HIYQHjRODUfvv6Ngb6S9dPUn3vVvRqK4JI7gSP8
	 jP7kQU+RTRzREYQflT5hxttQjvNWGdDDvQoRZkEmMNPRJKEBEflBXxpa5HWnXNz//U
	 gN8ieY4rxNRQMiBtZQhXXwkVClPARpV6jnQJ9N8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 019/101] selftests: mptcp: add explicit test case for remove/readd
Date: Thu,  5 Sep 2024 11:40:51 +0200
Message-ID: <20240905093716.865082384@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit b5e2fb832f48bc01d937a053e0550a1465a2f05d upstream.

Delete and re-create a signal endpoint and ensure that the PM
actually deletes and re-create the subflow.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: e06959e9eebd ("selftests: mptcp: join: test for flush/re-add endpoints")
[ No conflicts, but adapt the test to the helpers in this version:
  - run_tests has been modified a few times to reduce the number of
    positional parameters
  - no pm_nl_check_endpoint helper
  - no chk_mptcp_info helper
  - chk_subflow_nr taking an extra parameter
  - kill_tests_wait instead of mptcp_lib_kill_wait ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3239,6 +3239,29 @@ userspace_tests()
 		chk_join_nr 1 1 1
 		chk_rm_nr 1 1
 	fi
+
+	# remove and re-add
+	if reset "delete re-add signal" &&
+	   mptcp_lib_kallsyms_has "subflow_rebuild_header$"; then
+		pm_nl_set_limits $ns1 1 1
+		pm_nl_set_limits $ns2 1 1
+		pm_nl_add_endpoint $ns1 10.0.2.1 id 1 flags signal
+		run_tests $ns1 $ns2 10.0.1.1 4 0 0 speed_20 2>/dev/null &
+		local tests_pid=$!
+
+		wait_mpj $ns2
+		chk_subflow_nr needtitle "before delete" 2
+
+		pm_nl_del_endpoint $ns1 1 10.0.2.1
+		sleep 0.5
+		chk_subflow_nr "" "after delete" 1
+
+		pm_nl_add_endpoint $ns1 10.0.2.1 flags signal
+		wait_mpj $ns2
+		chk_subflow_nr "" "after re-add" 2
+		kill_tests_wait
+	fi
+
 }
 
 endpoint_tests()


