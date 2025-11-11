Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5AEA306B39;
	Tue, 11 Nov 2025 01:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823885; cv=none; b=k4aHWs4V3hmq/F6ogYsE5u6xSZJ5wh2jUnrV4aM0MCmi6HPzlleNnBB/9t/qBTv44mmVjOU9dVTsi2OzdQ/6H3r1krM/mcPBCWH5PTgKvctW1vvfJDrw0HtYMr5XX3KZ4a2O8eUb5YTozhXCLo9f/8PWRpL66KN0+dcOpfDTCj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823885; c=relaxed/simple;
	bh=RouH9wHRR+vd0fYLPmi2Kb3MmVQrPT5JY++AH+DEA1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FycEq3SEMGEP6rfdekJTyxLdnj6a5XSwhpIYgDNZO5Bk6wfpf+Q1JKpNIMHPXP6R4BneHYHeoLFulQLE3wAiOS1EVp/vLw1K70Tos4SFbE6FxJAB6QWcduGx37j+JUWtFcqceMHJms8H5ZvyfGeHJbsKagiuMKjfQchHCieEWBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTiYAe44; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTiYAe44"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD58C19424;
	Tue, 11 Nov 2025 01:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823885;
	bh=RouH9wHRR+vd0fYLPmi2Kb3MmVQrPT5JY++AH+DEA1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTiYAe44/CvlA34IHucWrapPG1mV8ibhAoJUzQbxJW6HyziFIXdk+LU0I5xC5br0M
	 8X4+kBkwZH69lm3SE6lZiOUheXDE1X16Gwki3gxIBQf/eM48/0VsS23iWjzZGENbf0
	 l2wKITAGG+CjiI2vkJWaO6cI1tqvSB3z2OCAgoc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 343/565] selftests: Disable dad for ipv6 in fcnal-test.sh
Date: Tue, 11 Nov 2025 09:43:19 +0900
Message-ID: <20251111004534.593050614@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Ahern <dsahern@kernel.org>

[ Upstream commit 53d591730ea34f97a82f7ec6e7c987ca6e34dc21 ]

Constrained test environment; duplicate address detection is not needed
and causes races so disable it.

Signed-off-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250910025828.38900-1-dsahern@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/fcnal-test.sh | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 46324e73f5035..a7edf43245c2a 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -424,6 +424,8 @@ create_ns()
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0
 }
 
 # create veth pair to connect namespaces and apply addresses.
-- 
2.51.0



