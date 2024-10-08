Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4AB1DF75C;
	Tue,  8 Oct 2024 12:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392106; cv=none; b=Y1rD6ttEym25pNlBn7LtPOXdKI2VSnz7RN5tn/hx7tKZuIx3znYEGiL++C+5AuDGitwNSfm3fwYMx+LcLprgJcHMK14RVOqQKA+rt1kCvojiLCm/OQ3w7wP2VsbF5FeEFlqQYhMJcTny1LpgoKq2SdY0uUfQ0f4sT4C1WWg1zwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392106; c=relaxed/simple;
	bh=PBuJ1gnEDBMrV5XPa28AaU9aeg0AS6GxTdhLpynNCY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJpxrfLb9KrK2T4XQ11200CxQYOBPN8F6/b1rcQ6tS7zizW6n/my00R55rCiGalH0Pv75rf3k3vkrbLJd0zDvLLRK/y5oLGeG6wtclCqNgZo02EHei9V4wqkUHtVIxFIa45H5hnH7zm1c5KccMl3i44nHEuuwNz/cbuaY+UkiVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lurAwSQL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lurAwSQL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F21C4CEC7;
	Tue,  8 Oct 2024 12:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392106;
	bh=PBuJ1gnEDBMrV5XPa28AaU9aeg0AS6GxTdhLpynNCY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lurAwSQLQYPy4YMY09MnnkEpEm4F4NgX84+KkBwUboBTTOVWw4LK/SWF/B0CzrSqD
	 FFckq+diMH8+3SNjd7B9UVZlxJfKfph3kf0dyVtoNR6G1V9ZPVJbucyydjRjUN3ZzJ
	 7+Ipr3ksmelXyVtU+dXq9kHaXBKUgWobQimmnNi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Lu <luyun@kylinos.cn>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 318/558] selftest: hid: add missing run-hid-tools-tests.sh
Date: Tue,  8 Oct 2024 14:05:48 +0200
Message-ID: <20241008115714.822433624@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



