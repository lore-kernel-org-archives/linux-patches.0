Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25C813AA2F;
	Tue, 27 Feb 2024 13:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041413; cv=none; b=Wyqtz71ynrSlirimplBFl/6olJElD/+OA2RCmkUXMN2DyAd8PWgiNLzuRSbrfYARqvoOR0u95JhSNJsinorSR328A5ibSV1TmgKpHFz9YpLMITGzNJUxkxIIgn4MvHosEZcOexF/ek7sSZzg8ctNOx0TrWQ+j4QHdYGHgDOWQVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041413; c=relaxed/simple;
	bh=wFLSbzoMpVWXM5IKcCLeEcLKpuNciAeALSX/z8hk66g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ldJEaoYlETC0Ze8NkXqEbibQweo3gUOjN/fajpXVUOZXRv7RyIxyGaoUCmvzzWEmluarQDBf+UPJx6sutrvZYcyx8CSzeGocMY5xP7kICX8c2sIRNLpvajx9QdNNqbq9V4MTKSvMXK1YXerWUm3Q5dr5AHJJLZq2Kd/EqiqsyS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDHISWnW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDHISWnW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C99C433F1;
	Tue, 27 Feb 2024 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041413;
	bh=wFLSbzoMpVWXM5IKcCLeEcLKpuNciAeALSX/z8hk66g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gDHISWnWs1sZrEGK57lArqiGwP+T0j9gciqzgtKL1ykjdSFwvatQfwUWR9z1xZOj1
	 kZEmvkZ+UBH2cUd3ZnSuJGjfOfn6UCdkJBNu8hcwy00MNfiOgtjXVmQDuagzqxMxoo
	 IljDyvZxiTUI0gZgr4voGqUEfJSUuY04m4CT/lWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Geliang Tang <geliang@kernel.org>
Subject: [PATCH 6.7 331/334] selftests: mptcp: join: stop transfer when check is done (part 1)
Date: Tue, 27 Feb 2024 14:23:09 +0100
Message-ID: <20240227131641.820199302@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 31ee4ad86afd6ed6f4bb1b38c43011216080c42a upstream.

Since the "Fixes" commit mentioned below, "userspace pm" subtests of
mptcp_join selftests introduced in v6.5 are launching the whole transfer
in the background, do the required checks, then wait for the end of
transfer.

There is no need to wait longer, especially because the checks at the
end of the transfer are ignored (which is fine). This saves quite a few
seconds in slow environments.

Note that old versions will need commit bdbef0a6ff10 ("selftests: mptcp:
add mptcp_lib_kill_wait") as well to get 'mptcp_lib_kill_wait()' helper.

Fixes: 4369c198e599 ("selftests: mptcp: test userspace pm out of transfer")
Cc: stable@vger.kernel.org # 6.5.x: bdbef0a6ff10: selftests: mptcp: add mptcp_lib_kill_wait
Cc: stable@vger.kernel.org # 6.5.x
Reviewed-and-tested-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240131-upstream-net-20240131-mptcp-ci-issues-v1-8-4c1c11e571ff@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3433,7 +3433,7 @@ userspace_tests()
 		chk_rm_nr 1 1 invert
 		chk_mptcp_info subflows 0 subflows 0
 		kill_events_pids
-		wait $tests_pid
+		mptcp_lib_kill_wait $tests_pid
 	fi
 
 	# userspace pm create destroy subflow
@@ -3452,7 +3452,7 @@ userspace_tests()
 		chk_rm_nr 1 1
 		chk_mptcp_info subflows 0 subflows 0
 		kill_events_pids
-		wait $tests_pid
+		mptcp_lib_kill_wait $tests_pid
 	fi
 }
 


