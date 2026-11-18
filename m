Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039801;
	b=Zhlp+d+1b7chRise+nzu1zp2ntYO9+gtA7THC1VQ2H1H9Wisx7EUm9s4NZIKAZ8EI1Lo
	 6HzcifaR2LDCXbU1qAZ9e0F/aWIaiXYcVxpA+cUasZDfLXl3+UwFa4I92GADxsSwtYhb2
	 oanDQ9BegZTj9KgwRii3Bjl8PYTspHsQMhnepK2vWQUSiHnW1uUn48EkNW/gdJiRwCZ64
	 kJdzqb/fxGMAHu2qQsGOcek6F1Lj2gRQa1VIB8gi0dwGJJ/LiP9094gxddZ+HXuHE90Hu
	 kKncNgzn0FLiBS5TCJWGZLl2PiNA7cMLeAWQyqjUT0PaGlJctyChW8CJAxROffbaOQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Au1EHTPmwzJkPwuHzishTWjPaMuVBckwNUj79ZW42Q=;
	b=PeiTtrqarLWM4hjimPLCk9briBVW4XdT1rmYhKCJKPx4X2nQkFcvn79SsZB8rRgr9slx
	 rM3lQV2amG52bUaK5I9Z6x1pCjdErK/p9LKX0uduKMc5XoG7+dLSk9L6Q9HvReXupgbEG
	 N7qEztL1NIzS/44yyNkyoKDxYiXa2g7eZ9Kr5IiYtbBEG8uZKWfpAdXI2RWontwkt7G+f
	 7hv9tRclLneLm/vfGRiI7F2cReK2LIR7cene53uS0mGl8C9/ezGdkyw2vc3/BjHMLSqpR
	 Nz7uQYICzkMQLYVTrEBkhZn6EBT20t3rfpBNPzmP7Yx733ZOsaqlTarzlou0Y+BIdCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbzGjq0z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C14F606A31C;
	Wed, 18 Nov 2026 22:10:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vbzGjq0z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD51A1F000C4;
	Wed, 18 Nov 2026 22:10:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039801;
	bh=8Au1EHTPmwzJkPwuHzishTWjPaMuVBckwNUj79ZW42Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vbzGjq0z0I6rCdrN4ZyjYT2bYAyLYE87tACp2e2PHdvYjSc3Dmm5rSVTyIeKEMmAk
	 X3VfbIWNE3byd+6XFW2B5X0o3HTLCcJNM/nK7rroL7PwbpEGDkDcVthOfy4/o/dG/y
	 aRnmDHe/l763PC3mYbNPpb3OVl8VWL0H//3mTwfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2189/3318] clk: mediatek: reset: Fix device registration kernel-doc
Date: Wed, 18 Nov 2026 15:46:51 +0100
Message-ID: <20261118150427.624892000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8d5fa37307ac1f0612cf17ac0ccabcc258cc1526 ]

The comment for mtk_register_reset_controller_with_dev() names the
older helper and documents np rather than dev. The new helper takes
a struct device and obtains its device node internally.

Use the actual function and parameter names and clarify that failures
return negative error codes.

Fixes: 761bc64003e3 ("clk: mediatek: reset: Add new register reset function with device")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/reset.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/mediatek/reset.h b/drivers/clk/mediatek/reset.h
index 562ffd290a224..b09cdcab0c4ba 100644
--- a/drivers/clk/mediatek/reset.h
+++ b/drivers/clk/mediatek/reset.h
@@ -60,11 +60,11 @@ struct mtk_clk_rst_data {
 };
 
 /**
- * mtk_register_reset_controller - Register mediatek clock reset controller with device
- * @np: Pointer to device.
+ * mtk_register_reset_controller_with_dev - Register a MediaTek reset controller
+ * @dev: Device used to manage the reset controller resources.
  * @desc: Constant pointer to description of clock reset.
  *
- * Return: 0 on success and errorno otherwise.
+ * Return: 0 on success, negative errno otherwise.
  */
 int mtk_register_reset_controller_with_dev(struct device *dev,
 					   const struct mtk_clk_rst_desc *desc);
-- 
2.53.0



