Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5785348097E;
	Thu, 20 Aug 2026 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247413; cv=none; b=ix2DcisUK+P7S5PO7Pp1guJykLyinClN8NRP2u6TgVOkWD/K5n53qaV3nMbvvgnY+JmmJ48oLl3YyyC2hRAdAm8tASgYBGk/luLTrcO2T2g46dr1Cy08QZfQ5I3fyXict9bqHgKz/KF06SLV2pX/yNvzRpbUk/FCJ5h7CF5VHqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247413; c=relaxed/simple;
	bh=Xsv0mNlgH3fTlC2pzMB1t7B3TnHHpnpQO9dGOXi6iOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ddCF6h38hA5+3elI1581ZX1S5VlW49vaaQKQecqo/dWatWVrTZngpjKExcauzXeNqoiZ44TuRMRhChX4yW8mG8pBrAOPPaiSsxD9Lf9ZO8w9NiDyMN5P/JULhjVSDV8eNa7cj5W7pyPJaTByrGzZnyY6rAbwrHgRC4pH0Oi0+HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXVVEiKX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXVVEiKX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B0A41F000E9;
	Thu, 20 Aug 2026 17:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247412;
	bh=lfpA3ReegfLG7pdxVgMBUu1n2tQBgHUv9wdyqL5ymBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HXVVEiKXz5PvC9YDeURoVQNYLItgGLlYiKazWbLLxUw81pieLI7ih7Pu5kj7El2Jd
	 3zjhhv+jtLJ2kKNfNA2B4blLMHgjxKiI1cpCemjz8Q6Zi/z0RrznnYt1kmiK1AOaIw
	 IR+BqzoBFMy0q2z2lOoTXZIuVwj12oJDaDB92Mic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 009/166] selftests: mptcp: join: mark tests with data corruption as failed
Date: Thu, 20 Aug 2026 16:54:28 +0200
Message-ID: <20260820145211.473925119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gang Yan <yangang@kylinos.cn>

commit ca318e7bbb7723f57bcd9e69a2873b5884435552 upstream.

check_transfer() compares the input and output files byte-by-byte using
`cmp -l "$in" "$out" | while read ...`. Because the while-loop body runs
in a subshell (the script sets neither lastpipe nor pipefail), the
fail_test call inside it -- which sets the global ret/last_test_failed --
and the `return 1` both act on the subshell, not on check_transfer().

check_transfer() thus always falls through to `return 0`, and any data
corruption affecting only the payload (leaving the subflow/PM counters
untouched) is silently reported as PASS.

Fixes: 8117dac3e7c3 ("selftests: mptcp: add invert check in check_transfer")
Cc: stable@vger.kernel.org
Signed-off-by: Gang Yan <yangang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260803-net-mptcp-misc-fixes-7-2-rc6-v2-5-b8f496d71664@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/mptcp_join.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/net/mptcp/mptcp_join.sh
+++ b/tools/testing/selftests/net/mptcp/mptcp_join.sh
@@ -573,7 +573,7 @@ check_transfer()
 		mv "$tmpfile" "$out"
 		tmpfile=""
 	fi
-	cmp -l "$in" "$out" | while read -r i a b; do
+	while read -r i a b; do
 		local sum=$((0${a} + 0${b}))
 		if [ $check_invert -eq 0 ] || [ $sum -ne $((0xff)) ]; then
 			fail_test "$what does not match (in, out):"
@@ -584,7 +584,7 @@ check_transfer()
 		else
 			print_info "$what has inverted byte at ${i}"
 		fi
-	done
+	done < <(cmp -l "$in" "$out")
 
 	return 0
 }


