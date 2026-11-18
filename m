Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024673;
	b=BbtNcNCZQmXtX6YTcukIwx6IqL8HiFCWnWXd5WZIPhE+Z7xSQ4C7JmqWkopgrOLsJ15M
	 Yov7W6EoTUNaY5n0SR/VU6S4yvB3ZqvmAC+ACig8KwSUe4bnHtnhCEma8OVw4tyiyPFs4
	 oUvp/vJlQX6DxAnrhtmKJGfKnXJVPmdIkeVxrKxtoUmfzBGvdGpKFRU8mPKc5tKeG2QVg
	 Ab9kQsPRGQ2HsJ8hSI5sRGypQnMpCw6yLonqL6Q6CLsdBcTU6Sl+8GcQAW1CFRUtwjYLN
	 74rGN4IZRUeJmQZIu3jZSfdHx2Ojc9j5VATJ8BDMihNuxc8n84vGriHe+ENoGiG5pBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rlHjWz3576lqHzsRSnC5bTAUCVs4gdbMRn0jHVmk0DE=;
	b=4KVH794cXuKM8BU0kJBLbDEa2RU+xZL+JyzBUbpb6ZcpgKbToyngAcyZBDX7aCCpVyHg
	 VYXDwcu/NtkUD54vAim8NEUGVskT/c34HG6704B4AboIKAvnVH95pDyigE/xEu46A0+fE
	 vOy6OOO6KzwmO6A0R1UyMU7mLbRl1lh0UhtSc96mAHA/faebp5Fwz2uC9BRatoDloIP1b
	 ZzOag91ktAayozZT92SpPEdS4iydy0D8DFqKRnMr1JPrLVLJ9zHIK1+M1hPn/YEThZemB
	 dvXn3H2Vex+zc0CmG0QBLVyCYsAUiB/8RWClK59cEPfBM+lVz8RDWOzDHfwECGEX97A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vcClS35;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF0A60A2603;
	Wed, 18 Nov 2026 17:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0vcClS35
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E8241F000C5;
	Wed, 18 Nov 2026 17:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024673;
	bh=rlHjWz3576lqHzsRSnC5bTAUCVs4gdbMRn0jHVmk0DE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0vcClS35e4pv7sCRwU5qRDdcXMaIyWvD2of4FenGLxlHNf6j8zf6rULR98KPTutm3
	 ysL8wJ8F6fmxMqv8WA5dx8eTWPh9FJxdXzww6+OKhCdB94Mrl9Xrz3JFJlDFuvIcPk
	 WBkHNznDJaZu1IK1SM/ocL3z5Cvovdw0j+qme7/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0808/2151] of/irq: Fix device node refcount leak in of_check_msi_parent()
Date: Wed, 18 Nov 2026 15:42:23 +0100
Message-ID: <20261118150151.481470569@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit cbe0f79dcab1c121d767927b53a61eadf2c5b518 ]

of_msi_xlate() documents @msi_np as a filter when it points at a node on
entry, handing back a reference only when it points at NULL. The msi-map
branch does that. of_check_msi_parent() keeps the reference from the 1:1
msi-parent match either way.

pci_msi_domain_get_msi_rid() is the only caller that passes a node in,
from irq_domain_get_of_node(), and it puts nothing, so a 1:1 match there
leaks the MSI controller node.

Fixes: 119aaeed0b67 ("of/irq: Add msi-parent check to of_msi_xlate()")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260826113604.010C01F000E9@smtp.kernel.org/
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://lore.kernel.org/all/20260826113604.010C01F000E9@smtp.kernel.org/
Link: https://patch.msgid.link/20260907112944.313618-2-fuad.tabba@linux.dev
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index 14ca310c375a0..aa74a5b6f7656 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -693,7 +693,7 @@ static int of_check_msi_parent(struct device_node *dev_node, struct device_node
 	if ((*msi_node && *msi_node != msi_spec.np) || msi_spec.args_count != 0)
 		ret = -EINVAL;
 
-	if (!ret) {
+	if (!ret && !*msi_node) {
 		/* Return with a node reference held */
 		*msi_node = msi_spec.np;
 		return 0;
-- 
2.53.0



