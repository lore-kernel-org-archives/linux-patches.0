Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F87427F1D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0977C433C8;
	Fri, 21 Jul 2023 18:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965375;
	bh=wYrqmWgN19T5t7BD4m3fsxuRLxtBHhazbVunZU+MTQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9a1YpKofSh4bW0vNkzGg2UUe9qd9dCxuo8WtUpGsXKJfYLcVzokqT1IRVOdqs2iA
	 IPubw0bpgS2JK8SAs9rAapRfe5iBr4se7wUjsgZMDlbgapyw3ppPu6a70DMeKRqGPB
	 Z1X2Cp3a9II4vAYJsMNgJpOBfB1oumEBKJoe9f04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.4 266/292] selftests: mptcp: depend on SYN_COOKIES
Date: Fri, 21 Jul 2023 18:06:15 +0200
Message-ID: <20230721160540.357242758@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthieu Baerts <matthieu.baerts@tessares.net>

commit 6c8880fcaa5c45355179b759c1d11737775e31fc upstream.

MPTCP selftests are using TCP SYN Cookies for quite a while now, since
v5.9.

Some CIs don't have this config option enabled and this is causing
issues in the tests:

  # ns1 MPTCP -> ns1 (10.0.1.1:10000      ) MPTCP     (duration   167ms) sysctl: cannot stat /proc/sys/net/ipv4/tcp_syncookies: No such file or directory
  # [ OK ]./mptcp_connect.sh: line 554: [: -eq: unary operator expected

There is no impact in the results but the test is not doing what it is
supposed to do.

Fixes: fed61c4b584c ("selftests: mptcp: make 2nd net namespace use tcp syn cookies unconditionally")
Cc: stable@vger.kernel.org
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -6,6 +6,7 @@ CONFIG_INET_DIAG=m
 CONFIG_INET_MPTCP_DIAG=m
 CONFIG_VETH=y
 CONFIG_NET_SCH_NETEM=m
+CONFIG_SYN_COOKIES=y
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NETFILTER_NETLINK=m


