Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29E2839EF01;
	Sat, 17 Oct 2026 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258977; cv=none; b=iTIOPpuADgkX5i1JciGrpQ22xYksWYspxC9EghgdJivPSSHgNnr12+H6vCo4ktVTilMt64R3i4Bz7aKuCDMHUBHIiCKcZHwQiE+C/RyY2uwD6diURWIYpEqwMPVYlp6k8v3mJITi8znGrtCqJ35ICGkQW58u5zrlXN/wKJuqYF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258977; c=relaxed/simple;
	bh=xoSpWxpz40nDGWFm7+Y0FN6D9LKSjvKyihiQ8CyD294=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C0VeNIGQMmBWyJFh0gUYi+LudhoaBVEH6OdFE3sXC6AkYMFwkU1bwFtpPi2Fz/SRsXRoDGUO3za8JVBP7UQwtI+DBxQZjl1scKZ3tq0hpyNhLO5VEjsWdDk8mw+cCkNTc4hYmsywuIckVjVE/wh/+xqI7m3I3vdxcOvwZ4f8JC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGzZKGNw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGzZKGNw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA7D1F000C4;
	Sat, 17 Oct 2026 17:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258976;
	bh=ercMaYhLf1ha85mIczODb6xV8gl0hlangLm1ekCcq3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QGzZKGNwJWLDmDbcqH1Ec0Cgl8wA1dUdSLKxgnNtYeLsT46yaZSkNrKuhBZ4Jtx4Q
	 sXR+KIPmFgWquqOYtnYhBQboX5tXG+hmmSaHQrB5OypZPmBWlmRUnmJsEQrisAPaVZ
	 E5CHFms/8RiScDIcHcjSl9Dx8fapvSBQ/H8UMykc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	netdev@vger.kernel.org,
	Willem de Bruijn <willemb@google.com>,
	Stanislav Fomichev <sdf@google.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1020/1674] tools: ynl: extend netdev sample to dump xdp-rx-metadata-features
Date: Sat, 17 Oct 2026 17:54:52 +0200
Message-ID: <20261017160457.315026210@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf@google.com>

[ Upstream commit 0c6c9b105ee90d7415dc796bcf632147b3d267ce ]

The tool can be used to verify that everything works end to end.

Unrelated updates:
- include tools/include/uapi to pick the latest kernel uapi headers
- print "xdp-features" and "xdp-rx-metadata-features" so it's clear
  which bitmask is being dumped

Cc: netdev@vger.kernel.org
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/r/20230913171350.369987-4-sdf@google.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: b69004f5a6ad ("net/mlx5e: xsk: Fix DMA and xdp_frame leak on XDP_TX xmit failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/net/ynl/generated/netdev-user.c | 19 +++++++++++++++++++
 tools/net/ynl/generated/netdev-user.h |  3 +++
 tools/net/ynl/samples/Makefile        |  2 +-
 tools/net/ynl/samples/netdev.c        |  8 +++++++-
 4 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/net/ynl/generated/netdev-user.c b/tools/net/ynl/generated/netdev-user.c
index 68b408ca0f7f1..b5ffe8cd1144a 100644
--- a/tools/net/ynl/generated/netdev-user.c
+++ b/tools/net/ynl/generated/netdev-user.c
@@ -45,12 +45,26 @@ const char *netdev_xdp_act_str(enum netdev_xdp_act value)
 	return netdev_xdp_act_strmap[value];
 }
 
+static const char * const netdev_xdp_rx_metadata_strmap[] = {
+	[0] = "timestamp",
+	[1] = "hash",
+};
+
+const char *netdev_xdp_rx_metadata_str(enum netdev_xdp_rx_metadata value)
+{
+	value = ffs(value) - 1;
+	if (value < 0 || value >= (int)MNL_ARRAY_SIZE(netdev_xdp_rx_metadata_strmap))
+		return NULL;
+	return netdev_xdp_rx_metadata_strmap[value];
+}
+
 /* Policies */
 struct ynl_policy_attr netdev_dev_policy[NETDEV_A_DEV_MAX + 1] = {
 	[NETDEV_A_DEV_IFINDEX] = { .name = "ifindex", .type = YNL_PT_U32, },
 	[NETDEV_A_DEV_PAD] = { .name = "pad", .type = YNL_PT_IGNORE, },
 	[NETDEV_A_DEV_XDP_FEATURES] = { .name = "xdp-features", .type = YNL_PT_U64, },
 	[NETDEV_A_DEV_XDP_ZC_MAX_SEGS] = { .name = "xdp-zc-max-segs", .type = YNL_PT_U32, },
+	[NETDEV_A_DEV_XDP_RX_METADATA_FEATURES] = { .name = "xdp-rx-metadata-features", .type = YNL_PT_U64, },
 };
 
 struct ynl_policy_nest netdev_dev_nest = {
@@ -97,6 +111,11 @@ int netdev_dev_get_rsp_parse(const struct nlmsghdr *nlh, void *data)
 				return MNL_CB_ERROR;
 			dst->_present.xdp_zc_max_segs = 1;
 			dst->xdp_zc_max_segs = mnl_attr_get_u32(attr);
+		} else if (type == NETDEV_A_DEV_XDP_RX_METADATA_FEATURES) {
+			if (ynl_attr_validate(yarg, attr))
+				return MNL_CB_ERROR;
+			dst->_present.xdp_rx_metadata_features = 1;
+			dst->xdp_rx_metadata_features = mnl_attr_get_u64(attr);
 		}
 	}
 
diff --git a/tools/net/ynl/generated/netdev-user.h b/tools/net/ynl/generated/netdev-user.h
index 0952d3261f4d5..b4351ff345955 100644
--- a/tools/net/ynl/generated/netdev-user.h
+++ b/tools/net/ynl/generated/netdev-user.h
@@ -18,6 +18,7 @@ extern const struct ynl_family ynl_netdev_family;
 /* Enums */
 const char *netdev_op_str(int op);
 const char *netdev_xdp_act_str(enum netdev_xdp_act value);
+const char *netdev_xdp_rx_metadata_str(enum netdev_xdp_rx_metadata value);
 
 /* Common nested types */
 /* ============== NETDEV_CMD_DEV_GET ============== */
@@ -48,11 +49,13 @@ struct netdev_dev_get_rsp {
 		__u32 ifindex:1;
 		__u32 xdp_features:1;
 		__u32 xdp_zc_max_segs:1;
+		__u32 xdp_rx_metadata_features:1;
 	} _present;
 
 	__u32 ifindex;
 	__u64 xdp_features;
 	__u32 xdp_zc_max_segs;
+	__u64 xdp_rx_metadata_features;
 };
 
 void netdev_dev_get_rsp_free(struct netdev_dev_get_rsp *rsp);
diff --git a/tools/net/ynl/samples/Makefile b/tools/net/ynl/samples/Makefile
index f2db8bb783095..32abbc0af39eb 100644
--- a/tools/net/ynl/samples/Makefile
+++ b/tools/net/ynl/samples/Makefile
@@ -4,7 +4,7 @@ include ../Makefile.deps
 
 CC=gcc
 CFLAGS=-std=gnu11 -O2 -W -Wall -Wextra -Wno-unused-parameter -Wshadow \
-	-I../lib/ -I../generated/ -idirafter $(UAPI_PATH)
+	-I../../../include/uapi -I../lib/ -I../generated/ -idirafter $(UAPI_PATH)
 ifeq ("$(DEBUG)","1")
   CFLAGS += -g -fsanitize=address -fsanitize=leak -static-libasan
 endif
diff --git a/tools/net/ynl/samples/netdev.c b/tools/net/ynl/samples/netdev.c
index 06433400ddddb..b828225daad04 100644
--- a/tools/net/ynl/samples/netdev.c
+++ b/tools/net/ynl/samples/netdev.c
@@ -32,12 +32,18 @@ static void netdev_print_device(struct netdev_dev_get_rsp *d, unsigned int op)
 	if (!d->_present.xdp_features)
 		return;
 
-	printf("%llx:", d->xdp_features);
+	printf("xdp-features (%llx):", d->xdp_features);
 	for (int i = 0; d->xdp_features > 1U << i; i++) {
 		if (d->xdp_features & (1U << i))
 			printf(" %s", netdev_xdp_act_str(1 << i));
 	}
 
+	printf(" xdp-rx-metadata-features (%llx):", d->xdp_rx_metadata_features);
+	for (int i = 0; d->xdp_rx_metadata_features > 1U << i; i++) {
+		if (d->xdp_rx_metadata_features & (1U << i))
+			printf(" %s", netdev_xdp_rx_metadata_str(1 << i));
+	}
+
 	printf(" xdp-zc-max-segs=%u", d->xdp_zc_max_segs);
 
 	name = netdev_op_str(op);
-- 
2.53.0



