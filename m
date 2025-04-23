Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D915127F755;
	Wed, 23 Apr 2025 14:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420045; cv=none; b=VAwTN9YiTngFvuqPIhOlckuUxo5TMDHaVlMJkSzECu6gMrJAafuk/KbmIs9MFReTDrzMK7sM2GTWHNhqGa1ertmlRT+Q876+WFGUIUFJKX0y3Mgb4c+FBiimVEYlOeL8485sc3qXAEp+cLacN31D8xdoiYtydoFLYrTao+Ti3wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420045; c=relaxed/simple;
	bh=okyoBp+Q/L9D3KBh/LzEuVKMSmJyXmUZDWBGtPZssA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bly0lVAit8jP4bPdY2avv511HAuAd5UA8VEvD4OCCZRWR7FXwm5F738wkhkBpYFvlZN+U/87dd+D75+RHH2xaXGWGBfhVex/HQS0YwZUpvPIn6I186CjqTKh8hhBIJFnpsXCRB6heKc3OOvH3Sh3SyQJfOu1RZmsPzilKfyFOis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Va8B3eD9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Va8B3eD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A288C4CEE2;
	Wed, 23 Apr 2025 14:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420044;
	bh=okyoBp+Q/L9D3KBh/LzEuVKMSmJyXmUZDWBGtPZssA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Va8B3eD9UwS7cWiAIMbTtE0vp/3f3ptjHIbZE54QftUpRtlrR2LSGX4QVcjg3wkVX
	 2gsfn2rwc56XqOQGhZjjK/TI+MD7uIUetMrFo5SP3FfKAwVrZlZfYVtaRCMVBdMvd1
	 c8x81XsaYXA+EEE+rD9lsaqTmOqCFFnzE+j9UvJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 012/291] nvmet-fcloop: swap list_add_tail arguments
Date: Wed, 23 Apr 2025 16:40:01 +0200
Message-ID: <20250423142624.909944292@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f5b8442b653db..787dfb3859a0d 100644
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



