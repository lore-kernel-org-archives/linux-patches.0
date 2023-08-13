Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C579443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:28:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C2BC433C7;
	Sun, 13 Aug 2023 21:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962122;
	bh=LJEqOoy/Sac427ChNWJowBXAlVtp6oGnDaQCF7GZgJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GriSVIqi9E+/ic2BlJbIfw6jZjdeEF7rp8zLa/2hQnYIuCjVOkoeYAFslKB2PDKf9
	 pFq2IcVcTYcnGmhRNYouRc6m2og5NNxw2N5DDykuYAaEKP7pV48lOOBTNzHK+Rz8Yp
	 3vMRrDfUWpUisDbAW2lkb0l23Y83IxJBvcBGtrVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Ido Schimmel <idosch@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.4 120/206] selftests: forwarding: bridge_mdb: Make test more robust
Date: Sun, 13 Aug 2023 23:18:10 +0200
Message-ID: <20230813211728.477522576@linuxfoundation.org>
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

commit 8b5ff37097775cdbd447442603957066dd2e4d02 upstream.

Some test cases check that the group timer is (or isn't) 0. Instead of
grepping for "0.00" grep for " 0.00" as the former can also match
"260.00" which is the default group membership interval.

Fixes: b6d00da08610 ("selftests: forwarding: Add bridge MDB test")
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Closes: https://lore.kernel.org/netdev/adc5e40d-d040-a65e-eb26-edf47dac5b02@alu.unizg.hr/
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://lore.kernel.org/r/20230808141503.4060661-18-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/forwarding/bridge_mdb.sh |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
+++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
@@ -617,7 +617,7 @@ __cfg_test_port_ip_sg()
 		grep -q "permanent"
 	check_err $? "Entry not added as \"permanent\" when should"
 	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q "0.00"
+		grep -q " 0.00"
 	check_err $? "\"permanent\" entry has a pending group timer"
 	bridge mdb del dev br0 port $swp1 $grp_key vid 10
 
@@ -626,7 +626,7 @@ __cfg_test_port_ip_sg()
 		grep -q "temp"
 	check_err $? "Entry not added as \"temp\" when should"
 	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q "0.00"
+		grep -q " 0.00"
 	check_fail $? "\"temp\" entry has an unpending group timer"
 	bridge mdb del dev br0 port $swp1 $grp_key vid 10
 
@@ -659,7 +659,7 @@ __cfg_test_port_ip_sg()
 		grep -q "permanent"
 	check_err $? "Entry not marked as \"permanent\" after replace"
 	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q "0.00"
+		grep -q " 0.00"
 	check_err $? "Entry has a pending group timer after replace"
 
 	bridge mdb replace dev br0 port $swp1 $grp_key vid 10 temp
@@ -667,7 +667,7 @@ __cfg_test_port_ip_sg()
 		grep -q "temp"
 	check_err $? "Entry not marked as \"temp\" after replace"
 	bridge -d -s mdb show dev br0 vid 10 | grep "$grp_key" | \
-		grep -q "0.00"
+		grep -q " 0.00"
 	check_fail $? "Entry has an unpending group timer after replace"
 	bridge mdb del dev br0 port $swp1 $grp_key vid 10
 


