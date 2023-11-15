Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6174F3A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFxQZS9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE61C433C9;
	Wed, 15 Nov 2023 19:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077798;
	bh=IdQL+rR0O+wr2nnBYLUNSltz3Ce9lTHjCv/5QQGC6fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFxQZS9koqKbHwhnLAstMgNdr8plc3u9h0u4dP2eyBoLQ4nc8kjkWDob51SNo6B+x
	 0wTImIWUw4+clhdOd7vmhldqwholt3IGyuZww/5hnYI/RxOlpzGy/NtnfIqdA7yTN4
	 RLRA3pulj/V7CV5DRfYTqiKdfvWKRRKt/MEiBtiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 526/603] media: verisilicon: Fixes clock list for rk3588 av1 decoder
Date: Wed, 15 Nov 2023 14:17:51 -0500
Message-ID: <20231115191648.347968326@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Gaignard <benjamin.gaignard@collabora.com>

[ Upstream commit 39377f84fb98561b86b645f0b7c33512eba7afaf ]

Mainlined RK3588 clock driver manage by itself the dependency between
aclk/hclk and their root clocks (aclk_vdpu_root/hclk_vdpu_root).
RK3588 av1 video decoder do not have to take care of it anymore so
remove them from the list and be compliant with yaml bindings description.

Fixes: 003afda97c65 ("media: verisilicon: Enable AV1 decoder on rk3588")
Signed-off-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/verisilicon/rockchip_vpu_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/verisilicon/rockchip_vpu_hw.c b/drivers/media/platform/verisilicon/rockchip_vpu_hw.c
index 816ffa905a4bb..f975276707835 100644
--- a/drivers/media/platform/verisilicon/rockchip_vpu_hw.c
+++ b/drivers/media/platform/verisilicon/rockchip_vpu_hw.c
@@ -648,7 +648,7 @@ static const char * const rockchip_vpu_clk_names[] = {
 };
 
 static const char * const rk3588_vpu981_vpu_clk_names[] = {
-	"aclk", "hclk", "aclk_vdpu_root", "hclk_vdpu_root"
+	"aclk", "hclk",
 };
 
 /* VDPU1/VEPU1 */
-- 
2.42.0



