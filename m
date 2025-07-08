Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E721CD1E4;
	Tue,  8 Jul 2025 16:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992698; cv=none; b=tTMZPK+zyEAj8+YSLvpx2hf7D6b2JNPFHdx6lkeELYJ14gsULpL6c/z8cr1EuzxnDS9YOs2HBX1m2RpWDxuZwRFaPAzn4+h7zjxXcIHckNwpywOz9h+SL6FQF32qI43wxpx909uXzZ6nhLCF6rmx9G3wX17r5xgwui3ZJ7OHGlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992698; c=relaxed/simple;
	bh=D4IBacZZ1s54S0mq++Hd+BGEq2pGtc+k2fA+NNDZ8Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DLmWxyYy6jMAojmD2MOnWVIXC8co1TAX+t9RmDUHXaGcxHFExBu4gHtfA+H30aur8Mc6d0U6yuXybNc1bfSd8yqjjDJNvzsJJGoDfBSJa5BLUz6iab57OXZJh0eXqIuEiqN0GJw8E/Trn8Rx8zJ3q731MZBDP/EL6nYXKtZzCvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tj6U9tpl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tj6U9tpl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B364C4CEED;
	Tue,  8 Jul 2025 16:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992698;
	bh=D4IBacZZ1s54S0mq++Hd+BGEq2pGtc+k2fA+NNDZ8Wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tj6U9tplPCBh3zIAxLkFDPECZG2VQ79FxrLisqpSj7XhyFdDYfRwOhthv6KbwUzEl
	 2FpbXgfhpSLGZr+RTqE2yesrPDAMrbFcA62I2fwsAS7CTEn/TffrWvSWRslGYuww2A
	 CASzusH5ClDNSyEqT1/YwwM8ORQujeYTTO8DdG5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/232] platform/mellanox: mlxbf-tmfifo: fix vring_desc.len assignment
Date: Tue,  8 Jul 2025 18:20:28 +0200
Message-ID: <20250708162242.272630679@linuxfoundation.org>
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

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit 109f4d29dade8ae5b4ac6325af9d1bc24b4230f8 ]

Fix warnings reported by sparse, related to incorrect type:
drivers/platform/mellanox/mlxbf-tmfifo.c:284:38: warning: incorrect type in assignment (different base types)
drivers/platform/mellanox/mlxbf-tmfifo.c:284:38:    expected restricted __virtio32 [usertype] len
drivers/platform/mellanox/mlxbf-tmfifo.c:284:38:    got unsigned long

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202404040339.S7CUIgf3-lkp@intel.com/
Fixes: 78034cbece79 ("platform/mellanox: mlxbf-tmfifo: Drop the Rx packet if no more descriptors")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/20250613214608.2250130-1-davthompson@nvidia.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-tmfifo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxbf-tmfifo.c b/drivers/platform/mellanox/mlxbf-tmfifo.c
index 6c834e39352d6..d2c27cc0733bb 100644
--- a/drivers/platform/mellanox/mlxbf-tmfifo.c
+++ b/drivers/platform/mellanox/mlxbf-tmfifo.c
@@ -281,7 +281,8 @@ static int mlxbf_tmfifo_alloc_vrings(struct mlxbf_tmfifo *fifo,
 		vring->align = SMP_CACHE_BYTES;
 		vring->index = i;
 		vring->vdev_id = tm_vdev->vdev.id.device;
-		vring->drop_desc.len = VRING_DROP_DESC_MAX_LEN;
+		vring->drop_desc.len = cpu_to_virtio32(&tm_vdev->vdev,
+						       VRING_DROP_DESC_MAX_LEN);
 		dev = &tm_vdev->vdev.dev;
 
 		size = vring_size(vring->num, vring->align);
-- 
2.39.5



