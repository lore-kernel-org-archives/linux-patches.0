Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9810D9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18697C433C7;
	Sun, 13 Aug 2023 21:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962869;
	bh=hwEnLo2tP0fO46fvhCBenOu25yC4/esmOUwiZ6XLvwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAiQdchXlqeUCJ3uoWXq1ihninaPnIrUVLKsADs8fvCWKBgQWo0Rev/IJzC03qKa6
	 Ggj8wLz87ZrqX1JAQwhHOiYmmdVhvKDSiMu05FmEuG0R2fOqRUPi3QxCdpX5gVSpSW
	 l31heBe93t0hKLgrY4Bt21zbqRCQnaPTkMQfxrCQ=
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
Subject: [PATCH 5.10 37/68] selftests: forwarding: Switch off timeout
Date: Sun, 13 Aug 2023 23:19:38 +0200
Message-ID: <20230813211709.286509231@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
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

commit 0529883ad102f6c04e19fb7018f31e1bda575bbe upstream.

The default timeout for selftests is 45 seconds, but it is not enough
for forwarding selftests which can takes minutes to finish depending on
the number of tests cases:

 # make -C tools/testing/selftests TARGETS=net/forwarding run_tests
 TAP version 13
 1..102
 # timeout set to 45
 # selftests: net/forwarding: bridge_igmp.sh
 # TEST: IGMPv2 report 239.10.10.10                                    [ OK ]
 # TEST: IGMPv2 leave 239.10.10.10                                     [ OK ]
 # TEST: IGMPv3 report 239.10.10.10 is_include                         [ OK ]
 # TEST: IGMPv3 report 239.10.10.10 include -> allow                   [ OK ]
 #
 not ok 1 selftests: net/forwarding: bridge_igmp.sh # TIMEOUT 45 seconds

Fix by switching off the timeout and setting it to 0. A similar change
was done for BPF selftests in commit 6fc5916cc256 ("selftests: bpf:
Switch off timeout").

Fixes: 81573b18f26d ("selftests/net/forwarding: add Makefile to install tests")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/8d149f8c-818e-d141-a0ce-a6bae606bc22@alu.unizg.hr/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230808141503.4060661-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/settings |    1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/testing/selftests/net/forwarding/settings

--- /dev/null
+++ b/tools/testing/selftests/net/forwarding/settings
@@ -0,0 +1 @@
+timeout=0


