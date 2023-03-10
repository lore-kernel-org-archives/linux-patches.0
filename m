Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0788481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB08C433D2;
	Fri, 10 Mar 2023 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457524;
	bh=2PrKZJowr1Ix8ElGxYOi8ACnKblOJKp+H8xf/h18p4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AKd9G49GuOPQgCSqTzelJMHQkBfpfM5XEY4gahJ806tOKeUgSvrptyHKV7OOXzEpw
	 JNoPOurItroPb5QwloY0l9H3ReIbQ7RR8txRoDi7n/3vrKqJ7Hgn4o7MCCk+EAg2u5
	 XuzpPE+bnNv5X1U4dPQ8RvFVjBke4sRTrbTyJ6bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/200] bus: mhi: ep: Fix the debug message for MHI_PKT_TYPE_RESET_CHAN_CMD cmd
Date: Fri, 10 Mar 2023 14:39:03 +0100
Message-Id: <20230310133721.317957661@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 8e697fcfdb9809634e268058ca743369c216b7ac ]

The debug log incorrectly mentions that STOP command is received instead of
RESET command. Fix that.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Link: https://lore.kernel.org/r/20221228161704.255268-5-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/mhi/ep/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/mhi/ep/main.c b/drivers/bus/mhi/ep/main.c
index 9c42886818418..357c61c12ce5b 100644
--- a/drivers/bus/mhi/ep/main.c
+++ b/drivers/bus/mhi/ep/main.c
@@ -219,7 +219,7 @@ static int mhi_ep_process_cmd_ring(struct mhi_ep_ring *ring, struct mhi_ring_ele
 		mutex_unlock(&mhi_chan->lock);
 		break;
 	case MHI_PKT_TYPE_RESET_CHAN_CMD:
-		dev_dbg(dev, "Received STOP command for channel (%u)\n", ch_id);
+		dev_dbg(dev, "Received RESET command for channel (%u)\n", ch_id);
 		if (!ch_ring->started) {
 			dev_err(dev, "Channel (%u) not opened\n", ch_id);
 			return -ENODEV;
-- 
2.39.2



