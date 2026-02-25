Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7AB30EF6D;
	Wed, 25 Feb 2026 06:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002715; cv=none; b=epdOh1I0kRyBMApKHikUwlEdtzTAWHbg9xp7CA04L6uFPI3TSsAGFUpm1j6bSiy0EdBeiFZK/Ho8V6uWaPO/KYQJD8s5PFvEL1QHOfQSwvyE3ltYN74oZu+pgc5sA2dZqItiXY0cu10eRGgP6PeXc/UKVN1HtQCftwYmMDqLSks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002715; c=relaxed/simple;
	bh=uoaTHn+Xht+9l39/MR7PSPZ8YJnl2OUr9GLh6H71OMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BpPF4IPGeqE3FNDjA9V8n1eU+iir5gir8A05G1BzQ0sXrvzUdLcmpEeK6cj1paiaHktrQ8drPgOnj351b/ukqT6IUVYMWiY7mAglvGZjaGrDHL7it35d3oM/kOeDQZskabmqQbBzC3svYGmaPHLSJNv9YfHTIZ+QltrjvHAGuhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVgmhO1N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVgmhO1N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66C6C116D0;
	Wed, 25 Feb 2026 06:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002715;
	bh=uoaTHn+Xht+9l39/MR7PSPZ8YJnl2OUr9GLh6H71OMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVgmhO1NhFH3+1niX5ZQkdymdIAKs0mH09TJhxbjLVl53FzdBGFugJTnmlWZ/We1k
	 6twW1yxGDpJxMl5ftgupOFEGjq3IGAvLNP2kjpuKDksgCtNsPx7KhW7CTeBZGrMb/6
	 rgn7cLZx/gJQpokBqJ7182F9ZGRw74nRLuXSn0zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Carvalho <asantostc@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 522/641] selftests: netconsole: remove log noise due to socat exit
Date: Tue, 24 Feb 2026 17:24:08 -0800
Message-ID: <20260225012401.177378002@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Andre Carvalho <asantostc@gmail.com>

[ Upstream commit e3b8cbf40c6e60a7a935bd8980884d5741a7a77b ]

This removes some noise that can be distracting while looking at
selftests by redirecting socat stderr to /dev/null.

Before this commit, netcons_basic would output:

Running with target mode: basic (ipv6)
2025/11/29 12:08:03 socat[259] W exiting on signal 15
2025/11/29 12:08:03 socat[271] W exiting on signal 15
basic : ipv6 : Test passed
Running with target mode: basic (ipv4)
2025/11/29 12:08:05 socat[329] W exiting on signal 15
2025/11/29 12:08:05 socat[322] W exiting on signal 15
basic : ipv4 : Test passed
Running with target mode: extended (ipv6)
2025/11/29 12:08:08 socat[386] W exiting on signal 15
2025/11/29 12:08:08 socat[386] W exiting on signal 15
2025/11/29 12:08:08 socat[380] W exiting on signal 15
extended : ipv6 : Test passed
Running with target mode: extended (ipv4)
2025/11/29 12:08:10 socat[440] W exiting on signal 15
2025/11/29 12:08:10 socat[435] W exiting on signal 15
2025/11/29 12:08:10 socat[435] W exiting on signal 15
extended : ipv4 : Test passed

After these changes, output looks like:

Running with target mode: basic (ipv6)
basic : ipv6 : Test passed
Running with target mode: basic (ipv4)
basic : ipv4 : Test passed
Running with target mode: extended (ipv6)
extended : ipv6 : Test passed
Running with target mode: extended (ipv4)
extended : ipv4 : Test passed

Signed-off-by: Andre Carvalho <asantostc@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251129-netcons-socat-noise-v1-1-605a0cea8fca@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a68a9bd086c2 ("selftests: netconsole: Increase port listening timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh b/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh
index 87f89fd92f8c1..ae8abff4be409 100644
--- a/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh
+++ b/tools/testing/selftests/drivers/net/lib/sh/lib_netcons.sh
@@ -249,7 +249,7 @@ function listen_port_and_save_to() {
 
 	# Just wait for 2 seconds
 	timeout 2 ip netns exec "${NAMESPACE}" \
-		socat "${SOCAT_MODE}":"${PORT}",fork "${OUTPUT}"
+		socat "${SOCAT_MODE}":"${PORT}",fork "${OUTPUT}" 2> /dev/null
 }
 
 # Only validate that the message arrived properly
-- 
2.51.0



