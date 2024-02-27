Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E51613B293;
	Tue, 27 Feb 2024 13:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041116; cv=none; b=edXOWfntx7oso4CwX/xHQKEj/bIsYIPHaxrYFY1dvrEKhU/pQZFbABwcjyMLdBXyvSAunOnOpHppADzl2co7nDjuZPjDBABcVzayVtzaAb042RAgd5jSROn4fsEMBQt6HeGAdE76F/MtQZ+3H6ZHG8UjNfMHIMbhp3mzs9PX3Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041116; c=relaxed/simple;
	bh=78zjQTd6I/JjfX6HXIwC45SumLmvleFmMRaOsX7SBIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhxLplQWS1EqqkdjyoQj3gf6StVrCUzhcDviv0KQEyj7MTXdhJmUsuKHXYRm9ANCJ9YL9x+4696yZvK8/k1T7K3HY08kjF9OvToEg6DZSD8BfJDXjvopgZduMmggppVf9eT0vmbuZTpTSxwNupCgHhAdGmjovpwNtls7I5BuwRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBJTAqIc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBJTAqIc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A72C433C7;
	Tue, 27 Feb 2024 13:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041115;
	bh=78zjQTd6I/JjfX6HXIwC45SumLmvleFmMRaOsX7SBIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EBJTAqIc/TTAqJQwjz7XG5T5y6pc66epH6gIVS9PFXcGSln7jNSYfSKPRswANABom
	 5uA9ow8FEXIXHLjlbti/nQcreyj7Dl9IPrZWr0AHmCdOhTBddVJUnCodFBLSvJtJlY
	 7Gwm/U0t/pgXg/TjLBceaTae2CcB0cL+pPhDW/sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 226/334] selftests: mptcp: diag: unique cestab subtest names
Date: Tue, 27 Feb 2024 14:21:24 +0100
Message-ID: <20240227131638.084775166@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 4103d8480866fe5abb71ef0ed8af3a3b7b9625bf upstream.

It is important to have a unique (sub)test name in TAP, because some CI
environments drop tests with duplicated name.

Some 'cestab' subtests from the diag selftest had the same names, e.g.:

    ....chk 0 cestab

Now the previous value is taken, to have different names, e.g.:

    ....chk 2->0 cestab after flush

While at it, the 'after flush' info is added, similar to what is done
with the 'in use' subtests. Also inspired by these 'in use' subtests,
'many' is displayed instead of a large number:

    many msk socket present                           [  ok  ]
    ....chk many msk in use                           [  ok  ]
    ....chk many cestab                               [  ok  ]
    ....chk many->0 msk in use after flush            [  ok  ]
    ....chk many->0 cestab after flush                [  ok  ]

Fixes: 81ab772819da ("selftests: mptcp: diag: check CURRESTAB counters")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/diag.sh |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -206,10 +206,15 @@ wait_local_port_listen()
 # $1: cestab nr
 chk_msk_cestab()
 {
-	local cestab=$1
+	local expected=$1
+	local msg="....chk ${2:-${expected}} cestab"
+
+	if [ "${expected}" -eq 0 ]; then
+		msg+=" after flush"
+	fi
 
 	__chk_nr "mptcp_lib_get_counter ${ns} MPTcpExtMPCurrEstab" \
-		 "${cestab}" "....chk ${cestab} cestab" ""
+		 "${expected}" "${msg}" ""
 }
 
 wait_connected()
@@ -253,7 +258,7 @@ chk_msk_cestab 2
 flush_pids
 
 chk_msk_inuse 0 "2->0"
-chk_msk_cestab 0
+chk_msk_cestab 0 "2->0"
 
 echo "a" | \
 	timeout ${timeout_test} \
@@ -273,7 +278,7 @@ chk_msk_cestab 1
 flush_pids
 
 chk_msk_inuse 0 "1->0"
-chk_msk_cestab 0
+chk_msk_cestab 0 "1->0"
 
 NR_CLIENTS=100
 for I in `seq 1 $NR_CLIENTS`; do
@@ -295,11 +300,11 @@ done
 
 wait_msk_nr $((NR_CLIENTS*2)) "many msk socket present"
 chk_msk_inuse $((NR_CLIENTS*2)) "many"
-chk_msk_cestab $((NR_CLIENTS*2))
+chk_msk_cestab $((NR_CLIENTS*2)) "many"
 flush_pids
 
 chk_msk_inuse 0 "many->0"
-chk_msk_cestab 0
+chk_msk_cestab 0 "many->0"
 
 mptcp_lib_result_print_all_tap
 exit $ret


