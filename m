Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ACF63B9D80;
	Sat, 30 May 2026 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164843; cv=none; b=qHh3BcPOms9eW+Kra31afLamci3zUQasVznD/a7lMjMitdfXPI5OnFLor7A/hsnjNRlrci0B3rB/RUygFJH/saPM8xK1OpZNpttRQvgaVrl4ALntBgzvTEx3k3OL2gBj1qjhUnRja+1YPfrmhKKyX3jKyJzbvrXHVT4x6T3lvIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164843; c=relaxed/simple;
	bh=hUnp9x8PTVX8EbVk8+LC8VovePvTypDgZ1lnuIsYuOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCqsVYBCHV1/PnBZ+T6v1ms8eLnKmRlQJuBRcmRQ6QwQolTfWdIwpno8W6RZKtc0dQyW7wxrzIo4ZeEbA1w+hp7POeFoiZTuJhB2zXtN/Qx4pttZjvh+azkL7mq8yyvceaQRsNi9izPxDAy3WQO2T+abV//fjBiA+LV+T0SQs7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvHXqm4s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvHXqm4s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28631F00893;
	Sat, 30 May 2026 18:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164842;
	bh=WE9kXCcEGJPqEFzNcb551JlPvWI+2ZgfG2Qlknu3rGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvHXqm4sqCPWy33b+sJTXpJGB3wTIZtUjP93CRrqXFT/bavmuP1+g1lJMeYJPQeAD
	 LVOU5kZEMPZBsaklnExhnlAc7jPuqISTsyk9ioHNODRCPwy40pWvi7Y+3aXWR8LF5t
	 xx2gIF2b+pAFhK15cfpiKZ6xZtdY9v44hbie88zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 675/776] Revert "s390/cio: Fix device lifecycle handling in css_alloc_subchannel()"
Date: Sat, 30 May 2026 18:06:29 +0200
Message-ID: <20260530160257.312889979@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

This reverts commit b1d4e6fb241672850296956c4d782a69363a3807.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/css.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index 4c3fde0bd5512..3c499136af657 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -247,7 +247,7 @@ struct subchannel *css_alloc_subchannel(struct subchannel_id schid,
 err_lock:
 	kfree(sch->lock);
 err:
-	put_device(&sch->dev);
+	kfree(sch);
 	return ERR_PTR(ret);
 }
 
-- 
2.53.0



