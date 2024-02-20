Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B25E414AD15;
	Tue, 20 Feb 2024 21:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463643; cv=none; b=OnhjLND+CoIIkXn45sxvRxs+2NgDjOezC5bGj3L3KXa8kefjkViV3J0bf4mB0Fguj0sA5J1Tn2Mi0pqjz4YV6rVq+5kDyifYtMFzFvWJZNIluuv32EdVaZ1EP1T5t68zHubK5XfuhHbBZfGK7UwrkZLtZ6uqbDjA+nUYdJx9o2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463643; c=relaxed/simple;
	bh=dETlS4o6PAwMUIDHCis66ekcmMPNnEB0vKpniE2MWLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RladP+wNrV7m6cSnQZuAHgcSatgL6eDtd4r0+3tCiC8gp9eg3vvKZ/E0SOPtZFGRgrPj7wNzpYG4H7MKlr5FqOJAnR6uk6+MkHUT/2YgrW0SR1FA777y8t12KcpvfSINUzUSIkcARItcXUmmUcY6bMrLF9RwjgvJ974+/XjntEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kv68YaJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kv68YaJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 244C9C433C7;
	Tue, 20 Feb 2024 21:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463643;
	bh=dETlS4o6PAwMUIDHCis66ekcmMPNnEB0vKpniE2MWLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kv68YaJf2W8/dMmazpJnatJS78l0BgC+0nnbhuAO3N1rupzt3Rmq0NolNA+iJupR7
	 jo6pBlBXUhVLEEo4DFXLoUdSyV/B6LLU6xxjwb6Wxr0Khi1W3ujT3hLhQQCEtdqg6i
	 GpcANJyWn3QSoAMc5EYcyY9yxqdzQst58lT+6Jd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 107/331] selftests: mptcp: add missing kconfig for NF Filter in v6
Date: Tue, 20 Feb 2024 21:53:43 +0100
Message-ID: <20240220205640.962918363@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 8c86fad2cecdc6bf7283ecd298b4d0555bd8b8aa upstream.

Since the commit mentioned below, 'mptcp_join' selftests is using
IPTables to add rules to the Filter table for IPv6.

It is then required to have IP6_NF_FILTER KConfig.

This KConfig is usually enabled by default in many defconfig, but we
recently noticed that some CI were running our selftests without them
enabled.

Fixes: 523514ed0a99 ("selftests: mptcp: add ADD_ADDR IPv6 test cases")
Cc: stable@vger.kernel.org
Reviewed-by: Geliang Tang <geliang@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240131-upstream-net-20240131-mptcp-ci-issues-v1-3-4c1c11e571ff@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -25,6 +25,7 @@ CONFIG_IP_MULTIPLE_TABLES=y
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
 CONFIG_IPV6_MULTIPLE_TABLES=y
+CONFIG_IP6_NF_FILTER=m
 CONFIG_NET_ACT_CSUM=m
 CONFIG_NET_ACT_PEDIT=m
 CONFIG_NET_CLS_ACT=y


