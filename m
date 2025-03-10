Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80B4232376;
	Mon, 10 Mar 2025 17:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626847; cv=none; b=q8hT0Ve75L/rI1vQgVvaESyTBTQzxKGpn/J2X4xmTpg1UMe5VL0hU3fXkXVjlKt4rSeryrq7Cu/I/pbE4V5aUnW0T3h9BWEIIZ3InKbkpILo4B0LbARsZLJq/H3QaS+d2Vw8yPickwN2HUjgLWOYlLVCL2/lM/t0Qiwrws3NOig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626847; c=relaxed/simple;
	bh=6goeNrC2/8QyLQ11H+Vkt0w/SbWxbqGLMZybWw/DO8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkPP+fOC+qr1sfFQ8TQEzHjl9wGLiJYhGNFOv0nOx2v70VkUKAAFPZUH8CpO0cEHXhtqVUdK4vfXUht/E6Ky46f/Y0b5FOjPidXWATvc8y1GwOXyU48/9Qg6TrUObUDjCn+cZeuviFAanmu8fSx7KYyirqt8sVH2IZCA3gsv+sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WF0TncyI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WF0TncyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545E5C4CEED;
	Mon, 10 Mar 2025 17:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626847;
	bh=6goeNrC2/8QyLQ11H+Vkt0w/SbWxbqGLMZybWw/DO8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WF0TncyIJduh12ScMrDlRIAkkVXi7c8aCd+3PRGjOpmtjWFKzD2Xm3EwBsCr1+gzi
	 6em9C7meH2QwVfPVVOKma7FFayQZ8LDjUjzmSpRm2wdmWW5dXWjUoAIlC9+6dYpnJH
	 f2A+0ITM3PQ2mPnqy34zlX6vEe2m8RgWsFc5HpvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 106/207] nvmet: remove old function prototype
Date: Mon, 10 Mar 2025 18:04:59 +0100
Message-ID: <20250310170451.974941904@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 0979ff3676b1b4e6a20970bc265491d23c2da42b ]

nvmet_subsys_nsid_exists() doesn't exist anymore

Fixes: 74d16965d7ac ("nvmet-loop: avoid using mutex in IO hotpath")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/nvmet.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/target/nvmet.h b/drivers/nvme/target/nvmet.h
index 7233549f7c8a0..016a5c2505464 100644
--- a/drivers/nvme/target/nvmet.h
+++ b/drivers/nvme/target/nvmet.h
@@ -607,7 +607,6 @@ void nvmet_subsys_disc_changed(struct nvmet_subsys *subsys,
 		struct nvmet_host *host);
 void nvmet_add_async_event(struct nvmet_ctrl *ctrl, u8 event_type,
 		u8 event_info, u8 log_page);
-bool nvmet_subsys_nsid_exists(struct nvmet_subsys *subsys, u32 nsid);
 
 #define NVMET_MIN_QUEUE_SIZE	16
 #define NVMET_MAX_QUEUE_SIZE	1024
-- 
2.39.5



