Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BAF217722;
	Fri, 17 Oct 2025 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716687; cv=none; b=oEy/mIPd8I7vnBqDCa4iQCP4apdwSvpiEHC01bWZYKLKgfU8DG6NPtPqNlQBqDfV61pFlX91/bLEQNt9oX9xCUW5LCBplT9JjuHDR2ykBHIVAooUE8vNyJpryzAtt+GFH4v8rW6RHAkDgQsLWVe1hrYPaCcuMWHDh/+aqM5CtXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716687; c=relaxed/simple;
	bh=pLwa3A1be5O/v8CttomnQHIFqovviGKCUgxNbMyNyc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo75v0CCdLIYhFdG2iORxy1ZKDONkWqZZU4yE70H1KK0mOa/d6gg85DGrOpPBGirH8u72VPWM43QSbyEfXxUFffFiFLavAL2muWHE/VWUJERinoCTquggA6xZtDge6ReCXAWrPAs5eKapprvjrVKOW5bwCT3uKP6hfQEyS9RiDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jLABbjCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jLABbjCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D152EC4CEE7;
	Fri, 17 Oct 2025 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716687;
	bh=pLwa3A1be5O/v8CttomnQHIFqovviGKCUgxNbMyNyc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jLABbjCde6ZBVsx5Qan7P/ukOBa0E8S/lFP0iCr4GIQDC6ce+j+r+xuAF1JYw6XGU
	 F53sHbDf8KX3wTDIQMz1oGPwDSf+ZuSTCk2l68u9kN7LqwMc75d/MbFnkgBBJx5WlX
	 B/yemz799zjm/ER+ZCF/GjfEjf077XAJyhr5Ez60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 276/276] selftests: mptcp: join: validate C-flag + def limit
Date: Fri, 17 Oct 2025 16:56:09 +0200
Message-ID: <20251017145152.567050935@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 008385efd05e04d8dff299382df2e8be0f91d8a0 upstream.

The previous commit adds an exception for the C-flag case. The
'mptcp_join.sh' selftest is extended to validate this case.

In this subtest, there is a typical CDN deployment with a client where
MPTCP endpoints have been 'automatically' configured:

- the server set net.mptcp.allow_join_initial_addr_port=0

- the client has multiple 'subflow' endpoints, and the default limits:
  not accepting ADD_ADDRs.

Without the parent patch, the client is not able to establish new
subflows using its 'subflow' endpoints. The parent commit fixes that.

The 'Fixes' tag here below is the same as the one from the previous
commit: this patch here is not fixing anything wrong in the selftests,
but it validates the previous fix for an issue introduced by this commit
ID.

Fixes: df377be38725 ("mptcp: add deny_join_id0 in mptcp_options_received")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250925-net-next-mptcp-c-flag-laminar-v1-2-ad126cc47c6b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in mptcp_join.sh, because many different helpers have been
  modified in newer kernel versions, e.g. in commit 03668c65d153
  ("selftests: mptcp: join: rework detailed report"), or commit
  985de45923e2 ("selftests: mptcp: centralize stats dumping"), etc.
  Adaptations have been made to use the old way, similar to what is done
  just above. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -1826,6 +1826,16 @@ deny_join_id0_tests()
 	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
 	run_tests $ns1 $ns2 10.0.1.1
 	chk_join_nr "subflow and address allow join id0 2" 1 1 1
+
+	# default limits, server deny join id 0 + signal
+	reset_with_allow_join_id0 0 1
+	ip netns exec $ns1 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns2 ./pm_nl_ctl limits 0 2
+	ip netns exec $ns1 ./pm_nl_ctl add 10.0.2.1 flags signal
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.3.2 flags subflow
+	ip netns exec $ns2 ./pm_nl_ctl add 10.0.4.2 flags subflow
+	run_tests $ns1 $ns2 10.0.1.1
+	chk_join_nr "default limits, server deny join id 0" 2 2 2
 }
 
 fullmesh_tests()


