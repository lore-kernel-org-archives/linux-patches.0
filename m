Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC2913DB90;
	Tue, 27 Feb 2024 14:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042424; cv=none; b=bggc+qr6yWNibiY5r8Mg62eRJaBV+/vHyB3GvLUpjGZ5dHhMhtyGUtQ7nRkAa/gokvGmr7r+SVoCGVeRMgjYC3wrXAgzcXVujAmd3HIYyXW0YP8jsRdBsS77POzcpEWN3c3ZAjfTeL+W8qBTJ4ijayh/McbNTt5sDDUN6P/t2ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042424; c=relaxed/simple;
	bh=MhWjsJArCRMgJiDK0LphGXleqL8jfAMLrw7L/cw96VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UJDQ6RbcUoXi1YI1n2LKOQGUqvtzSGHFb448G25CZqodYbvjW6a93oDJnXAqPliXO6UxidVr5ws9uBqLYCTNdxVDIKCUA80DdSTJ+72JHCa/P/gTN/7+BF4dBL1wyXFwnZ8GX/jGodVROv7TrVY2jAfjt2jICbdB/g7q36Ya+Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJ99QfXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJ99QfXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18E7C433F1;
	Tue, 27 Feb 2024 14:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042424;
	bh=MhWjsJArCRMgJiDK0LphGXleqL8jfAMLrw7L/cw96VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJ99QfXK+rBvVMhVljiy/jsrZKEfi56LMr6nNqbiRV3MyWKb8fXoqOl671i5gQW14
	 iR8fzuzogNJ+WA9IRoONuXPQyjdYtJzOJE9NgvvJCmgbMrEHg41I0uv/Nn6n1a2AZS
	 izO7+r7x39RitztyJYggaS/+dNHxM5yYCGUdYgtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Geliang Tang <geliang@kernel.org>
Subject: [PATCH 6.6 291/299] selftests: mptcp: join: stop transfer when check is done (part 1)
Date: Tue, 27 Feb 2024 14:26:42 +0100
Message-ID: <20240227131635.033785067@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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
@@ -3430,7 +3430,7 @@ userspace_tests()
 		chk_rm_nr 1 1 invert
 		chk_mptcp_info subflows 0 subflows 0
 		kill_events_pids
-		wait $tests_pid
+		mptcp_lib_kill_wait $tests_pid
 	fi
 
 	# userspace pm create destroy subflow
@@ -3449,7 +3449,7 @@ userspace_tests()
 		chk_rm_nr 1 1
 		chk_mptcp_info subflows 0 subflows 0
 		kill_events_pids
-		wait $tests_pid
+		mptcp_lib_kill_wait $tests_pid
 	fi
 }
 


