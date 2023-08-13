Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3015E9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B71C433C8;
	Sun, 13 Aug 2023 21:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962098;
	bh=ZhmOy+oA0zwY24LVnKTPePFg8jyclD82HtXhJZ+DrgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WC9VKe0q2qkS9K6xO10dTT0+1ZSjzvDjzEQ8Lo20n00mGigT2dCgQ0nZXn3E+0x/7
	 zIBrSxXrOynnUDgcWnfDHyvrogN55671gzbpGE6WIuv3yzzvAhjLTTABtJ7rp/n9Jq
	 q577uQY7f50Eu0UTN4iOwL6gogH0Iqk2mxgmJLlM=
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
Subject: [PATCH 6.4 112/206] selftests: forwarding: ethtool_extended_state: Skip when using veth pairs
Date: Sun, 13 Aug 2023 23:18:02 +0200
Message-ID: <20230813211728.249178683@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
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

commit b3d9305e60d121dac20a77b6847c4cf14a4c0001 upstream.

Ethtool extended state cannot be tested with veth pairs, resulting in
failures:

 # ./ethtool_extended_state.sh
 TEST: Autoneg, No partner detected                                  [FAIL]
         Expected "Autoneg", got "Link detected: no"
 [...]

Fix by skipping the test when used with veth pairs.

Fixes: 7d10bcce98cd ("selftests: forwarding: Add tests for ethtool extended state")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/adc5e40d-d040-a65e-eb26-edf47dac5b02@alu.unizg.hr/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230808141503.4060661-9-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/ethtool_extended_state.sh |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh
+++ b/tools/testing/selftests/net/forwarding/ethtool_extended_state.sh
@@ -108,6 +108,8 @@ no_cable()
 	ip link set dev $swp3 down
 }
 
+skip_on_veth
+
 setup_prepare
 
 tests_run


