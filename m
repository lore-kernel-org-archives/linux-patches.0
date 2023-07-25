Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF301D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FDCC433C7;
	Tue, 25 Jul 2023 11:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283267;
	bh=nZF5eHtWmCSAo1o00/9/b0UcRnKe+0CYWJFAVG3ukQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iIH8rsx4Bo6v2YJdE5MhNrDamqV0EUbe0ptx71IXxTBt6kx33ne81F7OScqvqwQRT
	 cBWk8fTslURE48L5cfoENkhqaLeyn+9hZHRVmg6WGx97yOkIzRI2Nm2IjVRG+ZWByH
	 tgPh9xCS53AsIqPjr888qtqhkV3XjF5Hg0GftiDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 15/78] selftests: tc: add ConnTrack procfs kconfig
Date: Tue, 25 Jul 2023 12:46:06 +0200
Message-ID: <20230725104451.935988951@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
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

commit 031c99e71fedcce93b6785d38b7d287bf59e3952 upstream.

When looking at the TC selftest reports, I noticed one test was failing
because /proc/net/nf_conntrack was not available.

  not ok 373 3992 - Add ct action triggering DNAT tuple conflict
  	Could not match regex pattern. Verify command output:
  cat: /proc/net/nf_conntrack: No such file or directory

It is only available if NF_CONNTRACK_PROCFS kconfig is set. So the issue
can be fixed simply by adding it to the list of required kconfig.

Fixes: e46905641316 ("tc-testing: add test for ct DNAT tuple collision")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/netdev/0e061d4a-9a23-9f58-3b35-d8919de332d7@tessares.net/T/ [1]
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20230713-tc-selftests-lkft-v1-3-1eb4fd3a96e7@tessares.net
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/tc-testing/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/tc-testing/config
+++ b/tools/testing/selftests/tc-testing/config
@@ -5,6 +5,7 @@ CONFIG_NF_CONNTRACK=m
 CONFIG_NF_CONNTRACK_MARK=y
 CONFIG_NF_CONNTRACK_ZONES=y
 CONFIG_NF_CONNTRACK_LABELS=y
+CONFIG_NF_CONNTRACK_PROCFS=y
 CONFIG_NF_FLOW_TABLE=m
 CONFIG_NF_NAT=m
 


