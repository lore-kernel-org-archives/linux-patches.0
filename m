Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED65B2AF07;
	Mon, 28 Oct 2024 06:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098207; cv=none; b=lBWkK6XuQM/8lbAZNCIYa5jyrOd7Yj5mLbrfrb3Hdi/AMbrGL24WcUxHP+vSyXLRVvAayBwqAP5nV/2O8COdQMs82g8UIPug7U0PgPtedmysY8VuknZiaVsH9rMuj+lqPI6CSsPP1GnZ0E5Hkq3tHI1LWSbw6UulOn68p7mRpqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098207; c=relaxed/simple;
	bh=KZC6GwFhgOGDktCGFmM+eSyxx8td2Jh7eqzc+PbzMlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjI7lZCJHOuKtQ18k0Opc6XR63xm9XMqJyPuIp5zPneSXVINQ1gBFOew+CqtOgvlFcDLipmg6IoFBsZsG58kfnlymsfRtjnXHKOusJ2cO/oPuEQasHS1z2vkuiAPmMujAVha1vvxaJgWHk4uDajyjWfKdPB6UR9ow0jZX+x/TCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVLsQR5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVLsQR5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8F6C4CEC3;
	Mon, 28 Oct 2024 06:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098206;
	bh=KZC6GwFhgOGDktCGFmM+eSyxx8td2Jh7eqzc+PbzMlQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fVLsQR5xbb0BnCez+qSjtcr+ju3C6WuFLqUU5BQXuMCRT5JXcLq2K90DGcS7zcZIg
	 ykx5BNTNvk22Dyc7q3X229OL1/VZ3lgFibNiDtpWRdOBJabg3aIYu1Q+YnJzTmCpFA
	 cykLmbzSNgog8AXaXv0LbX9mRRkVzRNcjonmXkpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Klimov <alexey.klimov@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 124/261] ASoC: codecs: lpass-rx-macro: add missing CDC_RX_BCL_VBAT_RF_PROC2 to default regs values
Date: Mon, 28 Oct 2024 07:24:26 +0100
Message-ID: <20241028062315.142139233@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Klimov <alexey.klimov@linaro.org>

[ Upstream commit e249786b2188107a7c50e7174d35f955a60988a1 ]

CDC_RX_BCL_VBAT_RF_PROC1 is listed twice and its default value
is 0x2a which is overwriten by its next occurence in rx_defaults[].
The second one should be missing CDC_RX_BCL_VBAT_RF_PROC2 instead
and its default value is expected 0x0.

Signed-off-by: Alexey Klimov <alexey.klimov@linaro.org>
Link: https://patch.msgid.link/20240925043823.520218-2-alexey.klimov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/lpass-rx-macro.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index ce42749660c87..ac759f4a880d0 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -958,7 +958,7 @@ static const struct reg_default rx_defaults[] = {
 	{ CDC_RX_BCL_VBAT_PK_EST2, 0x01 },
 	{ CDC_RX_BCL_VBAT_PK_EST3, 0x40 },
 	{ CDC_RX_BCL_VBAT_RF_PROC1, 0x2A },
-	{ CDC_RX_BCL_VBAT_RF_PROC1, 0x00 },
+	{ CDC_RX_BCL_VBAT_RF_PROC2, 0x00 },
 	{ CDC_RX_BCL_VBAT_TAC1, 0x00 },
 	{ CDC_RX_BCL_VBAT_TAC2, 0x18 },
 	{ CDC_RX_BCL_VBAT_TAC3, 0x18 },
-- 
2.43.0



