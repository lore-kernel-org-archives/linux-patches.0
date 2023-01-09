Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB535233
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 22:06:21 +0000 (UTC)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B0E041EC04EE
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 23:06:18 +0100 (CET)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Mon, 9 Jan 2023 23:06:18 +0100
Resent-Message-ID: <Y7yP2iOn0yhz2o97@zn.tnic>
Resent-To: patches <patches@lists.linux.dev>
Received: from deliver ([unix socket])
	 by localhost (Cyrus v2.4.17-caldav-beta9-Debian-2.4.17+caldav~beta9-3) with LMTPA;
	 Mon, 09 Jan 2023 18:26:37 +0100
X-Sieve: CMU Sieve 2.4
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPS id C18281EC03B3
	for <bp@alien8.de>; Mon,  9 Jan 2023 18:26:32 +0100 (CET)
Received: by mail-pg1-x549.google.com with SMTP id g18-20020a63f412000000b004aef17e314cso2265996pgi.21
        for <bp@alien8.de>; Mon, 09 Jan 2023 09:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RiU0lNLGMGUPnV0Kk7MtucviRlaIWTf06FqlgnaXXAw=;
        b=ZisrGcMc4yVeOWh+Ub7a0HpwJ53pdWvBs6HKJi5FouYnX3hYN+uLANH7A+TAvIBHIH
         RrJezCbsx4QlGdEvZMG56W2E0M6uT6c0wW0IA1hOXsDFtH06YDfzr2878ZTXi8UtYk7z
         7+ypsfvepTKgBvevaJLTRiR8DCHiTAXQ4TKTIkSR+2Lvm4PgUTaxsVWc6pc3z5Ic3NBI
         QMP1xH3Vocqx9GnYJ+bPquMkybuuZCIw6WVifvvu+CazpTsRdqDd927yFqsp5JwbxbmZ
         rAdrmabiEa7JdeJWaB7IcNsaUzTmEEjhN3SkkFocbF0zTgOzNUT+GbMqD7wWDcc02od6
         e6ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RiU0lNLGMGUPnV0Kk7MtucviRlaIWTf06FqlgnaXXAw=;
        b=lESw7AtyVbVhLXmrKLRTWlEKyB5yF2fwTXNDSj50PZRcb8CAixfvmANJAJ+/uLGeLF
         mxBpYUwOeGfYn8g7X8EL2KJfRZohMUClA9eMpA2ayyaNeBzxW2IXwlq8O+aaVH5YpD3g
         v95NhY2dif9a7Xe4wRGWrZuHvuJSgJaEq2hYOo/DjDktHKLp8+zF0JhvK9fK9ttlgtYx
         XdaK2f06eLCLLWm6gYf2z9YZ/YVXE+sO5uXUl5011NVcz8Tgkj5Zv+qJRjca46xDybMS
         vZScOiZ7FBISX+LMDmjOM5WqM+HDFi+rSOF+CYBhcLoMna30cQTBDX9e7lDv5z718zKN
         Urww==
X-Gm-Message-State: AFqh2kpGTSb26dcy1L9LyJzByiDh4BxjJyQYZ0gGVKpOIS2Q1XdyylQo
	GdSjPeI5rRRaOq+BPh5IiCd6CyUYRCxalybiuw==
X-Google-Smtp-Source: AMrXdXsd5H+2yasNOUMwFsKLNsydkM58mO5oYDxyc341PdhIwY5jt82O8GelizQ5e39gMkHZQZO+CgPc6li1ZsRj2Q==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2ee6])
 (user=dionnaglaze job=sendgmr) by 2002:a62:b617:0:b0:578:1bcf:fae7 with SMTP
 id j23-20020a62b617000000b005781bcffae7mr4562958pff.45.1673285191118; Mon, 09
 Jan 2023 09:26:31 -0800 (PST)
Date: Mon,  9 Jan 2023 17:26:15 +0000
In-Reply-To: <20230109172618.560581-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230109172618.560581-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109172618.560581-2-dionnaglaze@google.com>
Subject: [PATCH v10 1/4] crypto: ccp - Name -1 return value as SEV_RET_NO_FW_CALL
From: Dionna Glaze <dionnaglaze@google.com>
To: linux@vger.kernel.org, x86@kernel.org
Cc: Peter Gonda <pgonda@google.com>, Thomas Lendacky <Thomas.Lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>, Ingo Molnar <mingo@redhat.com>, 
	Andy Lutomirsky <luto@kernel.org>, John Allen <john.allen@amd.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Borislav Petkov <bp@alien8.de>, Dionna Glaze <dionnaglaze@google.com>
Content-Type: text/plain; charset="UTF-8"
Authentication-Results: mail.skyhub.de;
	dkim=pass header.d=google.com header.s=20210112 header.b=ZisrGcMc;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (mail.skyhub.de: domain of 3R068YwsKAvgintssflqf4jlttlqj.htrgufqnjsD.ij@flex--dionnaglaze.bounces.google.com designates 2607:f8b0:4864:20::549 as permitted sender) smtp.mailfrom=3R068YwsKAvgintssflqf4jlttlqj.htrgufqnjsD.ij@flex--dionnaglaze.bounces.google.com
X-Spamd-Bar: ------

From: Peter Gonda <pgonda@google.com>

The PSP can return a "firmware error" code of -1 in circumstances where
the PSP is not actually called. To make this protocol unambiguous, the
value is named SEV_RET_NO_FW_CALL.

Cc: Thomas Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: John Allen <john.allen@amd.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Borislav Petkov <bp@alien8.de>

Signed-off-by: Peter Gonda <pgonda@google.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 Documentation/virt/coco/sev-guest.rst |  2 +-
 drivers/crypto/ccp/sev-dev.c          | 22 ++++++++++++++--------
 include/uapi/linux/psp-sev.h          |  7 +++++++
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index bf593e88cfd9..e76393e389eb 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -41,7 +41,7 @@ The guest ioctl should be issued on a file descriptor of the /dev/sev-guest devi
 The ioctl accepts struct snp_user_guest_request. The input and output structure is
 specified through the req_data and resp_data field respectively. If the ioctl fails
 to execute due to a firmware error, then fw_err code will be set otherwise the
-fw_err will be set to 0x00000000000000ff.
+fw_err will be set to 0x00000000ffffffff, i.e., the lower 32-bits are -1.
 
 The firmware checks that the message sequence counter is one greater than
 the guests message sequence counter. If guest driver fails to increment message
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 06fc7156c04f..ac205f78a595 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -440,12 +440,19 @@ static int __sev_init_ex_locked(int *error)
 	return __sev_do_cmd_locked(SEV_CMD_INIT_EX, &data, error);
 }
 
+static inline int __sev_do_init_locked(int *psp_ret)
+{
+	if (sev_init_ex_buffer)
+		return __sev_init_ex_locked(psp_ret);
+	else
+		return __sev_init_locked(psp_ret);
+}
+
 static int __sev_platform_init_locked(int *error)
 {
 	struct psp_device *psp = psp_master;
 	struct sev_device *sev;
-	int rc = 0, psp_ret = -1;
-	int (*init_function)(int *error);
+	int rc = 0, psp_ret = SEV_RET_NO_FW_CALL;
 
 	if (!psp || !psp->sev_data)
 		return -ENODEV;
@@ -456,15 +463,12 @@ static int __sev_platform_init_locked(int *error)
 		return 0;
 
 	if (sev_init_ex_buffer) {
-		init_function = __sev_init_ex_locked;
 		rc = sev_read_init_ex_file();
 		if (rc)
 			return rc;
-	} else {
-		init_function = __sev_init_locked;
 	}
 
-	rc = init_function(&psp_ret);
+	rc = __sev_do_init_locked(&psp_ret);
 	if (rc && psp_ret == SEV_RET_SECURE_DATA_INVALID) {
 		/*
 		 * Initialization command returned an integrity check failure
@@ -473,9 +477,11 @@ static int __sev_platform_init_locked(int *error)
 		 * initialization function should succeed by replacing the state
 		 * with a reset state.
 		 */
-		dev_err(sev->dev, "SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.");
-		rc = init_function(&psp_ret);
+		dev_err(sev->dev,
+"SEV: retrying INIT command because of SECURE_DATA_INVALID error. Retrying once to reset PSP SEV state.");
+		rc = __sev_do_init_locked(&psp_ret);
 	}
+
 	if (error)
 		*error = psp_ret;
 
diff --git a/include/uapi/linux/psp-sev.h b/include/uapi/linux/psp-sev.h
index 91b4c63d5cbf..e8cfb8bde0d7 100644
--- a/include/uapi/linux/psp-sev.h
+++ b/include/uapi/linux/psp-sev.h
@@ -36,6 +36,13 @@ enum {
  * SEV Firmware status code
  */
 typedef enum {
+	/*
+	 * This error code is not in the SEV spec but is added to convey that
+	 * there was an error that prevented the SEV Firmware from being called.
+	 * The SEV API error codes are 16 bits, so the -1 value will not overlap
+	 * with possible values from the specification.
+	 */
+	SEV_RET_NO_FW_CALL = -1,
 	SEV_RET_SUCCESS = 0,
 	SEV_RET_INVALID_PLATFORM_STATE,
 	SEV_RET_INVALID_GUEST_STATE,
-- 
2.39.0.314.g84b9a713c41-goog

