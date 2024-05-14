Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52E912FB37;
	Tue, 14 May 2024 11:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686070; cv=none; b=UM9HQRbmGFI8kCfYwik16d/sOUhkzRMlbDCuGsklaBOeJx9u4vJ5RjGjVTR+M33wTWdXoWhFrPRQXeSO/Hqhe2SDfHD49pC0Q2UDE/Vek+cIV4msffSLZxqcVw0P5GTDpRmjQCgc08gTE4sNL02nbiwtW2jDiiLb148vm6eXq3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686070; c=relaxed/simple;
	bh=6D7+sW2sNU0x9se/OFHeS6RS5TgZMwkGKCiOSb0dTvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt4QgOKDt/2bUuET0wetPnhKYODSGJginV9Qc/IZnpWlNWmy1g3MmBNU+28TJDl1UVJv2+8+5BUNVriSHXo3S4VSwg+aQYvOWoR+f/IS+gZYCxJGQ4mTna2BsAGP4H3la0Td7lGHRzRCCW6fvBYZSmnFiGZVjxawFqq+q82C6To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJuTYqj/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJuTYqj/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00198C2BD10;
	Tue, 14 May 2024 11:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686070;
	bh=6D7+sW2sNU0x9se/OFHeS6RS5TgZMwkGKCiOSb0dTvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJuTYqj/hWRlOxfjeTLTqvIysU6xwzqQY/whV6mdQHU7GUwhqYL8M4HP61NFm2Ikh
	 RXUm/37XNIsfbbPjnDK7Va8wtbAaknW13ZfRZ0TzgtIP7UlaGnCaky7Sp9cPWxf+Y4
	 3dCEBZYYA5WDKrJaJcSkG+vY+IkinR6F/6ZPDmhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	karthikeyan <karthikeyan@linumiz.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/236] dmaengine: Revert "dmaengine: pl330: issue_pending waits until WFP state"
Date: Tue, 14 May 2024 12:16:04 +0200
Message-ID: <20240514101020.419166707@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vinod Koul <vkoul@kernel.org>

[ Upstream commit afc89870ea677bd5a44516eb981f7a259b74280c ]

This reverts commit 22a9d9585812 ("dmaengine: pl330: issue_pending waits
until WFP state") as it seems to cause regression in pl330 driver.
Note the issue now exists in mainline so a fix to be done.

Cc: stable@vger.kernel.org
Reported-by: karthikeyan <karthikeyan@linumiz.com>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/pl330.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index c29744bfdf2c2..3cf0b38387ae5 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1053,9 +1053,6 @@ static bool _trigger(struct pl330_thread *thrd)
 
 	thrd->req_running = idx;
 
-	if (desc->rqtype == DMA_MEM_TO_DEV || desc->rqtype == DMA_DEV_TO_MEM)
-		UNTIL(thrd, PL330_STATE_WFP);
-
 	return true;
 }
 
-- 
2.43.0



