Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5AB2135C1;
	Thu, 12 Dec 2024 15:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017465; cv=none; b=XvCG3yjjft2SE3QPuiucIFqwU12HTVo5yv4iclHmVF3rHDPl+wIkjJly2b75y6l4zXGhxQjewVcLLui+xhtECvj3gUv5uvgDrpQca6L7IBEQDQcuUzvD1/ZC9QJp2jIFKz/NgQmDYOQtSbKqCx5pUPo9xL+gI7F4LNcf9bDHnaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017465; c=relaxed/simple;
	bh=Luf2JNkb4+qisc7qc/JIdGvnH6wsMXEUz3uwt033RBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8Aiu4yUob4D9F0NjjbJr4xgATPIVI+vVqR0XFMXyLEmmxnuFRYHdsURXjO7q0qvHbgjPpGqeDtpTvBxZaw9lhW7Z3xpW7lnQr0FFzc9H1DbGWNS5MV8COVmqY1WEZ1/FP7l9ohXtGDcqRSGbRBg15WdODbjJYxrZ2V/ytgl9T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nd+S942U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nd+S942U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC80C4CECE;
	Thu, 12 Dec 2024 15:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017465;
	bh=Luf2JNkb4+qisc7qc/JIdGvnH6wsMXEUz3uwt033RBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nd+S942UtqfR6qW5VM8OclKFBGmo2E9rK8rCoYcjELOJaQquJx2YTM1ep//+xB3my
	 0wOJzEpmhMlDsKFl14VRRfwltYBYo2nIY+dPM/5miG9TarpARw6HcuTjTxOx5eRHRJ
	 iMfOqOMiFS3P5oi51jprUTJ8R8bVYuiLUGhHq5pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/356] selftests: hid: fix typo and exit code
Date: Thu, 12 Dec 2024 15:55:39 +0100
Message-ID: <20241212144245.418042654@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maximilian Heyne <mheyne@amazon.de>

[ Upstream commit e8f34747bddedaf3895e5d5066e0f71713fff811 ]

The correct exit code to mark a test as skipped is 4.

Fixes: ffb85d5c9e80 ("selftests: hid: import hid-tools hid-core tests")
Signed-off-by: Maximilian Heyne <mheyne@amazon.de>
Link: https://patch.msgid.link/20241126135850.76493-1-mheyne@amazon.de
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/hid/run-hid-tools-tests.sh | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/hid/run-hid-tools-tests.sh b/tools/testing/selftests/hid/run-hid-tools-tests.sh
index bdae8464da865..af1682a53c27e 100755
--- a/tools/testing/selftests/hid/run-hid-tools-tests.sh
+++ b/tools/testing/selftests/hid/run-hid-tools-tests.sh
@@ -2,24 +2,26 @@
 # SPDX-License-Identifier: GPL-2.0
 # Runs tests for the HID subsystem
 
+KSELFTEST_SKIP_TEST=4
+
 if ! command -v python3 > /dev/null 2>&1; then
 	echo "hid-tools: [SKIP] python3 not installed"
-	exit 77
+	exit $KSELFTEST_SKIP_TEST
 fi
 
 if ! python3 -c "import pytest" > /dev/null 2>&1; then
-	echo "hid: [SKIP/ pytest module not installed"
-	exit 77
+	echo "hid: [SKIP] pytest module not installed"
+	exit $KSELFTEST_SKIP_TEST
 fi
 
 if ! python3 -c "import pytest_tap" > /dev/null 2>&1; then
-	echo "hid: [SKIP/ pytest_tap module not installed"
-	exit 77
+	echo "hid: [SKIP] pytest_tap module not installed"
+	exit $KSELFTEST_SKIP_TEST
 fi
 
 if ! python3 -c "import hidtools" > /dev/null 2>&1; then
-	echo "hid: [SKIP/ hid-tools module not installed"
-	exit 77
+	echo "hid: [SKIP] hid-tools module not installed"
+	exit $KSELFTEST_SKIP_TEST
 fi
 
 TARGET=${TARGET:=.}
-- 
2.43.0



