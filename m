Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A8144C651;
	Thu, 30 Jul 2026 16:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427443; cv=none; b=tzl/s/fogAVx83yUNq+y511XwmrBGmEp3yA0LXXZ/Olbe//qV21dhh1W+NtsPnX3liCwnGSLFx/Q00pL/6SZE2LfdjvLDXycrSUS4KhDIgKVtkf5a0xsPqlUqxKR5BvM30OYi6uaZKh8WYuic8ySOo4b9oAF9taMHlCOaJL9tgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427443; c=relaxed/simple;
	bh=qI8blq6cu0jCgYVcAPiqgSbZgnuRkkhdNqSJDFKTdnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOyXcRFYxff5sF6lTZMbiyns3d/tDlmdomTYpDsnerEkat/X2HXy1TJDJ8chFqoZD4hMDYFIwZtrJe9aEvkX/DdOt8zcpaZiJP++2QJczYebIlFTDGqoMRsxPbayX9hrZxTNnzAV25V/9pm45yEOZKi1p6Mv9psCMcIXy9iv2ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAVU5B7u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAVU5B7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B931F000E9;
	Thu, 30 Jul 2026 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427442;
	bh=brdWHb03YTs3iGJBhzzioEqrfJK5BiE0tLLvitFutXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAVU5B7uTBWzlALHnfz0/P+A7JjvyAHQGl3o/HmEWv22QdvvxkKe2mq4Uvu55uRPq
	 DSDOiaXHBYDigvbNV5ZLUYSBdUjgLg5+T6rFxcbcpH1NMHlZryHzkhuZaSujQsJDTV
	 rBeZZAvq9fhL4Gl/nmoMPvf/ow74YVN/SWks8/pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 170/484] selftests: openvswitch: add config file
Date: Thu, 30 Jul 2026 16:11:07 +0200
Message-ID: <20260730141427.162859575@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

[ Upstream commit 441a820ccef9af80a9ac5a4c85b9c396e595967c ]

The kselftests doc mentions that a config file should be present "if a
test needs specific kernel config options enabled". This selftest
requires some kernel config, but no config file was provided.

We could say that a sub-target could use the parent's config file, but
the kselftests doc doesn't mention anything about that. Plus the
net/openvswitch target is the only net target without a config file.

Here is a new config file, which is a trimmed version of the net one,
with hopefully the minimal required kconfig on top of 'make defconfig'.

The Fixes tag points to the introduction of the net/openvswitch target,
just to help validating this target on stable kernels.

Fixes: 25f16c873fb1 ("selftests: add openvswitch selftest suite")
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Reviewed-by: Eelco Chaudron <echaudro@redhat.com>
Link: https://patch.msgid.link/20260710-net-sft-fix-containers-v1-2-a2915c294ef5@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/openvswitch/config | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)
 create mode 100644 tools/testing/selftests/net/openvswitch/config

diff --git a/tools/testing/selftests/net/openvswitch/config b/tools/testing/selftests/net/openvswitch/config
new file mode 100644
index 00000000000000..c659749cd086c7
--- /dev/null
+++ b/tools/testing/selftests/net/openvswitch/config
@@ -0,0 +1,16 @@
+CONFIG_GENEVE=m
+CONFIG_INET_DIAG=y
+CONFIG_IPV6=y
+CONFIG_NETFILTER=y
+CONFIG_NET_IPGRE=m
+CONFIG_NET_IPGRE_DEMUX=m
+CONFIG_NF_CONNTRACK=m
+CONFIG_NF_CONNTRACK_OVS=y
+CONFIG_OPENVSWITCH=m
+CONFIG_OPENVSWITCH_GENEVE=m
+CONFIG_OPENVSWITCH_GRE=m
+CONFIG_OPENVSWITCH_VXLAN=m
+CONFIG_PSAMPLE=m
+CONFIG_VETH=y
+CONFIG_VLAN_8021Q=y
+CONFIG_VXLAN=m
-- 
2.53.0



