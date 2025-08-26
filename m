Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FD330AAD8;
	Tue, 26 Aug 2025 14:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216817; cv=none; b=g6NG0gpfwweYLqwtRHBQshbRl5b+2wka9ylgESvsOmOK9kgNKLiB3lUx8eJRxNeUMqXDYQ9GNHBBJ4JZx8nvRqHiXE5uwzQ0ojf8oPz4v19XoPsu5i7kUx22EYSSi1TWRyXkY33dMeTRjBzcV0QyYJLPNNjYp7z7Ke/WXM1okME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216817; c=relaxed/simple;
	bh=WdHENq4MXH6gK4JKtTXf47ZCHtZeIyJxEVGH0sn0Bug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mupOXmGsunmaPAvER3AEHCNYeYJFAxt7aiy9NwomzBk3nP1YAF3igjbfE0jZq7PZpGh/6VrNvf3njMelmIhGalwTXZ06W6pkE5QN8HViz+1D0fjkUsapJVc5yJQoJG/hlrTgk2dDJT2aIWW29bv6CAjZDH3QgiVoFcQB7Mo73PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UyrlJQZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyrlJQZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD0AC4CEF1;
	Tue, 26 Aug 2025 14:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216817;
	bh=WdHENq4MXH6gK4JKtTXf47ZCHtZeIyJxEVGH0sn0Bug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UyrlJQZFSeoYh1VXEk5OnvREY9HbNpuOYXmFKVXm+4q4JoA05wxW0RyFUxR5FGzPI
	 83uluK1jAd9LgRz2SEB1qMJK6QWQHcP54yxLPBvsovgGXcJZ6pVMnrodqiaz/uBQTm
	 QwZiHMcCHrY/ty39u4nyu/2DUCzwnUa1yF/JfS8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 554/644] selftests: mptcp: connect: also cover checksum
Date: Tue, 26 Aug 2025 13:10:45 +0200
Message-ID: <20250826111000.256073947@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit fdf0f60a2bb02ba581d9e71d583e69dd0714a521 upstream.

The checksum mode has been added a while ago, but it is only validated
when manually launching mptcp_connect.sh with "-C".

The different CIs were then not validating these MPTCP Connect tests
with checksum enabled. To make sure they do, add a new test program
executing mptcp_connect.sh with the checksum mode.

Fixes: 94d66ba1d8e4 ("selftests: mptcp: enable checksum in mptcp_connect.sh")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250715-net-mptcp-sft-connect-alt-v2-2-8230ddd82454@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflict in Makefile, in the context, because userspace_pm.sh test
  has been introduced later, in commit 3ddabc433670 ("selftests: mptcp:
  validate userspace PM tests by default"), which is not in this
  version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/Makefile                  |    2 +-
 tools/testing/selftests/net/mptcp/mptcp_connect_checksum.sh |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect_checksum.sh

--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -6,7 +6,7 @@ KSFT_KHDR_INSTALL := 1
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g  -I$(top_srcdir)/usr/include
 
 TEST_PROGS := mptcp_connect.sh mptcp_connect_mmap.sh mptcp_connect_sendfile.sh \
-	      pm_netlink.sh mptcp_join.sh diag.sh \
+	      mptcp_connect_checksum.sh pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh mptcp_sockopt.sh
 
 TEST_GEN_FILES = mptcp_connect pm_nl_ctl
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect_checksum.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+MPTCP_LIB_KSFT_TEST="$(basename "${0}" .sh)" \
+	"$(dirname "${0}")/mptcp_connect.sh" -C "${@}"


