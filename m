Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3063C429802;
	Thu, 30 Jul 2026 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421959; cv=none; b=KQXsbxNd48sej56F9lQEWHk86QrFa6PI9px5KSy9NpsVDHLWA+hujZFrm5XA1kexr9FV96OW5dCTuTgq+gdtFLPFMd4CHqi1PsY3uFrudW4N7tNFjhN2BL3QTyKt5Q9T2QuCiIIjn5/G3/eOrBLaXzlvJqNHCrG0yhYKNRQlBO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421959; c=relaxed/simple;
	bh=BJ7uPtTKNW8kUJ/lUKnL8IF1QcO5aKbMSC1NFQi5hzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Krvb2kFdemFrvhYFih3L6P7xyLcGVNnk6z46rWd05DV0b8OhYoJxRUTB5bamzLTDTCVz4nPtImYjFU7sNoeY5TIRluoyMNF4917EQ5mz24B0jIhkRZgbPoE8zTZetnLl4bMS5Lnf/Y6Ek3WJdGQUX5mxJliQwe68uEWqz1gpbv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KuHkfGI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KuHkfGI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7861F000E9;
	Thu, 30 Jul 2026 14:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421957;
	bh=6RFw3PontUcAhojk1/Aq6OaKrb01IphxUvZRYB57sVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KuHkfGIPHLvgev9ECS5l2XP2veAVFI0+zHO8DiqYRWitblpsqad7Zfpf7snYm4x1
	 WoJ33o1mvr8XDNW20aotxFJ29hFvZrn8rHS/rb4tucUA5UlGpACFbSQcEk88vQWDVo
	 9e1qwv8hHFrvp+GEjembxWPOodA8YY4xpFwKQb4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Eelco Chaudron <echaudro@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 278/744] selftests: openvswitch: add config file
Date: Thu, 30 Jul 2026 16:09:11 +0200
Message-ID: <20260730141450.198076332@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



