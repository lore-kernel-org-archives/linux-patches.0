Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD54FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 16:50:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103B4C433D2;
	Mon, 15 May 2023 16:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684169457;
	bh=iALokWUToq9WeD4fWT5UrORsdnnD5rePhwj5lcidu+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mLThKr5OFBETm/9gnyyYGO7uhYzJ5TAqurYmvKngIrvVGcHXpZfORdjondBJsNvLJ
	 T6Ave6Dp/ITqBVhjrAnZlivX3o2tNwWmXf/MUfZ8zS6kPMPRGFLat31uydcEdzVzFw
	 h8950VDY0sJc2WK+U/XGnDDhg5kj31/yJpwINKw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Engelhardt <jengelh@inai.de>,
	Jeremy Sowden <jeremy@azazel.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 064/246] selftests: netfilter: fix libmnl pkg-config usage
Date: Mon, 15 May 2023 18:24:36 +0200
Message-Id: <20230515161724.499696446@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jeremy Sowden <jeremy@azazel.net>

[ Upstream commit de4773f0235acf74554f6a64ea60adc0d7b01895 ]

1. Don't hard-code pkg-config
2. Remove distro-specific default for CFLAGS
3. Use pkg-config for LDLIBS

Fixes: a50a88f026fb ("selftests: netfilter: fix a build error on openSUSE")
Suggested-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/netfilter/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/Makefile b/tools/testing/selftests/netfilter/Makefile
index 4504ee07be08d..3686bfa6c58d7 100644
--- a/tools/testing/selftests/netfilter/Makefile
+++ b/tools/testing/selftests/netfilter/Makefile
@@ -8,8 +8,11 @@ TEST_PROGS := nft_trans_stress.sh nft_fib.sh nft_nat.sh bridge_brouter.sh \
 	ipip-conntrack-mtu.sh conntrack_tcp_unreplied.sh \
 	conntrack_vrf.sh nft_synproxy.sh rpath.sh
 
-CFLAGS += $(shell pkg-config --cflags libmnl 2>/dev/null || echo "-I/usr/include/libmnl")
-LDLIBS = -lmnl
+HOSTPKG_CONFIG := pkg-config
+
+CFLAGS += $(shell $(HOSTPKG_CONFIG) --cflags libmnl 2>/dev/null)
+LDLIBS += $(shell $(HOSTPKG_CONFIG) --libs libmnl 2>/dev/null || echo -lmnl)
+
 TEST_GEN_FILES =  nf-queue connect_close
 
 include ../lib.mk
-- 
2.39.2



