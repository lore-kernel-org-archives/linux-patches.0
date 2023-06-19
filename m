Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FA28C06
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83020C433C8;
	Mon, 19 Jun 2023 10:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171800;
	bh=st9s7eaSd1f32g4PxDRxrIgd5GWNyJHZCigDb4hdYYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzCjb19U8lhXMU8ptphF/tSRBSQdD592cYemsGYbIH8aP0MMt20a+j4uLwA4wcAWz
	 eqZmomFb0f3/5VvGmr0GsJ6T6h2FQ0tNvVYniwc9oDbOQ2JApiTvqwgqJ66Y0cKVRJ
	 AW9xMhC98f6KYZx5dtaFFFDUzIDU9Zrtg4rNiiOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 137/166] selftests/tc-testing: Fix Error: failed to find target LOG
Date: Mon, 19 Jun 2023 12:30:14 +0200
Message-ID: <20230619102201.418583314@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit b849c566ee9c6ed78288a522278dcaf419f8e239 ]

Add missing netfilter config dependency.

Fixes following example error when running tests via tdc.sh for all XT
tests:

 # $ sudo ./tdc.py -d eth2 -e 2029
 # Test 2029: Add xt action with log-prefix
 # exit: 255
 # exit: 0
 #  failed to find target LOG
 #
 # bad action parsing
 # parse_action: bad value (7:xt)!
 # Illegal "action"
 #
 # -----> teardown stage *** Could not execute: "$TC actions flush action xt"
 #
 # -----> teardown stage *** Error message: "Error: Cannot flush unknown TC action.
 # We have an error flushing
 # "
 # returncode 1; expected [0]
 #
 # -----> teardown stage *** Aborting test run.
 #
 # <_io.BufferedReader name=3> *** stdout ***
 #
 # <_io.BufferedReader name=5> *** stderr ***
 # "-----> teardown stage" did not complete successfully
 # Exception <class '__main__.PluginMgrTestFail'> ('teardown', ' failed to find target LOG\n\nbad action parsing\nparse_action: bad value (7:xt)!\nIllegal "action"\n', '"-----> teardown stage" did not complete successfully') (caught in test_runner, running test 2 2029 Add xt action with log-prefix stage teardown)
 # ---------------
 # traceback
 #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 495, in test_runner
 #     res = run_one_test(pm, args, index, tidx)
 #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 434, in run_one_test
 #     prepare_env(args, pm, 'teardown', '-----> teardown stage', tidx['teardown'], procout)
 #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 245, in prepare_env
 #     raise PluginMgrTestFail(
 # ---------------
 # accumulated output for this test:
 #  failed to find target LOG
 #
 # bad action parsing
 # parse_action: bad value (7:xt)!
 # Illegal "action"
 #
 # ---------------
 #
 # All test results:
 #
 # 1..1
 # ok 1 2029 - Add xt action with log-prefix # skipped - "-----> teardown stage" did not complete successfully

Fixes: 910d504bc187 ("selftests/tc-testings: add selftests for xt action")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/tc-testing/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/tc-testing/config b/tools/testing/selftests/tc-testing/config
index 4638c63a339ff..aec4de8bea78b 100644
--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -6,6 +6,7 @@ CONFIG_NF_CONNTRACK_MARK=y
 CONFIG_NF_CONNTRACK_ZONES=y
 CONFIG_NF_CONNTRACK_LABELS=y
 CONFIG_NF_NAT=m
+CONFIG_NETFILTER_XT_TARGET_LOG=m
 
 CONFIG_NET_SCHED=y
 
-- 
2.39.2



