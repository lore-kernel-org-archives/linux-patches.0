Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61F85383CA;
	Wed, 23 Sep 2026 14:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790175038; cv=none; b=dREtSzcoDzn+BpbBqxwdqcuiHnOGDpOGgI150n+1bIR+lmU9KZ/qBw/KeyOmhbF6z+BaGyjSMr3G2yZPwvr7h5QdyERc/aKOGG+E8WjS4SJV2PquysvsjnsDcJEfMoGGfEI5ml/kStT+I9jVTXBQrfMmWiMK3wEqRvNGRGEe22Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790175038; c=relaxed/simple;
	bh=l4qg46iwSd63ZJRZBSgZ+LBwG0Msdb3YNRuREsmMQUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JHJQTeBO+X0hyWlAttAtea9Os45dfakOaWuZTMnkYNJIZztE5eg4Rsw2AJE4xuKZr4WHH8AiDgEiaVqk5+CG2S7M0DxuX9N5EQkkZ+JpDRnooQpk94NhLf6DUc5JhGlJtisr29pIjq3yTMqCStt8v+PqdxLt/eChmUMwwrXwrHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvRf4VFq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvRf4VFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CFA1F000FF;
	Wed, 23 Sep 2026 14:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790175036;
	bh=mzAJB57GCzA59LpJjOP8LeV30hNUdMGxy+D5e6nJsDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvRf4VFq+1CNBs/jInkpa2dBqIxzcNtIV4Rx2cMX2cl7W772rlu9iKjVbJMDBS267
	 AYpqDMzgWSEZ5pP/ahs9TBm3NVbO+chkmdcI0SJDyXexLcJ981SkqSqq8jF1ZoCpQ+
	 /msH2A8yiHZb6tRa6HYom4OhHwSnsaQ46ktJpUAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shashiko <sashiko-bot@kernel.org>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 302/398] Input: soc_button_array - check btns_desc->package.count
Date: Wed, 23 Sep 2026 16:06:16 +0200
Message-ID: <20260923140651.249212899@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <johannes.goede@oss.qualcomm.com>

commit fb5022278b6ea7f1838e3ef78028d5d5e3375f65 upstream.

Check that btns_desc->package.count is not 0 before accessing
btns_desc->package.elements[0].

Fixes: 4c3362f44980 ("Input: soc_button_array - add support for ACPI 6.0 Generic Button Device")
Cc: stable@vger.kernel.org
Reported-by: Shashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-input/20260909091440.3384C1F00A3A@smtp.kernel.org/
Signed-off-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Link: https://patch.msgid.link/20260909093934.29411-2-johannes.goede@oss.qualcomm.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/soc_button_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/misc/soc_button_array.c
+++ b/drivers/input/misc/soc_button_array.c
@@ -377,7 +377,7 @@ static struct soc_button_info *soc_butto
 		}
 	}
 
-	if (!btns_desc) {
+	if (!btns_desc || !btns_desc->package.count) {
 		dev_err(dev, "ACPI Button Descriptors not found\n");
 		button_info = ERR_PTR(-ENODEV);
 		goto out;


