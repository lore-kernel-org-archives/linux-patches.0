Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063811;
	b=s4eHcXNsGxGiaEhmGoJ8/NvkrYEjdCO4KyIjSPER6p59HX2mZ7jWn5eWol/yKk9tPUPY
	 HbFWdJUOvuXnct9JAhcxuJgyuN/5t5StD5t1fI8Ob3I23C5BNjdNCN9WwN+C9zoJNNv01
	 GlAf+zJL9CHuAiwwyu4p0qodErPvV9TvOMU6izi3hXEPHOyNu/VFBDL10z+zUvI038SW3
	 p9Nu8cNTXw5bqJESxloVA7yR/4sGW1b6yWy7NHd0Rghdg7gmzCW4e9Uvl174pVWa0xilh
	 aEdVOlZuDE/TUg1wvcySpQA7NgO+ZxQFytqWLcNm90+uqEU+03d1hPI1IZoQ1De2qDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063811;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=etwrsGzrsT+li+aMKJECb8VdRd1BaD5UdO+ptay9UGM=;
	b=0FSH4FvksxDeUmVP/fyICxthycG7PCvzjbiUOi8ZTbmggfT4BC9wzHvu11Bu4YiiHGV6
	 ekC/ufh1oM0vPpO/HCr3nkAr4D3V+TetFQ6y56C3ZPu9izNtTuYFC/BpaGebmp3hhM5a7
	 AapCskoMZdToPpJFnJyNNOwkjQ/x1GZk04FnWHDryCLrZcqUYvzuFWPwK5f+VO0QGekMG
	 qLj+QAuF6Fh6ymaZMCFgzD2ixPbP8ECZ8wAGd8lxknNdtRfz329DItnNuPEmiKQytoGP2
	 c1Yu4B+WY3/BICVE9wYz0wXrqSGb3tqbM8ZyPwhpJCwTjV+uYm077SN+ucmVTpGQVug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQCs8dP2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BAC6082BF2;
	Sat,  7 Nov 2026 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQCs8dP2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2E91F0089F;
	Sat,  7 Nov 2026 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063811;
	bh=etwrsGzrsT+li+aMKJECb8VdRd1BaD5UdO+ptay9UGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQCs8dP2dt4e3ADvejiEoXgWEgT2xUl6R+7WHSod54hVuOVJJG6oahXzOLE2s7RHd
	 WEXHgAD6gQHvgwf9Ls0X0KvAykIqdXQpNnL2JxReBGFnSjWLHco2zKYFnu4holvU7D
	 GH8U/rzAtGOBrJgY9e4o2lW4YTuzbkwZa1icHCAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0029/1257] media: sunxi-cir: Ensure no more interrupts can occur before free
Date: Sat,  7 Nov 2026 08:38:45 -0500
Message-ID: <20261107134940.213423470@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 28e840a7e5b8c..af1ee08ffdbec 100644
--- a/drivers/media/rc/sunxi-cir.c
+++ b/drivers/media/rc/sunxi-cir.c
@@ -374,8 +374,8 @@ static void sunxi_ir_remove(struct platform_device *pdev)
 	struct sunxi_ir *ir = platform_get_drvdata(pdev);
 
 	rc_unregister_device(ir->rc);
-	rc_free_device(ir->rc);
 	sunxi_ir_hw_exit(&pdev->dev);
+	rc_free_device(ir->rc);
 }
 
 static void sunxi_ir_shutdown(struct platform_device *pdev)
-- 
2.53.0



