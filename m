Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B5E32FA18;
	Mon, 29 Dec 2025 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025064; cv=none; b=ZRNRKGJSrG/R5w78XZgt9i4T8fwUUuXtnUKiDmf6N3rcLR6Gaxft2hV4EQkBemWevTHM4Ra8JiSX3ZbhGCp7PSNuWFjUYic9+/uJDKTPeqkiwodKB1/lxIkPlvP/1Q900K9Sv0RwNHlju/gbrSdNysbG6fOSkvrYT+7a+6w3A+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025064; c=relaxed/simple;
	bh=nef9WbZxN2/NqgDIE3H5wtKqu2TkLr96OkjZ8x067vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G5rOTaT3VJalM/nvawiZVgPxJnFN9Hw+izbqlqDf7vNOpQNFIym8VtAmHuBZGdN/OmXB+ZLH6ikgUR6Djsd2lQs7Z73zaEMS7F6c274k1oTYL/jCvdgqjn3cYTL+4FlYvw+tBir41D+PrtKTZL0kwi/Kme3LKw/hSdGmtl5O5g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbMPzLIq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbMPzLIq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1968C19421;
	Mon, 29 Dec 2025 16:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025064;
	bh=nef9WbZxN2/NqgDIE3H5wtKqu2TkLr96OkjZ8x067vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbMPzLIqua/r8or0wYViTAw71z9I/5Q3ulwp0yNHJt9/AwSL/8rfdKkdEhg1m+1Ie
	 7+jlsMLEzqTHbR9ZUbnrSWEABKnqNwSBfSlcEe+MFMIPvEGPa8eHP5onLG9nBIhV4m
	 9dxUbqg3lFd5/uwq2PaFoRAvH19CcBbm1QGXD+3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/430] selftests: netfilter: prefer xfail in case race wasnt triggered
Date: Mon, 29 Dec 2025 17:08:03 +0100
Message-ID: <20251229160727.345359047@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit b8a81b0ce539e021ac72825238aea1eb657000f0 ]

Jakub says: "We try to reserve SKIP for tests skipped because tool is
missing in env, something isn't built into the kernel etc."

use xfail, we can't force the race condition to appear at will
so its expected that the test 'fails' occasionally.

Fixes: 78a588363587 ("selftests: netfilter: add conntrack clash resolution test case")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Closes: https://lore.kernel.org/netdev/20251206175647.5c32f419@kernel.org/
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/netfilter/conntrack_clash.sh | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/net/netfilter/conntrack_clash.sh b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
index 7fc6c5dbd5516..84b8eb12143ae 100755
--- a/tools/testing/selftests/net/netfilter/conntrack_clash.sh
+++ b/tools/testing/selftests/net/netfilter/conntrack_clash.sh
@@ -116,7 +116,7 @@ run_one_clash_test()
 	# not a failure: clash resolution logic did not trigger.
 	# With right timing, xmit completed sequentially and
 	# no parallel insertion occurs.
-	return $ksft_skip
+	return $ksft_xfail
 }
 
 run_clash_test()
@@ -133,12 +133,12 @@ run_clash_test()
 		if [ $rv -eq 0 ];then
 			echo "PASS: clash resolution test for $daddr:$dport on attempt $i"
 			return 0
-		elif [ $rv -eq $ksft_skip ]; then
+		elif [ $rv -eq $ksft_xfail ]; then
 			softerr=1
 		fi
 	done
 
-	[ $softerr -eq 1 ] && echo "SKIP: clash resolution for $daddr:$dport did not trigger"
+	[ $softerr -eq 1 ] && echo "XFAIL: clash resolution for $daddr:$dport did not trigger"
 }
 
 ip link add veth0 netns "$nsclient1" type veth peer name veth0 netns "$nsrouter"
@@ -167,8 +167,7 @@ load_simple_ruleset "$nsclient2"
 run_clash_test "$nsclient2" "$nsclient2" 127.0.0.1 9001
 
 if [ $clash_resolution_active -eq 0 ];then
-	[ "$ret" -eq 0 ] && ret=$ksft_skip
-	echo "SKIP: Clash resolution did not trigger"
+	[ "$ret" -eq 0 ] && ret=$ksft_xfail
 fi
 
 exit $ret
-- 
2.51.0



