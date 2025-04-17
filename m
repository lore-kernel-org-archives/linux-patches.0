Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FBAC256C63;
	Thu, 17 Apr 2025 18:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913865; cv=none; b=iC9SW0vcmHQBSk/CNAyR0DmfrBp7v/n/F9d7pE7CHCAZTcmS2znL+xUcUe+RbIgrBdv4bf0TD5NkMYLgT6XNYAZoKsx+zBRjUCwXCTbf1JB0EHD4qIjd38PBCG1rhKp70zp5Jvh7Ipb+OcwuGMkoYXFmIaOFlLUHADffB1UA2cE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913865; c=relaxed/simple;
	bh=ovGVMSMSGttmPbfK3KqneKPp7GJrsF6l4+IMhAsVLwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ihYuaLV0aIhzcxMcUOafDB40znSwmvuEGm+HuXWRkXg+nJCGUDsUdAoka0/JIVTq7mI1YdVbXhqol183L2J/Dc4JTw44lI64Vp7ns3cWwF4zFtjB4ZVX6p30/GL4yOiB8463Tpo6PHZtEyinyyXwkmVnbgKgXZFHXf695q/3V8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jal7G0fH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jal7G0fH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9571DC4CEE4;
	Thu, 17 Apr 2025 18:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913865;
	bh=ovGVMSMSGttmPbfK3KqneKPp7GJrsF6l4+IMhAsVLwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jal7G0fHXdVGExF/0EYFWSXXjDwKAQ8SMLVF7Js3KMS+6Vn27ESV04TUvugrnNltK
	 5nBsEmHjhu0XQT3SRrjvAKDRsuyXRgPwH9wEhTdiJXuIyB+twgkIacsMUKAscwk7s+
	 tBr7Z7TxtpJhOBEDn2VzGJo386ummyas5KR0p6IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 028/414] nvmet-fcloop: swap list_add_tail arguments
Date: Thu, 17 Apr 2025 19:46:26 +0200
Message-ID: <20250417175112.548743919@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 2b5f0c5bc819af2b0759a8fcddc1b39102735c0f ]

The newly element to be added to the list is the first argument of
list_add_tail. This fix is missing dcfad4ab4d67 ("nvmet-fcloop: swap
the list_add_tail arguments").

Fixes: 437c0b824dbd ("nvme-fcloop: add target to host LS request support")
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fcloop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index e1abb27927ff7..da195d61a9664 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -478,7 +478,7 @@ fcloop_t2h_xmt_ls_rsp(struct nvme_fc_local_port *localport,
 	if (targetport) {
 		tport = targetport->private;
 		spin_lock(&tport->lock);
-		list_add_tail(&tport->ls_list, &tls_req->ls_list);
+		list_add_tail(&tls_req->ls_list, &tport->ls_list);
 		spin_unlock(&tport->lock);
 		queue_work(nvmet_wq, &tport->ls_work);
 	}
-- 
2.39.5



