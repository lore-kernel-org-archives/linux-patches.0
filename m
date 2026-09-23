Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B05C493656;
	Wed, 23 Sep 2026 14:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173825; cv=none; b=WaTwYKxPIdXAspw97nApy1iDSMv9nvtVdHSi99RedMmbl2QNGbDychU1LLGKNlXHNoE0T8P2iTDvbUIG29Ii34oDRI+pw8L7sgdYHRGafsc7UzLJjKWnhQrVK+n37o5nQtZH/bc1w36jzI6WwBCG2dii/owVtQ6PTGqxO30mDz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173825; c=relaxed/simple;
	bh=1YAqVFgi+/EeEdbv/wCNWF4JQibf2H2LivNG2XWLgZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEjpJKmEdmqXr+iittzHxNRrMUOcrKt+Th/Z8F2CUhTRalnCybmnUF9RHYJBPn3mHg3P0EwCnKDhCy6VN/WrtsAeNVgoEFw/z+zoK6LWKilpPYj+B1VwaXAboAPWWSa11dYvFZpqDVGrfMW2OoLZyp50dIdLpbowfS0reNyFhHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUxifs3p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUxifs3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F1A1F000FF;
	Wed, 23 Sep 2026 14:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173824;
	bh=klQ16Kr7tmuPrEFrKU70nPQpnTlPeCVl6q1zk3/v3Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cUxifs3pL4CjLzl20XWTrqhsZnAnj+02xUEottf7bnCJLg0vfXgWrVQ7U0sHARh2A
	 3ju1KXSnOqmoyQSYnTDpEO3aJcpOVp+VX14gDs2t6hxihrRGHpr8lKrXGYKqYOemAR
	 XpQKhggGcy620k8j8JugTP+XfoRLMtGqXHxFNLNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 355/438] Input: cyttsp5 - clamp the HID report size before memcpy
Date: Wed, 23 Sep 2026 16:06:16 +0200
Message-ID: <20260923140654.038032912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -710,6 +710,7 @@ static irqreturn_t cyttsp5_handle_irq(in
 		size = 2;
 	} else {
 		report_id = ts->input_buf[2];
+		size = min(size, CY_MAX_INPUT);
 	}
 
 	switch (report_id) {


