Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 304D015E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5emwczf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE33C433C9;
	Mon, 23 Oct 2023 11:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060925;
	bh=Ry11/joSiPX+mAzxxo4R4o48hY2zzOJFtEDq5Wcln+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5emwczfVmZ68Asm24tUJSonVyQUQI5QbSR2v1truKsMi/Tvz4emEHqRTRVpeSfcL
	 Vo7eRDkzjK6ZiOjPzpVfMdXo4eWN7icl0wL3eyVAAM9ANrH2pFbXgsvxl+14LWf+K8
	 XDHhUrwyrFZtXi6srI6I+swQSSVbCcH+f2ahIQrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.15 002/137] Documentation: sysctl: align cells in second content column
Date: Mon, 23 Oct 2023 12:55:59 +0200
Message-ID: <20231023104820.941750775@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bagas Sanjaya <bagasdotme@gmail.com>

commit 1faa34672f8a17a3e155e74bde9648564e9480d6 upstream.

Stephen Rothwell reported htmldocs warning when merging net-next tree:

Documentation/admin-guide/sysctl/net.rst:37: WARNING: Malformed table.
Text in column margin in table line 4.

========= =================== = ========== ==================
Directory Content               Directory  Content
========= =================== = ========== ==================
802       E802 protocol         mptcp     Multipath TCP
appletalk Appletalk protocol    netfilter Network Filter
ax25      AX25                  netrom     NET/ROM
bridge    Bridging              rose      X.25 PLP layer
core      General parameter     tipc      TIPC
ethernet  Ethernet protocol     unix      Unix domain sockets
ipv4      IP version 4          x25       X.25 protocol
ipv6      IP version 6
========= =================== = ========== ==================

The warning above is caused by cells in second "Content" column of
/proc/sys/net subdirectory table which are in column margin.

Align these cells against the column header to fix the warning.

Link: https://lore.kernel.org/linux-next/20220823134905.57ed08d5@canb.auug.org.au/
Fixes: 1202cdd665315c ("Remove DECnet support from kernel")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Link: https://lore.kernel.org/r/20220824035804.204322-1-bagasdotme@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/sysctl/net.rst |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -31,18 +31,18 @@ see only some of them, depending on your
 
 Table : Subdirectories in /proc/sys/net
 
- ========= =================== = ========== ==================
+ ========= =================== = ========== ===================
  Directory Content               Directory  Content
- ========= =================== = ========== ==================
- 802       E802 protocol         mptcp     Multipath TCP
- appletalk Appletalk protocol    netfilter Network Filter
+ ========= =================== = ========== ===================
+ 802       E802 protocol         mptcp      Multipath TCP
+ appletalk Appletalk protocol    netfilter  Network Filter
  ax25      AX25                  netrom     NET/ROM
- bridge    Bridging              rose      X.25 PLP layer
- core      General parameter     tipc      TIPC
- ethernet  Ethernet protocol     unix      Unix domain sockets
- ipv4      IP version 4          x25       X.25 protocol
+ bridge    Bridging              rose       X.25 PLP layer
+ core      General parameter     tipc       TIPC
+ ethernet  Ethernet protocol     unix       Unix domain sockets
+ ipv4      IP version 4          x25        X.25 protocol
  ipv6      IP version 6
- ========= =================== = ========== ==================
+ ========= =================== = ========== ===================
 
 1. /proc/sys/net/core - Network core options
 ============================================


