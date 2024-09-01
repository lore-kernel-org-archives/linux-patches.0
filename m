Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCE0181B86;
	Sun,  1 Sep 2024 16:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209258; cv=none; b=Mpc4rmPGDiTn02PK8C6KYtZkTKFpW2QkIL4bonr9jwN+pmKDHELlbJjR6KxoY3i0EzZa37KcphXRjSexhwsMV2+Cy2z9y/6N7pP1xC1V9RM9u6IwR7EIiMTgtLuhXluq5+H6zUhGdZAWe7YnsDGz/+fXd1p57CEYLmgmdIaVZw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209258; c=relaxed/simple;
	bh=jA3D9qTQU0ZFimK2vgzObGJIQW9H1NCf8yolSFG1L94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0y/3CpmrLVI57cNhYZvICSu5Mc48Q/Yk1QgH8q5wBhaSsO7ngi2Rl7eH8ZH416LRgH/bhdDgnEFcCBjdE9CwdXn4CkK2GodA6tBV4EWb/dSKgSVAHLqe6gNkG0x8VmyngN+Wwn5QGo8YV+IgILyY7IR6k+ncQbgXqcECcdtMqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jm/ipePk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jm/ipePk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BF09C4CEC3;
	Sun,  1 Sep 2024 16:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209258;
	bh=jA3D9qTQU0ZFimK2vgzObGJIQW9H1NCf8yolSFG1L94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jm/ipePk0SVN3mJVMoQyrYSM3z5pbBGf5x57RcZUPB1k7lQBONq/2Tqh7hsfCx60n
	 ld6mvszcLNCmdbJI5N3ABRIn5vc2MXW9A38xRJv7eqO7Vl9Jw/94xtouGUQTLdyXHM
	 ZST1TTdDaU2+LXbz/H7QhWIFvsomljtPcN4+nVDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 49/71] selftests: forwarding: local_termination: Down ports on cleanup
Date: Sun,  1 Sep 2024 18:17:54 +0200
Message-ID: <20240901160803.741820831@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160801.879647959@linuxfoundation.org>
References: <20240901160801.879647959@linuxfoundation.org>
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

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 65a3cce43d5b4c53cf16b0be1a03991f665a0806 ]

This test neglects to put ports down on cleanup. Fix it.

Fixes: 90b9566aa5cd ("selftests: forwarding: add a test for local_termination.sh")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/bf9b79f45de378f88344d44550f0a5052b386199.1724692132.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/forwarding/local_termination.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/forwarding/local_termination.sh b/tools/testing/selftests/net/forwarding/local_termination.sh
index c5b0cbc85b3e0..9b5a63519b949 100755
--- a/tools/testing/selftests/net/forwarding/local_termination.sh
+++ b/tools/testing/selftests/net/forwarding/local_termination.sh
@@ -278,6 +278,10 @@ bridge()
 cleanup()
 {
 	pre_cleanup
+
+	ip link set $h2 down
+	ip link set $h1 down
+
 	vrf_cleanup
 }
 
-- 
2.43.0



