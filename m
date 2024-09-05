Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14FA718D65E;
	Thu,  5 Sep 2024 09:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530042; cv=none; b=No6/6x1iOZJHWAfSyez+PBfwxHrJpTRCOJ80Xhm3MpusVSe/nQ8Yqr1lqGBJH25wSXnr3yHdcEgxPqDtz6a/y9m4t4Y0SUAZo/Y+4Ut2aq0L60DzSHc4Bitn9Yy86z44F5YuhHmHTbxpPE03UtVrygfUwCh2yQjsFE5S7vBzcv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530042; c=relaxed/simple;
	bh=xboHx9Ew2AlkoTIktClepw5l9bjghKlkE13prnFwxDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HDSbMiNb1l/DPvAtLEHqR5v9BOybSvVmK1Y4WhxDOgHnrgfSZEooImLxZXa1vh+OVy/xaizXT0moilurl63/c8wvA+1EjE0kcUN9LcHWRmwEg7/DKyU435YNv8e8QPw7AQoZC9WVRQFeN42PeEZNtJB37Fk9UKvP2NSd+0TmsDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqjpaqrT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqjpaqrT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D473C4CEC3;
	Thu,  5 Sep 2024 09:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530042;
	bh=xboHx9Ew2AlkoTIktClepw5l9bjghKlkE13prnFwxDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NqjpaqrTK7HQ+4ZPrfyl9Kb85wzdJIAJ8SvRijJfLLsgVQJ1WLUKaHIk9IPE6an7e
	 rL/tE929SxSutXYQP5V6pVjpenjfsvG7Jtx0tWVuPuZ/UEJ8Zwkn5jrTWerWmWKyuX
	 EmYw5PRD7a7bW6UI3k6fa81MFMHV+vrbhhqPf4Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Subject: [PATCH 6.6 037/132] selftests: mptcp: join: stop transfer when check is done (part 2.2)
Date: Thu,  5 Sep 2024 11:40:24 +0200
Message-ID: <20240905093723.686356074@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

Use mptcp_lib_kill_wait in "userspace pm create id 0 subflow" subtest.

This new test has recently been queued to v6.6 [1] with the backport of
commit b2e2248f365a ("selftests: mptcp: userspace pm create id 0
subflow").

The modification here was part of commit 04b57c9e096a ("selftests:
mptcp: join: stop transfer when check is done (part 2)") that has been
backported to v6.6 a few months ago -- see commit 358f02b84fbb
("selftests: mptcp: join: stop transfer when check is done (part 2)") --
but it was not modifying this subtest as it was not present in v6.6.

Link: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/commit/?id=bd2122541bd8 [1]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3678,7 +3678,7 @@ userspace_tests()
 		chk_mptcp_info subflows 1 subflows 1
 		chk_subflows_total 2 2
 		kill_events_pids
-		wait $tests_pid
+		mptcp_lib_kill_wait $tests_pid
 	fi
 }
 


