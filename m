Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9EF379975;
	Thu, 15 Jan 2026 17:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496408; cv=none; b=CnOQH/w089eXMyu3a8AUyOiqr+Dk6gCAWvn30AWbhk/rOTu0VLiU4PtAFL2CyuPXMqvA9sO9uThquxGdb9q+ZHhK1BuNzy4uof42m+u8BK9aJkvg3dhG8qipASx4MF6m2he9xAMtZCXSWUnA6kXs/jWXxs/aIr9WLUJdfxVAw+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496408; c=relaxed/simple;
	bh=28B5FrkxaveGDFngIjdkENuZy27Y1fBNLPletrmRSnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmFo0MdDJX0SGSKY/kRI7ap3KjwCoGpYVTNFr3zOg0ocQPFvWKH765iOpY0jPNcnlkZRPEjSoY0Poka0WXYYta3R1QAXPRIkveKd/q1frKPtbAF5t72hgM8UXdRlozzO3odt6xpHeapyjEtHAw6NDGKzJzPUfLwsPDbpUoa/3mY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XIB0tG6p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XIB0tG6p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7F8C116D0;
	Thu, 15 Jan 2026 17:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496408;
	bh=28B5FrkxaveGDFngIjdkENuZy27Y1fBNLPletrmRSnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XIB0tG6psh6t0NRGCh8EgLRFsc7sjmsB8n2XQohgGfw+IkGdNEGFISYYTus3TalIc
	 RoFbfFtUH4meMziRWkeovyaz9L4otnVGEQ0ZDS+kSKfbT+gvf9uuVBX/pkioMkI/fA
	 KUvazWdo+GVcwTX4gcBm95hWa1ybe+yLo6mIAgOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nimrod Oren <noren@nvidia.com>,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/181] selftests: drv-net: Bring back tool() to driver __init__s
Date: Thu, 15 Jan 2026 17:47:58 +0100
Message-ID: <20260115164207.407548802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 353cfc0ef3f34ef7fe313ae38dac37f2454a7cf5 ]

The pp_alloc_fail.py test (which doesn't run in NIPA CI?) uses tool, add
back the import.

Resolves:
  ImportError: cannot import name 'tool' from 'lib.py'

Fixes: 68a052239fc4 ("selftests: drv-net: update remaining Python init files")
Reviewed-by: Nimrod Oren <noren@nvidia.com>
Signed-off-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20260105163319.47619-1-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/hw/lib/py/__init__.py | 4 ++--
 tools/testing/selftests/net/lib/py/__init__.py            | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/lib/py/__init__.py b/tools/testing/selftests/drivers/net/hw/lib/py/__init__.py
index fb010a48a5a19..a86f5c311fdcb 100644
--- a/tools/testing/selftests/drivers/net/hw/lib/py/__init__.py
+++ b/tools/testing/selftests/drivers/net/hw/lib/py/__init__.py
@@ -22,7 +22,7 @@ try:
         NlError, RtnlFamily, DevlinkFamily, PSPFamily
     from net.lib.py import CmdExitFailure
     from net.lib.py import bkg, cmd, bpftool, bpftrace, defer, ethtool, \
-        fd_read_timeout, ip, rand_port, wait_port_listen, wait_file
+        fd_read_timeout, ip, rand_port, wait_port_listen, wait_file, tool
     from net.lib.py import KsftSkipEx, KsftFailEx, KsftXfailEx
     from net.lib.py import ksft_disruptive, ksft_exit, ksft_pr, ksft_run, \
         ksft_setup
@@ -37,7 +37,7 @@ try:
                "CmdExitFailure",
                "bkg", "cmd", "bpftool", "bpftrace", "defer", "ethtool",
                "fd_read_timeout", "ip", "rand_port",
-               "wait_port_listen", "wait_file",
+               "wait_port_listen", "wait_file", "tool",
                "KsftSkipEx", "KsftFailEx", "KsftXfailEx",
                "ksft_disruptive", "ksft_exit", "ksft_pr", "ksft_run",
                "ksft_setup",
diff --git a/tools/testing/selftests/net/lib/py/__init__.py b/tools/testing/selftests/net/lib/py/__init__.py
index 97b7cf2b20eb9..8f2da17d53510 100644
--- a/tools/testing/selftests/net/lib/py/__init__.py
+++ b/tools/testing/selftests/net/lib/py/__init__.py
@@ -12,7 +12,7 @@ from .ksft import KsftFailEx, KsftSkipEx, KsftXfailEx, ksft_pr, ksft_eq, \
 from .netns import NetNS, NetNSEnter
 from .nsim import NetdevSim, NetdevSimDev
 from .utils import CmdExitFailure, fd_read_timeout, cmd, bkg, defer, \
-    bpftool, ip, ethtool, bpftrace, rand_port, wait_port_listen, wait_file
+    bpftool, ip, ethtool, bpftrace, rand_port, wait_port_listen, wait_file, tool
 from .ynl import NlError, YnlFamily, EthtoolFamily, NetdevFamily, RtnlFamily, RtnlAddrFamily
 from .ynl import NetshaperFamily, DevlinkFamily, PSPFamily
 
@@ -25,7 +25,7 @@ __all__ = ["KSRC",
            "NetNS", "NetNSEnter",
            "CmdExitFailure", "fd_read_timeout", "cmd", "bkg", "defer",
            "bpftool", "ip", "ethtool", "bpftrace", "rand_port",
-           "wait_port_listen", "wait_file",
+           "wait_port_listen", "wait_file", "tool",
            "NetdevSim", "NetdevSimDev",
            "NetshaperFamily", "DevlinkFamily", "PSPFamily", "NlError",
            "YnlFamily", "EthtoolFamily", "NetdevFamily", "RtnlFamily",
-- 
2.51.0



