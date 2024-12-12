Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00732080FC;
	Thu, 12 Dec 2024 15:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015690; cv=none; b=Eqy+k4n1A8SdOMQKH1cgx1A5vRiRmmppkdpWXO5cBYpcfF842viAckGHZcIGPENqMzsF0wyP/8WZSbiHC0Y6sa0k+GU1Tls4PdzM43RRAbQlmZpC2uCepmIuMkLDc6t5LMGDy4Apxky/41TAiKTGBqiymEC2JxSeFFNK3uYSHiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015690; c=relaxed/simple;
	bh=jPkVc6YolaZ1iP2umkrLgqyGYTTsOSSsCN7npZw/D0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oF7DcS6NHkpN+6LAkPcNPJp8Mwy6K/5H77moFlGIMjod0FZ90PvoyaFw/ShIw/fwBI4FEJFroeWKxOmwTXoGlQSSPM+CVbt6Aq57nVmbEmjwtzzO/In5hrDRi3+k9ox5YPuqjHIiiElHAu1m1F93z4kZPs+G7yaIAJwKGLAyl7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gtVJMYdX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gtVJMYdX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0108BC4CECE;
	Thu, 12 Dec 2024 15:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015690;
	bh=jPkVc6YolaZ1iP2umkrLgqyGYTTsOSSsCN7npZw/D0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gtVJMYdXWih5pWCABHTlYU+63WndxiJbZTdVDhkQFuzQy52aWovxVRu4XLwAz8K6b
	 +XWw+J9ApoKn/QwTSa1sd6mUJVkKFOdFmMCSi2XHX5/ZFCk8NW4+yEXsX8XZDOzJF4
	 qReq1ma6S+xZTG5NitSya6a1RWtwEf52aJeRHPEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilian Heyne <mheyne@amazon.de>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 019/466] selftests: hid: fix typo and exit code
Date: Thu, 12 Dec 2024 15:53:08 +0100
Message-ID: <20241212144307.451332681@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



