Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A7134F487;
	Fri, 21 Nov 2025 13:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732719; cv=none; b=txco4xleGQVTZjOh9Wfpo2j5YqXTN9FX4D6ErwjXTZsc0RqpFyb5cuia5mkMyPB3rnW2ExVtcBzbzE61mLfYtYY2KNvloDVP/S36s/CRLz3tGt8JqWrSjX86nVVR1F6EqvXRBV/VRwiZqdMac7MGvqTpuO1Tdx4MdDc8TCGHd5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732719; c=relaxed/simple;
	bh=KJa37Lx7OeIhv2xG4sd1sTfpgeYynbH+OfdJXWNHEF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ba3T9jTS4wXM7ClH+YSs8+sS+Dsngj/4GNTHTkmK/qNq3yjpgHaVp6l5IhZOPadbUTQ53VtbhYP8x90NVIbqZTAXsi9664zYRzuYgtDpUg4QcEMEf38ItYD5vOU1+JW8rpTfYRDPsXZq0+TJ9921xc9riLR/IQ3Rqh94x99jJl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3cwfZII; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3cwfZII"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C96C4CEF1;
	Fri, 21 Nov 2025 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732719;
	bh=KJa37Lx7OeIhv2xG4sd1sTfpgeYynbH+OfdJXWNHEF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3cwfZIIL4Dh03AebKCRFR7vAj5nOdddETI+13CyS8Y0fuBhhPwMXA0ttQJ23d3K2
	 oDDSKa14ofFkf0vFiG1ZCztTS4TTWkLh25OnE5XDOIMlrXK8dCCQI/q2qxGXwdcE54
	 W87/FuYgcCDUEMmrqOkeYnPiikAcIHigceOMtSLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 220/529] selftests: Disable dad for ipv6 in fcnal-test.sh
Date: Fri, 21 Nov 2025 14:08:39 +0100
Message-ID: <20251121130238.841494463@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5726975975c14..b4d7b1994091b 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -423,6 +423,8 @@ create_ns()
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.keep_addr_on_down=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.forwarding=1
 	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.forwarding=1
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.default.accept_dad=0
+	ip netns exec ${ns} sysctl -qw net.ipv6.conf.all.accept_dad=0
 }
 
 # create veth pair to connect namespaces and apply addresses.
-- 
2.51.0



