Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0413AC0C9;
	Mon, 23 Mar 2026 13:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274001; cv=none; b=OhfGmU2zwv+nsfPoDqG5FSWNAasv0HuGfXYdMEAFFn9uRBXfvqB9K5zEWEAQfpccCW3/VsBIfwvgNJ2g6125qFM+7e8eqMR8nT6lTWL8skZlNNIXfmddJYX8JTb5q7tiSTX8P7XTtlId/9wxGkywCi74SmAkHHSqntznLWIuk9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274001; c=relaxed/simple;
	bh=kCWwm7/OkZZfHu9AL1KN6P9A3qWER7Uj4/2FESNo0As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qbMvE6fAnInna8SDCS8q9Ni8Fke3x1+r2Zz+l8c5WkbKmXS6ZHNEUkjffQMvcUYIeycl16RfTM6i+vZMQJtxbterUj8+nZ2+u27/IsoOuEEhrIrF/Nrrds9ON6oyM5Ht/YwQa3npzveiRzQf0FujBz3kjW6UJKvLbaRB7wYjnTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0poIxfEG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0poIxfEG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFD22C4AF09;
	Mon, 23 Mar 2026 13:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274001;
	bh=kCWwm7/OkZZfHu9AL1KN6P9A3qWER7Uj4/2FESNo0As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0poIxfEGkLenIz/Mmja5YL+S6NRpF9dXKuRr3SgAYCmBMvytWAcO17CyL332ae+9f
	 o8aee6l+7tcddOGwQBEpOaXS545peuVOmlUANW/00JZru4qbh/qYWbOecGonP5+sj7
	 Z2hSsnFqniDsWCeCn/RYlbk5/DGxKxGfSS21DJaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 033/220] firmware: stratix10-svc: Delete some stray tabs
Date: Mon, 23 Mar 2026 14:43:30 +0100
Message-ID: <20260323134505.628102692@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 9e51d1da5b245c9bf97fc49b06cca7e901c0fe94 ]

These lines are indented one tab too far.  Delete the extra tabs
for readability.

Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Stable-dep-of: 22fd7f7fed2a ("firmware: stratix10-svc: Add Multi SVC clients support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1317,7 +1317,7 @@ int stratix10_svc_async_send(struct stra
 		dev_dbg(ctrl->dev,
 			"Async message sent with transaction_id 0x%02x\n",
 			handle->transaction_id);
-			*handler = handle;
+		*handler = handle;
 		return 0;
 	case INTEL_SIP_SMC_STATUS_BUSY:
 		dev_warn(ctrl->dev, "Mailbox is busy, try after some time\n");
@@ -1702,12 +1702,12 @@ int stratix10_svc_send(struct stratix10_
 			kthread_run_on_cpu(svc_normal_to_secure_thread,
 					   (void *)chan->ctrl,
 					   cpu, "svc_smc_hvc_thread");
-			if (IS_ERR(chan->ctrl->task)) {
-				dev_err(chan->ctrl->dev,
-					"failed to create svc_smc_hvc_thread\n");
-				kfree(p_data);
-				return -EINVAL;
-			}
+		if (IS_ERR(chan->ctrl->task)) {
+			dev_err(chan->ctrl->dev,
+				"failed to create svc_smc_hvc_thread\n");
+			kfree(p_data);
+			return -EINVAL;
+		}
 	}
 
 	pr_debug("%s: sent P-va=%p, P-com=%x, P-size=%u\n", __func__,


