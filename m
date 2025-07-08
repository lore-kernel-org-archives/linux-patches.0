Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AA02E49B0;
	Tue,  8 Jul 2025 16:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992848; cv=none; b=JFLZ7bh4MuKNv8lKK3plAGlZ2aE0wjfmZKzWMbYvW88AdgSnQ7O/Y8J6PehZZBAVFc4hMw5+gd0gTAy+yjZLs1R0t4r4Z9cnGRvGnXpgpiUJ4dHLhu97L8dB8RojqBHqxX8o8zcJORuERZQ8o11MFiWx50I8WNC215XkpSeB1fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992848; c=relaxed/simple;
	bh=K7SfNmUMx6DBAeBIXYa7Gx5fbGV1JS4MB+uk1aSS6i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dBa/LvsWStKMpKOU9Y8/icY1kQefC5yqSnNw9hmgIprXa1MYEhxAaVO3EuiKMEI7ttFgx+jALAYf371C6MxHzTc8ikAmqfIk6n4zp2wbChYvq7r3w3/6rjQTO2Fa3dBI8LmRVqCIBgDmO4UguwvWl8vtb4GFCWrT+H3U/zf+m0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZaBXfDM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZaBXfDM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 522CFC4CEED;
	Tue,  8 Jul 2025 16:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992848;
	bh=K7SfNmUMx6DBAeBIXYa7Gx5fbGV1JS4MB+uk1aSS6i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZaBXfDM1BOSjjyhS1NMIyXwLP3cN5zC0XEGqfC0Jwqr7FjB3BPz2KFVjBXK7h+b2
	 5eTgu59/HqrgbRo0ZwC+J9LqA3vsrccIAjvPRQdpz3lLAxagtLnBuIRoVppLmyGglF
	 R/kg8KBFNNpYV3qZE6oKZr513o7xpiNZEMseVmSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 072/232] platform/mellanox: mlxreg-lc: Fix logic error in power state check
Date: Tue,  8 Jul 2025 18:21:08 +0200
Message-ID: <20250708162243.340827445@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 644bec18e705ca41d444053407419a21832fcb2f ]

Fixes a logic issue in mlxreg_lc_completion_notify() where the
intention was to check if MLXREG_LC_POWERED flag is not set before
powering on the device.

The original code used "state & ~MLXREG_LC_POWERED" to check for the
absence of the POWERED bit. However this condition evaluates to true
even when other bits are set, leading to potentially incorrect
behavior.

Corrected the logic to explicitly check for the absence of
MLXREG_LC_POWERED using !(state & MLXREG_LC_POWERED).

Fixes: 62f9529b8d5c ("platform/mellanox: mlxreg-lc: Add initial support for Nvidia line card devices")
Suggested-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://lore.kernel.org/r/20250630105812.601014-1-alok.a.tiwari@oracle.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxreg-lc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxreg-lc.c b/drivers/platform/mellanox/mlxreg-lc.c
index 43d119e3a4734..99152676dbd28 100644
--- a/drivers/platform/mellanox/mlxreg-lc.c
+++ b/drivers/platform/mellanox/mlxreg-lc.c
@@ -688,7 +688,7 @@ static int mlxreg_lc_completion_notify(void *handle, struct i2c_adapter *parent,
 	if (regval & mlxreg_lc->data->mask) {
 		mlxreg_lc->state |= MLXREG_LC_SYNCED;
 		mlxreg_lc_state_update_locked(mlxreg_lc, MLXREG_LC_SYNCED, 1);
-		if (mlxreg_lc->state & ~MLXREG_LC_POWERED) {
+		if (!(mlxreg_lc->state & MLXREG_LC_POWERED)) {
 			err = mlxreg_lc_power_on_off(mlxreg_lc, 1);
 			if (err)
 				goto mlxreg_lc_regmap_power_on_off_fail;
-- 
2.39.5



