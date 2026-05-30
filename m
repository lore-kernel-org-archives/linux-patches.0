Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA663C2B80;
	Sat, 30 May 2026 18:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166507; cv=none; b=M95D7TPbgSmGMtNtHVZyxCKbhuMab4OKTUdnMeO31xg22i/Z9jHxFfr4gq1VXgf55v4WOlMJzH/6qFZK1PSxzrRc7W6xTTN/Z0fPmV0jO/xUJMd7ZOzJ/RAhUXDxXIuOiW8H1R5pRkOYLrWdLdfGf+AxVMYfC6tjWKwH9xm+Emk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166507; c=relaxed/simple;
	bh=SlyHKpEXo+j9DLWQNmhcKL0ySh393yuCOghd+B7iySc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R81wnZDdVgmwAOUOSS/cbNH/u8KPFPmaRLrFUPe/0clheL3r1Vwu1/gimT9GMcGSb66SvIpy/uV/WT69n6UTkiaUU0R3/+irFL8SfaU0Xi8Gm3n/Ah4wlerTTLWRf3mZOM92AeK0grdJpctsj0vKBcOEF1lZ2uoJCqooCE+BnW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m1o8MFfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m1o8MFfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42CEC1F00898;
	Sat, 30 May 2026 18:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166502;
	bh=+oFXpa4B8kFe/r4kZX5RdLNd3fIJT+UPazuLLI4CJw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m1o8MFfC8kCQjJK7PSJHbHuiyTiKEIjuf7hFOAOEbGd+ZUQ9Xr515zfqSwr35yfW6
	 YevQOIP9zLl1pLUlE7CCIMsKOqj6VLBAFpWneiP2x1o6Y3VY9JboTPZpLO0KGpzChf
	 GfsfZZyifZ5OP1W0CAfvweUz04yM+d7zyFPGIy4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Slaby <jirislaby@kernel.org>,
	=?UTF-8?q?Ahelenia=20Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 391/589] tty: hvc: remove HVC_IUCV_MAGIC
Date: Sat, 30 May 2026 18:04:32 +0200
Message-ID: <20260530160235.074242971@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: наб <nabijaczleweli@nabijaczleweli.xyz>

[ Upstream commit eef7381d8134f249dc17138bb1794c249aff7f5a ]

According to Greg, in the context of magic numbers as defined in
magic-number.rst, "the tty layer should not need this and I'll gladly
take patches"

This stretches that definition slightly, since it multiplexes it with
the terminal number as a constant offset, but is equivalent

Acked-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Ahelenia Ziemiańska <nabijaczleweli@nabijaczleweli.xyz>
Ref: https://lore.kernel.org/linux-doc/YyMlovoskUcHLEb7@kroah.com/
Link: https://lore.kernel.org/r/8c8a2c9dfc1bfbe6ef3f3237368e483865fc1c29.1663288066.git.nabijaczleweli@nabijaczleweli.xyz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f2a880e802ad ("tty: hvc_iucv: fix off-by-one in number of supported devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/hvc_iucv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/hvc/hvc_iucv.c b/drivers/tty/hvc/hvc_iucv.c
index 796fbff623f6e..d76dff7eec521 100644
--- a/drivers/tty/hvc/hvc_iucv.c
+++ b/drivers/tty/hvc/hvc_iucv.c
@@ -29,7 +29,6 @@
 
 
 /* General device driver settings */
-#define HVC_IUCV_MAGIC		0xc9e4c3e5
 #define MAX_HVC_IUCV_LINES	HVC_ALLOC_TTY_ADAPTERS
 #define MEMPOOL_MIN_NR		(PAGE_SIZE / sizeof(struct iucv_tty_buffer)/4)
 
@@ -131,9 +130,9 @@ static struct iucv_handler hvc_iucv_handler = {
  */
 static struct hvc_iucv_private *hvc_iucv_get_private(uint32_t num)
 {
-	if ((num < HVC_IUCV_MAGIC) || (num - HVC_IUCV_MAGIC > hvc_iucv_devices))
+	if (num > hvc_iucv_devices)
 		return NULL;
-	return hvc_iucv_table[num - HVC_IUCV_MAGIC];
+	return hvc_iucv_table[num];
 }
 
 /**
@@ -1119,8 +1118,8 @@ static int __init hvc_iucv_alloc(int id, unsigned int is_console)
 	priv->is_console = is_console;
 
 	/* allocate hvc device */
-	priv->hvc = hvc_alloc(HVC_IUCV_MAGIC + id, /*		  PAGE_SIZE */
-			      HVC_IUCV_MAGIC + id, &hvc_iucv_ops, 256);
+	priv->hvc = hvc_alloc(id, /*		 PAGE_SIZE */
+			      id, &hvc_iucv_ops, 256);
 	if (IS_ERR(priv->hvc)) {
 		rc = PTR_ERR(priv->hvc);
 		goto out_error_hvc;
@@ -1424,7 +1423,7 @@ static int __init hvc_iucv_init(void)
 
 	/* register the first terminal device as console
 	 * (must be done before allocating hvc terminal devices) */
-	rc = hvc_instantiate(HVC_IUCV_MAGIC, IUCV_HVC_CON_IDX, &hvc_iucv_ops);
+	rc = hvc_instantiate(0, IUCV_HVC_CON_IDX, &hvc_iucv_ops);
 	if (rc) {
 		pr_err("Registering HVC terminal device as "
 		       "Linux console failed\n");
-- 
2.53.0



