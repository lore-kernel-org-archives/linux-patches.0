Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F7EE47A64;
	Mon,  1 Apr 2024 17:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991222; cv=none; b=nRLqD5LH9tUy4xIqFAqrfV55M5x0Gsbd6fkHl84CxOvU0I8MXiDP+zf3UY8/HpDWZHu/+NKPbxWmBIDocxOilNkfChpIm6mHqHq0uEy5UWXpeuV0Yit+hVlPgUsKYz5zPZ0bqPuYGUpr+rfexBXzj8GNPakF3W4adxl05YafKIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991222; c=relaxed/simple;
	bh=ITBnKnhqNTg8anUR4AjpsephsxBkTHBO5EKbrxTO+uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hz5fe5uD9lqPzFreOafGxu0OWOlZPgWnAq/YVw+5+ZUYH2rHKFHC27oIo4tHl8kYNoVb2yzBT4xCwXOp9XqGIjemDYBZsA3oZno/JtIUclKJc2GYbhKL66myNntfVnCzFNppHAc7xQDtcoxJ1ZeM2g5fJdf79FmxYgJVe2J4Dwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l/bkRwNJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l/bkRwNJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F09C433C7;
	Mon,  1 Apr 2024 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991222;
	bh=ITBnKnhqNTg8anUR4AjpsephsxBkTHBO5EKbrxTO+uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l/bkRwNJ+cT+COsPGB2DtTWqUdKprJNPSjFMODWkoYy3S9ujZu7l2jsHciAVD7bPw
	 K/bGawYVlksEQ2vmu546QLhd4tVszloeTHQDRY06QfkUN17L9DBSF8vsiwz4IKmzUi
	 jv17dGJbtxCWJCKwpdGh6lDTn4OoRjlMYRrEx+ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 199/272] selftests: mptcp: diag: return KSFT_FAIL not test_cnt
Date: Mon,  1 Apr 2024 17:46:29 +0200
Message-ID: <20240401152537.110524290@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -56,7 +56,7 @@ __chk_nr()
 			echo "[ skip ] Feature probably not supported"
 		else
 			echo "[ fail ] expected $expected found $nr"
-			ret=$test_cnt
+			ret=${KSFT_FAIL}
 		fi
 	else
 		echo "[  ok  ]"
@@ -100,10 +100,10 @@ wait_msk_nr()
 	printf "%-50s" "$msg"
 	if [ $i -ge $timeout ]; then
 		echo "[ fail ] timeout while expecting $expected max $max last $nr"
-		ret=$test_cnt
+		ret=${KSFT_FAIL}
 	elif [ $nr != $expected ]; then
 		echo "[ fail ] expected $expected found $nr"
-		ret=$test_cnt
+		ret=${KSFT_FAIL}
 	else
 		echo "[  ok  ]"
 	fi


