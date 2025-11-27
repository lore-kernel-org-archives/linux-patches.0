Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD37E296BBC;
	Thu, 27 Nov 2025 14:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255412; cv=none; b=peNYEK9Tg1jQwWGG8EAsLSu96mSrOgj82/acu6Kq27EkOAX3313I+4FWbhkA+TWKIHHjycP+YfMu3gf3XDGNem84THR585VBN76Am+fSIK3ySQrWAERZLkPx9M1sHjNn0L/LvfEjsz54QvDLzPpyhRFvw6Y9WIezzMwYOq3oI1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255412; c=relaxed/simple;
	bh=zsrvqqCcwTGbp6UOq7hXA1oK07L5i3dvDZhwf6L1uHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxBdEs4qb0er56NemHkCofst4CoRkByVcaW1vhe5okMD+6h+glVcfOlcwIr8S+musp3zLtsWzVDBd/78QdrtttR6uPIfqAQOuMBRMrdbaiyoU3VeaA/cB340yhHUv+OLL9EfIvXDpKNBwv2qi4uycMWECK6I6Jy4VSvsxbZ4T/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7iDunmY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7iDunmY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54189C4CEF8;
	Thu, 27 Nov 2025 14:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255412;
	bh=zsrvqqCcwTGbp6UOq7hXA1oK07L5i3dvDZhwf6L1uHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7iDunmY5RNjCdkvJUaA3pg5l9rn/ywiAzXL+PSq2Wstg220MDj2nYYW4qXu5xBQw
	 ZYy7HjzOKLuy3OqWpKZBgsvUMxEEEg9GzgB3ssjOTmEFP+wO6JoO0cz/w6++7w9bjo
	 +36S/Ef9s1B8WuBdzSJTxg1cDHZxKuiI0vlYIN9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/112] net: mlxsw: linecards: fix missing error check in mlxsw_linecard_devlink_info_get()
Date: Thu, 27 Nov 2025 15:46:06 +0100
Message-ID: <20251127144035.182166341@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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



