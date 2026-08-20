Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA26846C82A;
	Thu, 20 Aug 2026 17:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247819; cv=none; b=JpMbXxtgBfA4rGz1FylJEw7W9uE0ZeZECpGGXnkjY/R/+G3j4ct1hXqaWdfXsU7aAxbu2FHgA00YK28faOCBvHbCou/r2fAWwyTbVOEeEjIxkyIJ5csT6x6yHoQRt2j4czWWJOw7AcK8DQm3TFTT/PRzOfrIKu5pHq03xrInyFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247819; c=relaxed/simple;
	bh=R9t07yjfolD2IBpg3rX/zoy41zJVZzHqO32q2wVuLqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnCIqlfw1/4N1nSCyuUzSgtTmJdidNIHh0OrmAw3A4mWgNhAODnqm6tfpjNf3g/hHA8WQh58B+T15/CYBkdn3hq1vnf9jvcri8Li7Zsj3FswVCL9iYPt0p5HEh9bArYiWOEABDkRR1Z5uZKw9W3KGIdKfaS4Q3mXk/txd9Q8MFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VZRbe9Mo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VZRbe9Mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CB31F000E9;
	Thu, 20 Aug 2026 17:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247817;
	bh=XXdrhv1TejZio1NQ2kwjG0MfQ7VmrLHpukWQmSqFySU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VZRbe9Mo0mg0088OuLaojY5Xtaaz08p6fCqayyxL+xPXjADZBgTHXZ3AIK6ip9KUh
	 QuyWOcKx4nGokFZEX30tZXgPshE6nEB14piayivJP2JtMcMhoZPymWS6sSJn41cyOx
	 XpkCNvpV54Pm1bUSrDzo1EwOKp+KQ1i67YW1idzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 013/303] selftests: mptcp: join: mark tests with data corruption as failed
Date: Thu, 20 Aug 2026 16:52:29 +0200
Message-ID: <20260820145253.588518442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -500,7 +500,7 @@ check_transfer()
 		mv "$tmpfile" "$out"
 		tmpfile=""
 	fi
-	cmp -l "$in" "$out" | while read -r i a b; do
+	while read -r i a b; do
 		local sum=$((0${a} + 0${b}))
 		if [ $check_invert -eq 0 ] || [ $sum -ne $((0xff)) ]; then
 			echo "[ FAIL ] $what does not match (in, out):"
@@ -512,7 +512,7 @@ check_transfer()
 		else
 			echo "$what has inverted byte at ${i}"
 		fi
-	done
+	done < <(cmp -l "$in" "$out")
 
 	return 0
 }


