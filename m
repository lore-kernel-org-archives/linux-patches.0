Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB731DE890;
	Tue,  8 Oct 2024 12:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390453; cv=none; b=DO9//n718l6rYSkb/K6gPIoM6C3XyYwf81yozG7rvrPjRTFXONu3U5FeKp0tLHeuVbbBbr4tfivgXwSNxBsayeO3C4LrrWlUEzQoqwB8es0nnLyQiJ8pLg7SkgbYd4oLduRrO7sLiQtZIZviLwCKmOB+QQqRX4T6LYaowEGUkcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390453; c=relaxed/simple;
	bh=Zpo/wFVsDdDRRt2iNZbfxlBHi42bSvYqGPc7evHL25Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H/qEuXyTxtGe/P340kifHr0fB3VbMGNoLtrok2dP0ju2ZKXkN30ZAdOgKxs1RojoFzE8qB15HHYy6+9ShnIyPA7vB05ckC/4RyAg4cmfloqwqGRwZN7rbuNfld0TSdMrh9OJpfyx7xuKa/RyqSC3AOnnzUXAu9i8Terlvf1mHZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GmGWOXZv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GmGWOXZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8714DC4CEC7;
	Tue,  8 Oct 2024 12:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390453;
	bh=Zpo/wFVsDdDRRt2iNZbfxlBHi42bSvYqGPc7evHL25Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GmGWOXZvaLthxsBJqngrPTlTjAUGyP/62zhzZcHOobl7W9xFsrPiC8K6dki9x3LyR
	 Ec/HBvUowgNA7tOC1T4mAHY67d/BOOk9YczRInDDc3SJ2MEqWbd+NZzpDKzOdUCPjG
	 zpg20A9t1ttH7IxqTtC/nNSL9i2sx3DrozMqzvao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Lu <luyun@kylinos.cn>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 262/482] selftest: hid: add missing run-hid-tools-tests.sh
Date: Tue,  8 Oct 2024 14:05:25 +0200
Message-ID: <20241008115658.594329875@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Lu <luyun@kylinos.cn>

[ Upstream commit 160c826b4dd0d570f0f51cf002cb49bda807e9f5 ]

HID test cases run tests using the run-hid-tools-tests.sh script.
When installed with "make install", the run-hid-tools-tests.sh
script will not be copied over, resulting in the following error message.

  make -C tools/testing/selftests/ TARGETS=hid install \
  	  INSTALL_PATH=$KSFT_INSTALL_PATH

  cd $KSFT_INSTALL_PATH
  ./run_kselftest.sh -c hid

selftests: hid: hid-core.sh
bash: ./run-hid-tools-tests.sh: No such file or directory

Add the run-hid-tools-tests.sh script to the TEST_FILES in the Makefile
for it to be installed.

Fixes: ffb85d5c9e80 ("selftests: hid: import hid-tools hid-core tests")
Signed-off-by: Yun Lu <luyun@kylinos.cn>
Acked-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/hid/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/hid/Makefile b/tools/testing/selftests/hid/Makefile
index 2b5ea18bde38b..346328e2295c3 100644
--- a/tools/testing/selftests/hid/Makefile
+++ b/tools/testing/selftests/hid/Makefile
@@ -17,6 +17,8 @@ TEST_PROGS += hid-tablet.sh
 TEST_PROGS += hid-usb_crash.sh
 TEST_PROGS += hid-wacom.sh
 
+TEST_FILES := run-hid-tools-tests.sh
+
 CXX ?= $(CROSS_COMPILE)g++
 
 HOSTPKG_CONFIG := pkg-config
-- 
2.43.0



