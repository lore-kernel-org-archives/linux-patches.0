Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017619;
	b=Yaw3RcKcC4/6zreqx2HYGCeyVsWQ9Kph58G5xFZVHlt3KnfJGzMQnrqYfZtTU8KpbSsP
	 iS4hKuPvZGg6ymulER61hUSI6v06XBd/tKyYXXkCu5P4IpdVfOVy3e3ICkTKceFLyKHpv
	 kcdb7ugs6lFspNwZGTG/PG/oG7cCk2GYIS3WIcekNKOmKNRdGr3DyiO2ODUi2XRbdNX9L
	 79wB2hBJJDWziyKM7SMja0065P2lrMM7S/LQu5BgmJbO6GhvCJ/5M0vPvJUxuZt94pBDd
	 AS6ajgIIGdh9x5AeWL/RX9WU9UD58g5ZeKGfDp3F3EgH88ib5hMhFJkGf/JaQMqm2cg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017619;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DVv0YOd1JPO8Wljyxcp16PC361uORHieNHDmuam95Ik=;
	b=0Jm2Opjes/n8tC6+Qf7rqhEe3o+aXhMnE1d6G4ns2Jw11vH9XM5rlcocoGfLtCMx5uUc
	 OPl+29VRx2bmWbe9dJJR2A6G+GCYVjEAOnqSH7A7yIvkNHzSbTbHvBy3TW59OHCV4iHDO
	 E1pYsqY3GD976/G3xFw2xb0yorDeU4dwTXJFYfU2zWCygZiGD3JMHEwtx3jzqQK635+XR
	 fiLd3Gu4BAXM1DMY/u0kk3DTEQx5gvZ6dkJ8rZ+rc7N6cRYbqoRZzxJKs1aGZhiVdZ8I/
	 B4uc+U5vRGHd9yi1pXZscTkIW3RgmvXsc/CB0ex+jk4S0QgpaBVmk60fjmD9FYeqxAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qsOGxPIw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F95606A31C;
	Wed, 18 Nov 2026 16:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qsOGxPIw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FF11F000C7;
	Wed, 18 Nov 2026 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017619;
	bh=DVv0YOd1JPO8Wljyxcp16PC361uORHieNHDmuam95Ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qsOGxPIwEn0rh6ZzkxGSoWXphFrkeqHVMk1Bbt8NYSbau6uhKjleHEAyhCEZAvKxy
	 GURa1NVjcXFdPCi/qgpKXT+hvi+1joEMI2RF7Q6wLlrGm2OaDgejlJ7U5CNl/GI40o
	 7ED3JJR9xKs++O4DN+sUdbBv42dYUskbCFYeUt00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0948/2651] of/irq: Fix device node refcount leak in of_check_msi_parent()
Date: Wed, 18 Nov 2026 15:36:28 +0100
Message-ID: <20261118150322.033210289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ef1ed9743907b..d10ec6e8bea0b 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -787,7 +787,7 @@ static int of_check_msi_parent(struct device_node *dev_node, struct device_node
 	if ((*msi_node && *msi_node != msi_spec.np) || msi_spec.args_count != 0)
 		ret = -EINVAL;
 
-	if (!ret) {
+	if (!ret && !*msi_node) {
 		/* Return with a node reference held */
 		*msi_node = msi_spec.np;
 		return 0;
-- 
2.53.0



