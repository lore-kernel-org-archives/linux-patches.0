Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035711;
	b=VAzXgC2BEKU/CkyZfG3gFnT9qKow1h6mG3AaDSiPXg1KZfQMvm5toLwMa2Ua9ajKRmjb
	 tcemzWNMAK2fHy7E6ro4/iAaBUqBJ6ODcC6upBhuxiwxEL1jS51Aclo/B02LMG9bO0YgJ
	 2qwIFqfoXIESTeR053RC5WWEiLq6sgVvRlRsxsF/fzj/Az5blXB+UJ5xgdpAL8TdacNZ8
	 dTzAZxyOp/mtj17Le4RCdvDKYaIXEFvduV60lqM7H/qUqbKL4m7DcXjDVGEP9BGDGSO+G
	 JwF8h1E11pdRVkqJuzQGRLKgOKsz1JjccP5wq+Xe7+RLNv6CHkadcqPNyhnBP53blAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035711;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5nhasKrK5mxKT2ybFadnWRPOFBoq0HL34461zY2MaZ4=;
	b=uF9+z19Afhya7ymzBWiI4GUdWCjh0ISbtkeNfNcbX1rvX7M4njdsxYy1EAZ5IqLRTBAk
	 7neOtbfpP3o4PqrKIKmABmosx6IBrTVrzPmJE2OipDp+J7VQ0tXwbswGg5zTKql2JUb6j
	 pMBVdN8SlNYRFvj2BgyPr/ato3WoUMeRtOHsyQkIVQZ69hqq9su1odll5AiUbr5QJEoqw
	 8o3vfpjya3MuaiAjycUJBJpB7WU8MF0KuTdVmvA9RJgQ5vMTjeDCQAeqBLvcFgRcUgOU4
	 CWNDwq3V9LJppldqFBOc9o+q+M1UY4B5F6/xHsQDrgoAj3PdL2Di8TDMGZIuz95nMqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtOSFUc2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B377606A32A;
	Wed, 18 Nov 2026 21:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HtOSFUc2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7D01F000C4;
	Wed, 18 Nov 2026 21:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035710;
	bh=5nhasKrK5mxKT2ybFadnWRPOFBoq0HL34461zY2MaZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HtOSFUc2PqRGsDZWBTut2lMoemf/USGq6lzloqqslE2BqkwuBiCOVMJoGVI8Utgr9
	 0S5LYbMte+6f8XJy5rw/2cRWOr+vKTeoO5kVNc7BBsgPeV4p3W4HEIsy5dNtb4OfF4
	 q/xByu73lsjY+qtVC8JMxr2MEv9VFiCRJAJg0EA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0801/3318] media: sunxi-cir: Ensure no more interrupts can occur before free
Date: Wed, 18 Nov 2026 15:23:43 +0100
Message-ID: <20261118150342.968689582@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit f9b33ec404200c03dd490ec133b8f9bf599c5444 ]

Only call rc_free_device() once the hardware has been stopped.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/sunxi-cir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/sunxi-cir.c b/drivers/media/rc/sunxi-cir.c
index 6b12453430644..dc9d983d15aa3 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -373,8 +373,8 @@ static void sunxi_ir_remove(struct platform_device *pdev)
 	struct sunxi_ir *ir = platform_get_drvdata(pdev);
 
 	rc_unregister_device(ir->rc);
-	rc_free_device(ir->rc);
 	sunxi_ir_hw_exit(&pdev->dev);
+	rc_free_device(ir->rc);
 }
 
 static void sunxi_ir_shutdown(struct platform_device *pdev)
-- 
2.53.0



