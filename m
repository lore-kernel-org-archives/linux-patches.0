Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC512C0285;
	Thu, 15 Jan 2026 17:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496696; cv=none; b=llVM7hIeAee6o7u52H9fn6JyYP5iCyKI2Nn56wMmVoxJVc9unTCgZYy9iauqb4TzG7lNucZ24/7ESuIoPD+B8FKVhO/NH5a8/3J+2ePiB8zZfsGWsaZ2LHBqeNqZObgF78VO5fyvczNKs0/jEB0x1Rfr0OIlJNkRBMgKEABr/sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496696; c=relaxed/simple;
	bh=SNuow4mO4C6xrtT6fzzsnhSJHb/y83l3dXUteCQbqCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJdXLDzSqkSyO4HzzL/ekorSCjVWudTKmHzlZtJG6tYhrUWSIyx32jImhDZRjqc5mSljmNA8PtLMk0cJjBmG7q/MjE3afCtzEE3D5kZFE1PlNKWjjS09dSruAm3LTY01Zhf9IxJIUwWqz4xgeQnFRGS6o/w9t8qVSEQ7rRreT8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDRj8tMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDRj8tMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B58DC116D0;
	Thu, 15 Jan 2026 17:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496696;
	bh=SNuow4mO4C6xrtT6fzzsnhSJHb/y83l3dXUteCQbqCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDRj8tMNIscKTsoKje25Jc7pgKFJSZ/1NRgtpvsbArwii7sumlSoKfVEe9Mtw15Dn
	 N9jeMq9uOZ9L5YHmHkX+QiLUKD98HSqY2RSAHcsqNLxVKm0gKziJC2LGQW4p9Oo1pv
	 71J12pYGDiI2t8O+yv7U3PfCbXkZyySxoGd4YJoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/119] net/mlx5e: Dont print error message due to invalid module
Date: Thu, 15 Jan 2026 17:48:05 +0100
Message-ID: <20260115164154.478625953@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 389b34d56b751..79c477e05e46c 100644
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



