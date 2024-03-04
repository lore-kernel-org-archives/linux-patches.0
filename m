Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DFA1C6AB;
	Mon,  4 Mar 2024 21:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589322; cv=none; b=I5BGA0TMXvMTVnHLs1hPd6UsusXUMY0E9mYx5IapA9WLoUWGjMDwMSR0+p4X6pAgCaJwNx4qyOq3QXGTxmesp/V+h9VL8ZwgtHNv/neVobvQVUgUKF9cR3yh73U0AJ83hlOI87IlXKjyH3G6mV/I3b8kDB433i4jz4vAOx6cmcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589322; c=relaxed/simple;
	bh=C1h4/x48d4Uopjz5Wwmd7+O52FbNPG0rJL0R/6atX60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c6b2QQpgkwnvR3KzzzFihWNYG8XnBhyiu2EU793Tf3ObxsOF5h/nHbaxGYmGYGg+QcAPaQxcb5fdclnAqNPyEUWW/VyiZ/DsXenOlruhpAxunHYhoU2/V9Z/O3+pnhM4A5ssoRweXwp5mPLo1uFDHAaiqg6WBQeh6uGVuN+EafQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVrLPqa7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVrLPqa7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCCEC433C7;
	Mon,  4 Mar 2024 21:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589322;
	bh=C1h4/x48d4Uopjz5Wwmd7+O52FbNPG0rJL0R/6atX60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVrLPqa7MKFoKojdUWdDXpkGClPwBkRtI9ql5HGXTlIIVlIp5bQci2utPHrO+1awh
	 56cDCtAMUXBZ25vdcrl80WzIQxfYBx0ER7SnXcUKaoe1Cko0jbVBoLIuaqYLug5raG
	 seM+DByZfn7eSegScggmY2vuhnJiKgIv2SUPlwng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 64/84] selftests: mptcp: add missing kconfig for NF Filter
Date: Mon,  4 Mar 2024 21:24:37 +0000
Message-ID: <20240304211544.521273908@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit 3645c844902bd4e173d6704fc2a37e8746904d67 upstream.

Since the commit mentioned below, 'mptcp_join' selftests is using
IPTables to add rules to the Filter table.

It is then required to have IP_NF_FILTER KConfig.

This KConfig is usually enabled by default in many defconfig, but we
recently noticed that some CI were running our selftests without them
enabled.

Fixes: 8d014eaa9254 ("selftests: mptcp: add ADD_ADDR timeout test case")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -17,3 +17,4 @@ CONFIG_NETFILTER_XTABLES=m
 CONFIG_NETFILTER_XT_MATCH_BPF=m
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NF_TABLES_IPV6=y
+CONFIG_IP_NF_FILTER=m


