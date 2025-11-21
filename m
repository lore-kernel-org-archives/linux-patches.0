Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DCDE34F46F;
	Fri, 21 Nov 2025 13:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732708; cv=none; b=GTjq2x4Ao+UzZU39rhNoxN50P0cvjimkxyIpa+Zo7ME1jh/fTIl/w6J/0jHO1aeVATslDIN+FQbWb8qY5fR/XthxRjjrpJBPVwbBVcDyLIiTrPHqJRLCBNjlljU5xNav/OLUKXvkFowF6gbSJ+7D/qj25fba/0dg4Nc6juTFmj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732708; c=relaxed/simple;
	bh=aWh7D9ae01qbFfIBdkp/wXAbN4++Nv2Bx/LDNM7SoZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKUvKnpDeVBZi8IW/UvS5D5ZRskXQ9yyMhs1no+D3glv6EvTpM7/+kcGWETOX/EJaQ53sKonGhlZqpv7Y+U0oquUuZCcArJCKP3lvlZ/sSVNJFfbLozpFxgmt3uU1w540b4qlO/aEK5DsL9vGTOyjnJSrVm8Gs2ld2MUTfuNB88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFByMBzX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFByMBzX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B42C4CEF1;
	Fri, 21 Nov 2025 13:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732707;
	bh=aWh7D9ae01qbFfIBdkp/wXAbN4++Nv2Bx/LDNM7SoZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFByMBzXzUjyhnoYfb8U1RcYHHcR0fImee0NhoaEToJTVvzwmlanug/BsUlyLwPo0
	 9apaTvE1LYCpe+lilfUvTbDEmqPdToAvlpiAYyT0Fu3x2XRDYPbygo50TrIaDbNzoD
	 cQr9pFdb37Yinx346fq0ik6OiURNGfuZnb2ECE98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/529] media: redrat3: use int type to store negative error codes
Date: Fri, 21 Nov 2025 14:08:35 +0100
Message-ID: <20251121130238.700828419@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit ecba852dc9f4993f4f894ea1f352564560e19a3e ]

Change "ret" from u8 to int type in redrat3_enable_detector() to store
negative error codes or zero returned by redrat3_send_cmd() and
usb_submit_urb() - this better aligns with the coding standards and
maintains code consistency.

No effect on runtime.

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 9f2947af33aa7..880981e1c507e 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -422,7 +422,7 @@ static int redrat3_send_cmd(int cmd, struct redrat3_dev *rr3)
 static int redrat3_enable_detector(struct redrat3_dev *rr3)
 {
 	struct device *dev = rr3->dev;
-	u8 ret;
+	int ret;
 
 	ret = redrat3_send_cmd(RR3_RC_DET_ENABLE, rr3);
 	if (ret != 0)
-- 
2.51.0



