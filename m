Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E021F95A
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56ED0C433C8;
	Tue,  1 Aug 2023 09:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882938;
	bh=1CR21AlWjxmzx71U2Khe9P8MRrhwW44JW1deQZFeSaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es7AuvivQ4VYqOYpRe2gRnamBTmp6vkrEmD+45nopmFDv+rpLrKlMyHjYqFOKW8Ux
	 edoTSfTB/wK6xEeLrAIfkqoD1lY6QpjevI5smGQbFCOfIiyWO6ilF2rrEUPWUxWi14
	 FZvh5Gn0SKR/Zk49Ip6OhQI8R3d20yM48Y30omfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 056/239] soundwire: qcom: update status correctly with mask
Date: Tue,  1 Aug 2023 11:18:40 +0200
Message-ID: <20230801091927.553679050@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit f84d41b2a083b990cbdf70f3b24b6b108b9678ad ]

SoundWire device status can be incorrectly updated without
proper mask, fix this by adding a mask before updating the status.

Fixes: c7d49c76d1d5 ("soundwire: qcom: add support to new interrupts")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230525133812.30841-2-srinivas.kandagatla@linaro.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index e3ef5ebae6b7c..027979c66486c 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -437,7 +437,7 @@ static int qcom_swrm_get_alert_slave_dev_num(struct qcom_swrm_ctrl *ctrl)
 		status = (val >> (dev_num * SWRM_MCP_SLV_STATUS_SZ));
 
 		if ((status & SWRM_MCP_SLV_STATUS_MASK) == SDW_SLAVE_ALERT) {
-			ctrl->status[dev_num] = status;
+			ctrl->status[dev_num] = status & SWRM_MCP_SLV_STATUS_MASK;
 			return dev_num;
 		}
 	}
-- 
2.39.2



