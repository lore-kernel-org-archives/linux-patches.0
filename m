Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8933D346778;
	Tue, 11 Nov 2025 01:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824776; cv=none; b=SKKNlJOqvBaVg2AaKEztO5V9xgRY5TdEkpb7WzoTqXpwB+bAb65q7QtsR5KV2lItfeZsa25sFRYL3bOFHpAbc59KMrjo8VBox3b0hFOVqfTLFHzCzvO/v13mSFrhncepTJjkYgVUeqQHArsXiFGgHC1vbwr2kiPU9IiGyXoP0q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824776; c=relaxed/simple;
	bh=7buMQpt9C6iDYKyZK2WHiGVM0PGKcEhwfFrBjxPI/f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbfdVoE7NmG3NyDs+qZlY51NdpAYQ6NqN76nwPRWN6qbCybtysNXml6gi6ZBN2vGAmAn5X8dk798Oawy2jMV1rq5BYS86fisxz1NF9JleHk/MwklWEUhiYb1vi4f4Q7AK2THe6VqSxkkZn4mxv7Xjgc56YEzPDwo8TgVkoJxvX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mqM7GyaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mqM7GyaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17158C4CEFB;
	Tue, 11 Nov 2025 01:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824776;
	bh=7buMQpt9C6iDYKyZK2WHiGVM0PGKcEhwfFrBjxPI/f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqM7GyaDsdzOxwXP1hsA+xFbvdXa51u73IVXXxWEwzAKmNCSY8u9Foun9FLj9VcL/
	 pvWO3oSgJWk4Cw87QPRJGt/f0QW6WKk/Qq9/pOX8yoKhMbLn7ahuWDaKum9jTGUitG
	 zwGI0VpFZAPN9WaKq6ec95svIAa2qU5c9wt2w3cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Liang <wangliang74@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 515/565] selftests: netdevsim: Fix ethtool-coalesce.sh fail by installing ethtool-common.sh
Date: Tue, 11 Nov 2025 09:46:11 +0900
Message-ID: <20251111004538.545694859@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit d01f8136d46b925798abcf86b35a4021e4cfb8bb ]

The script "ethtool-common.sh" is not installed in INSTALL_PATH, and
triggers some errors when I try to run the test
'drivers/net/netdevsim/ethtool-coalesce.sh':

  TAP version 13
  1..1
  # timeout set to 600
  # selftests: drivers/net/netdevsim: ethtool-coalesce.sh
  # ./ethtool-coalesce.sh: line 4: ethtool-common.sh: No such file or directory
  # ./ethtool-coalesce.sh: line 25: make_netdev: command not found
  # ethtool: bad command line argument(s)
  # ./ethtool-coalesce.sh: line 124: check: command not found
  # ./ethtool-coalesce.sh: line 126: [: -eq: unary operator expected
  # FAILED /0 checks
  not ok 1 selftests: drivers/net/netdevsim: ethtool-coalesce.sh # exit=1

Install this file to avoid this error. After this patch:

  TAP version 13
  1..1
  # timeout set to 600
  # selftests: drivers/net/netdevsim: ethtool-coalesce.sh
  # PASSED all 22 checks
  ok 1 selftests: drivers/net/netdevsim: ethtool-coalesce.sh

Fixes: fbb8531e58bd ("selftests: extract common functions in ethtool-common.sh")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Link: https://patch.msgid.link/20251030040340.3258110-1-wangliang74@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/netdevsim/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/drivers/net/netdevsim/Makefile b/tools/testing/selftests/drivers/net/netdevsim/Makefile
index 5bace0b7fb570..d7800f0703bcf 100644
--- a/tools/testing/selftests/drivers/net/netdevsim/Makefile
+++ b/tools/testing/selftests/drivers/net/netdevsim/Makefile
@@ -15,4 +15,8 @@ TEST_PROGS = devlink.sh \
 	tc-mq-visibility.sh \
 	udp_tunnel_nic.sh \
 
+TEST_FILES := \
+	ethtool-common.sh
+# end of TEST_FILES
+
 include ../../../lib.mk
-- 
2.51.0



