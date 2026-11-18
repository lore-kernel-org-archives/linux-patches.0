Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061292;
	b=UtnKuOjBn1XyhyJEsTWQ4L+meg3hKWxiazXj2HrFihKFbzaSpHpTUC88koLSTjRzL/28
	 YGrUZ0VddfLQQnbfs+S1F9Ok1OxMeDeQseI8YPWSJwPQ+eiJ0JDE2ixcE5xjmK8Vgyl6c
	 SmaENEP4lKtHVUmxNyUwcOCRwOgrrtlUfzgUTavjxFC8x7EQHeolRhMjTaMsHSwTi9pCC
	 RUtxb3unmEYNHOt70Yd+3a1BMBkfyQ65KD+LhSIJT92/0LZ+Z88miV9B9yfR2/9+iaUxI
	 qBIRQGb0bf7lKs4jmfvcl7eCORlaK/7G2U8yvFpOGBQID1+XXMyRe2y5HpfwRTwF8YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sCbLBSUpM/iEnVo3WPdOWmQY+3/trwLd0wXDC4waD6Y=;
	b=m2HIVMQW4pdu8Gqt+eNNwcBXLJxLykgM/BhDRl3eQwI042HpZ6PknRryJyqcjMdO2181
	 z9YCxVa8d/opiFsuF6WYiPJrypjGpeKAMMpK1bx1HV2jePPd+hhrarv5Xs6nG0zLUUHPa
	 50LmvJb5tFKC8JObLr+ZDqui1hROK0ULTsrmkp9233cwJuLGLtXbKpUqhjPqPrjw68CPm
	 eGKf75ivhqL40DdIXzdvGTy7SQKvGHNbEMAX34xUnptIePu5wyW7FApWO8tKU5xjZ6EOD
	 Otnu73A7G8KIgHDSq4XdypTKF0tXFdG3HOI829LPTdUXQTGedNWJSGwykdbj2ny6tkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+iSNMv5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED144606A320;
	Thu, 19 Nov 2026 04:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D+iSNMv5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498461F000C4;
	Thu, 19 Nov 2026 04:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061291;
	bh=sCbLBSUpM/iEnVo3WPdOWmQY+3/trwLd0wXDC4waD6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D+iSNMv5yX9Kx9xmQHlHANg6nG5YWQ8XIvVD+ERHh5220oLOVm+oxNOB1RvptH1cG
	 RNdla8FdX8v6Mqksy4n7tw199gnTUueD30ExhVElL0b+53Uv8WhMeZrezIEDMGAbWF
	 QDICS60KBcdxaGpKqdpsaHITCqZXYEu3r6tpgm48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1499/1848] dmaengine: ste_dma40: Validate disabled channel indexes
Date: Wed, 18 Nov 2026 15:58:57 +0100
Message-ID: <20261118150022.118313951@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit c96e9f056095825b5f8d4a11f4107fc174892f92 ]

d40_of_probe() checks how many entries disabled-channels contains, but not
the channel numbers themselves. d40_phy_res_init() later uses every value
as an index into base->phy_res, whose size is the number of channels found
in this DMA40 instance. An out-of-range value can therefore write beyond
the allocation.

Validate each disabled channel against the detected hardware channel count
before allocating and initializing the channel resources.

Fixes: 499c2bc3cc89 ("dmaengine: ste_dma40: Fetch disabled channels from DT")
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-16-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index aa268ecb53582..8cb561d0dad70 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -3232,6 +3232,15 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 
 	num_phy_chans = min(num_phy_chans, STEDMA40_MAX_PHYS);
 
+	for (i = 0; plat_data->disabled_channels[i] != -1; i++) {
+		int chan = plat_data->disabled_channels[i];
+
+		if (chan < 0 || chan >= num_phy_chans) {
+			dev_err(dev, "Invalid disabled channel %d\n", chan);
+			return -EINVAL;
+		}
+	}
+
 	/* The number of channels used for memcpy */
 	num_memcpy_chans = plat_data->num_of_memcpy_chans;
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
-- 
2.53.0



