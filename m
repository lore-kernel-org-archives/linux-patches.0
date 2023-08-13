Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA5E9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C90EC433C7;
	Sun, 13 Aug 2023 21:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962576;
	bh=4olqZJdtoncaEXqoC4l5R9b0axxxsrnGBplQ1UNfpLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7bGrK+NCz8hyuolfwN/Nn/2xpBXYJNoowbO7uI1mDEWZlfa4Pmx/lgC36gzO54He
	 xfKV0KupGoX2AHKtvZD60uDsor7gd/AMpM/aOSjKEWyiBVyebVRNYVUwyk/CqnZ98N
	 e3Za3SommUyvSOGTUVlz/vFgIAhaSeT+xOF5/ZZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 079/149] selftests: forwarding: hw_stats_l3_gre: Skip when using veth pairs
Date: Sun, 13 Aug 2023 23:18:44 +0200
Message-ID: <20230813211721.160262640@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ido Schimmel <idosch@nvidia.com>

commit 9a711cde07c245a163d95eee5b42ed1871e73236 upstream.

Layer 3 hardware stats cannot be used when the underlying interfaces are
veth pairs, resulting in failures:

 # ./hw_stats_l3_gre.sh
 TEST: ping gre flat                                                 [ OK ]
 TEST: Test rx packets:                                              [FAIL]
         Traffic not reflected in the counter: 0 -> 0
 TEST: Test tx packets:                                              [FAIL]
         Traffic not reflected in the counter: 0 -> 0

Fix by skipping the test when used with veth pairs.

Fixes: 813f97a26860 ("selftests: forwarding: Add a tunnel-based test for L3 HW stats")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/adc5e40d-d040-a65e-eb26-edf47dac5b02@alu.unizg.hr/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230808141503.4060661-10-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/hw_stats_l3_gre.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/net/forwarding/hw_stats_l3_gre.sh
+++ b/tools/testing/selftests/net/forwarding/hw_stats_l3_gre.sh
@@ -99,6 +99,8 @@ test_stats_rx()
 	test_stats g2a rx
 }
 
+skip_on_veth
+
 trap cleanup EXIT
 
 setup_prepare


