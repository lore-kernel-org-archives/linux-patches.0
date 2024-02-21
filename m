Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F6469E00;
	Wed, 21 Feb 2024 14:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525334; cv=none; b=kx3NTrYmaI4iv9aseFR06ZBv7R8CmUAGq6WMDWBQET22w8VXTn6EzgYjSVNVq6RbaqoyrMOS+yeaOqPgAy5Zp52hT0X8/59plW8AQPMtaA78Ss9IOO6Ot+X7N64csC0Btfwog7QvRXcotm3EacpzVHENmvGcrKsqYFzlfozCRrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525334; c=relaxed/simple;
	bh=wU0bc3vp0V/75VvWXezWckKZqt65DL1A2WBJFjl7N6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RYLt/o9MsIV8F6rj1jKAH/OpsYSiDiWNCvanEi2ro47shN0ItNHBC7Om9RRK2zOTQYaUr2EoBjtQxi9efYvSuWb5Jz3LPa1bB4P4fo1LKdkiuwrlLHiwn0Pe1dPmn81sxLChL5kztghjMl4azeCZFvpPVXtpDpZni9PUMDGGHy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/7zvHc6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/7zvHc6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12735C433C7;
	Wed, 21 Feb 2024 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525334;
	bh=wU0bc3vp0V/75VvWXezWckKZqt65DL1A2WBJFjl7N6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/7zvHc6MCcuJiIzJvLy/FhcLDq552H9DfMg9we3jGDLmdHGqJx3XeJsdafTG/2OW
	 ONEPAm4nw9559NK6lSsEzoZofDo7D8MVolkOv/y0dRj74yj/6SWGf7ivmrjQfqMNP/
	 KVhnnxECvIsqBATqpu1615i0mQdRbC1oAx6j1kG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/267] RDMA/IPoIB: Fix error code return in ipoib_mcast_join
Date: Wed, 21 Feb 2024 14:07:44 +0100
Message-ID: <20240221125943.880470874@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index b9e9562f5034..805df1fcba84 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_multicast.c
@@ -558,6 +558,7 @@ static int ipoib_mcast_join(struct net_device *dev, struct ipoib_mcast *mcast)
 		spin_unlock_irq(&priv->lock);
 		complete(&mcast->done);
 		spin_lock_irq(&priv->lock);
+		return ret;
 	}
 	return 0;
 }
-- 
2.43.0



