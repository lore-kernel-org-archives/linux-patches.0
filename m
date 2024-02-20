Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8472F151CE1;
	Tue, 20 Feb 2024 21:03:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463012; cv=none; b=m81IPr6yjQ0CVGbUo6Dm/dBq7eXVmk8gs6K5PJ+D3lKbBcqHYM8v7s5kFqu7qV3v7rPa8WK7qZJsyu0B3su0+S6dTKoSYlLs7WfRHsZdttQTqOE7LJu2fd7oGVHlNdW1LsNBWIXSz+Ljq6c9zgxHt1aAKCaieuRjLW8wtN3kGe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463012; c=relaxed/simple;
	bh=ifHBdjTOdqUIAynLXcoVuXyqqgZItkVNG8m9ByrJvSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAJDIyTVqJbW1ics7FCVQTzDnQ0TId67a925J5LomokHCq08WDWikizzV4Vo7V83r2iikUOGFnoblVXxAwlUw52pFepLyq/EvMh/ep2XXNHzRPEhNY0GaqIS3GfQmRZ4qcoR+WkVvTlojUvq3rpAbDSdyijE2a/oVz6vNEO898E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czmDDWHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czmDDWHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7092C433C7;
	Tue, 20 Feb 2024 21:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463012;
	bh=ifHBdjTOdqUIAynLXcoVuXyqqgZItkVNG8m9ByrJvSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czmDDWHJMq65dvPia4ct79oTYUZEY3vUVJPRlL/ng2wmGaW+pqN85274X3KESf8/N
	 SPRvwLYiaR4rmw8PgFstfh1APVLL9Ii+GT2f4vwLrfGI9Oiwm1Rml+HTyD9J6YrEAq
	 zJ7N9R5SkXKRcI/uRrY/aZhSkF0uk/GeiRDAbR6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 068/197] selftests: mptcp: add missing kconfig for NF Filter
Date: Tue, 20 Feb 2024 21:50:27 +0100
Message-ID: <20240220204843.115605906@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/net/mptcp/config |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/net/mptcp/config
+++ b/tools/testing/selftests/net/mptcp/config
@@ -22,6 +22,7 @@ CONFIG_NFT_TPROXY=m
 CONFIG_NFT_SOCKET=m
 CONFIG_IP_ADVANCED_ROUTER=y
 CONFIG_IP_MULTIPLE_TABLES=y
+CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
 CONFIG_IPV6_MULTIPLE_TABLES=y
 CONFIG_NET_ACT_CSUM=m


