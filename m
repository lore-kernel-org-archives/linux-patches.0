Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DD4182A7;
	Sat,  3 Feb 2024 04:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933614; cv=none; b=BS6XY21ei7QVvCM8k/cVv7dNSH9pxw8FDMnLe+hcNHir6QbH+iShsIM8iYOo1X5SeVA5HgfRStSuE3T3NBmDgDS5VXX/PLmns5/th092LBvzCXVZ+83xMh7vC6ynGpPFpVobeVsQ6kY+Fcca2TWdOO5eX5nCbXvGNLhT8+eo2Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933614; c=relaxed/simple;
	bh=jvPHIRztUhvHs6N15BWGxvSe7Ob73FMzTpKi9K+VNqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiD6S38z0I8B9rer+4bs8myXs9wlMGdd8rdHbfX2HMUqmci0WpVVFxeTR/8/e3lZyvOmX9h8hKk+sp5/PParx4OewuVetKaIxSSVozUGoVR/FnTXz4h/lHdkL964i6kSINd2HUlqIBTAcArzS2eY2d5lUoeoe2+K+RH9N5djgMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XtA9ttdg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XtA9ttdg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2E7C43390;
	Sat,  3 Feb 2024 04:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933613;
	bh=jvPHIRztUhvHs6N15BWGxvSe7Ob73FMzTpKi9K+VNqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XtA9ttdgwwlqSmjdQTCqmdUhUkWm4dr+gHCUJcPBiATiYz75quktzdwkEKGNE6sMN
	 zMLPTw47uD0qtguu8QV4aMziok1nUpKXAb0P1BMjTu91UkW1ONzXY3R1n2dTvpitaN
	 ucMDQ1tTsb9V8Z+YOGwL0mV1DsKqkMS8l6jH7lXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/322] RDMA/IPoIB: Fix error code return in ipoib_mcast_join
Date: Fri,  2 Feb 2024 20:04:19 -0800
Message-ID: <20240203035404.455206688@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 753fff78f430704548f45eda52d6d55371a52c0f ]

Return the error code in case of ib_sa_join_multicast fail.

Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Link: https://lore.kernel.org/r/20231121130316.126364-2-jinpu.wang@ionos.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_multicast.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
index 5b3154503bf4..9e6967a40042 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -546,6 +546,7 @@ static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 		spin_unlock_irq(&priv->lock);
 		complete(&mcast->done);
 		spin_lock_irq(&priv->lock);
+		return ret;
 	}
 	return 0;
 }
-- 
2.43.0



