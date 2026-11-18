Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050873;
	b=EFQvwZj2LHBx8E2zq8rgoOYk4Tsv5K7tH6gRxcv9XTfn7KnFc6tJLdd1hK4aA1amRcom
	 0QCCQE/kfpRnRS2kkDE9fyhd8k+BYTPDwsaFX7DoAWRRjSPwkxlrfO6yGEthfKgeQlTcH
	 /VY7kt0wQ0MgiOxn3Yjo18AAYMVm5+F72ycGuidie4S7q5BfERbvMz+l3mufvnhpmrK1c
	 92nDQBI4ff3jOZWnN6Kyn0YcnEybI2B260/j18e9b6LvW9LPrGpwZ2U/XEq/c7XwCsyJ6
	 bGvRSqT+oE1+LwtCoQLuwSFk5EWWdJBaPA4W3oXtw+TNThRCeZWc9ZB7j9AbJ7QCY7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050873;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DbAcOWTtdxjgwnqwLI84a2ZHP+5vqtm2rUy+Q4c8NHY=;
	b=POAMwYLNUBTAg/pnb5j44nVYK2hnr9y2ivwPYFNDHWtjGUg1kKtXNen62R1CQLhXZvrU
	 xojg2Z2nR/wBWcs+kd3CXTrPDDubqSfUCVCZ73gC+5BcBoBCtE241e6a3/unT2YMp11mQ
	 tUAskY0ToCg9HMCipyKegRUPKT1J7OggArFeTFXPAW+LaF6kcJSC1wjoUAz33OdKc/C26
	 wds+3758xCTzsSYWgUfRtrvV9rKkRABqd8GhtA8SArRhqATSd2TOhAK2HVUN/Xdimbr0V
	 WO3Ukxo/0hrIonAi7iZ6a9CcVrWSGKzT8qiWLuZf7/JhWmbTbQoo3ExX4sFHPf82Vqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLN7rjsp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E934606A32A;
	Thu, 19 Nov 2026 01:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kLN7rjsp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6E81F000C4;
	Thu, 19 Nov 2026 01:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050873;
	bh=DbAcOWTtdxjgwnqwLI84a2ZHP+5vqtm2rUy+Q4c8NHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLN7rjspZ8mhgh96GS3NMRTRkKLNoWQoqb27vHzwU67xTKnhuXqrfjsXBvkliQDXO
	 XINYr2B0IZ+HxdAqNS6+0ybtxm+QX+8OOxTDA1swJ5SwFE0b+I6XaDp3LewPsnpDU1
	 qwmT3eiwmKzTesB+AFUmj8+QLDmFurESHjneehyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Lad Prabhakar <prabhakar.csengg@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 6.1 2848/2857] media: davinci: vpif_capture: fix error return code in vpif_probe()
Date: Wed, 18 Nov 2026 16:04:42 +0100
Message-ID: <20261118150344.128633970@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Yingliang <yangyingliang@huawei.com>

commit 92d748703790c03fa797e07b41c922c69ad529f5 upstream.

Set error return code, when get platform data failed.

Fixes: b4a4547371b9 ("media: davinci: Init async notifier after registering V4L2 device")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Lad Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/davinci/vpif_capture.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/ti/davinci/vpif_capture.c
+++ b/drivers/media/platform/ti/davinci/vpif_capture.c
@@ -1643,6 +1643,7 @@ static int vpif_probe(struct platform_de
 
 	pdev->dev.platform_data = vpif_capture_get_pdata(pdev);
 	if (!pdev->dev.platform_data) {
+		err = -EINVAL;
 		dev_warn(&pdev->dev, "Missing platform data. Giving up.\n");
 		goto vpif_unregister;
 	}


