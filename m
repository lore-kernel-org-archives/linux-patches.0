Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBF92750ED;
	Thu, 15 Jan 2026 17:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497117; cv=none; b=haPxN6aEUO57QZHZjZR7861rRWPwsYK6p4I+ewfh+lisF5w51t+F8AWOsGKiTR460OzW9sn+KrgXXZ+GYDRfO5GvIso4lgKFgUAzxL2pwF53jxrXy6jDb71MSnplbNVecdniq2o5J0ucVoZ1O/1wej1NCuRrSffjKY2xeQXJXE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497117; c=relaxed/simple;
	bh=AEokJD5DdiEijNKj+FIpYBiqliYvSc+ONKnbrUC6Rb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rjmfi+E6eAlosyZZPegt6XZiGiqvORldRUXuvj4Gb223aRNHfAR9DKe4V1JrF7Be+0g/fpLGmMbDNhsQBVFsx2fV3BJ5qe1MPbFugJ/InQUz/+ZWCap0PoG4S5yIzKOeEaJ3SgQhzZKkr5g2AsGrS6pRsG8feXJ41NaT2q5yK/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LCUcwQer; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LCUcwQer"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB85C116D0;
	Thu, 15 Jan 2026 17:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497117;
	bh=AEokJD5DdiEijNKj+FIpYBiqliYvSc+ONKnbrUC6Rb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LCUcwQerS/pU2Gqi+L7x4PvBib+FWkc2jMaSBbK+6DvRKFuzh+HTgweRETZ36mwLP
	 nG/Gx5Dy3mD7FnU5L9faJKN+keeAM67+YtFQsA4kqsnlJGcxAiFxMI93K1jEQHsL9w
	 uLR7e8JgjFPHfYKnkGJv4b7CigwQ0pKPw/IOsqwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 42/72] net/mlx5e: Dont print error message due to invalid module
Date: Thu, 15 Jan 2026 17:48:52 +0100
Message-ID: <20260115164145.020204163@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a1548e6bfb35d..28ec31722ec2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -432,7 +432,8 @@ int mlx5_query_module_eeprom(struct mlx5_core_dev *dev,
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



