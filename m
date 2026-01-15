Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F77274B43;
	Thu, 15 Jan 2026 16:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496179; cv=none; b=bbayoS9+rOU708A7PGQCT3M8T439TmowRVyP57tKa79I1qr0cXzAgc3+bKAiOwO8KvLTCNRE4FNX2g17QVeXWQQiUyIfeEBcSxp/+FF/kaTRh1Op6RiLut5WW8nmh+slu0RVzVbAP4BE4Y6HtoC5Bmztxz9pWbBmfGMzkdH6dJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496179; c=relaxed/simple;
	bh=n/99m2UtB+HAUB2NRopHgX0Rsug5bvYxaBQnzUGg/f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9zvN5c+j0PRVoANVzJZd3tU4utUMhuElY+OMZmFytra8id73S/zXpTxKoML83dY0LZu1N5Fs0rsn7viEWvTFrtGFcWJVOxyuUJgblzSA0SqYrEOzRvM9+jg5Uo86Bds9voPG1WjJAn6n4vvw/atyJfDL+bSKsjmI74aKrK2Pq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Svi+pRxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Svi+pRxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37A9C116D0;
	Thu, 15 Jan 2026 16:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496179;
	bh=n/99m2UtB+HAUB2NRopHgX0Rsug5bvYxaBQnzUGg/f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Svi+pRxCVTgcePWqOLyQYXpGNThtSDSlHXUxCkPr7l0TQ3f2yuS1+vCsPxS7TdwBr
	 4rqzG89y9jlWWLBoBRDQw01MNvqi0GXONB9bbEp5tbKMMp1meH+30A6kf/wW+GlIe0
	 eiwxwuoFYnXn9VJk9BWRwlDssZEjpKEz/fkKZ24Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/181] net/mlx5e: Dont print error message due to invalid module
Date: Thu, 15 Jan 2026 17:47:21 +0100
Message-ID: <20260115164206.074035262@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 144297e2a24e3e54aee1180ec21120ea38822b97 ]

Dumping module EEPROM on newer modules is supported through the netlink
interface only.

Querying with old userspace ethtool (or other tools, such as 'lshw')
which still uses the ioctl interface results in an error message that
could flood dmesg (in addition to the expected error return value).
The original message was added under the assumption that the driver
should be able to handle all module types, but now that such flows are
easily triggered from userspace, it doesn't serve its purpose.

Change the log level of the print in mlx5_query_module_eeprom() to
debug.

Fixes: bb64143eee8c ("net/mlx5e: Add ethtool support for dump module EEPROM")
Signed-off-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20251225132717.358820-5-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/port.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index aa9f2b0a77d36..876e648c91ba8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -430,7 +430,8 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
 		mlx5_qsfp_eeprom_params_set(&query.i2c_address, &query.page, &offset);
 		break;
 	default:
-		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
+		mlx5_core_dbg(dev, "Module ID not recognized: 0x%x\n",
+			      module_id);
 		return -EINVAL;
 	}
 
-- 
2.51.0



