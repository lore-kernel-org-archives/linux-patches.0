Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8739E1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 089A8C433C9;
	Tue, 25 Jul 2023 11:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285122;
	bh=TToWLbmurN6TPpsJ7EXIoQxnBuWhKrh0iNzgNqvxOHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OebqWhp3OXkhD9OWozhdJ+lN9SR3vQB0gnCc6riZ6vq4NeS9CUxCqjQvG+TyWh9NP
	 j/UQhEHwdsSH0VSEFhMi734l/Bc/knHevACMJtcZ4qxkKF4wGaFqVMgNqfuzbLi9UT
	 YKM6/GpGC7Z6gGmtQOpj3bIvoUf84/q2fZf4P374=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <simon.horman@corigine.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/313] selftests: rtnetlink: remove netdevsim device after ipsec offload test
Date: Tue, 25 Jul 2023 12:43:35 +0200
Message-ID: <20230725104523.708575192@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 5f789f103671fec3733ebe756e56adf15c90c21d ]

On systems where netdevsim is built-in or loaded before the test
starts, kci_test_ipsec_offload doesn't remove the netdevsim device it
created during the test.

Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev probe")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/e1cb94f4f82f4eca4a444feec4488a1323396357.1687466906.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/rtnetlink.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
index 911c549f186fb..3b929e031f59c 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -833,6 +833,7 @@ EOF
 	fi
 
 	# clean up any leftovers
+	echo 0 > /sys/bus/netdevsim/del_device
 	$probed && rmmod netdevsim
 
 	if [ $ret -ne 0 ]; then
-- 
2.39.2



