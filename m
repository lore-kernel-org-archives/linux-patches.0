Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AEE33508C;
	Mon, 27 Oct 2025 19:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591612; cv=none; b=t4NVqAQ0OHN3itcnVPIsHvaBCqjrxcz7NuV3KVNki4MXLJJnTkIJe5rVlDS5+4YeQkGu6LKoRcSchdK2u31R+y9h3o6Z7NPO9F7aV5mDr9AkSj3d5U7w6eFmbkdtMbjmKQw9od0IVWUiuAfAdA6CFly1LvqAuNxyXoD/F75tugE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591612; c=relaxed/simple;
	bh=FRmIOf6T74eJPDrhLJXTGPAAsWBRZW/x1kqweQF5SX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtvAgSrOTrgBnqxBmWcgv17Rhc8N9GVW9r5SrdqQMVoO3DKnZyEJxNXjHkBuF8Ojz7TA+SdSCcpoKbR8Ct+WmnYgZrllASQ2306acPFtJBLepICEl76x2AEQtgeWcM5gT4ZSuUlhOnO/xqR0qML37c2XSeGyuMPHHJyc6AkyH0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+NcPzab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+NcPzab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5F8C4CEF1;
	Mon, 27 Oct 2025 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591612;
	bh=FRmIOf6T74eJPDrhLJXTGPAAsWBRZW/x1kqweQF5SX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+NcPzabTufG1QKyk6u2p9qXIJK0YDJ1ohdOnPN1VArzG2Wx1Ytdf6dJC3SiEXAY5
	 9UfpxjG9EyHmNupHeTNQoGIZ7Ve9wSHPtw4+ZI67Zry9s7jvy8MTUlAEXPGArhI2rI
	 4wv3Oqy3rjwEtNj1YxR1+CsebN4AxUvTeqimX4iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Xue <zxue@semtech.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/332] bus: mhi: host: Do not use uninitialized dev pointer in mhi_init_irq_setup()
Date: Mon, 27 Oct 2025 19:34:45 +0100
Message-ID: <20251027183530.935618719@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Xue <zxue@semtech.com>

[ Upstream commit d0856a6dff57f95cc5d2d74e50880f01697d0cc4 ]

In mhi_init_irq_setup, the device pointer used for dev_err() was not
initialized. Use the pointer from mhi_cntrl instead.

Fixes: b0fc0167f254 ("bus: mhi: core: Allow shared IRQ for event rings")
Fixes: 3000f85b8f47 ("bus: mhi: core: Add support for basic PM operations")
Signed-off-by: Adam Xue <zxue@semtech.com>
[mani: reworded subject/description and CCed stable]
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250905174118.38512-1-zxue@semtech.com
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/host/init.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/bus/mhi/host/init.c
+++ b/drivers/bus/mhi/host/init.c
@@ -147,7 +147,6 @@ void mhi_deinit_free_irq(struct mhi_cont
 int mhi_init_irq_setup(struct mhi_controller *mhi_cntrl)
 {
 	struct mhi_event *mhi_event = mhi_cntrl->mhi_event;
-	struct device *dev = &mhi_cntrl->mhi_dev->dev;
 	int i, ret;
 
 	/* Setup BHI_INTVEC IRQ */
@@ -163,7 +162,7 @@ int mhi_init_irq_setup(struct mhi_contro
 			continue;
 
 		if (mhi_event->irq >= mhi_cntrl->nr_irqs) {
-			dev_err(dev, "irq %d not available for event ring\n",
+			dev_err(mhi_cntrl->cntrl_dev, "irq %d not available for event ring\n",
 				mhi_event->irq);
 			ret = -EINVAL;
 			goto error_request;
@@ -174,7 +173,7 @@ int mhi_init_irq_setup(struct mhi_contro
 				  IRQF_SHARED | IRQF_NO_SUSPEND,
 				  "mhi", mhi_event);
 		if (ret) {
-			dev_err(dev, "Error requesting irq:%d for ev:%d\n",
+			dev_err(mhi_cntrl->cntrl_dev, "Error requesting irq:%d for ev:%d\n",
 				mhi_cntrl->irq[mhi_event->irq], i);
 			goto error_request;
 		}


