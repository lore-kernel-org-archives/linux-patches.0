Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE5747AF5F;
	Sat, 12 Sep 2026 12:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215648; cv=none; b=AHJhZGzY/UK9XomYNNiu1nKkBHovxLdoQOsMzI5vuXLRm8wkQG/wZAEVyrlauvCawLUiovGiOiyKY/Kw8ZToftqzdA44qDtibNyaiWFKlJaJOY5Y/mFiyth8HNQr7Kuff/YFyPY+kWP+p4M9SZcSYRWqfsHnHQinXEV8tKOevOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215648; c=relaxed/simple;
	bh=ROCCaz7+tCjW9K3NrZ+rDi48uJM4tDrB7VP235MibM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFKHBBOsLTnLDLtB2VHe8RnlCNc4FaLxWGk7E5Oqm0BYx/xqap+HnsNIo/rGtYZaX18mNaQLg8oROcb9uTl0SMRiN3j9JvCwn7jCOY70xEGw+hx4B6hQZfWofRD5e+VB8jsqkPfBenw0OhX1+m9CVkY1G6LlOdJTHkzFVdkUTro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sUWRrVQD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sUWRrVQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D2B1F000FF;
	Sat, 12 Sep 2026 12:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215644;
	bh=mKUZVWQxF454ssr9HGHudhbKo5HV92dmPinjamRTASY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sUWRrVQDDPNVh9Uu8l4MrI0nbzqtls057LlZneYR0sxtoeLox9gnoK1hpxe0mrN70
	 9p1PkQb6oTa9cDI05vSUGtpmJglWKhRRCoj8OGC56+8ZrvfsMmDlqYyTwd+VumiuBU
	 8LhzmIZsEN/AQTF6cksTJzNGCcIevX9C23DWPYmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0575/1376] usb: gadget: f_uac1_legacy: remove broken string configfs attributes
Date: Sat, 12 Sep 2026 08:50:01 +0200
Message-ID: <20260912065620.345101507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 590d74ec8f488e06b9f1c0f8f0941f45531f3a55 ]

The UAC1_STR_ATTRIBUTE macro defines configfs show/store handlers for
the fn_play, fn_cap, and fn_cntl string options. The store function
contains an inverted null check on the kstrndup() return value.

This means every write attempt returns -ENOMEM on success and
dereferences a NULL pointer on allocation failure. The attributes
have been broken and unused for many years.

Remove the UAC1_STR_ATTRIBUTE macro and the three attributes it
generated. The internal defaults (FILE_PCM_PLAYBACK, FILE_PCM_CAPTURE,
FILE_CONTROL) set in f_audio_alloc_inst() are unaffected.

Fixes: 0854611a19ae ("usb: gadget: f_uac1: add configfs support")
Link: https://lore.kernel.org/linux-usb/20260625113154.1954813-1-xu.yang_2@oss.nxp.com/
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Assisted-by: Claude:claude-sonnet-4.6
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260713060845.3759673-1-xu.yang_2@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/configfs-usb-gadget-uac1_legacy   |  3 -
 Documentation/usb/gadget-testing.rst          |  3 -
 drivers/usb/gadget/function/f_uac1_legacy.c   | 56 -------------------
 drivers/usb/gadget/function/u_uac1_legacy.h   |  3 -
 4 files changed, 65 deletions(-)

diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uac1_legacy b/Documentation/ABI/testing/configfs-usb-gadget-uac1_legacy
index b2eaefd9bc498..6a681d219f439 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uac1_legacy
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uac1_legacy
@@ -5,8 +5,5 @@ Description:
 		The attributes:
 
 		audio_buf_size - audio buffer size
-		fn_cap - capture pcm device file name
-		fn_cntl - control device file name
-		fn_play - playback pcm device file name
 		req_buf_size - ISO OUT endpoint request buffer size
 		req_count - ISO OUT endpoint request count
diff --git a/Documentation/usb/gadget-testing.rst b/Documentation/usb/gadget-testing.rst
index bf555c2270f5c..3ef109ad12d5b 100644
--- a/Documentation/usb/gadget-testing.rst
+++ b/Documentation/usb/gadget-testing.rst
@@ -712,9 +712,6 @@ The uac1 function provides these attributes in its function directory:
 
 	=============== ====================================
 	audio_buf_size	audio buffer size
-	fn_cap		capture pcm device file name
-	fn_cntl		control device file name
-	fn_play		playback pcm device file name
 	req_buf_size	ISO OUT endpoint request buffer size
 	req_count	ISO OUT endpoint request count
 	=============== ====================================
diff --git a/drivers/usb/gadget/function/f_uac1_legacy.c b/drivers/usb/gadget/function/f_uac1_legacy.c
index 4981af8337ab8..c234f9fea27cf 100644
--- a/drivers/usb/gadget/function/f_uac1_legacy.c
+++ b/drivers/usb/gadget/function/f_uac1_legacy.c
@@ -888,60 +888,10 @@ UAC1_INT_ATTRIBUTE(req_buf_size);
 UAC1_INT_ATTRIBUTE(req_count);
 UAC1_INT_ATTRIBUTE(audio_buf_size);
 
-#define UAC1_STR_ATTRIBUTE(name)					\
-static ssize_t f_uac1_opts_##name##_show(struct config_item *item,	\
-					 char *page)			\
-{									\
-	struct f_uac1_legacy_opts *opts = to_f_uac1_opts(item);		\
-	int result;							\
-									\
-	mutex_lock(&opts->lock);					\
-	result = sprintf(page, "%s\n", opts->name);			\
-	mutex_unlock(&opts->lock);					\
-									\
-	return result;							\
-}									\
-									\
-static ssize_t f_uac1_opts_##name##_store(struct config_item *item,	\
-					  const char *page, size_t len)	\
-{									\
-	struct f_uac1_legacy_opts *opts = to_f_uac1_opts(item);		\
-	int ret = -EBUSY;						\
-	char *tmp;							\
-									\
-	mutex_lock(&opts->lock);					\
-	if (opts->refcnt)						\
-		goto end;						\
-									\
-	tmp = kstrndup(page, len, GFP_KERNEL);				\
-	if (tmp) {							\
-		ret = -ENOMEM;						\
-		goto end;						\
-	}								\
-	if (opts->name##_alloc)						\
-		kfree(opts->name);					\
-	opts->name##_alloc = true;					\
-	opts->name = tmp;						\
-	ret = len;							\
-									\
-end:									\
-	mutex_unlock(&opts->lock);					\
-	return ret;							\
-}									\
-									\
-CONFIGFS_ATTR(f_uac1_opts_, name)
-
-UAC1_STR_ATTRIBUTE(fn_play);
-UAC1_STR_ATTRIBUTE(fn_cap);
-UAC1_STR_ATTRIBUTE(fn_cntl);
-
 static struct configfs_attribute *f_uac1_attrs[] = {
 	&f_uac1_opts_attr_req_buf_size,
 	&f_uac1_opts_attr_req_count,
 	&f_uac1_opts_attr_audio_buf_size,
-	&f_uac1_opts_attr_fn_play,
-	&f_uac1_opts_attr_fn_cap,
-	&f_uac1_opts_attr_fn_cntl,
 	NULL,
 };
 
@@ -956,12 +906,6 @@ static void f_audio_free_inst(struct usb_function_instance *f)
 	struct f_uac1_legacy_opts *opts;
 
 	opts = container_of(f, struct f_uac1_legacy_opts, func_inst);
-	if (opts->fn_play_alloc)
-		kfree(opts->fn_play);
-	if (opts->fn_cap_alloc)
-		kfree(opts->fn_cap);
-	if (opts->fn_cntl_alloc)
-		kfree(opts->fn_cntl);
 	kfree(opts);
 }
 
diff --git a/drivers/usb/gadget/function/u_uac1_legacy.h b/drivers/usb/gadget/function/u_uac1_legacy.h
index b5df9bcbbeba7..b9ddae550ff3c 100644
--- a/drivers/usb/gadget/function/u_uac1_legacy.h
+++ b/drivers/usb/gadget/function/u_uac1_legacy.h
@@ -62,9 +62,6 @@ struct f_uac1_legacy_opts {
 	char				*fn_cap;
 	char				*fn_cntl;
 	unsigned			bound:1;
-	unsigned			fn_play_alloc:1;
-	unsigned			fn_cap_alloc:1;
-	unsigned			fn_cntl_alloc:1;
 	struct mutex			lock;
 	int				refcnt;
 };
-- 
2.53.0



