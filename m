Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBA61C6AB;
	Mon,  4 Mar 2024 21:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589324; cv=none; b=n+/uXDjjGt6iWogZYWCzK/PudBhHycdzuNjuLJwRWYV1GtA3VkFNQ3C2LVhNKlNFa6i7QxUUmKSLabL+gmqVPPV6LAICyFGI4hEB3KZIVSjf5UMnRwTBK1mrUVSyq7xCaE5Ofb3cVbIctYSZQgYStpoFh58L333P18v3CwXDl3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589324; c=relaxed/simple;
	bh=FAS7D6a+1c61wdeF+14zWCZZFlDFJg8tz9Sui3F9dno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQRmyqjHKFjn7M2JrsPUF2WhWkGtB/+vDYH9GysVYTjRnHvsgXfB7qw9OvStcZiql0KIiaRweCl6+fqv+CiJU9DDnBEP6rl8wjQ5OaToTur9uxhRtwJPD3j6gx8k2IE/XsGFOLWgmjk7dFM0hP7ocv5btjXUEEf+toaJQqv80mA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCAFWnQf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCAFWnQf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5108DC433C7;
	Mon,  4 Mar 2024 21:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589324;
	bh=FAS7D6a+1c61wdeF+14zWCZZFlDFJg8tz9Sui3F9dno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCAFWnQfX15wHcEEsTBaUpod6J9feDkqoz4KsY4ZavODSE/+Lf7+RagdsjPxFwI37
	 pT3T/C3IBKLBp/Gv1nbklsao+NtL8PKUWzCgF1XhA82+IIqoyKMUtkLxEB1CN+7t08
	 y6lLFDU2jYNiRvEolAwLCH/Q5Cf1RCzBm0hgyzJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 65/84] selftests: mptcp: add missing kconfig for NF Filter in v6
Date: Mon,  4 Mar 2024 21:24:38 +0000
Message-ID: <20240304211544.561860475@linuxfoundation.org>
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
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -18,3 +18,4 @@ CONFIG_NETFILTER_XT_MATCH_BPF=m
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NF_TABLES_IPV6=y
 CONFIG_IP_NF_FILTER=m
+CONFIG_IP6_NF_FILTER=m


