Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67ABC2C324D;
	Mon,  2 Jun 2025 14:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874435; cv=none; b=WdZRtx4NxrLsW193NIlx8+EC/l3GpUMWtWO6z6UxG0anrfWlw9G9NHfMH6hG1iMcDRAnXcvrbCqkpINjzBbb00TX2Hzm3uyouBhz/iw1XerwV97KfT3DOMwXl14qOUC7UcbtPIKqA3eBZjqICCQz+m7CAM4ru+FgGBQ4T2BSpqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874435; c=relaxed/simple;
	bh=Khvk0eMXm4Wnufusi8aIzflQ3X+WVu8zOevrHCWlzIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KC2AyJfMaqtGXxcmR59ir1cHxIV3iASwcNC0g4Dwkct9FmU83cujw6eZe/41xlSv8qViiDfFx3oLQTyb22UIO77j0zoj8unbEJzm8TnsssQZivtglgY45wOcx09LKBKdyd79QmRkpXLGCWi2ZuvClY9xzzzL8cp4yjnNFVS4i8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Flbe/Amm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Flbe/Amm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57763C4CEEB;
	Mon,  2 Jun 2025 14:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874434;
	bh=Khvk0eMXm4Wnufusi8aIzflQ3X+WVu8zOevrHCWlzIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Flbe/AmmVkyBBhORJeqlheOr5ChASkhBlQhNwYn+vb78R+QljFw2MS5J20xkS+Izu
	 BsFMoWVb3umS69dWKAqe6N+qRQLqa5/BectArODTUyWObA/+atR7PyrNJcWqeNU4O9
	 WRd+wV7U0xOzjw24vO+Gd8jVIo4DCvwzGZyKwC28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang wangx <wangxiang@cdjrlc.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/204] irqchip/gic-v2m: Add const to of_device_id
Date: Mon,  2 Jun 2025 15:45:56 +0200
Message-ID: <20250602134256.596591818@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang wangx <wangxiang@cdjrlc.com>

[ Upstream commit c10f2f8b5d8027c1ea77f777f2d16cb9043a6c09 ]

struct of_device_id should normally be const.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211209132453.25623-1-wangxiang@cdjrlc.com
Stable-dep-of: 3318dc299b07 ("irqchip/gic-v2m: Prevent use after free of gicv2m_get_fwnode()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v2m.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v2m.c b/drivers/irqchip/irq-gic-v2m.c
index 11efd6c6b111b..5cb9539111d7a 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -407,7 +407,7 @@ static int __init gicv2m_init_one(struct fwnode_handle *fwnode,
 	return ret;
 }
 
-static struct of_device_id gicv2m_device_id[] = {
+static const struct of_device_id gicv2m_device_id[] = {
 	{	.compatible	= "arm,gic-v2m-frame",	},
 	{},
 };
-- 
2.39.5



