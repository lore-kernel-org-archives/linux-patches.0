Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF3358F5E;
	Tue,  8 Jul 2025 16:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993431; cv=none; b=XmhQrMnfXuR+gtaWqnhSnhF4lRevepN8v58Pdu8jktw1TpZUbLJrRSmoc56aS9Gnf0DUQUBphhCbs0UVUPMpPPJv88mKJ6hDoNYVzARHBJktBEP0ohHPB4WvL3C8EZOT7wmQmC0Ib3EvfFjFGaDbvTLDUeUW4Ous3bpxwx/REps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993431; c=relaxed/simple;
	bh=WEImpKk4OYmn1fzs4v0e4QzyLM6EiKksi4CQsQw77SI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSCkFx09u1790NzAaCMpYY4GeXS8YmhZERbZXx7xumd/ye+3LeJ3TB1RjtjpOYWzm4xE3RrroIOZFd3xSGjRUWEMANG+f23zt1rYIyb4xhPIZkmm+Wr1f2QRj/jd5rHehNOxwWMn4N059LMlE3tO8PbDg+Y9v5COFx1VUUi7e9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iim6FTsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iim6FTsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D15BC4CEED;
	Tue,  8 Jul 2025 16:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993431;
	bh=WEImpKk4OYmn1fzs4v0e4QzyLM6EiKksi4CQsQw77SI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Iim6FTsY1Go/YyUx9TnRi1LQydSAGBBGAy2YrUaYkOFUU1FIJzRNSnpAD0PdNRMHb
	 cerEnlKQq7PKMjpmyl/Dsl76lBfcRMMrUGx++l1+0tSga9G4iqVx58/0r+NtpfpRE4
	 dlinodU97Ye6NIaafy2gnNTU/DgPBDPkOiSR2Y8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 042/178] platform/mellanox: mlxbf-tmfifo: fix vring_desc.len assignment
Date: Tue,  8 Jul 2025 18:21:19 +0200
Message-ID: <20250708162237.778931524@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index aae99adb29eb0..70c58c4c6c842 100644
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



