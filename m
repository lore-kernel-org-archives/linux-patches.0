Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3F426F462;
	Wed, 30 Jul 2025 09:39:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868367; cv=none; b=l+rnNyoR90jWB9kK2G0LXZridnqg7Xpx3Zgcnk0naLDeLQD5yw/t4prc51sll0P7472oRM3xi/WfrccKJ7folPbIOFu4F0pXgm6YZb8ebJ9sCR8ZvGuyFDeoFOmr/Shu+Uc48EzXSjFrjzV8J/nyMRDCe2Z39sA6eqnCZTxDuKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868367; c=relaxed/simple;
	bh=/gDcrEUrt9yfNLihPkpynrRLbnnxw0oymohmiYp9tJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VU5Pntxwr+iQIvwFNtgnDUG2X5gc05YNbn5Uwdzx6pOcQCja7e8BQor4gj8W3UG5TqZe8MiX2r6+iyLKYWmNsaIV8Lus3sfI37Rz284GShgN+W7+KnwH8VYFw/hKfE2DbC1DbFy+72VY9guaXptzdW8fMsuHDoxi6Qf6E9v0dhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lO8s6eBU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lO8s6eBU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB750C4CEFF;
	Wed, 30 Jul 2025 09:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868367;
	bh=/gDcrEUrt9yfNLihPkpynrRLbnnxw0oymohmiYp9tJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lO8s6eBUwzCUh5Ok8bHCRSBEiTPRffTBKUnkRvW1mv3qdfiOp8uNcK2kDGmYv4d1a
	 +sv30dO8YQM2xoJ4bdFxSYHE8m39sOMcst0O8bly9H7nCsKOoStpgVBPiHU0eoyhtR
	 GlX6dxbxVTdeGuWN41aCeabvNa52vQh9nBBbtISw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 46/76] selftests: mptcp: connect: also cover checksum
Date: Wed, 30 Jul 2025 11:35:39 +0200
Message-ID: <20250730093228.626592458@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/Makefile                  |    2 +-
 tools/testing/selftests/net/mptcp/mptcp_connect_checksum.sh |    5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect_checksum.sh

--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -5,7 +5,7 @@ top_srcdir = ../../../../..
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
 
 TEST_PROGS := mptcp_connect.sh mptcp_connect_mmap.sh mptcp_connect_sendfile.sh \
-	      pm_netlink.sh mptcp_join.sh diag.sh \
+	      mptcp_connect_checksum.sh pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh mptcp_sockopt.sh userspace_pm.sh
 
 TEST_GEN_FILES = mptcp_connect pm_nl_ctl mptcp_sockopt mptcp_inq
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect_checksum.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+MPTCP_LIB_KSFT_TEST="$(basename "${0}" .sh)" \
+	"$(dirname "${0}")/mptcp_connect.sh" -C "${@}"


