Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028176;
	b=3VHTVuUGnCBmAdp7tolz+hOSKU4E4h/fNM1ah54Eca2NZtfaDPD+aVebBSEHpZZHypTy
	 S7VVVSI4fgFFQ5UepSMkFEQYqGk0GSbnmT5/+baCCDHdgKuoiw8pMEoy7kAqV+BUIBOoQ
	 bqr2+RpmgwMCSySqOkZ11m7As2Eu8r+GCGX/LXbz+vY4IeJfd0yUnvAxM6PU+0RmQOKVz
	 ETG7g7XjOEyjOZw1FrzojbIghCXl3PGVKc+ct3AHcrwh2QJk+fp4jy+0TDnr+dEjvClPC
	 sQnJAcB59j0pxsCbC81LJZbgwKtzXwt0E2cPu0kCFUkeeDaUpGkf/oYaoECGmRoCjOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N5rYX3CoqKQNW/zGitDmXi2FgOISKKibiL3JSCuQUDA=;
	b=1TQeAQvduKpoJ3RkbxeOvsasSc0e5SaJBvSH4Go0UNIi+aBu82PpeO5kcBEznAJffSsT
	 5uebqWJOOqKV0nVzuCgqTDjhnMDXXbwajiaL5ibq7OjunDbgsUYxqH+pBCwk/pUxBtYbq
	 flF1/QGvz2CrZEG/WwE54s99X/Nlc0Am1MH1XQSLHnWL1jzZrc++ymSxJ9H/ULwthI9Y3
	 kajeFSUDnWd7hyGFuaTBquZBAFZeZznKg60hFSC/x1rAiw19pDf8iBgvYamB9Uy/WWDwq
	 Ruay5odrfSQW9AdCM4YLjg9x07CxETMEhu3zyrOkPwDku6zsUEiGVi3w0YV/iYulIOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EBQ7/W1A";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE42F606A320;
	Wed, 18 Nov 2026 18:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EBQ7/W1A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8D91F000C4;
	Wed, 18 Nov 2026 18:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028176;
	bh=N5rYX3CoqKQNW/zGitDmXi2FgOISKKibiL3JSCuQUDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBQ7/W1Ak9WwBVpsbq5EIZZF4Gu9PLu4jp2Jp4BWKKmFdBaYMHwnWv7lZsoYMVMYN
	 gW5qWM4/6jOzf4p/MfAeLFPwEYdQ9TV/rAC2ftNUE5wNoiCzE98KIwKsjLO3Da7QN+
	 ZVmZFLM2WIx4e4tC76ys0jOjCYnwbhDFGo62mf8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2053/2151] bridge: Add internal flags for neigh_forward_grat
Date: Wed, 18 Nov 2026 16:03:08 +0100
Message-ID: <20261118150236.510235819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danielle Ratson <danieller@nvidia.com>

[ Upstream commit 3a28ccb9dd47d1b6f64c64a94c958a968299aa1d ]

Add internal flags for the neigh_forward_grat feature:

- BR_NEIGH_FORWARD_GRAT: Port-level flag
- BR_VLFLAG_NEIGH_FORWARD_GRAT_ENABLED: Per-VLAN flag

These will be used to control whether gratuitous ARP and unsolicited NA
packets are forwarded when neighbor suppression is enabled.

Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260511065936.4173106-3-danieller@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: fcc00b15cb21 ("net: bridge: netlink: do not clear the vlan info dump error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_bridge.h | 1 +
 net/bridge/br_private.h   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/if_bridge.h b/include/linux/if_bridge.h
index c5fe3b2a53e82..ec9ffea1e46ed 100644
--- a/include/linux/if_bridge.h
+++ b/include/linux/if_bridge.h
@@ -61,6 +61,7 @@ struct br_ip_list {
 #define BR_PORT_LOCKED		BIT(21)
 #define BR_PORT_MAB		BIT(22)
 #define BR_NEIGH_VLAN_SUPPRESS	BIT(23)
+#define BR_NEIGH_FORWARD_GRAT	BIT(24)
 
 #define BR_DEFAULT_AGEING_TIME	(300 * HZ)
 
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index ba379e65c5687..1161ab10fc276 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -183,6 +183,7 @@ enum {
 	BR_VLFLAG_GLOBAL_MCAST_ENABLED = BIT(3),
 	BR_VLFLAG_NEIGH_SUPPRESS_ENABLED = BIT(4),
 	BR_VLFLAG_TAGGING_BY_SWITCHDEV = BIT(5),
+	BR_VLFLAG_NEIGH_FORWARD_GRAT_ENABLED = BIT(6),
 };
 
 /**
-- 
2.53.0



