Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5FF1E3772;
	Thu, 30 Jan 2025 14:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246717; cv=none; b=qdBdfPFt0piSLTZLJjKH/nVOyfOW+Yz+qbtsAMJNQJ4gUSGwbLHus2f2DEuMGsoLZw1plpMyIDNaPuUYELTXC2WqrRzwGbvb9ciqmz+YZoCcE297QZyx7ip/WS7/al0fMblTadbjLMnF+6qzlFARXzk5c9R0fvoISim/x5t4CmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246717; c=relaxed/simple;
	bh=l8afz0lt9KRj3tzkja3t1YhNSu6levduVwtiSyeAO0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spvdZqZ1Tblub33IJwJRgeoqPm4bSy/qgdfkeTGYPLRhBrZvlbMrbsMPrjaaiaxJChfhKbvM/RlguC8aaNP9aHh0GPXyhTLn4UJvcZarrvgOmnTgcz+1d6rpyVo+MzTcZ17G98QEX90iyD/95efUflhyHFrYvHrq/dSmgRTDPoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ykdMPhz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ykdMPhz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DABC4CED2;
	Thu, 30 Jan 2025 14:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246717;
	bh=l8afz0lt9KRj3tzkja3t1YhNSu6levduVwtiSyeAO0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ykdMPhz6rU0R77Yr8ESP5C5U28xxFSG5pLzntvO2sDE9JNpzxF/NKH6bf5u5A1CFD
	 gK01qPSumg2NaX0AC9+FbXJ/CQNxnHQiRjSr4xJHChpMJ3m1JlIqZScUZCJiB5Mfmr
	 6YpnVe0jgGwbs+a9vYY5z3fmF72rRBfQl+CJp5Ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/91] phy: core: fix code style in devm_of_phy_provider_unregister
Date: Thu, 30 Jan 2025 15:01:01 +0100
Message-ID: <20250130140135.353928636@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit b555f35f2f87f8a99ba8e65d3f51ae4294748b58 ]

Documentation/process/coding-style.rst says:
"functions: they have the opening brace at the beginning of the next
line"

devm_of_phy_provider_unregister() function has opening brace at same
line, so fix it up.

Link: https://lore.kernel.org/r/20200629145010.122675-1-vkoul@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: c0b82ab95b4f ("phy: core: Fix that API devm_of_phy_provider_unregister() fails to unregister the phy provider")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/phy-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index c801fe727f09..ffe89ed15a36 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -1094,7 +1094,8 @@ EXPORT_SYMBOL_GPL(of_phy_provider_unregister);
  * of_phy_provider_unregister to unregister the phy provider.
  */
 void devm_of_phy_provider_unregister(struct device *dev,
-	struct phy_provider *phy_provider) {
+	struct phy_provider *phy_provider)
+{
 	int r;
 
 	r = devres_destroy(dev, devm_phy_provider_release, devm_phy_match,
-- 
2.39.5



