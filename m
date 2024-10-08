Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244841DE89F;
	Tue,  8 Oct 2024 13:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393593; cv=none; b=OrF9b1UpMqJfxksnrNBMat3jKPzFtJnkmeOL4uwtBY9+6QmUQy6X+zDeEbdodnZL29LcnPv5N8F4v7giKijNIL+QJg7WnHBqRyfKdapnN0MF75Kx0PwGLsUAp45dA5Bb2OifWI+LgOWGhqTrSg+tzdstiY6F+FtWRqPks1ZDpxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393593; c=relaxed/simple;
	bh=y6LVkq8gg+as2eeEIW0Z2rp07dwMuF6MXYuLGl2lrIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGFwWm/s+vS63jEchvfhmqHmU4KZSMjgFGMl7mKknMmpGY9vuE2s5uvk34raYTkmAWM73Uh1k8PyyjVFboKJf/4ieq/VCLA8dF6s3HIEZoYdn3wnvmq17WPYSMjgBrhRY786u5Q6YdobPspV9X2nD96090wnnzTLhq3bMqtxzsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vn9kUAtX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vn9kUAtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E269C4CECC;
	Tue,  8 Oct 2024 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393592;
	bh=y6LVkq8gg+as2eeEIW0Z2rp07dwMuF6MXYuLGl2lrIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vn9kUAtX4LTRfRDUb8k8FjxIRpV8umJfr2nTNJGUvtewbi5519XJ2R0gEwl4CVxKy
	 cbw6AXjXEsyks0J4avU1eHxuprGydwjaqYhGFWKkuRouHOfF684o4rCaxjqtJqhrTB
	 LNSFxBqPk0S8Omz8+yfapf7usXRPuwD9iRhR6uUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Lu <luyun@kylinos.cn>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 190/386] selftest: hid: add missing run-hid-tools-tests.sh
Date: Tue,  8 Oct 2024 14:07:15 +0200
Message-ID: <20241008115636.887045283@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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
index 2e986cbf1a463..87b6f5f83d7e0 100644
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



