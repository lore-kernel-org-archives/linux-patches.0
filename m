Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029618;
	b=LhXsToZ2S/Ynt0AsP2SAeApe0oyJGHNPkDRsIzyigV9voukoAzZnoYK9yYIondkfvc0U
	 gZ9WtpTOxxn50syz2mXXLifUj17S5Al2JUTrrpPz5TzYNlX+1793G8pRJNJFLEVcIDTSp
	 HdX6Wa7GkdK4IHgAdHJMoPIOr+fm3rTfiwjdj/RRMfbqCLCna5Rux9TO5/jkf3vlpiFPC
	 qFwkJPF6C0ZymeV0fkuiLSrh52nBYWAf06P5mn9p+PT7BXmjodxL34AipZqci2XpFWle2
	 9Nf/HijGbL6plTXDzAhyJNM8cEPFD/RyTWtaB8wTokL2M5YixbeHbxaGf2MCvsp1xZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MqVf2osESPKwDIeQsz20/32/CCi4/5vJwjSpod5gO6o=;
	b=Z5YnHPvlpejcorYd24di8wcgvFjsFIVbAz1xgZsJxRFd+PWACpKkAkQdXQaeN2wktmGs
	 ohSeLMm0lcSBOzq0xGp81/Mm1bq0iz/M0qCL8dqExiXQxgZJlrJLcnCoH0QQEQlKoWMyw
	 sftjppSo/vRl25g0H6aiyLHN97pBYQkPnkePGRFD6HD1suRSgqWg6fO+GRSPi9mhH/wop
	 676SvjJF4BH81oKRo1vZAl2ksYlZDTvnfrqZNhSdkex4ef8BmCeZCz7jijPLGTgHk8qI/
	 4RHGD+RB8+QHO05ZjHn4TYId4m2ld4XCy+ZDrGWTT+s68VzybpV/LoOWmtHLqsnMx/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kd/A4/Bm";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92418606A333;
	Wed, 18 Nov 2026 19:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kd/A4/Bm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85F51F000C5;
	Wed, 18 Nov 2026 19:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029618;
	bh=MqVf2osESPKwDIeQsz20/32/CCi4/5vJwjSpod5gO6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kd/A4/BmhgfFM6wGlOJZyNNSwS0JOj25u39IsHFnlBHSXKMrZRCnUDqsC88lNq1+7
	 +YWuw/OSIieNYtDKbtTneWjyOUlw8B9/zgAcOZr69hD6Q+oAyMRCuGh0bNBKBxpExR
	 xlsh+YGnFjBqODfRmoejFNvg0rkxkjNWZ4Nyxij8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0377/1756] clk: mediatek: reset: Fix device registration kernel-doc
Date: Wed, 18 Nov 2026 15:41:44 +0100
Message-ID: <20261118150023.475485957@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



