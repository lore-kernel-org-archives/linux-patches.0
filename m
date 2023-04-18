Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA2F2572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D861C433EF;
	Tue, 18 Apr 2023 12:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822309;
	bh=/ikK3zxhLCGeODiyNWRWcTeAwaBULc8sOuXpWUqiKm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xj6B/uTcFuMiNt+MM8u7ccV5GLWJevI0sjsWk9140Sbr2f49IGBQPH9Tc1WjpIdI3
	 nC7G6NeS7OM2HcZIpYeMrmajeoucK2/TmkBUsUUqAaI7saZSXQ2yJmPJtHyucU1roO
	 6Tqxar9D2CwbFaixCVlYuArWrcg+W42OMOk4on+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Xin Long <lucien.xin@gmail.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 072/139] selftests: add the missing CONFIG_IP_SCTP in net config
Date: Tue, 18 Apr 2023 14:22:17 +0200
Message-Id: <20230418120316.527733460@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 3a0385be133e7091cc9a9a998c7ec712bb9585db ]

The selftest sctp_vrf needs CONFIG_IP_SCTP set in config
when building the kernel, so add it.

Fixes: a61bd7b9fef3 ("selftests: add a selftest for sctp vrf")
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Link: https://lore.kernel.org/r/61dddebc4d2dd98fe7fb145e24d4b2430e42b572.1681312386.git.lucien.xin@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index bd89198cd8176..84833cb491998 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -45,3 +45,4 @@ CONFIG_BAREUDP=m
 CONFIG_IPV6_IOAM6_LWTUNNEL=y
 CONFIG_CRYPTO_SM4_GENERIC=y
 CONFIG_AMT=m
+CONFIG_IP_SCTP=m
-- 
2.39.2



