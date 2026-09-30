Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08EA646D2D2;
	Wed, 30 Sep 2026 17:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788760; cv=none; b=ioiN8byhc8t8AQbckGTEaP0tFLju08JhHrb5vnfNrFEBXu65PqQvJWHzKQmqyTAA3ypLD3HksSFc18QclmmGZfESJiW8TDtVwVyRfXgo/VIdPraXF1inZ5Em94fY2nILPF9Bd9Y1RtDQQZMd5iDrUsvKrBOjXw8awE2lBPDJNL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788760; c=relaxed/simple;
	bh=DUhriQCEnfyZkvc876ShmkaBsNB8Uybe3nqDAlilaxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fh/qcU6DC37N+5ZWS/5WlgR9/xFnEen8bCnjShLU1wo77RyKeDpZ+3dvpcJn77DIUi5dClKedLfssbRMXXgJlu06vQmHyZchMCaB2osn+4ddM1BOqt0t9jFrw7+r8lSiOc5KupZa73vZEvwys1D5o7a4C+gtPwHW9SgxTShb5ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTOSigSw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTOSigSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C761F000FF;
	Wed, 30 Sep 2026 17:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788758;
	bh=bc9HOM75PHO/c+ylN7F5Zi8rvsUzq4jAVLK9XA/bF9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NTOSigSwxIk5ElkT1tvzLJWEs940whI7QkRKbecWTSIqzs3QyhoA9eFSJs0OTMgFN
	 vFCaO7sSlzHE26l7+c5HG9yIHO9j84InLMMFTKhV1GPZfFNddct5zdFft0ukHhNfOU
	 V/CD710YGq8ledjKx92n4e9k8aRHY//7u5hf48f4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 237/877] Input: cyttsp5 - clamp the HID report size before memcpy
Date: Wed, 30 Sep 2026 17:19:08 +0200
Message-ID: <20260930152419.840066512@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 85f080fb87ed5cd3e46121be677f52c82f26a0ab upstream.

The size field comes from the device and is used as the memcpy()
length into response_buf, which is CY_MAX_INPUT bytes.

Fixes: 5b0c03e24a06 ("Input: Add driver for Cypress Generation 5 touchscreen")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Link: https://patch.msgid.link/20260901122649.1173066-1-gonglinkai@kylinos.cn
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/cyttsp5.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/touchscreen/cyttsp5.c
+++ b/drivers/input/touchscreen/cyttsp5.c
@@ -711,6 +711,7 @@ static irqreturn_t cyttsp5_handle_irq(in
 		size = 2;
 	} else {
 		report_id = ts->input_buf[2];
+		size = min(size, CY_MAX_INPUT);
 	}
 
 	switch (report_id) {


