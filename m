Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD55F1F957
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32169C433C7;
	Tue,  1 Aug 2023 09:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690881874;
	bh=nkOLSAeBlptg6dgJqYXpT0y1Nu1pmrd3G4DlqmUciv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jfT77iO1s1rHND7cdo0Xykb4tt9G82/uDDUeQeNanq+k2KYiWIpOvVA3zkD/YXcBs
	 TobkKqipFq8zuCULBQy1TAZ5QcAoKWtf4eKs5c4zVnaIsHPertsix1MqoX7p05/7q8
	 VY/DixO7Rf0V6o/xbQqT0TD+lpKtd1wrJwFGhFgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roopa Prabhu <roopa@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 061/155] vxlan: move to its own directory
Date: Tue,  1 Aug 2023 11:19:33 +0200
Message-ID: <20230801091912.382918421@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roopa Prabhu <roopa@nvidia.com>

[ Upstream commit 6765393614ea8e2c0a7b953063513823f87c9115 ]

vxlan.c has grown too long. This patch moves
it to its own directory. subsequent patches add new
functionality in new files.

Signed-off-by: Roopa Prabhu <roopa@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 94d166c5318c ("vxlan: calculate correct header length for GPE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/Makefile                        | 2 +-
 drivers/net/vxlan/Makefile                  | 7 +++++++
 drivers/net/{vxlan.c => vxlan/vxlan_core.c} | 0
 3 files changed, 8 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/vxlan/Makefile
 rename drivers/net/{vxlan.c => vxlan/vxlan_core.c} (100%)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 739838623cf65..50e60852f1286 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -30,7 +30,7 @@ obj-$(CONFIG_TUN) += tun.o
 obj-$(CONFIG_TAP) += tap.o
 obj-$(CONFIG_VETH) += veth.o
 obj-$(CONFIG_VIRTIO_NET) += virtio_net.o
-obj-$(CONFIG_VXLAN) += vxlan.o
+obj-$(CONFIG_VXLAN) += vxlan/
 obj-$(CONFIG_GENEVE) += geneve.o
 obj-$(CONFIG_BAREUDP) += bareudp.o
 obj-$(CONFIG_GTP) += gtp.o
diff --git a/drivers/net/vxlan/Makefile b/drivers/net/vxlan/Makefile
new file mode 100644
index 0000000000000..5672661335933
--- /dev/null
+++ b/drivers/net/vxlan/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the vxlan driver
+#
+
+obj-$(CONFIG_VXLAN) += vxlan.o
+
+vxlan-objs := vxlan_core.o
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan/vxlan_core.c
similarity index 100%
rename from drivers/net/vxlan.c
rename to drivers/net/vxlan/vxlan_core.c
-- 
2.39.2



