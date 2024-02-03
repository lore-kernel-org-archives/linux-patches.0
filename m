Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723E0175A6;
	Sat,  3 Feb 2024 04:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933973; cv=none; b=reHRFfjn47rsgIjFzac5tjgybyrPcvIeaIq74715zpBI+1BjeVIAHsRm1SY3nMWHm8HlApfhYXI8b+LKpKp3X4/svdCSXkW9nyfQz5MSWdqpC2o0ykvpzj/ht56V2Ei0mEsfkE+D91hY1d+kBNaD6zqgGMjhNF9J44xqUUhDO8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933973; c=relaxed/simple;
	bh=OHfwsQAQfDSOx+BOSxPD0zrDjh1OqBPYD+SEw99v49Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RS72R9jBA3z4TGBMt1rrjfHgRUt7XY74ewMn8mFZm0kx4zQH/9PMPeeV4I7OeTJXwx13BdnxJkBqtC6DrfOy1Vjh1A6oCLOFH176kBNAnTICErrlYgfA/sYtmo8I9Nuw/U2nIR8VlajTuSlhJ29oW8u5XSBFMLL7sn6E4eo7R+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kImF32F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kImF32F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3946DC433F1;
	Sat,  3 Feb 2024 04:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933973;
	bh=OHfwsQAQfDSOx+BOSxPD0zrDjh1OqBPYD+SEw99v49Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kImF32FzCtGSw1jKKQEwwiP2ypdFDov9PakOkvJ3OpYm5UHhWwU7fy7lf/UMeWb6
	 e44gPIcYfMs6bMYfRznIUw38t6SpJ5hDPuXm/l64JT+Nz+xQYOxOLkmNDjGM6JQnzK
	 sBCPNgXCdSLGOM7T3s5p0LopIqshX45kHo3bn9OI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 346/353] selftests: net: enable some more knobs
Date: Fri,  2 Feb 2024 20:07:44 -0800
Message-ID: <20240203035414.701495761@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit c15a729c9d45aa142fb01a3afee822ab1f0e62a8 ]

The rtnetlink tests require additional options currently
off by default.

Fixes: 2766a11161cc ("selftests: rtnetlink: add ipsec offload API test")
Fixes: 5e596ee171ba ("selftests: add xfrm state-policy-monitor to rtnetlink.sh")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Link: https://lore.kernel.org/r/9048ca58e49b962f35dba1dfb2beaf3dab3e0411.1706723341.git.pabeni@redhat.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 24a7c7bcbbc1..3b749addd364 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -22,6 +22,8 @@ CONFIG_VLAN_8021Q=y
 CONFIG_GENEVE=m
 CONFIG_IFB=y
 CONFIG_INET_DIAG=y
+CONFIG_INET_ESP=y
+CONFIG_INET_ESP_OFFLOAD=y
 CONFIG_IP_GRE=m
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
@@ -93,3 +95,4 @@ CONFIG_IP_SCTP=m
 CONFIG_NETFILTER_XT_MATCH_POLICY=m
 CONFIG_CRYPTO_ARIA=y
 CONFIG_XFRM_INTERFACE=m
+CONFIG_XFRM_USER=m
-- 
2.43.0



