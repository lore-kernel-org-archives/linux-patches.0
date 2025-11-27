Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8691E2882A7;
	Thu, 27 Nov 2025 15:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255822; cv=none; b=rYok/sXJ5a1X6Gi/I2v0DsmU27d1UvGrYP9Xe0z70YZRKrNENg6V15FINy529sbZgHFcuZjG2R9GUAHhrVdmB6OKhjtUYrKeTzeGwkOsMxNvH6hwo7B2tIIpBefnNgAZCPmTJCzjTOywR2yD6vicFkk7mwihGJIwfJ1J1MnR6JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255822; c=relaxed/simple;
	bh=zGJLoIchn3WknDPRizXflDSNuSddY/r5ObGuGconEiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7yAxEw8vVTqPALxPLJ+ND2Yxc0JNvxdqzYZaxJ1gy64nSYJy6wc02TpatIKun2m10yHuur16NILHO36nIV0ykPhbRlDrXtzQ1tRJR/7H1DgFeF29fEghYR+FDEEmwPBmqqKziZHrmwzxFT/xVA2tPs/3En3AoM2vWt1S8K5Bhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeLSuW8G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeLSuW8G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A469C4CEF8;
	Thu, 27 Nov 2025 15:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255822;
	bh=zGJLoIchn3WknDPRizXflDSNuSddY/r5ObGuGconEiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeLSuW8GEE+ptCd+SkUdkYlfwMv+vm17PJlJ57yeLHVnFpJxGxScOUFp9ND8l5Hap
	 bwkUEQI9GppxupIgBTG4+rJ9+LJRk3dKFi+rtKrKsvgUdfguuvOxdABg68nZZiLs8h
	 VQ8/njsPLfK5a4ORbrisvjULn5OhHm3C/GEvIUp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 099/175] net: mlxsw: linecards: fix missing error check in mlxsw_linecard_devlink_info_get()
Date: Thu, 27 Nov 2025 15:45:52 +0100
Message-ID: <20251127144046.575454169@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>

[ Upstream commit b0c959fec18f4595a6a6317ffc30615cfa37bf69 ]

The call to devlink_info_version_fixed_put() in
mlxsw_linecard_devlink_info_get() did not check for errors,
although it is checked everywhere in the code.

Add missed 'err' check to the mlxsw_linecard_devlink_info_get()

Fixes: 3fc0c51905fb ("mlxsw: core_linecards: Expose device PSID over device info")
Signed-off-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251113161922.813828-1-Pavel.Zhigulin@kaspersky.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core_linecards.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
index b032d5a4b3b84..10f5bc4892fc7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_linecards.c
@@ -601,6 +601,8 @@ int mlxsw_linecard_devlink_info_get(struct mlxsw_linecard *linecard,
 		err = devlink_info_version_fixed_put(req,
 						     DEVLINK_INFO_VERSION_GENERIC_FW_PSID,
 						     info->psid);
+		if (err)
+			goto unlock;
 
 		sprintf(buf, "%u.%u.%u", info->fw_major, info->fw_minor,
 			info->fw_sub_minor);
-- 
2.51.0



