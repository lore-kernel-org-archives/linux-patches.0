Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1880515B10D;
	Mon, 28 Oct 2024 06:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097748; cv=none; b=izm96m+QrIunKa1kYcIXM0kFtH0A5FDwgSPxr8zTBMaZimmdmqksLRsQg9u6ZQGzePBMvCQ9QPUjBk61zidRgF0+A9CZBKW+H9L4melvBO4q/XTAIzFU6esKfhxpMwP9CPmzkdb15DGzBWyW4x0sdICHMvF9DP7p3X49EjTKc4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097748; c=relaxed/simple;
	bh=/1vty4VzPcd/S9L1pd893Vm+3TlS3d0RbYxVS/mPCtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXwMSVdHdTldMLwf9vGkvyXizqsFtkOLQYPIcHLWnJ7s8cH9StNoI/9BHlYK3t/chKtIfOsvqlvZO8BPsMLbHSo0rb5Ry+hTgzKrhhGa6ItBA33Mp2JxlnHxyshOAGrUZ9zfl4gIbWGcmvVlz3IHn+NQjhirYoQZy562D4zw8gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BU8JyASK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BU8JyASK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0E0C4CEC3;
	Mon, 28 Oct 2024 06:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097748;
	bh=/1vty4VzPcd/S9L1pd893Vm+3TlS3d0RbYxVS/mPCtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BU8JyASKnpt0s0qgYyZFrfEcCOqj/RPRgnM6Vo0cUZCHQkbWjqpRrgVrSdZifJKQc
	 dDsP3i4a99EMeBN7hTCEETMUqQA1GbPWmpYQICHeIXd+K/Cfq1DJu2eqgJ0Y/AcFHC
	 IFrh9FJflu/Pke16zPBUAXa7rRl4UbEBHROiG2E4=
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
Subject: [PATCH 6.6 102/208] usb: gadget: f_uac2: Replace snprintf() with the safer scnprintf() variant
Date: Mon, 28 Oct 2024 07:24:42 +0100
Message-ID: <20241028062309.171191072@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



