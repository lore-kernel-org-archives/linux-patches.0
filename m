Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B34305E31;
	Mon, 13 Oct 2025 15:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368349; cv=none; b=SEjXPDTkNXWbb6yxdMWP9rV6fm6xhqhLQ0nuK81+oOPhOKRt8aiWZw3W88uu8nZhNMSTUpeqO/ODwYisl2stbxFHeVeOeMtioxzYBmdZpA8p4Oa8zHJAJAgUH+KjbVMgzmsKil3fQ4Rpwoe2yxqNdZM/HnmCCVI6y1mytJ57eQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368349; c=relaxed/simple;
	bh=O9dtS4VSKv1YTzAfN69wFSMtEMhXTEwL463BBtujc0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4ozotrL+jHUNBVPoxJDm9Anj1FYzq5pYZdyOeRvL88WC6itbJ29vh6tvG9up1iSyqtm6HrynnPGMqfZYcbOIwc2ZLVmJ+gtvpGfblPTFptrPwfIK9ZqKoH4n2NjFy/XrqzLSrVfIdvx/HbhYvOw0TE5jk681iLntEnEdNGo5iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=chu7VPT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="chu7VPT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE21C19424;
	Mon, 13 Oct 2025 15:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368349;
	bh=O9dtS4VSKv1YTzAfN69wFSMtEMhXTEwL463BBtujc0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chu7VPT/xMZ3Yix0y1+WQqwl4X3QWE171zDtWzHEV8ak8QA22c6uF7XyVhwF21DdB
	 zjceRnCIRDX5/VuHvB9dLwmUhy/0NsEkQR41OQ1e/nI09zzdsdVe8V6JtsYjkIapcB
	 9lMkvOMc+NvQdHJynn2K72iBw2PFVFd+f/UG8MSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 130/262] misc: genwqe: Fix incorrect cmd field being reported in error
Date: Mon, 13 Oct 2025 16:44:32 +0200
Message-ID: <20251013144330.806198708@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 6b26053819dccc664120e07c56f107fb6f72f3fa ]

There is a dev_err message that is reporting the value of
cmd->asiv_length when it should be reporting cmd->asv_length
instead. Fix this.

Fixes: eaf4722d4645 ("GenWQE Character device and DDCB queue")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://lore.kernel.org/r/20250902113712.2624743-1-colin.i.king@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_ddcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
index 500b1feaf1f6f..fd7d5cd50d396 100644
--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -923,7 +923,7 @@ int __genwqe_execute_raw_ddcb(struct genwqe_dev *cd,
 	}
 	if (cmd->asv_length > DDCB_ASV_LENGTH) {
 		dev_err(&pci_dev->dev, "[%s] err: wrong asv_length of %d\n",
-			__func__, cmd->asiv_length);
+			__func__, cmd->asv_length);
 		return -EINVAL;
 	}
 	rc = __genwqe_enqueue_ddcb(cd, req, f_flags);
-- 
2.51.0



