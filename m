Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724037BAF7;
	Wed, 21 Feb 2024 14:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525513; cv=none; b=sabBg8y73fL10HYd/5gzfLBpdzBXMOz5Vyog+w5oDKvvlFq6l2vFPebmD65EBEGByuTVdFkq0rXErrOuNHxhv/6+S0mTmYkCoLW+yCFbY6ULh8l4xX0lXsHHVv2982U9HUL/MS4d1EHMQWmx8pfnWmV6V3KDV/WRFwsCv4uDzK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525513; c=relaxed/simple;
	bh=YtoANlfhiM97WQFk0qTMA1FWbt2F92h/u1lPvLZnixU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGTayE5dgiSPG2uZu5XFzP0riWIJFyFjJxizubMdXZhVNFU21x2x0jgfGkeujx/zW6gnai7scj7rBM8X2ANPeBvGTXe8XwTQ8H/lZ7H5/zrk1oD19jko1qQlbwHphBH74X03CfCiaVHZx6q4JlwgNrHuDgELc+7v8zL+iIifzT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9vdMlWx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9vdMlWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A6CC433C7;
	Wed, 21 Feb 2024 14:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525513;
	bh=YtoANlfhiM97WQFk0qTMA1FWbt2F92h/u1lPvLZnixU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9vdMlWxM52J3nU8MtENSBNnh2C7UvVJBiD91sG/i9gJKU8QYdiNQeBMeoGXGZlaV
	 2zSblVoF9v/6laeRWLexVpccovDl7TVRIkB6gLsuEU6+NwfbeV1xfjZBXbWwE7647S
	 JplI2TXiZLeUJXLZu9bS+bZCPzmslzs1VQWBJrF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 179/267] dmaengine: fix is_slave_direction() return false when DMA_DEV_TO_DEV
Date: Wed, 21 Feb 2024 14:08:40 +0100
Message-ID: <20240221125945.752213069@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit a22fe1d6dec7e98535b97249fdc95c2be79120bb ]

is_slave_direction() should return true when direction is DMA_DEV_TO_DEV.

Fixes: 49920bc66984 ("dmaengine: add new enum dma_transfer_direction")
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20240123172842.3764529-1-Frank.Li@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dmaengine.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 8013562751a5..aa8bdc7473ff 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -815,7 +815,8 @@ static inline int dmaengine_slave_config(struct dma_chan *chan,
 
 static inline bool is_slave_direction(enum dma_transfer_direction direction)
 {
-	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM);
+	return (direction == DMA_MEM_TO_DEV) || (direction == DMA_DEV_TO_MEM) ||
+	       (direction == DMA_DEV_TO_DEV);
 }
 
 static inline struct dma_async_tx_descriptor *dmaengine_prep_slave_single(
-- 
2.43.0



