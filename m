Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B0991BB6A4;
	Thu,  6 Jun 2024 14:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683492; cv=none; b=uGnvN/D4q8HRIhdABKknhZ3KgyRYFjLHMhsq1ND3MnYIUrXsJmgXYwNsDO7AftDA83+r8Py6uM0NJpVT7pvxGyMEL3TBIBAOfwmhguqN6+CFNhOLQ67UjVLPvGf44Ejt00L3E+lhGSv/GbgYKx32tXtoq1dF8gPXEoBDW0u4CF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683492; c=relaxed/simple;
	bh=nCUC9v3Bu9wF82tU/ar5PnsttFeKCt7HQGrydNIRwrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLdAMEpVUPe7P3EQm7T6XFM5fMYfbkaK0Uk+twGrwvgjjapNeaUscb+5Y9yGDZXL2SG41oULbB2IWBMESGdaPxd99BhSJRDZffNj2F5+w8fJUXqGffVofsiqzPZwVoWZFIbYVynM4ZdacCduW43aG0FJ/V8lEYWsWYsyqXXtgao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mREDPS8S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mREDPS8S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE2EC32782;
	Thu,  6 Jun 2024 14:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683492;
	bh=nCUC9v3Bu9wF82tU/ar5PnsttFeKCt7HQGrydNIRwrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mREDPS8SWljrL1XOZCGEhY0eVvRKlNjrAANGz1Dq0Q5/UiVU5M793JzNrXDkBK4T2
	 pjTxPVHGdCM/ql/MJHIOYrlu8djyxoTgRM/18St4lWzj/GvCQmo7GF0RzwyrD2SnMe
	 9wUrCjrfWa0gNkYgE3PpG/EVwHGE9eEt4z331yPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <mudongliangabcd@gmail.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 382/473] media: flexcop-usb: fix sanity check of bNumEndpoints
Date: Thu,  6 Jun 2024 16:05:11 +0200
Message-ID: <20240606131712.482792814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Dongliang Mu <mudongliangabcd@gmail.com>

[ Upstream commit f62dc8f6bf82d1b307fc37d8d22cc79f67856c2f ]

Commit d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type
") adds a sanity check for endpoint[1], but fails to modify the sanity
check of bNumEndpoints.

Fix this by modifying the sanity check of bNumEndpoints to 2.

Link: https://lore.kernel.org/linux-media/20220602055027.849014-1-dzm91@hust.edu.cn
Fixes: d725d20e81c2 ("media: flexcop-usb: sanity checking of endpoint type")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/b2c2/flexcop-usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/usb/b2c2/flexcop-usb.c b/drivers/media/usb/b2c2/flexcop-usb.c
index 790787f0eba84..bcb24d8964981 100644
--- a/drivers/media/usb/b2c2/flexcop-usb.c
+++ b/drivers/media/usb/b2c2/flexcop-usb.c
@@ -515,7 +515,7 @@ static int flexcop_usb_init(struct flexcop_usb *fc_usb)
 
 	alt = fc_usb->uintf->cur_altsetting;
 
-	if (alt->desc.bNumEndpoints < 1)
+	if (alt->desc.bNumEndpoints < 2)
 		return -ENODEV;
 	if (!usb_endpoint_is_isoc_in(&alt->endpoint[0].desc))
 		return -ENODEV;
-- 
2.43.0



