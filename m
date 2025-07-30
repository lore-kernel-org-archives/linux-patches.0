Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41EE275AE9;
	Wed, 30 Jul 2025 09:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869256; cv=none; b=iUK/Log2bjj+AP3PvVlmkN1dTzBqvvdB9zTFlkf1OJ5TTrAt2NATSKD0T2svzEnEjn4qUhOppwLh5uqHjflggP+AxLcE1DGHeonIzwaxbLEO843xLh3lBiq/sDvKWP1ck98hPpu7wnDcLcJWsLXSlXkPfVW1ls8D/fmBDF6XNCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869256; c=relaxed/simple;
	bh=kf5m3p7O/XxnWyOSdDYhKpBpdFinr19TNZT3cVEJD3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=avkRh9/Zc3iF59zsVSxGXyhR6AL/BeqgDBdIbOHZkibNQtwn/7uWShQz3EkHunj57VgIf/FwuIiLYd35fAZoX3U2l9hiu0efmgIF2aWmur11+pbz3yYkIWqMteMiaCaew9H7cSgx82KINEBpkwnKDOnE0An5JbLPrzwvZon/qLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFYlX6OC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFYlX6OC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24335C4CEF5;
	Wed, 30 Jul 2025 09:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869256;
	bh=kf5m3p7O/XxnWyOSdDYhKpBpdFinr19TNZT3cVEJD3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFYlX6OCnIiBWQbv5AAXMmmCBe13igxV7H6Tiy3b9xOb+u7MsuX6g7KlBiTTy2os9
	 opb2q7SI6QTA4twbn418EtLdbYvG1xR4I4wqh0/P/+dVrf1t8Peu7LKF8CBWQnGlzl
	 RlJowEnmRkDvN2JJ0pKTpUcnHaoeLhUyOKMNdyXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 76/92] selftests: mptcp: connect: also cover checksum
Date: Wed, 30 Jul 2025 11:36:24 +0200
Message-ID: <20250730093233.700145477@linuxfoundation.org>
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
 CFLAGS += -Wall -Wl,--no-as-needed -O2 -g -I$(top_srcdir)/usr/include $(KHDR_INCLUDES)
 
 TEST_PROGS := mptcp_connect.sh mptcp_connect_mmap.sh mptcp_connect_sendfile.sh \
-	      pm_netlink.sh mptcp_join.sh diag.sh \
+	      mptcp_connect_checksum.sh pm_netlink.sh mptcp_join.sh diag.sh \
 	      simult_flows.sh mptcp_sockopt.sh userspace_pm.sh
 
 TEST_GEN_FILES = mptcp_connect pm_nl_ctl mptcp_sockopt mptcp_inq mptcp_diag
--- /dev/null
+++ b/tools/testing/selftests/net/mptcp/mptcp_connect_checksum.sh
@@ -0,0 +1,5 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+MPTCP_LIB_KSFT_TEST="$(basename "${0}" .sh)" \
+	"$(dirname "${0}")/mptcp_connect.sh" -C "${@}"


