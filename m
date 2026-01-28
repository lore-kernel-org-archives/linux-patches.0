Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2F42E6CCD;
	Wed, 28 Jan 2026 15:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614793; cv=none; b=RBXVzyKPpSeJAYHKeuVUJY5BiaHMnqAZpiu83fiwixLPpFYSxuJSNlgkxuIeNqobanwyI8okzkdPpg5RhCRZjzoNINmZtWVccgdGEFSQr7YJQrhYNdg7245ZOtz22GJIuqBLYR6eXRd7FLpp5d2KioeudA8cXKDPeWlmazZC6mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614793; c=relaxed/simple;
	bh=qd1KW2QwFWmg1ynd0gpYocG2uAEsP17h8zkpuMYhBBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfyTmXAj2m1K5zvJfgZA+0Xags+W/YKFyXHx35x1m7aCTA+jZ/LD9W8acUDEaWMTKlPYRGtKH6O8/yJrNuAKwas2g/j0WjPjOAZVOJK71d/DNON4IQt5ZEh4/HnosruQzz+lnvrhj+3YX5lpXNfKNuynZJaD4V3WYrSbvdpPIxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1b5xrpVO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1b5xrpVO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223BAC4CEF1;
	Wed, 28 Jan 2026 15:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614793;
	bh=qd1KW2QwFWmg1ynd0gpYocG2uAEsP17h8zkpuMYhBBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1b5xrpVOOEowVs25y6n9n3BgJUuaOThxdmrDF7e/jcMTosmljCUP0JrUnwJIJxEo1
	 uRsX8K4YnBR8gnG7TNnkiX+CIAcTPud9XBxpVeQxaiHl3MRNtibYzPAc7M8RrcrZl+
	 tdNDRUQ+O3CSbZLxgoZTUk5DVGVpmPc29EImxfBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>,
	Daniel Wagner <dwagner@suse.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/254] nvme-fc: rename free_ctrl callback to match name pattern
Date: Wed, 28 Jan 2026 16:23:38 +0100
Message-ID: <20260128145353.504109393@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 205fb5fa6fde1b5b426015eb1ff69f2ff25ef5bb ]

Rename nvme_fc_nvme_ctrl_freed to nvme_fc_free_ctrl to match the name
pattern for the callback.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Stable-dep-of: 0edb475ac0a7 ("nvme: fix PCIe subsystem reset controller state transition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2384,7 +2384,7 @@ nvme_fc_ctrl_get(struct nvme_fc_ctrl *ct
  * controller. Called after last nvme_put_ctrl() call
  */
 static void
-nvme_fc_nvme_ctrl_freed(struct nvme_ctrl *nctrl)
+nvme_fc_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(nctrl);
 
@@ -3349,7 +3349,7 @@ static const struct nvme_ctrl_ops nvme_f
 	.reg_read32		= nvmf_reg_read32,
 	.reg_read64		= nvmf_reg_read64,
 	.reg_write32		= nvmf_reg_write32,
-	.free_ctrl		= nvme_fc_nvme_ctrl_freed,
+	.free_ctrl		= nvme_fc_free_ctrl,
 	.submit_async_event	= nvme_fc_submit_async_event,
 	.delete_ctrl		= nvme_fc_delete_ctrl,
 	.get_address		= nvmf_get_address,


