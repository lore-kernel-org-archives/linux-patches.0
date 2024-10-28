Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EB918DF68;
	Mon, 28 Oct 2024 06:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097387; cv=none; b=U5mSDRrcDBx5QDO6ljx801qbbC+ogbiR+LRo+UB6X1zWdGTRX658UXDyh+DCArmIPg10WHmNE1r1P9aJY8i+DtAmVEG9s/cUBbU+XiMe+sY0BcK56VPW2fYQZCtae9Jrpcc791LhToprie0I2CQz4PKjw7KYNQdMSphfx6SJtUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097387; c=relaxed/simple;
	bh=uXM7Ebw2RUvdwmcJmC2fBf9NBmOJKRiQfwLA0efZ8KQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eo4pNicC9+Jvzk5KOvrR/Xf7BRn4xI6u9c91ix5ne8b07Jm0OaUfgEuQtRJ0PGXGOTdu3VP0USadN2GBLmQBdeZTci5LJ1f55i3An4a2DFEFvZwjTu8U5tu/FBDNnlpkQsVtbDSFWTx2FoIF4dNrGAvYMKR2gQvUlbi4fUyxaNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMsHwZ6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMsHwZ6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E69C4CEC3;
	Mon, 28 Oct 2024 06:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097387;
	bh=uXM7Ebw2RUvdwmcJmC2fBf9NBmOJKRiQfwLA0efZ8KQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lMsHwZ6T3tNUK+RW377ycmtAuxDKZ+AN1FQ7bYgVO3JrUR3aUx6ous46ajp98uoKW
	 /ZY1shQano/Hwz+9mbg5wbm5S+1Rt0kIQzv8iGUTXGIreJKu3ZBd/D5j08QbDwPmRm
	 mR8nGJLLFg4j9uqE+QecrIYan+S5K+VmK9DrTsGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Gruber <jimmyjgruber@gmail.com>,
	Yadwinder Singh <yadi.brar01@gmail.com>,
	Jaswinder Singh <jaswinder.singh@linaro.org>,
	Ruslan Bilovol <ruslan.bilovol@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 062/137] usb: gadget: f_uac2: Replace snprintf() with the safer scnprintf() variant
Date: Mon, 28 Oct 2024 07:24:59 +0100
Message-ID: <20241028062300.470246508@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit 60034e0aedf507888c4a880f57011bb7f5d7700c ]

There is a general misunderstanding amongst engineers that {v}snprintf()
returns the length of the data *actually* encoded into the destination
array.  However, as per the C99 standard {v}snprintf() really returns
the length of the data that *would have been* written if there were
enough space for it.  This misunderstanding has led to buffer-overruns
in the past.  It's generally considered safer to use the {v}scnprintf()
variants in their place (or even sprintf() in simple cases).  So let's
do that.

Link: https://lwn.net/Articles/69419/
Link: https://github.com/KSPP/linux/issues/105
Cc: James Gruber <jimmyjgruber@gmail.com>
Cc: Yadwinder Singh <yadi.brar01@gmail.com>
Cc: Jaswinder Singh <jaswinder.singh@linaro.org>
Cc: Ruslan Bilovol <ruslan.bilovol@gmail.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20231213164246.1021885-4-lee@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 9499327714de ("usb: gadget: f_uac2: fix return value for UAC2_ATTRIBUTE_STRING store")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uac2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/function/f_uac2.c b/drivers/usb/gadget/function/f_uac2.c
index 0219cd79493a7..55a4f07bc9cc1 100644
--- a/drivers/usb/gadget/function/f_uac2.c
+++ b/drivers/usb/gadget/function/f_uac2.c
@@ -2042,7 +2042,7 @@ static ssize_t f_uac2_opts_##name##_show(struct config_item *item,	\
 	int result;							\
 									\
 	mutex_lock(&opts->lock);					\
-	result = snprintf(page, sizeof(opts->name), "%s", opts->name);	\
+	result = scnprintf(page, sizeof(opts->name), "%s", opts->name);	\
 	mutex_unlock(&opts->lock);					\
 									\
 	return result;							\
@@ -2060,7 +2060,7 @@ static ssize_t f_uac2_opts_##name##_store(struct config_item *item,	\
 		goto end;						\
 	}								\
 									\
-	ret = snprintf(opts->name, min(sizeof(opts->name), len),	\
+	ret = scnprintf(opts->name, min(sizeof(opts->name), len),	\
 			"%s", page);					\
 									\
 end:									\
@@ -2178,7 +2178,7 @@ static struct usb_function_instance *afunc_alloc_inst(void)
 	opts->req_number = UAC2_DEF_REQ_NUM;
 	opts->fb_max = FBACK_FAST_MAX;
 
-	snprintf(opts->function_name, sizeof(opts->function_name), "Source/Sink");
+	scnprintf(opts->function_name, sizeof(opts->function_name), "Source/Sink");
 
 	return &opts->func_inst;
 }
-- 
2.43.0



