Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46271509BF;
	Tue, 20 Feb 2024 21:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462914; cv=none; b=DnuWTUZJPLgdfWcimrw0tfgKGnXOEecKcKJ6Y4a5/3F2vAfLi71v3ZBK/Kl6pcHIgJLpZoUHyHvrHFVplD6/xGZxXvsSgR2tyAl1yu6o8DMLMCK40mlNTVawzxJEqvAL4Kf/bFgXcq49OqnHlpCfJukiCGGY9GmATcRik/nM1hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462914; c=relaxed/simple;
	bh=Tl05ZGhgeTha+MItdRo1KgDDdbo+JUfA/W2g2NxSTeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJYhEjRmho5OkDMgz1gOfdL4zXDONT0ZpNLlLeWSVaeucSv6hz6JOvl6aarP6ZM3ByzlNjSzr8Xy40dDLnqd1niEOi3q4fq73f7yVppdfOJSL94R9nno2zXw5Kj9ByQvy4HTQQUNyX9Bz7XkJK3VdWoDHPG7HUb19FCji05+E5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqyb81jg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqyb81jg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51CB6C433F1;
	Tue, 20 Feb 2024 21:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462913;
	bh=Tl05ZGhgeTha+MItdRo1KgDDdbo+JUfA/W2g2NxSTeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqyb81jg6zi6oP7zuxfaJ5wmdTuT2URuE8ZPYS7fJP1WiJE0PC6GHSJN1/8zAg9nb
	 D8m8tQJpgPnPjQTphbpYm9OpX/9+mist2WJChQNu6wPPzLGRI3jh+KZauPyhX9e+YK
	 mkkBIxBO7q9mVBu1MYyymHbdKvxk1x5vYj9VTfmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 069/197] selftests: mptcp: add missing kconfig for NF Filter in v6
Date: Tue, 20 Feb 2024 21:50:28 +0100
Message-ID: <20240220204843.145554012@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


