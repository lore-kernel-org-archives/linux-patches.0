Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F11FC07
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57630C433C9;
	Thu, 24 Aug 2023 14:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889197;
	bh=Bbv5zzSAXIIhz94OBhqvRsU8lM74FzkGBoPDJOW51Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldD646i7TUO9aPf5dynel1OhlPAgmzDZHy7/uJUvp5y3SQ9LFB1/YP4yaWK20vXu2
	 DEZMO+ACJRf8qPkmU/TtneXsSYLUTooXKlqXVH2IbaAiXbFBhCOfVOpbVBDQfcrMjR
	 2rpz8vxJ8g9TwHrPQ2G4sBso0BNw4upf/nMbNCgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Hemant Kumar <hemantk@codeaurora.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bhaumik Bhatt <bbhatt@codeaurora.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/135] bus: mhi: Add MMIO region length to controller structure
Date: Thu, 24 Aug 2023 16:49:52 +0200
Message-ID: <20230824145029.043784759@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bhaumik Bhatt <bbhatt@codeaurora.org>

[ Upstream commit baa7a08569358d9d16e71ce36f287c39a665d776 ]

Make controller driver specify the MMIO register region length
for range checking of BHI or BHIe space. This can help validate
that offsets are in acceptable memory region or not and avoid any
boot-up issues due to BHI or BHIe memory accesses.

Link: https://lore.kernel.org/r/1620330705-40192-4-git-send-email-bbhatt@codeaurora.org
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20210802051255.5771-6-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 6a0c637bfee6 ("bus: mhi: host: Range check CHDBOFF and ERDBOFF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mhi.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index d4841e5a5f458..5d9f8c6f3d40f 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -303,6 +303,7 @@ struct mhi_controller_config {
  * @rddm_size: RAM dump size that host should allocate for debugging purpose
  * @sbl_size: SBL image size downloaded through BHIe (optional)
  * @seg_len: BHIe vector size (optional)
+ * @reg_len: Length of the MHI MMIO region (required)
  * @fbc_image: Points to firmware image buffer
  * @rddm_image: Points to RAM dump buffer
  * @mhi_chan: Points to the channel configuration table
@@ -383,6 +384,7 @@ struct mhi_controller {
 	size_t rddm_size;
 	size_t sbl_size;
 	size_t seg_len;
+	size_t reg_len;
 	struct image_info *fbc_image;
 	struct image_info *rddm_image;
 	struct mhi_chan *mhi_chan;
-- 
2.40.1



