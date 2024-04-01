Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563E8C129;
	Mon,  1 Apr 2024 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988641; cv=none; b=B+5nFtvR63k8hV9Ul1D5NXa5HEbyIZofn1ApXxjM3s9eQ7TqtMR3iC2MYWjfiJ5sywvfFgX8bTGbM8JaM+VIunEOsYD1XQSrNrRmLP6J8gjQXop+2GokoH/5gPLNlc5/5FYTjePZNYHQTTGL0j+zJcP5xEP0LvaYRPPNqyXPJtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988641; c=relaxed/simple;
	bh=H0J0LSH3bd+nSWcUVdg3D7zfz7hzfnrF+ezI/zof+hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeHOze5AL7Lj87bKwj0nF9w8rteICwq6CLGzgnrCfIVmB6IjKMh9lELsfKYMbaH1xcqrdHBSookTsFbSLkOv0Pa2W2vMSnho6niao5sdKKKY1vcHj7BYKusdtBAlc+A8NlRh0bH1Iz9oX6YJ/+4Fav37tKjgz8IVsSYReDq0J4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQ87ufjo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQ87ufjo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D65C433C7;
	Mon,  1 Apr 2024 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988641;
	bh=H0J0LSH3bd+nSWcUVdg3D7zfz7hzfnrF+ezI/zof+hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQ87ufjo2KcrzrcljzL3VLzuI8E27mm+X87eWLf7lzKtl6Ljhwt15mB0NJUQieUuE
	 xGYA9k5SH3FbJUqvoAl7uap58u0DrQDj7VoE/m9xQ52WhcwoSOByGfbQ/+wAMqan4M
	 h/P5nxed86D7XcF91iEZfPdlArTKn3dA4vK01KGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 245/432] selftests: mptcp: diag: return KSFT_FAIL not test_cnt
Date: Mon,  1 Apr 2024 17:43:52 +0200
Message-ID: <20240401152600.447919734@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 45bcc0346561daa3f59e19a753cc7f3e08e8dff1 upstream.

The test counter 'test_cnt' should not be returned in diag.sh, e.g. what
if only the 4th test fail? Will do 'exit 4' which is 'exit ${KSFT_SKIP}',
the whole test will be marked as skipped instead of 'failed'!

So we should do ret=${KSFT_FAIL} instead.

Fixes: df62f2ec3df6 ("selftests/mptcp: add diag interface tests")
Cc: stable@vger.kernel.org
Fixes: 42fb6cddec3b ("selftests: mptcp: more stable diag tests")
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/diag.sh |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/net/mptcp/diag.sh
+++ b/tools/testing/selftests/net/mptcp/diag.sh
@@ -69,7 +69,7 @@ __chk_nr()
 		else
 			echo "[ fail ] expected $expected found $nr"
 			mptcp_lib_result_fail "${msg}"
-			ret=$test_cnt
+			ret=${KSFT_FAIL}
 		fi
 	else
 		echo "[  ok  ]"
@@ -115,11 +115,11 @@ wait_msk_nr()
 	if [ $i -ge $timeout ]; then
 		echo "[ fail ] timeout while expecting $expected max $max last $nr"
 		mptcp_lib_result_fail "${msg} # timeout"
-		ret=$test_cnt
+		ret=${KSFT_FAIL}
 	elif [ $nr != $expected ]; then
 		echo "[ fail ] expected $expected found $nr"
 		mptcp_lib_result_fail "${msg} # unexpected result"
-		ret=$test_cnt
+		ret=${KSFT_FAIL}
 	else
 		echo "[  ok  ]"
 		mptcp_lib_result_pass "${msg}"


