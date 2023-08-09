Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FC517AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422B4C433C7;
	Wed,  9 Aug 2023 11:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581114;
	bh=7T0JucRwyr7f6pc+4XRNiKVYEA/e3rkZKfiDFNsQgM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruUKf+EdbwQ6BKW6wXiZippZZ4pL54rrpZ72BG8CFNOJp5d+aTsJY7SK/tCv4jUQ1
	 nuiSCl7j+Gp/jK7YR2J+D/ej7uyUGOQFqJh4sqF8W0kbLrg12agqiWq0BWBspyAJJR
	 4413fqqH7blpAQz6gVLjHANixYSB86Ums6it3YZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthieu Baerts <matthieu.baerts@tessares.net>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 110/201] selftests: mptcp: depend on SYN_COOKIES
Date: Wed,  9 Aug 2023 12:41:52 +0200
Message-ID: <20230809103647.479286395@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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
@@ -6,3 +6,4 @@ CONFIG_INET_DIAG=m
 CONFIG_INET_MPTCP_DIAG=m
 CONFIG_VETH=y
 CONFIG_NET_SCH_NETEM=m
+CONFIG_SYN_COOKIES=y


