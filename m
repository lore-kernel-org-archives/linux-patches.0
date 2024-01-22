Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24556133992;
	Tue, 23 Jan 2024 00:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969293; cv=none; b=nZFfgMtG/zqxX2ngzGs7wQ8GwZ8wdv5EFeNAB6woepljKNqvlYu9A7wAwe3zbWwnNSGK7Ia6aYGYcE2z1oolIA9osoS+46FDqFdebz1tcgSPO7gBLsRtYCh50/0oPGgCGaE5CrlsNK6VZne55MMwwC6uXfkYYs1LIACvSolmzGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969293; c=relaxed/simple;
	bh=eYqyXwIvdgNiRuHN8o45Fqveur/VYlAKWixZkyKuAEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIGM1UnNMbyVHsyKf+cs/gTHSaK3Zst7LkiM72jeKWFJNaIYs79h8xwmZCA9D23nin22f6n6mARKN8am+Na/MUUhN3ce8we2omy2+1BFL23c7LWngZcwkW1p96bkys3Z5RE1RwZsIAZuUjTuzy/J20R3hCdopcdEqv0B132Tyk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRCEo2Br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRCEo2Br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE17DC433C7;
	Tue, 23 Jan 2024 00:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969293;
	bh=eYqyXwIvdgNiRuHN8o45Fqveur/VYlAKWixZkyKuAEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRCEo2Brct/64nbySrrOpqDlTdeal31vB+f/COBtPt9++NsgaRbZm13GE+J+92aN2
	 rMt9+9uQi5q2Penh7vtigCl/rn+eCqYN2bzSfQbcZjKTz9r0NUK8zKYuvByXFd3Nah
	 TAxrOsZvamaKgVi7IuFkfma2XsywR4Vs5Ync49FY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 133/641] selftests/net: specify the interface when do arping
Date: Mon, 22 Jan 2024 15:50:37 -0800
Message-ID: <20240122235822.215869901@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 7f770d28f2e5abfd442ad689ba1129dd66593529 ]

When do arping, the interface need to be specified. Or we will
get error: Interface "lo" is not ARPable. And the test failed.
]# ./arp_ndisc_untracked_subnets.sh
    TEST: test_arp:  accept_arp=0                                       [ OK ]
    TEST: test_arp:  accept_arp=1                                       [FAIL]
    TEST: test_arp:  accept_arp=2  same_subnet=0                        [ OK ]
    TEST: test_arp:  accept_arp=2  same_subnet=1                        [FAIL]

After fix:
]# ./arp_ndisc_untracked_subnets.sh
    TEST: test_arp:  accept_arp=0                                       [ OK ]
    TEST: test_arp:  accept_arp=1                                       [ OK ]
    TEST: test_arp:  accept_arp=2  same_subnet=0                        [ OK ]
    TEST: test_arp:  accept_arp=2  same_subnet=1                        [ OK ]

Fixes: 0ea7b0a454ca ("selftests: net: arp_ndisc_untracked_subnets: test for arp_accept and accept_untracked_na")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh b/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
index c899b446acb6..327427ec10f5 100755
--- a/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
+++ b/tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh
@@ -150,7 +150,7 @@ arp_test_gratuitous() {
 	fi
 	# Supply arp_accept option to set up which sets it in sysctl
 	setup ${arp_accept}
-	ip netns exec ${HOST_NS} arping -A -U ${HOST_ADDR} -c1 2>&1 >/dev/null
+	ip netns exec ${HOST_NS} arping -A -I ${HOST_INTF} -U ${HOST_ADDR} -c1 2>&1 >/dev/null
 
 	if verify_arp $1 $2; then
 		printf "    TEST: %-60s  [ OK ]\n" "${test_msg[*]}"
-- 
2.43.0



