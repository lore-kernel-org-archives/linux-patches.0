Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 116865FF0A;
	Tue, 13 Feb 2024 17:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845709; cv=none; b=H3kNn3EY+tva6Hy2FZOG7SJ+tP7RgkqspPM8vJgeE0xVS+gGvYResSnZN+G7TISExmO6LoyF5OG+qtBTKUUJMEaeF5GRwCVGHuNJ8ZEnriagWOgU1wSW5Atx5KU7Q9FgCbZy02d86O6c+4JaFEy5NF8gQF978f9O3CVLJOuRsPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845709; c=relaxed/simple;
	bh=cslD5R1vSbtnzi3WRA9wLmHcnR+wpuC5IZ5q1CX5o8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozKsBkY8uRwG8mzKIMMe41752Eb5d8CLwyCoVpAUj+IvAM0y/oGf+xpwq2HOOI1dBxf5aRLdI0rhfThEyR9xpc5PEgwTaSO9cZLQj57U64wI/kgWvIrS6tS85pvVfHTK/NM+Y7+2TqRB2fMxRPNxTDG0fFdDh5oXLUb4DUvBLAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QtOzGKpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QtOzGKpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6755CC433C7;
	Tue, 13 Feb 2024 17:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845708;
	bh=cslD5R1vSbtnzi3WRA9wLmHcnR+wpuC5IZ5q1CX5o8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtOzGKpwAFA1+SLEPjg/McQezGKwDpNI9JihsvXEUgPEtraDzGwEg/f49ITVRxAw1
	 r71vAXkkXcrpM2aSAC7J8lDisCilIAoUsEmqeIcJtOsP+L2Maic2kmsRi2wo1ROHz2
	 Gt5tKeeC43SKF6Y9kRnhDMAXQHhrP0WYlnMnaj/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Yujie Liu <yujie.liu@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 036/124] selftests/net: change shebang to bash to support "source"
Date: Tue, 13 Feb 2024 18:20:58 +0100
Message-ID: <20240213171854.786916270@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

From: Yujie Liu <yujie.liu@intel.com>

[ Upstream commit 05d92cb0e919239c29b3a26da1f76f1e18fed7d3 ]

The patch set [1] added a general lib.sh in net selftests, and converted
several test scripts to source the lib.sh.

unicast_extensions.sh (converted in [1]) and pmtu.sh (converted in [2])
have a /bin/sh shebang which may point to various shells in different
distributions, but "source" is only available in some of them. For
example, "source" is a built-it function in bash, but it cannot be
used in dash.

Refer to other scripts that were converted together, simply change the
shebang to bash to fix the following issues when the default /bin/sh
points to other shells.

not ok 51 selftests: net: unicast_extensions.sh # exit=1

v1 -> v2:
  - Fix pmtu.sh which has the same issue as unicast_extensions.sh,
    suggested by Hangbin
  - Change the style of the "source" line to be consistent with other
    tests, suggested by Hangbin

Link: https://lore.kernel.org/all/20231202020110.362433-1-liuhangbin@gmail.com/ [1]
Link: https://lore.kernel.org/all/20231219094856.1740079-1-liuhangbin@gmail.com/ [2]
Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: 378f082eaf37 ("selftests/net: convert pmtu.sh to run it in unique namespace")
Fixes: 0f4765d0b48d ("selftests/net: convert unicast_extensions.sh to run it in unique namespace")
Signed-off-by: Yujie Liu <yujie.liu@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20231229131931.3961150-1-yujie.liu@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e71e016ad0f6 ("selftests: net: fix tcp listener handling in pmtu.sh")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/pmtu.sh               | 4 ++--
 tools/testing/selftests/net/unicast_extensions.sh | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/pmtu.sh b/tools/testing/selftests/net/pmtu.sh
index 8518eaacf4b5..3f118e3f1c66 100755
--- a/tools/testing/selftests/net/pmtu.sh
+++ b/tools/testing/selftests/net/pmtu.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 #
 # Check that route PMTU values match expectations, and that initial device MTU
@@ -198,7 +198,7 @@
 # - pmtu_ipv6_route_change
 #	Same as above but with IPv6
 
-source ./lib.sh
+source lib.sh
 
 PAUSE_ON_FAIL=no
 VERBOSE=0
diff --git a/tools/testing/selftests/net/unicast_extensions.sh b/tools/testing/selftests/net/unicast_extensions.sh
index b7a2cb9e7477..f52aa5f7da52 100755
--- a/tools/testing/selftests/net/unicast_extensions.sh
+++ b/tools/testing/selftests/net/unicast_extensions.sh
@@ -1,4 +1,4 @@
-#!/bin/sh
+#!/bin/bash
 # SPDX-License-Identifier: GPL-2.0
 #
 # By Seth Schoen (c) 2021, for the IPv4 Unicast Extensions Project
@@ -28,7 +28,7 @@
 # These tests provide an easy way to flip the expected result of any
 # of these behaviors for testing kernel patches that change them.
 
-source ./lib.sh
+source lib.sh
 
 # nettest can be run from PATH or from same directory as this selftest
 if ! which nettest >/dev/null; then
-- 
2.43.0



