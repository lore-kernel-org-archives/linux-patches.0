Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7EF335BC3;
	Mon, 18 Aug 2025 13:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524815; cv=none; b=eiEkcM7loN3eYQlckpMV8dLYcZ6N9tckMpoK03OcaM89Lb1gbRjUIsE5vhCW2Ah37bU7Dr0iB5U7ks+wF1kYf14I61ETN2zYyQRG++tvpDAvpoUN1WcsfKxA47YJUyXYT4YXkk3x4H1UdUxyWb3RYqmv8WB4yOepUB3wHjzEu4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524815; c=relaxed/simple;
	bh=8ywg+aAX1LOa6txgh+r3fJ4+isK8VlXuahvCtkeixa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gzznw5FXfeyVP7ktQuPvmRQgD2GCYjIXpLHQHfvsupxp9LYCRBd4IcTnqcSjgLkcqcG5k465IrJOhlggtBkOYbkB2aeVMm/PYLlX70F+7dpwGuXfFBnwYSL8aL4AKy75BDxQtXMjaL5DHqJmVSmcpvFcSykw7RQ8GQt/zXbCaG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngG82ItE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngG82ItE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B27CC4CEEB;
	Mon, 18 Aug 2025 13:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524815;
	bh=8ywg+aAX1LOa6txgh+r3fJ4+isK8VlXuahvCtkeixa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngG82ItEHTj0mZ+2zSGG2IIQqQ/55EuC4B1T1hKKjfonMX/SurDZmA0l/6RcFPvdE
	 ie5hGnM7xZiuEixi2KRyUo+RHjjv2VOsO6qikPdUoWSq0I+dE5EA/zMsoIPlOqyjT8
	 p0U4HqVQoS/GjpnSsOGKnepIvaNWGVZCI92OEwb0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 072/570] net: ti: icss-iep: Fix incorrect type for return value in extts_enable()
Date: Mon, 18 Aug 2025 14:40:59 +0200
Message-ID: <20250818124508.600960271@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 5f1d1d14db7dabce9c815e7d7cd351f8d58b8585 ]

The variable ret in icss_iep_extts_enable() was incorrectly declared
as u32, while the function returns int and may return negative error
codes. This will cause sign extension issues and incorrect error
propagation. Update ret to be int to fix error handling.

This change corrects the declaration to avoid potential type mismatch.

Fixes: c1e0230eeaab ("net: ti: icss-iep: Add IEP driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250805142323.1949406-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icss_iep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/icssg/icss_iep.c b/drivers/net/ethernet/ti/icssg/icss_iep.c
index 50bfbc2779e4..d8c9fe1d98c4 100644
--- a/drivers/net/ethernet/ti/icssg/icss_iep.c
+++ b/drivers/net/ethernet/ti/icssg/icss_iep.c
@@ -621,7 +621,8 @@ static int icss_iep_pps_enable(struct icss_iep *iep, int on)
 
 static int icss_iep_extts_enable(struct icss_iep *iep, u32 index, int on)
 {
-	u32 val, cap, ret = 0;
+	u32 val, cap;
+	int ret = 0;
 
 	mutex_lock(&iep->ptp_clk_mutex);
 
-- 
2.50.1



