Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D38A1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A4FC433B8;
	Tue, 25 Jul 2023 11:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283255;
	bh=z7BFixCmGewQxSmWKaXu1g8Afbx1mNqQk4aDvzsM6GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFpkwX53ZTd+PhcoMehX42+GODUF7Aszp28Nynxtxph4M/PrVz2Skw/xM2oQbjAuw
	 HEXRJ3dr/Lc1xnbBQeIVbQLHIL1GsOnj1mPp6Av//BLHwctZzPAwuvj2MRtrwPRpS5
	 V21VBQTW7cMW0RsUOMHFJO4mVt2F3cXBYdH62kZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pedro Tammela <pctammela@mojatatu.com>,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 11/78] selftests: tc: add ct action kconfig dep
Date: Tue, 25 Jul 2023 12:46:02 +0200
Message-ID: <20230725104451.767895927@linuxfoundation.org>
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

commit 719b4774a8cb1a501e2d22a5a4a3a0a870e427d5 upstream.

When looking for something else in LKFT reports [1], I noticed most of
the tests were skipped because the "teardown stage" did not complete
successfully.

Pedro found out this is due to the fact CONFIG_NF_FLOW_TABLE is required
but not listed in the 'config' file. Adding it to the list fixes the
issues on LKFT side. CONFIG_NET_ACT_CT is now set to 'm' in the final
kconfig.

Fixes: c34b961a2492 ("net/sched: act_ct: Create nf flow table per zone")
Cc: stable@vger.kernel.org
Link: https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20230711/testrun/18267241/suite/kselftest-tc-testing/test/tc-testing_tdc_sh/log [1]
Link: https://lore.kernel.org/netdev/0e061d4a-9a23-9f58-3b35-d8919de332d7@tessares.net/T/ [2]
Suggested-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Tested-by: Zhengchao Shao <shaozhengchao@huawei.com>
Link: https://lore.kernel.org/r/20230713-tc-selftests-lkft-v1-2-1eb4fd3a96e7@tessares.net
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
+CONFIG_NF_FLOW_TABLE=m
 CONFIG_NF_NAT=m
 
 CONFIG_NET_SCHED=y


