Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208375;
	b=JqRzHOGr90jtoy6T33IzBC7+/0DTeXOTuQTEJ558U/o0dvEo2z8LkXohKPYgpk06UHKt
	 OZPK/ojdsR6E6J8ZoZz+x8Z21sPFizDvWMU6TKTAPENEYZ+UxVEg/nMBYIuFo9H9Rcoa1
	 zEb+L2aHPk5Dpec6a6/Y6X9yu8+dOVjr3ej1uZv4nZUoxoUgEsuQbQMiSOho+CftRKbSi
	 jTlxizI0SESQZfyoFMFkdjHhzkdcDBctAIUsUqSfA2lv7v2Ueaxsd/amAukG1mc6mJGwT
	 MryYuHz8o/5cwSw+1hseOSNfBImEkmA0QKzM2Ul1uJt+a0YRK2kfnbt4kk//vwg3vsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208375;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SinG8I+vpGmNMl2Dex9h/PrUmZPZWmsyP2RX0914pVg=;
	b=R5gujFOy81cb7aA1iO8c2hgCQdrEKc0jCghAYR/lN0jM4dU+wt7l/fvSXlPAgRrv+Ppl
	 S9B37xAU9nia4iGbcDqKM2x1jkmQ38tuvBJrvNGnl3hAKsi86ZxPyDSCBaByAReIPAMQG
	 JaYANFYUIYM55zUfu4m9YICK7kqKN0wWqiQcXstum/A0Tfhs7CO1DPU7kJIcTuRh1+m+S
	 vQte2h6l+rbI9fHXuCIyAlsfIzgOFUj8Jr+U3Gx1v5NPbT3F+97yvn61b8f0UGOipK8+G
	 lvAdM0cgt8QY83lAc77iN92Pdgh1GqnEsiM95IjexqMLIk7ERb50fr7I1B/WGUCTfAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="m/VGLvX6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42F7606A31A;
	Wed, 28 Oct 2026 17:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=m/VGLvX6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113A41F01828;
	Wed, 28 Oct 2026 17:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208374;
	bh=SinG8I+vpGmNMl2Dex9h/PrUmZPZWmsyP2RX0914pVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m/VGLvX6lfXURNtbli8HhWwcHOczavDZD297wzvwWZXtB2FNQ0aE4Q++1tbpC28Vj
	 5ahXHO/KQDV6Ns+FmPyX4ugsQ0U6TzrhA8dJDmhjv7wIbLViXrhSh99G3fliJzr2Gr
	 tzcu3A1QZnBix4aNqMEaXJCPfXaiqu4nErXVAJyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 054/516] params: Do not go over the limit when getting the string length
Date: Wed, 28 Oct 2026 17:53:26 +0100
Message-ID: <20261028170004.810652083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit fd0cd057a1b7351604daa6ffc91dfe28adf7225d ]

We can use strnlen() even on early stages and it prevents from
going over the string boundaries in case it's already too long.

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20231120151419.1661807-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/params.c b/kernel/params.c
index 9f0f059571a0a..30c0a7388024e 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -264,7 +264,10 @@ EXPORT_SYMBOL_GPL(param_set_uint_minmax);
 
 int param_set_charp(const char *val, const struct kernel_param *kp)
 {
-	if (strlen(val) > 1024) {
+	size_t len, maxlen = 1024;
+
+	len = strnlen(val, maxlen + 1);
+	if (len == maxlen + 1) {
 		pr_err("%s: string parameter too long\n", kp->name);
 		return -ENOSPC;
 	}
@@ -274,7 +277,7 @@ int param_set_charp(const char *val, const struct kernel_param *kp)
 	/* This is a hack.  We can't kmalloc in early boot, and we
 	 * don't need to; this mangled commandline is preserved. */
 	if (slab_is_available()) {
-		*(char **)kp->arg = kmalloc_parameter(strlen(val)+1);
+		*(char **)kp->arg = kmalloc_parameter(len + 1);
 		if (!*(char **)kp->arg)
 			return -ENOMEM;
 		strcpy(*(char **)kp->arg, val);
@@ -512,7 +515,7 @@ int param_set_copystring(const char *val, const struct kernel_param *kp)
 {
 	const struct kparam_string *kps = kp->str;
 
-	if (strlen(val)+1 > kps->maxlen) {
+	if (strnlen(val, kps->maxlen) == kps->maxlen) {
 		pr_err("%s: string doesn't fit in %u chars.\n",
 		       kp->name, kps->maxlen-1);
 		return -ENOSPC;
-- 
2.53.0



