Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7543C8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC50C433C7;
	Sun, 16 Jul 2023 20:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539784;
	bh=C8PLL0Cav3DkvT7QU9xIFOFJBnW6+Faals+hiEkzQE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAqfgVEk8LJhokvtFn/OyiblPW2l9JSZvBvmr5/w/F7xZ0Z8A6d8pmvZpJ+Gao2Gj
	 N3DcWqcTg1tqHd1iHUCwr3V2fuABLX8WC+51ehA+torG9GNHj5Rax0utpuqR+31vDh
	 mrJ9BQB3AGapGs+xsnrjKavkXn85wc/kk4ltPhGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <simon.horman@corigine.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/591] selftests: rtnetlink: remove netdevsim device after ipsec offload test
Date: Sun, 16 Jul 2023 21:44:29 +0200
Message-ID: <20230716194927.240054938@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
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
index 275491be3da2f..cafd14b1ed2ab 100755
--- a/tools/testing/selftests/net/rtnetlink.sh
+++ b/tools/testing/selftests/net/rtnetlink.sh
@@ -835,6 +835,7 @@ EOF
 	fi
 
 	# clean up any leftovers
+	echo 0 > /sys/bus/netdevsim/del_device
 	$probed && rmmod netdevsim
 
 	if [ $ret -ne 0 ]; then
-- 
2.39.2



