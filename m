Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 995ED313531;
	Mon, 27 Oct 2025 18:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590511; cv=none; b=rLnPxtDm2MBFFKPv6NQeVeGYDjIruIA5RyEKsLONxHt0hRdlKHj+DJJx+VF/Iu7StNQ3St5xAZYsVosn38AhX3EArLgr/SOxoTvP8WFgjt1XyDkvW07vmGeFGh5MpA09UI8pPsbpgCRKdlYykO58HR1O9lL8tNDODyrmFICUYjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590511; c=relaxed/simple;
	bh=XAne1fgb2mvGNgTrJNrWghSq+k40ONQmf4dFWr5OkhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9HUkgRbzDsAbNQgTpT4lMiLiJWd+Bn6YX+M9b1g8UVlQ/O4TGPW9FdnVK2F8aChpDD5vUQ23Zicm4hNiPYDAoOuLk+PmG/MntEJ+LTVcFt/QnGLDTkHPaomk1ta9enqVfI2ijrywo5qlLkMIMKzqvAx9Ea9sC7DlNP3br362FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOCxYRlb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOCxYRlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C91BC4CEF1;
	Mon, 27 Oct 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590511;
	bh=XAne1fgb2mvGNgTrJNrWghSq+k40ONQmf4dFWr5OkhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOCxYRlbI7UdeV1hdp+EdPCOdXyAmTWshvBk5rOLAnlJg0IzhM8HrODmE1+kkOYle
	 qg60hnrA5AVkQL8riOD0Wk5uk4uHW0pYwb3yUV6XlInsPLYRV/v+oasoJGx3N5uJny
	 HU6FoYFmqD+WZuvcducbzbA0f6YNGwf0Eo3lNics=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/224] misc: genwqe: Fix incorrect cmd field being reported in error
Date: Mon, 27 Oct 2025 19:33:09 +0100
Message-ID: <20251027183510.158457245@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 026c6ca245408..e53bdd5f04eaa 100644
--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -918,7 +918,7 @@ int __genwqe_execute_raw_ddcb(struct genwqe_dev *cd,
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



