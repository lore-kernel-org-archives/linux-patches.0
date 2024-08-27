Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7711C57B3;
	Tue, 27 Aug 2024 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770322; cv=none; b=PBwVQ/k3Xau7saT7OOIi1Qoo7YvyIjdHChMi3r1/OkKUdhXPLoKPoGAJVRLvvYAZy3Tlkbc8sy8ZuTn+Yik/ttI05b+Idcj80zkGALMRoux6oufSEdUKasDfgh6ZAu2up+XVjuiNRgRy6v+rXAxb9PA7p9zkFkqWtNsn+5dBMX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770322; c=relaxed/simple;
	bh=570j3/MzFzE7PoxuFCdMllXPaUGVG1+Ygt5JgSNFqJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=F3cCrVAJ7KlB56w2gVPDYeV/BR67JRD009p46FQ8Brp0mW/qYhrV1lv5fpURaLqxMoY57pn42DUN2U8n76MwZnSp+JreQ1vbzTl13oCwHTBQRVrMzHOjtuCRjkk2ZZg9GUHDzw8zbF3jw8Cln8u8jFrWdTQrYxBJS5a1wRryY18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiGy4p+g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiGy4p+g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81D6C4DE12;
	Tue, 27 Aug 2024 14:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770322;
	bh=570j3/MzFzE7PoxuFCdMllXPaUGVG1+Ygt5JgSNFqJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiGy4p+gJxYVRBI74z6r3LLTaa4Jd2FVht+Y4oDQ2G4Lyc+97rhNKEnDcOgqjGrU+
	 hSvfE/bbe4UWM6d7ifRS0RJmrwN9AlepPb6HV7c+1pxcEwz4OsappxvC7Kry8uh5D9
	 POH3byRbVwyXy4ISuk/TTg+itP+RIix+Qe1zwk2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/341] usb: gadget: fsl: Increase size of name buffer for endpoints
Date: Tue, 27 Aug 2024 16:37:06 +0200
Message-ID: <20240827143850.831536649@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 87850f6cc20911e35eafcbc1d56b0d649ae9162d ]

This fixes a W=1 warning about sprintf writing up to 16 bytes into a
buffer of size 14. There is no practical relevance because there are not
more than 32 endpoints.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/6754df25c56aae04f8110594fad2cd2452b1862a.1708709120.git.u.kleine-koenig@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/fsl_udc_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/fsl_udc_core.c b/drivers/usb/gadget/udc/fsl_udc_core.c
index ee5705d336e3d..10a82527626eb 100644
--- a/drivers/usb/gadget/udc/fsl_udc_core.c
+++ b/drivers/usb/gadget/udc/fsl_udc_core.c
@@ -2486,7 +2486,7 @@ static int fsl_udc_probe(struct platform_device *pdev)
 	/* setup the udc->eps[] for non-control endpoints and link
 	 * to gadget.ep_list */
 	for (i = 1; i < (int)(udc_controller->max_ep / 2); i++) {
-		char name[14];
+		char name[16];
 
 		sprintf(name, "ep%dout", i);
 		struct_ep_setup(udc_controller, i * 2, name, 1);
-- 
2.43.0



