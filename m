Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BD7111A8;
	Sat,  3 Feb 2024 04:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933393; cv=none; b=Y+ERKs8L1o55iDiD2X6fhWS3ZiSTtELC6lvWrLZfylnUJeuXZRANfxPB5zSETkXIMCBSsqWvAC26L8nGbwx7TirOphZDo5+QZb4+1K6s1Zz/nfo6oUUWiEJlwNSxtIe+pq1PdkfMZ9GajfeGW6iRg6TmHqaS0YxaE7J6nPPqxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933393; c=relaxed/simple;
	bh=/KXdMt8nJebMdj1ykWNyinG1k53B8F1uuyA66rT0tsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEAqEaESmEzayR8o/Ihzwkpx+HnAWmwDJEZk//X5u421vqU1yTljSePnDzv0B37oUo/A2aIUHYTY45bs2yhN8XQ0H8Vn5xXZO+WzFOnYhMFLcKWfrZnEmHPfvizH2kYb1gnJJk0mvSe5P3yJ3J8/IpdEc5OxJHrpCk85guIu2pE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DGZLEKRW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DGZLEKRW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C1BC433C7;
	Sat,  3 Feb 2024 04:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933392;
	bh=/KXdMt8nJebMdj1ykWNyinG1k53B8F1uuyA66rT0tsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DGZLEKRWMDefnHiFO2Sw4/CWU2HQ/n4+jKN7vkkEfNJ/ztxBASDDpoorJwOGnrwMt
	 4b1wIlep732MNL3K3s5wc8PrDoVyE31k/gSpTx0rYPnwR3H2uw+C3rNdk4V8Do4axB
	 NHLnpu+FpZyDrZDfxJTmzLdhMspVQyEOcSRtfYBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/219] RDMA/IPoIB: Fix error code return in ipoib_mcast_join
Date: Fri,  2 Feb 2024 20:04:41 -0800
Message-ID: <20240203035332.639351209@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



