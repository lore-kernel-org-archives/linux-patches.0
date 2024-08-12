Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA273187335;
	Mon, 12 Aug 2024 16:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479003; cv=none; b=ZTYVOY3HOibSmX6L2khkX3Zncvap85EwaJlrpdZxh3T3F7lKi600zhENaTL6SzE0Io9Rdy9R1QJI5rXjEFH8ndHYhoaO5wRQISfgNP5jK9axZFz2e06t4kCLVFNt/+M7L6GeZVKjQz4s3OaB8Vddd9fIxLHjCQfE+MNNEePSyA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479003; c=relaxed/simple;
	bh=wxt2EUbAA/gt6mlxTDIH6aYB6ZwdlpIeDVzOBefforI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GveeGd5otrhO8gjnthrcHBeG3A8AESj4/N7ygLwiYgSGebHgezOD6LXnxuoVvQUC5UGzXJmxgCNOR7k/VoScJcZYx4S4FelYcpdFXHnzmUtoXRRRxhkVh6qwgCEWJ12v3M5pk5+fMgFF4uqkzCz+uLR9O0XMPkaqlY3xFNyNCQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gxu03H6c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gxu03H6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A36BC32782;
	Mon, 12 Aug 2024 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479002;
	bh=wxt2EUbAA/gt6mlxTDIH6aYB6ZwdlpIeDVzOBefforI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gxu03H6cxS928upAdfsgNKIYN1jVeVYLUPRB4tSpEeAAtaBdal98f1IOQRsfcNXLS
	 ixtWvCsGeCXBfYrK+j0bkq5jTLMsPdVKsLKhp45GfjrU89kRPn1vaOcXZYXQ3sEulB
	 xEYow7HhorPXiasIZAQnAhyJAxIgVWvo7MxTHVts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 103/150] torture: Enable clocksource watchdog with "tsc=watchdog"
Date: Mon, 12 Aug 2024 18:03:04 +0200
Message-ID: <20240812160129.135763136@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 877a0e83c57fa5e2a7fd628ec2e1733ed70c8792 ]

This commit tests the "tsc=watchdog" kernel boot parameter when running
the clocksourcewd torture tests.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Stable-dep-of: f2655ac2c06a ("clocksource: Fix brown-bag boolean thinko in cs_watchdog_read()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/rcutorture/bin/torture.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/rcutorture/bin/torture.sh b/tools/testing/selftests/rcutorture/bin/torture.sh
index d477618e7261d..91bca30e8587c 100755
--- a/tools/testing/selftests/rcutorture/bin/torture.sh
+++ b/tools/testing/selftests/rcutorture/bin/torture.sh
@@ -405,16 +405,16 @@ fi
 
 if test "$do_clocksourcewd" = "yes"
 then
-	torture_bootargs="rcupdate.rcu_cpu_stall_suppress_at_boot=1 torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000"
+	torture_bootargs="rcupdate.rcu_cpu_stall_suppress_at_boot=1 torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000 tsc=watchdog"
 	torture_set "clocksourcewd-1" tools/testing/selftests/rcutorture/bin/kvm.sh --allcpus --duration 45s --configs TREE03 --kconfig "CONFIG_TEST_CLOCKSOURCE_WATCHDOG=y" --trust-make
 
-	torture_bootargs="rcupdate.rcu_cpu_stall_suppress_at_boot=1 torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000 clocksource.max_cswd_read_retries=1"
+	torture_bootargs="rcupdate.rcu_cpu_stall_suppress_at_boot=1 torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000 clocksource.max_cswd_read_retries=1 tsc=watchdog"
 	torture_set "clocksourcewd-2" tools/testing/selftests/rcutorture/bin/kvm.sh --allcpus --duration 45s --configs TREE03 --kconfig "CONFIG_TEST_CLOCKSOURCE_WATCHDOG=y" --trust-make
 
 	# In case our work is already done...
 	if test "$do_rcutorture" != "yes"
 	then
-		torture_bootargs="rcupdate.rcu_cpu_stall_suppress_at_boot=1 torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000"
+		torture_bootargs="rcupdate.rcu_cpu_stall_suppress_at_boot=1 torture.disable_onoff_at_boot rcupdate.rcu_task_stall_timeout=30000 tsc=watchdog"
 		torture_set "clocksourcewd-3" tools/testing/selftests/rcutorture/bin/kvm.sh --allcpus --duration 45s --configs TREE03 --trust-make
 	fi
 fi
-- 
2.43.0



