Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E279A14A0B7;
	Tue, 25 Jun 2024 09:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309518; cv=none; b=KVr+Is6ciKybxGJsFMGyZCfGzKsln8c/oL9+GWI09nFioJ+pLDKxcR9yFHYcvb4MWazTtQTBiRIe0rVbYciSvQq0FcCJvNTyazkEjONxpygZoh9m/FkWOdfl9aiwvJermgDRY4ailgLbRGO5YZOtPfFzel5I3+yCNaZEnG4voC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309518; c=relaxed/simple;
	bh=LAfFkxfBjZVAIq6q5nINoD9Pu63odIewZgjuaK30CCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWeTLFPXUb3t3OQZRKkt+FSWMTY5fhI9+mk6v5JVW2S3Ssr8/HKnjCA9AvtCmMZMFFmNNrZMzB+eFrz8SRXmLVIu02qzVXpKZZahuGk/22cKItaYK/51Yf1Xv4tGyPGuE6DWJOQDPqu80D+eFGxPK/wR4qEj+3EKnQkSARC4q5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oXM7uoGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oXM7uoGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69938C32781;
	Tue, 25 Jun 2024 09:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309517;
	bh=LAfFkxfBjZVAIq6q5nINoD9Pu63odIewZgjuaK30CCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXM7uoGWsHfraW3iodDy8iPleCG2OtHDluP++PHAGFQoTPyzLnPB2Ws8dIQrhGvSV
	 eStyUxUQOygWWIOEdR/EbZf+tS0uyhc5Q3JYW4EvZJpqo3xaRTdW4wWtQiHfyGyjlc
	 Y62iq0KSsewTyP/q5jK15Rr6Wsm8rBt5WQjCZM9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/131] usb: gadget: function: Remove usage of the deprecated ida_simple_xx() API
Date: Tue, 25 Jun 2024 11:33:18 +0200
Message-ID: <20240625085527.588755007@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
References: <20240625085525.931079317@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 920e7522e3bab5ebc2fb0cc1a034f4470c87fa97 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_max() is inclusive. So a -1 has been added when needed.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/7cd361e2b377a5373968fa7deee4169229992a1e.1713107386.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_hid.c     | 6 +++---
 drivers/usb/gadget/function/f_printer.c | 6 +++---
 drivers/usb/gadget/function/rndis.c     | 4 ++--
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/function/f_hid.c b/drivers/usb/gadget/function/f_hid.c
index f1ca9250cad96..bb558a575cb15 100644
--- a/drivers/usb/gadget/function/f_hid.c
+++ b/drivers/usb/gadget/function/f_hid.c
@@ -1025,9 +1025,9 @@ static inline int hidg_get_minor(void)
 {
 	int ret;
 
-	ret = ida_simple_get(&hidg_ida, 0, 0, GFP_KERNEL);
+	ret = ida_alloc(&hidg_ida, GFP_KERNEL);
 	if (ret >= HIDG_MINORS) {
-		ida_simple_remove(&hidg_ida, ret);
+		ida_free(&hidg_ida, ret);
 		ret = -ENODEV;
 	}
 
@@ -1172,7 +1172,7 @@ static const struct config_item_type hid_func_type = {
 
 static inline void hidg_put_minor(int minor)
 {
-	ida_simple_remove(&hidg_ida, minor);
+	ida_free(&hidg_ida, minor);
 }
 
 static void hidg_free_inst(struct usb_function_instance *f)
diff --git a/drivers/usb/gadget/function/f_printer.c b/drivers/usb/gadget/function/f_printer.c
index a881c69b1f2bf..8545656419c71 100644
--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -1316,9 +1316,9 @@ static inline int gprinter_get_minor(void)
 {
 	int ret;
 
-	ret = ida_simple_get(&printer_ida, 0, 0, GFP_KERNEL);
+	ret = ida_alloc(&printer_ida, GFP_KERNEL);
 	if (ret >= PRINTER_MINORS) {
-		ida_simple_remove(&printer_ida, ret);
+		ida_free(&printer_ida, ret);
 		ret = -ENODEV;
 	}
 
@@ -1327,7 +1327,7 @@ static inline int gprinter_get_minor(void)
 
 static inline void gprinter_put_minor(int minor)
 {
-	ida_simple_remove(&printer_ida, minor);
+	ida_free(&printer_ida, minor);
 }
 
 static int gprinter_setup(int);
diff --git a/drivers/usb/gadget/function/rndis.c b/drivers/usb/gadget/function/rndis.c
index 29bf8664bf582..12c5d9cf450c1 100644
--- a/drivers/usb/gadget/function/rndis.c
+++ b/drivers/usb/gadget/function/rndis.c
@@ -869,12 +869,12 @@ EXPORT_SYMBOL_GPL(rndis_msg_parser);
 
 static inline int rndis_get_nr(void)
 {
-	return ida_simple_get(&rndis_ida, 0, 1000, GFP_KERNEL);
+	return ida_alloc_max(&rndis_ida, 999, GFP_KERNEL);
 }
 
 static inline void rndis_put_nr(int nr)
 {
-	ida_simple_remove(&rndis_ida, nr);
+	ida_free(&rndis_ida, nr);
 }
 
 struct rndis_params *rndis_register(void (*resp_avail)(void *v), void *v)
-- 
2.43.0



