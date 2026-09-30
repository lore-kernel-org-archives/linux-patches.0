Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8A133DEF9;
	Wed, 30 Sep 2026 18:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792167; cv=none; b=QzU9MmUX6XcIxfFm7GJC7i1QqoXEnsXhULpzhhrqkUWPQnyZrHNIyMjdxIxsIENsxUttnioYUMxh+THUqD8aHDd+1mQYU+en9xgK/fmDpkOv+gijbrnAKaM/hhMcVH3fKvi99GJI1vAhxRogtQoca+gRrjmistB0VWrqfYOWHGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792167; c=relaxed/simple;
	bh=dYor3OYQP2/7jgL7Zcnrpv6Sg/qGjpfsajzmPQ1zExc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2Kw8+Dnh9rTsF6bxH44ysdZAs2h6Zf98QtRFGS1IQCN1Y+WFLd2vqEwTM4SxDnE+SXWqPAVqPPAOXgK2Y4qHdmgUb4sTJiooRSRUJAN8kNMZg/AcuzWIOU2Yza0WZA0EMQlrJaqXxeLYtyhgh6Oc4xNTuInIlMJCQ3xBp/H5bU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EPOHs4Na; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EPOHs4Na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0121F000FF;
	Wed, 30 Sep 2026 18:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792166;
	bh=9bNB8cua4kvP1EwcDPCjyrvLYlCn/WZbdoYs1+6Kxy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EPOHs4NaiScAmaglFQZBAxfnxdKQDNU7/4k/4Ra6z2ocJ8K6QHqux69GvVFsotO0C
	 YdAzb24F0MY05WdeLr/QX3mEqvUr/RkoPGKVW8+5D3InGwjc8GK2sABi2OyO0JSxEu
	 6fxuoh0DBkewCbUZis/tkiD0epVJyoQ46bGwmOvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"hpp.iscas" <hppiscas@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 514/752] Input: eeti_ts - publish the OF module alias
Date: Wed, 30 Sep 2026 17:26:24 +0200
Message-ID: <20260930152409.380325360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: hpp.iscas <hppiscas@163.com>

[ Upstream commit a52ae68a937efc353251aec27fc995ff66cbe1ca ]

The EETI driver matches eeti,exc3000-i2c Device Tree clients, but only
publishes the legacy eeti_ts I2C ID. The I2C core emits an OF modalias
for a Device Tree client.

Publish the existing OF match table within its CONFIG_OF guard.

Fixes: e32d7f1b246c ("Input: eeti - add device tree matching table")
Signed-off-by: hpp.iscas <hppiscas@163.com>
Link: https://patch.msgid.link/20260905134004.66336-1-hppiscas@163.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/eeti_ts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/touchscreen/eeti_ts.c b/drivers/input/touchscreen/eeti_ts.c
index a639ba7e56ea0..d73b3071c357d 100644
--- a/drivers/input/touchscreen/eeti_ts.c
+++ b/drivers/input/touchscreen/eeti_ts.c
@@ -284,6 +284,7 @@ static const struct of_device_id of_eeti_ts_match[] = {
 	{ .compatible = "eeti,exc3000-i2c", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, of_eeti_ts_match);
 #endif
 
 static struct i2c_driver eeti_ts_driver = {
-- 
2.53.0



