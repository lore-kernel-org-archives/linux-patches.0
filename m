Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D8428314B;
	Thu, 27 Nov 2025 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254957; cv=none; b=iU/Uzv82xh4abGf6DeKwbnl+4cP4uOINdaFRrKHv5NXae01lsKCsfWGACp+UoJY/+FA0ypdqdvGOmg769hMFHFRWx4Q4J3nbdd/smnIV6V+y0isLFd8oRyOm28sZCRKwgGl31d0lxr/wGoJ4watGyNLoP3QZ44t77HDOw51fW+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254957; c=relaxed/simple;
	bh=gcSpgCxw2kVKCGjkD1zi8N2I/parU1hH9J9u2G7rwcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WV5Q/ddWseC+TpPGeN+U5eerObrkSfG9z1zFtNiv5lDyaIDIMlr7uMo62qhReP64kVtT3coTvjFp2SHlOJE5NiQr72tS3hn/rUwhzMatu1KSM9PLcVWtg3hDVFxpFRDqnVBXF3ZlkPY8+vKVkYQd1sBP73aFatsdcND2iYygKqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rdmj+uwJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rdmj+uwJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21E95C4CEF8;
	Thu, 27 Nov 2025 14:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254957;
	bh=gcSpgCxw2kVKCGjkD1zi8N2I/parU1hH9J9u2G7rwcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rdmj+uwJGYJJknAnNelUBdwdAFA/9xhuUPkvBKN7Yj4FhH2uA5HqA2jTxqwWANl7g
	 bp5u/bKB3Psr7zQc4SgCLzyQqU2/AGrILaMn8NqxTbzRh1NNpDe/OIQjVJRyp9/kT6
	 l9QTioSb3NwlWBdFT7456uf1gFtFFnhc0aZNsl5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 44/86] net: mlxsw: linecards: fix missing error check in mlxsw_linecard_devlink_info_get()
Date: Thu, 27 Nov 2025 15:46:00 +0100
Message-ID: <20251127144029.440211812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



