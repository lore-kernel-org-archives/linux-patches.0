Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2315B17BBF;
	Mon,  2 Jun 2025 14:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875221; cv=none; b=BpBB5bnXPqE7IRl+F5ztf28w8JDWSocydXmMuUnu80teQAi8hzbbKvmscoOfQXRIjlFVbmW93PnhKptOdxmekvl5bP6S/AlPN9ww6uRgkyJa4cWrkRJQi92YsHMV+TwJQgxCvVL2EiEHzM9KZqMVFUUobPG+E+d3tK74Q0ADybY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875221; c=relaxed/simple;
	bh=2xaeAaM3ENmeMu6WTVyHWW3h+5Q79m0qJf1L4KRDyCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZvQju48j8kEzx5TPpTtBRgLyBzueh8Uvw2uESBiEzIbREC0Va4Un3Tf4/tZ0MTKs+VZnXJ4CGwHlh39v11fg1qoQyPvhu/bcg+IED8OzHMRApc7rtu3mf0hU2U9rBk6yUtcslt86XRaH73JvBsdCaKLplCakSmxfY6qIa16QRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oD+sOss9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oD+sOss9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B19CC4CEEB;
	Mon,  2 Jun 2025 14:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875218;
	bh=2xaeAaM3ENmeMu6WTVyHWW3h+5Q79m0qJf1L4KRDyCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oD+sOss9wmbEf8jBGWm3YIc5F8TClHV3+FBRHP+YuA4th1VaV/KbcPXgQvSo5y31p
	 tZ3j0EYsZc4AoS0kkJbDVRqx0w9TpBq48mXlA+m5p+Kp8PFOFcamd6QUzNOxXDRJLB
	 mvNlzcDAC8qJyqORK0CTeR35kdXkSH+uF3kCb5WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang wangx <wangxiang@cdjrlc.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/270] irqchip/gic-v2m: Add const to of_device_id
Date: Mon,  2 Jun 2025 15:45:20 +0200
Message-ID: <20250602134308.630696802@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 205a275196074..6a7551fd91a05 100644
--- a/drivers/irqchip/irq-gic-v2m.c
+++ b/drivers/irqchip/irq-gic-v2m.c
@@ -408,7 +408,7 @@ static int __init gicv2m_init_one(struct fwnode_handle *fwnode,
 	return ret;
 }
 
-static struct of_device_id gicv2m_device_id[] = {
+static const struct of_device_id gicv2m_device_id[] = {
 	{	.compatible	= "arm,gic-v2m-frame",	},
 	{},
 };
-- 
2.39.5



