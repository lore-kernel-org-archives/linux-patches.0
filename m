Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B629285404;
	Wed,  4 Feb 2026 15:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217306; cv=none; b=eHNlSVJo8v8GVoPvfuHskQgXY5EP3uryl3iD1+GD94IPnCejgFtHx+/8gSMyEW+lqQQWhXZkVoIfEv48WaRQKRZs9OkyX4Re/WKtrz6jlV85D2+LFe12ZtNn+hl6TySCvQFbANbXLZ9aH8TSOh1TWSRM0VI5S/qy5t8EvlutFgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217306; c=relaxed/simple;
	bh=3eH3b+7SpAlptolUusIKF2DTJLpKEuhIrj792+06gGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcaKbSovH8rr/nUpkGefCi3K/GiO5kdjFAICSRcGQWJvl1tah9MtIzG19/q4CHzdguxfGD2+4StDgqVAidoM8FOarMFmEL2ZhG3GgSX07u3U2UlD3VgHLZwyjFe5QWM5MSXePbGXXx5VLLJXvcnBandi0oU52LrqRRnOgg6O2X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFWqZFiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFWqZFiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA29EC19423;
	Wed,  4 Feb 2026 15:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217306;
	bh=3eH3b+7SpAlptolUusIKF2DTJLpKEuhIrj792+06gGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFWqZFiVlhEtwMxYFkPjKXKAhUq5nTkYP3QlW+ApPhRWlsxulYR3G+vuxsMCWZYkG
	 MKCloPJnU+qY9/vmGN3oZ+/p5QozcQWub2rhe0iESdOWt+vFD1n3AEmmGRHHBUTEev
	 H5HTivIjqiqUA7NjIL6SEhrXIX2+kZcYZNNyMxO4=
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
Subject: [PATCH 5.15 167/206] nvme-fc: rename free_ctrl callback to match name pattern
Date: Wed,  4 Feb 2026 15:39:58 +0100
Message-ID: <20260204143904.222519167@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2410,7 +2410,7 @@ nvme_fc_ctrl_get(struct nvme_fc_ctrl *ct
  * controller. Called after last nvme_put_ctrl() call
  */
 static void
-nvme_fc_nvme_ctrl_freed(struct nvme_ctrl *nctrl)
+nvme_fc_free_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_fc_ctrl *ctrl = to_fc_ctrl(nctrl);
 
@@ -3361,7 +3361,7 @@ static const struct nvme_ctrl_ops nvme_f
 	.reg_read32		= nvmf_reg_read32,
 	.reg_read64		= nvmf_reg_read64,
 	.reg_write32		= nvmf_reg_write32,
-	.free_ctrl		= nvme_fc_nvme_ctrl_freed,
+	.free_ctrl		= nvme_fc_free_ctrl,
 	.submit_async_event	= nvme_fc_submit_async_event,
 	.delete_ctrl		= nvme_fc_delete_ctrl,
 	.get_address		= nvmf_get_address,


