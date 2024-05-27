Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682C917E90E;
	Mon, 27 May 2024 19:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836840; cv=none; b=DK8UJ8Pj15qVJGOWiK0MdFiCE/EQ5RogIlWQRascH5k85rZidz6WXM0btG8/jTR2M8msEZFFl652a0/umirS9KKgDyRyEveQQyS6GPxO9IrwfC5aR1nELTkZNtz62EZXJugcxWNrUfryU6lFQ0Ga9y2uVakMZ+Qop0fGCLvNVKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836840; c=relaxed/simple;
	bh=iMxK/dADr/dxLveZFLxyYyL7l0ADqfwRV8YRbHujYAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AnN8M6QGIvfiHTh5GhniZOYChjOEMjNxDrmxJ3tuzbKLCHisRoASXb7ryKQ1m+5Btubv352d+UvWrOpLkUxpj1StQCE87tXI5ApMVAgpf2RK+LYc6KSsfzA+SE0cJiwciz+1kiGg6H2tiLn7g9MlEdl1TO00Y5EvMg3kHZSD8/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvuUy5Fr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvuUy5Fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD03C32781;
	Mon, 27 May 2024 19:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836839;
	bh=iMxK/dADr/dxLveZFLxyYyL7l0ADqfwRV8YRbHujYAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvuUy5FrNzUk4kG2oCnwG19znQBVtfviHcoNEVstLgqxZmqgMOufKQz4VvmDRy0yV
	 /0DCMOnOKtAoDrEqT8OXahAdlYIDQIwxuaKTB6sbmR8TQwYB9eGB+RqiQCPHsCOjzg
	 IpZn0PZQiEQxBxqMVwjwVZJMt2Y9JdQioGKHT5O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 208/427] selftests: ktap_helpers: Make it POSIX-compliant
Date: Mon, 27 May 2024 20:54:15 +0200
Message-ID: <20240527185621.753300142@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 45d5a2b1886a3ff0fe5627ebee84c089db7ff5f2 ]

There are a couple uses of bash specific syntax in the script. Change
them to the equivalent POSIX syntax. This doesn't change functionality
and allows non-bash test scripts to make use of these helpers.

Reported-by: Mike Looijmans <mike.looijmans@topic.nl>
Closes: https://lore.kernel.org/all/efae4037-c22a-40be-8ba9-7c1c12ece042@topic.nl/
Fixes: 2dd0b5a8fcc4 ("selftests: ktap_helpers: Add a helper to finish the test")
Fixes: 14571ab1ad21 ("kselftest: Add new test for detecting unprobed Devicetree devices")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest/ktap_helpers.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kselftest/ktap_helpers.sh b/tools/testing/selftests/kselftest/ktap_helpers.sh
index f2fbb914e058d..79a125eb24c2e 100644
--- a/tools/testing/selftests/kselftest/ktap_helpers.sh
+++ b/tools/testing/selftests/kselftest/ktap_helpers.sh
@@ -43,7 +43,7 @@ __ktap_test() {
 	directive="$3" # optional
 
 	local directive_str=
-	[[ ! -z "$directive" ]] && directive_str="# $directive"
+	[ ! -z "$directive" ] && directive_str="# $directive"
 
 	echo $result $KTAP_TESTNO $description $directive_str
 
@@ -99,7 +99,7 @@ ktap_exit_fail_msg() {
 ktap_finished() {
 	ktap_print_totals
 
-	if [ $(("$KTAP_CNT_PASS" + "$KTAP_CNT_SKIP")) -eq "$KSFT_NUM_TESTS" ]; then
+	if [ $((KTAP_CNT_PASS + KTAP_CNT_SKIP)) -eq "$KSFT_NUM_TESTS" ]; then
 		exit "$KSFT_PASS"
 	else
 		exit "$KSFT_FAIL"
-- 
2.43.0



