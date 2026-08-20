Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784DD37DEBF;
	Thu, 20 Aug 2026 15:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238066; cv=none; b=IsnULcC0DIM3G04DetYQRypLvLGXQWhDCS1wQeQSNwlsvAVnxVkjbVSDsszkl+NGmdaDz600T655cXs9/k2bMzm+ItOpkM+zUBm43FpOUhuAn23jiV9E9MoeDu3ApVLeAOk3q73OdmRek7ho/xBMs5Q6pEDtC9M27hCjk1iH3C0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238066; c=relaxed/simple;
	bh=vrcYBTTiJas6L4tFXLlWz+NnsyEWJoxdTWbrhKZCT+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJk0vhLODzjhCLj/v8VwzHOtQL0nNhfMe6oo0sHATYis2TYjNqdeGnVqq2+0aZin8roJ5OLolnh/jFLxs0cf7WptF20d9JQC+JjTRSN9+J4H0w8Wrx4/tHlulleOB2jtNAyDG22kJsyJ61myQrQbWuFezggeltZWKs7gOm5CPqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNvNXl66; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNvNXl66"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532191F00A3A;
	Thu, 20 Aug 2026 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238065;
	bh=beK7ug05NQlSBgsSiHXHBHVjr7O989lbph9V1DYxVxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNvNXl668K+swyiMgyvXbkUT5iWBgY1oUM/fzTD7CgoaKYu4K4BYeS5zEfPgf8gwh
	 Zuuzm4zg5u4tLFViGYyctllHw2CfV7EgUyezgBOXXatlia+jEqK1yVPtsxUs84O8EB
	 1uOSJ66gCpsVGvXa3gHtSHGfzVJJVK13HrbGDMhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gang Yan <yangang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 008/228] selftests: mptcp: join: mark tests with data corruption as failed
Date: Thu, 20 Aug 2026 16:52:30 +0200
Message-ID: <20260820145244.718794943@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -566,7 +566,7 @@ check_transfer()
 		mv "$tmpfile" "$out"
 		tmpfile=""
 	fi
-	cmp -l "$in" "$out" | while read -r i a b; do
+	while read -r i a b; do
 		local sum=$((0${a} + 0${b}))
 		if [ $check_invert -eq 0 ] || [ $sum -ne $((0xff)) ]; then
 			fail_test "$what does not match (in, out):"
@@ -577,7 +577,7 @@ check_transfer()
 		else
 			print_info "$what has inverted byte at ${i}"
 		fi
-	done
+	done < <(cmp -l "$in" "$out")
 
 	return 0
 }


