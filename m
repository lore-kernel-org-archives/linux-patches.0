Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED8926FD9B;
	Mon, 29 Dec 2025 16:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025296; cv=none; b=FEteKIMrZcXhs597NLlCK253w4So0HoEmdrBKwBNQmMbXRlx/F9GkIQ1X1HE3pYAvpqTNC39ljeaaAidBL7v07FL5/W0MV2c7Tgwh3gDGr3TFZA1LtVEgd/ni8LYhcI9LM+xvD5eN4qAd8qvJZQi9K+Ln2S2XFNvmL0PO+uujbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025296; c=relaxed/simple;
	bh=TQJHHvHHpoU4eeK42K7+55A3eC9tb8D6bGui4bpNvsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lu1Z4As1phQyfBi2NPVCYvdaxxMu2ewJZomTcxgi/VUsbyrNcQtry9tKeHxHfLzbpcW9bsYjtjLO7M2yMbnBQzGb64DAPX/ckd/bxosHixxNUK82GnDjmNnDfqnbYc3jZa/UpVaAUjjT5MzELbn3wbbqfyeFdqrPyH88ZIrm/QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofpreNh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofpreNh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF7E7C4CEF7;
	Mon, 29 Dec 2025 16:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025296;
	bh=TQJHHvHHpoU4eeK42K7+55A3eC9tb8D6bGui4bpNvsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofpreNh9KaH7vt+5KsTxVORmNH6/U9yaSLs2Md0Uq4KG/yqS6UyYh0j26dzGoDacv
	 l/zUqfUjDj8VHopAKgv0ib22W09b2ofoh/uJH1qysgsa9OR94eicjA/FuGKnpHRT9r
	 su8Onp+8RFR0cv2fPY4R37G3RavpeSmiUfhSLsGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 162/430] dt-bindings: mmc: sdhci-of-aspeed: Switch ref to sdhci-common.yaml
Date: Mon, 29 Dec 2025 17:09:24 +0100
Message-ID: <20251229160730.325230139@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Andrew Jeffery <andrew@codeconstruct.com.au>

commit ed724ea1b82a800af4704311cb89e5ef1b4ea7ac upstream.

Enable use of common SDHCI-related properties such as sdhci-caps-mask as
found in the AST2600 EVB DTS.

Cc: stable@vger.kernel.org # v6.2+
Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml
+++ b/Documentation/devicetree/bindings/mmc/aspeed,sdhci.yaml
@@ -41,7 +41,7 @@ properties:
 patternProperties:
   "^sdhci@[0-9a-f]+$":
     type: object
-    $ref: mmc-controller.yaml
+    $ref: sdhci-common.yaml
     unevaluatedProperties: false
 
     properties:


