Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D745067749;
	Tue, 23 Jan 2024 01:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971690; cv=none; b=BBPygCdCC0hhgOOnBXMLWPqCoDbu/1YwI1nXEo6rCi8VgC3Asd9ckyh/v3EtpU7fYZidZNtL7zcu1/7NrM+hQNfZRlvTu5aqEUZ0UdIr5DatNQtR/VV/9OXLQYoitday41BldciWuzlA7ZSDTuk7G2RXeRZ/sJaNaLfVwInUgOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971690; c=relaxed/simple;
	bh=k7KYr9ZDV7NdfOMlLjYWcLmRYMgMNmlqcZcOTO8s4aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkRFsnq+hkQD5HDjjO4Z5tJ5JjkFlCvxBdm0Pd3fSm/EqmxvdJ8YL3hJ/tAuFHRRtLm2rdJFy02RdQg6RpmNXNqd7+F3+OEOLLv/VS9Q8w84lNCLgKZBCkKe4IZ8BQjdMUgJgs3Xs/EcXGzYOoCf6rhQhPLGoOhlZROMC83uxiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eL2o0eHq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eL2o0eHq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C19C433C7;
	Tue, 23 Jan 2024 01:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971690;
	bh=k7KYr9ZDV7NdfOMlLjYWcLmRYMgMNmlqcZcOTO8s4aE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eL2o0eHqa5N4yTHvpkBO9QmSYkXHK/e36F23GqO1B0mVvUsYIBcpuoyrefnsE4y8S
	 i1adwJ8eND0zCs9NlbZQRydUCSLEInW3zXWLcY8IPsdc8RmJYqCqssm2o81Os3uNvT
	 jRNCGnQ6XU3/Z9lZMhBeMsh7/FQmkv3EeLuwWRCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Chukun Pan <amadeus@jmu.edu.cn>
Subject: [PATCH 5.10 207/286] net: ethernet: mtk_eth_soc: remove duplicate if statements
Date: Mon, 22 Jan 2024 15:58:33 -0800
Message-ID: <20240122235740.084121536@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

It seems that there was something wrong with backport,
causing `if (err)` to appear twice in the same place.

Fixes: da86a63479e ("net: ethernet: mtk_eth_soc: fix error handling in mtk_open()")
Cc: Liu Jian <liujian56@huawei.com>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2302,7 +2302,6 @@ static int mtk_open(struct net_device *d
 	if (!refcount_read(&eth->dma_refcnt)) {
 		int err = mtk_start_dma(eth);
 
-		if (err)
 		if (err) {
 			phylink_disconnect_phy(mac->phylink);
 			return err;


