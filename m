Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B548B17AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:34:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9FBC433C8;
	Wed,  9 Aug 2023 11:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580892;
	bh=zT8j9RqAIb3TvxuGxMCmKOVM6gPMxktlpTTqenENVqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urbjH3hivHsnOomatSTBoYHymPvQ+7UqlcI62r9fRSdwSnZFnR7e1UpmVWT+sF5Z8
	 SDecpswga+RvFk+6s+2rpMyr+ZMWt5EpqKmXPBOqbfY/PPbYn2q3mh91IL0om+5Tjd
	 JmL45HGUiWcPJZnj80Gav9aGrgYI9bbaPrjmGu8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roopa Prabhu <roopa@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/201] vxlan: move to its own directory
Date: Wed,  9 Aug 2023 12:40:34 +0200
Message-ID: <20230809103644.905048250@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
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
index 72e18d505d1ac..64430440c580c 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -29,7 +29,7 @@ obj-$(CONFIG_TUN) += tun.o
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



