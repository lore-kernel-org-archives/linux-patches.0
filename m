Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847B614263
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:47:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DF0C433C8;
	Tue, 25 Jul 2023 11:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285648;
	bh=CivuM81LuSSuax7eVM6Io0zzAIXz5OxlVy1/77tzCv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFssWTur7NmgNAt2W0bnhGz7oqPdqnkf477tAwY6qcEtmYXMboMGqrk+zVyjtDcTG
	 QTB8XOMVmgl8vQ2vi+CK2xA6U/uy1/EsfAAN9ewvBbHZgiHwxEeVUpul6AqidVNvgn
	 eVTTpSQQF9c2BtTHVc8ugTONMf2d+yj3sd/N4oSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 279/313] selftests: tc: set timeout to 15 minutes
Date: Tue, 25 Jul 2023 12:47:12 +0200
Message-ID: <20230725104533.147578290@linuxfoundation.org>
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

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit fda05798c22a354efde09a76bdfc276b2d591829 upstream.

When looking for something else in LKFT reports [1], I noticed that the
TC selftest ended with a timeout error:

  not ok 1 selftests: tc-testing: tdc.sh # TIMEOUT 45 seconds

The timeout had been introduced 3 years ago, see the Fixes commit below.

This timeout is only in place when executing the selftests via the
kselftests runner scripts. I guess this is not what most TC devs are
using and nobody noticed the issue before.

The new timeout is set to 15 minutes as suggested by Pedro [2]. It looks
like it is plenty more time than what it takes in "normal" conditions.

Fixes: 852c8cbf34d3 ("selftests/kselftest/runner.sh: Add 45 second timeout per test")
Cc: stable@vger.kernel.org
Link: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230711/testrun/18267241/suite/kselftest-tc-testing/test/tc-testing_tdc_sh/log [1]
Link: https://lore.kernel.org/netdev/0e061d4a-9a23-9f58-3b35-d8919de332d7@tessares.net/T/ [2]
Suggested-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20230713-tc-selftests-lkft-v1-1-1eb4fd3a96e7@tessares.net
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/tc-testing/settings | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/tc-testing/settings

diff --git a/tools/testing/selftests/tc-testing/settings b/tools/testing/selftests/tc-testing/settings
new file mode 100644
index 000000000000..e2206265f67c
--- /dev/null
+++ b/tools/testing/selftests/tc-testing/settings
@@ -0,0 +1 @@
+timeout=900
-- 
2.41.0



