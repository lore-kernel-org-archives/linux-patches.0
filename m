Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006C0154BFF;
	Thu,  5 Sep 2024 09:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530004; cv=none; b=EF0xf8xBqvx1afhfMPMZq+D92WPdrlFXcryfUpZaPgzazkYN3u0VB1niYRXiKjb6CzJwN/NFOZ978USdiP+1+Ce7Uyqz0ZmFQv8CQLdzwWCR8EiN9p7mpL4Y1afGlMczjSB9EAYUl1Ei/iVHkPN/w2U3b+o7UWBdahLtXcXnb2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530004; c=relaxed/simple;
	bh=IPN5TZrNjJctU/PGb30fKR2SmjkYuFU4dxQC2c/AKn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CPjEXw+CehUKa8p/I+lnk9HrGLfk9yeHYV064KZ1sAW7I/vXUReH4mPRrR18ao6rZKzsa5HRAmgzyy93HH4YHF6Bc6aKCZyadaBpLrfiZhcDVGD4AYR1jBM18ZT3VWK7PuuJCVavWzfsLXdY4EVKSBszj+MJTZZ2Si8RfqSPXNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gCqdozVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gCqdozVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B064C4CEC3;
	Thu,  5 Sep 2024 09:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530003;
	bh=IPN5TZrNjJctU/PGb30fKR2SmjkYuFU4dxQC2c/AKn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gCqdozViaeKKp7QNVABapPMGgL47RjZTzTgT80w86c7ug+PjdL+xaYLOb+f41tUQ1
	 svJtjEoGzDz031prwJIGhgRYG+9Jym1hKFeU6+dv/m16dYoRWpS/vGJ+h/t3MrUk7S
	 +trPukGAde97lQtPLx0IKFMnS7fMj3Luoe5mha7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matttbe@kernel.org>,
	Geliang Tang <geliang.tang@suse.com>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/132] selftests: mptcp: userspace pm create id 0 subflow
Date: Thu,  5 Sep 2024 11:40:11 +0200
Message-ID: <20240905093723.176572434@linuxfoundation.org>
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

From: Geliang Tang <geliang.tang@suse.com>

[ Upstream commit b2e2248f365a7ef0687fe048c335fe1a32f98b36 ]

This patch adds a selftest to create id 0 subflow. Pass id 0 to the
helper userspace_pm_add_sf() to create id 0 subflow. chk_mptcp_info
shows one subflow but chk_subflows_total shows two subflows in each
namespace.

Reviewed-by: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Signed-off-by: Mat Martineau <martineau@kernel.org>
Link: https://lore.kernel.org/r/20231128-send-net-next-2023107-v4-5-8d6b94150f6b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e93681afcb96 ("selftests: mptcp: join: cannot rm sf if closed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/net/mptcp/mptcp_join.sh | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/tools/testing/selftests/net/mptcp/mptcp_join.sh b/tools/testing/selftests/net/mptcp/mptcp_join.sh
index 2be13dd19ddd2..d378f23bb31a6 100755
--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -3545,6 +3545,25 @@ userspace_tests()
 		kill_events_pids
 		mptcp_lib_kill_wait $tests_pid
 	fi
+
+	# userspace pm create id 0 subflow
+	if reset_with_events "userspace pm create id 0 subflow" &&
+	   continue_if mptcp_lib_has_file '/proc/sys/net/mptcp/pm_type'; then
+		set_userspace_pm $ns2
+		pm_nl_set_limits $ns1 0 1
+		speed=5 \
+			run_tests $ns1 $ns2 10.0.1.1 &
+		local tests_pid=$!
+		wait_mpj $ns2
+		chk_mptcp_info subflows 0 subflows 0
+		chk_subflows_total 1 1
+		userspace_pm_add_sf $ns2 10.0.3.2 0
+		chk_join_nr 1 1 1
+		chk_mptcp_info subflows 1 subflows 1
+		chk_subflows_total 2 2
+		kill_events_pids
+		wait $tests_pid
+	fi
 }
 
 endpoint_tests()
-- 
2.43.0



