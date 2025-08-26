Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6866E352074;
	Tue, 26 Aug 2025 14:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218122; cv=none; b=O6Ptqco6qBUgB6pKKE++rvsrMbH2vmYLyV9JPKZ7grXlKjti8no1CMSpx1DZiOkN/1JhAf0lx4d0C+7+Tvq5ay7H4is/tSIOu7yZ4J5FOaeIVWoH2bTfguoTbym0NBkfJLPLTLsI3BE9WZ6egVg+J2YKvmMZ0kCPbnP96O0EDOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218122; c=relaxed/simple;
	bh=UMBWrOvMfi4K8Tyk3dsjAbBwtYKQny4NPYDGxdsWpGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LykZvOxrxt0Z2gDKkiddey7GMcK7rZcfGuqrxdL0h3GuWBX2MmLrEM+0PK5HXcaYWP7UfNpssyVJL2RuxHoiqSbQj5WNBWF6wZMRupXviODI+2TyXNBsoZP9+Qu+2j1KG4CE6k/LyBXcUg4eFPrmhj7G8Wu4RSvf40R0oO9Eoe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOI5SZkc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOI5SZkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3D1C16AAE;
	Tue, 26 Aug 2025 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218122;
	bh=UMBWrOvMfi4K8Tyk3dsjAbBwtYKQny4NPYDGxdsWpGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOI5SZkck4fkAyqhyLxifhC/UveWMi2+JGQVYP9Fs5G3Qaz9ZYAdoTKNh+dYnTcZx
	 HCY/nmg15vokN7pOOiS6U53SKFT8FhQzSaK3ePB98tP2IYSTU1uXFPdr4jkKdHs1nz
	 nvOp331f6GSQWWb5jwR6kf1DR72qG2SdSDp53Qp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/523] selftests: mptcp: connect: also cover alt modes
Date: Tue, 26 Aug 2025 13:10:10 +0200
Message-ID: <20250826110934.326834212@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ Drop userspace_pm.sh from TEST_PROGS ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
[ Drop mptcp_sockopt.sh from TEST_PROGS, and drop "sendfile" which is
  not supported in this version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/Makefile              |    3 ++-
 tools/testing/selftests/net/mptcp/mptcp_connect_mmap.sh |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)
 create mode 100755 tools/testing/selftests/net/mptcp/mptcp_connect_mmap.sh

--- a/tools/testing/selftests/net/mptcp/Makefile
+++ b/tools/testing/selftests/net/mptcp/Makefile
@@ -5,7 +5,8 @@ KSFT_KHDR_INSTALL := 1
 
 CFLAGS =  -Wall -Wl,--no-as-needed -O2 -g  -I$(top_srcdir)/usr/include
 
-TEST_PROGS := mptcp_connect.sh pm_netlink.sh mptcp_join.sh diag.sh \
+TEST_PROGS := mptcp_connect.sh mptcp_connect_mmap.sh \
+	      pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh
 
 TEST_GEN_FILES = mptcp_connect pm_nl_ctl
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect_mmap.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+MPTCP_LIB_KSFT_TEST="$(basename "${0}" .sh)" \
+	"$(dirname "${0}")/mptcp_connect.sh" -m mmap "${@}"


