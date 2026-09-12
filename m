Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782591FBEA6;
	Sat, 12 Sep 2026 19:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242590; cv=none; b=Wp+qShbRwaICQPCyAIZjHa1O2sh5u6vdNhIqYVL6/pYiFLih+5LxJAY0y2/aN4QJ8Ro7KyyrxQ43qjpPmcsfD7OeklkAlBUeyTgb0omYtOJUtXIjJHTlYnGz91PqMYx6E/lsoKL6BXnktYHB0xyqbfcEtFn1yw+9un0VSOzARik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242590; c=relaxed/simple;
	bh=T49XHQm5K5QSf3P7v/bPkhAMob9IlZNUydc1D116N1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VL2MtdsJqddfiJCTPv0NHL0OIyTPgsiuzpruJn6nHOnc3DTfcVMIQbPNiEdozSNwoMF4f0g0jTbvkUnfmNcPNkdpFRu7/686mJrhZ4wZp84ZZjUe0200SYiYpGCwWAH1QHMIPgzqmNim3bt7IBnPMz2kU/uaYG4c7ySva+iyZh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQBb5nMs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQBb5nMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4ED41F000FF;
	Sat, 12 Sep 2026 19:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242589;
	bh=OY5TOs+ylmh7Pnh13OW/GcecrblWrMYKn+NBTh5U0Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQBb5nMsoueoEgI76w0ZXcR1KwAkFcWLechsAa48a6k5a2n9nkYGbNaYYY23mEEH+
	 z12CGJaolY33aLISXc9MdT4EbnDLfIx1BAZ2Vh2BPvfSfQicqVn4esaOQkzgH+L+VI
	 kVDGw7z/RImRDhalO8Frh7kloType/g6A80vMnj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 456/798] usb: gadget: f_uac1_legacy: remove broken string configfs attributes
Date: Sat, 12 Sep 2026 09:01:24 +0200
Message-ID: <20260912065527.595087089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2eeb3e9299e44..76f83a30fe1b7 100644
--- a/Documentation/usb/gadget-testing.rst
+++ b/Documentation/usb/gadget-testing.rst
@@ -695,9 +695,6 @@ The uac1 function provides these attributes in its function directory:
 
 	=============== ====================================
 	audio_buf_size	audio buffer size
-	fn_cap		capture pcm device file name
-	fn_cntl		control device file name
-	fn_play		playback pcm device file name
 	req_buf_size	ISO OUT endpoint request buffer size
 	req_count	ISO OUT endpoint request count
 	=============== ====================================
diff --git a/drivers/usb/gadget/function/f_uac1_legacy.c b/drivers/usb/gadget/function/f_uac1_legacy.c
index f8ed471ab9a81..6b1efbb57072b 100644
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



