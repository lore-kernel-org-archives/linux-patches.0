Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4063378B57;
	Wed, 21 Feb 2024 13:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521397; cv=none; b=YKRD3I05f7wrZbvE2G+7DRDO6HAzFT8QlUCuaZv8wwB1sPcCwxwYvHiWO0X0vMdiIRiJBMysYL4NI5BxXl0Gx4r7d15GUukITtQKT5e0+euiU0CUmT11ss6dTJJhn/orW4E0aMF3Q8pHHRy5ktrhTIBkOzoQi4blKYVTJsKVz+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521397; c=relaxed/simple;
	bh=pDJG0GR6EgAe3VNkYN4bgSdaIlbEd2s+azEQpJb0w0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3mEUgxjG6JRrd3cNv9nNR9TYxwMHX4Seg6OD+R8IBSvNuvLjNJS0XoZ9YDI2aRlBIJ3pHuk4x4zlN+Q56phJd9eksboHXwDxNaJhxj8H5PgkVk5KA5FvI2RTkgH30apDIQEpo/jmYIBHymwdDBhyX67gdzHseUrDLuFI311DvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZLGFz4I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZLGFz4I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D6FC43390;
	Wed, 21 Feb 2024 13:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521396;
	bh=pDJG0GR6EgAe3VNkYN4bgSdaIlbEd2s+azEQpJb0w0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZLGFz4IdJBXedLIry/46GSpC8s02oXVnZw/wxAcmi9TUv8YXkB4CpeFiUUaY752y
	 WyNwPdLLsrLySLbkMCeQG97o6Kz9REyVKl99CrUjgg3mcFpnrIqLu3otqyPbAMz/zK
	 iOkJcq996jY/k+jWufrU8B0Ztpj7fesNi9ow2xjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Wang <jinpu.wang@ionos.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/202] RDMA/IPoIB: Fix error code return in ipoib_mcast_join
Date: Wed, 21 Feb 2024 14:06:40 +0100
Message-ID: <20240221125934.974843940@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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



