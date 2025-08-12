Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE9462D9EF3;
	Tue, 12 Aug 2025 17:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020303; cv=none; b=Hoath/HHwtZQAfYEQ256+1PXvB2fw9FvEYPdGC6WyUtTbg3XuxYW/N5mX7090q+gZ7TS4XA4njpnPhZfmEeke+VDr088VOrI0DjwlyR4YcvsUpiOCTTQm1R/b61MXIkjrmaO6zDTgiQb3HXCVusQezQdbQw6NFuoA7QsbSymyCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020303; c=relaxed/simple;
	bh=MeaiD6BgFjcYSl5b0SSdkFd2ugKRsTVn7rULS3ogHR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIH8n8tTgFiZeSYwUCxMMxGiFGLYZeS3VcSqTB3fib3Mn5DgSiOjuX9zTMs+9UhJbo/GMBJOL+cq9WUV1Y7D1dwWw2mBdAlBTO1WvT7osk+f33+KiPAOnyxDv7INgddrklf1lkRu6p6VqgqOtn0TkucWFPwjPRkZ/oTtQPflVN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVDyJnFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVDyJnFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7921CC4CEF0;
	Tue, 12 Aug 2025 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020302;
	bh=MeaiD6BgFjcYSl5b0SSdkFd2ugKRsTVn7rULS3ogHR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OVDyJnFiEEcFkqjH3jdNWPyCcU82zQRw3mzWK0aXmbatQMs2g3gx06D/Excakwz0E
	 eoRGuYNV9PIgWslpERH1q3tXUZmWPSCjGkDTgEYAfA0DSuIn6ahgStgJNqWQb8ViFm
	 NQVevakTP2Q/4tFpqHVSNp3neyWTluV7LRohWu7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 040/253] selftests: mptcp: connect: also cover alt modes
Date: Tue, 12 Aug 2025 19:27:08 +0200
Message-ID: <20250812172950.440467394@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
 
-TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh \
+TEST_PROGS := mptcp_connect.sh mptcp_connect_mmap.sh mptcp_connect_sendfile.sh \
+	      pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh mptcp_sockopt.sh userspace_pm.sh
 
 TEST_GEN_FILES = mptcp_connect pm_nl_ctl mptcp_sockopt mptcp_inq
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


