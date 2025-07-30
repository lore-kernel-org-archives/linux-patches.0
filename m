Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80BF28751E;
	Wed, 30 Jul 2025 09:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869253; cv=none; b=j+55ONCmRjS2IKOxCkF8KKjFLKk79nKDv1bVr1M5AFA466H88ObRHc5u77DLno7uyd/bl40Xg3QExjn01Lk5bPU6UEYljsdj41f7B9T/cY4JQT7wIrh56sMJU2DnyOi0GjGnLX4nJskJI4vOkjcDsF7XOujhmOoZKVexydt6Yiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869253; c=relaxed/simple;
	bh=Bla+K5SgDprZaR4xR362QTRGa5lfgdv4+9QJ8/7u6VY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iqaMj9pkMlGg7ZNdQRZJOofoD1zhQCjDjbT5huCMG73t+eEdmEHbGDqat3C/VO4SsVdiFD2/0Fjq/pJrd4fVHtDPeNruBnl+oNXcfPnIaIxHjzCSM+Hb2XX2UYIK/LS5gl+6548ov3yT/N5EWLRGdOT0RCA85e6mLOxtX1yX+bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2RcReM37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2RcReM37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED03C4CEF9;
	Wed, 30 Jul 2025 09:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869253;
	bh=Bla+K5SgDprZaR4xR362QTRGa5lfgdv4+9QJ8/7u6VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2RcReM37u4oOQnnQuWecouDqFCzO+8KdGNqnQps+xTaDcVzzogOPfMHAPRzReWT9G
	 8Cvy4VkNoNDQ0QvMrMcs+nV5PVQMLxGPLOjCxTLhuI+qp3puvxT/hVZ68ttV8YSTe0
	 E8UsF5oKwch/OxI32z1BtjSif7+g2FrdtvzzgnxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 75/92] selftests: mptcp: connect: also cover alt modes
Date: Wed, 30 Jul 2025 11:36:23 +0200
Message-ID: <20250730093233.663151102@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 37848a456fc38c191aedfe41f662cc24db8c23d9 upstream.

The "mmap" and "sendfile" alternate modes for mptcp_connect.sh/.c are
available from the beginning, but only tested when mptcp_connect.sh is
manually launched with "-m mmap" or "-m sendfile", not via the
kselftests helpers.

The MPTCP CI was manually running "mptcp_connect.sh -m mmap", but not
"-m sendfile". Plus other CIs, especially the ones validating the stable
releases, were not validating these alternate modes.

To make sure these modes are validated by these CIs, add two new test
programs executing mptcp_connect.sh with the alternate modes.

Fixes: 048d19d444be ("mptcp: add basic kselftest for mptcp")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250715-net-mptcp-sft-connect-alt-v2-1-8230ddd82454@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/Makefile                  |    3 ++-
 tools/testing/selftests/net/mptcp/mptcp_connect_mmap.sh     |    5 +++++
 tools/testing/selftests/net/mptcp/mptcp_connect_sendfile.sh |    5 +++++
 3 files changed, 12 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect_mmap.sh
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect_sendfile.sh

--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -4,7 +4,8 @@ top_srcdir = ../../../../..
 
 CFLAGS += -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
 
-TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh \
+TEST_PROGS := mptcp_connect.sh mptcp_connect_mmap.sh mptcp_connect_sendfile.sh \
+	      pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh mptcp_sockopt.sh userspace_pm.sh
 
 TEST_GEN_FILES = mptcp_connect pm_nl_ctl mptcp_sockopt mptcp_inq mptcp_diag
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect_mmap.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+MPTCP_LIB_KSFT_TEST="$(basename "${0}" .sh)" \
+	"$(dirname "${0}")/mptcp_connect.sh" -m mmap "${@}"
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect_sendfile.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+MPTCP_LIB_KSFT_TEST="$(basename "${0}" .sh)" \
+	"$(dirname "${0}")/mptcp_connect.sh" -m sendfile "${@}"


