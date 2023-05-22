Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC69171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3ACC4339B;
	Mon, 22 May 2023 19:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785112;
	bh=jjV+KCVi+vVsQ9e6G29qaHadYSqH5V2oSSXsT42SAt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BMsDAtH+LJLxtTvHwcOgfU5ijJ8fRr1XfJUl9zinOv6gAwGpPSPb7RyWiL5we0pDs
	 R7V832WN6DJE5tCAhyuwmFfe+pDAqaWG40HjI9AkSJwT/G1axqHgLUBraAlkmVJXJt
	 weFC1Az52GtGCCBDqbixjhB5h+572SKbAxiQG99Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 285/364] net: selftests: Fix optstring
Date: Mon, 22 May 2023 20:09:50 +0100
Message-Id: <20230522190419.868537293@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit 9ba9485b87ac97fd159abdb4cbd53099bc9f01c6 ]

The cited commit added a stray colon to the 'v' option. That makes the
option work incorrectly.

ex:
tools/testing/selftests/net# ./fib_nexthops.sh -v
(should enable verbose mode, instead it shows help text due to missing arg)

Fixes: 5feba4727395 ("selftests: fib_nexthops: Make ping timeout configurable")
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fib_nexthops.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index a47b26ab48f23..0f5e88c8f4ffe 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -2283,7 +2283,7 @@ EOF
 ################################################################################
 # main
 
-while getopts :t:pP46hv:w: o
+while getopts :t:pP46hvw: o
 do
 	case $o in
 		t) TESTS=$OPTARG;;
-- 
2.39.2



