Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4435233
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 22:06:24 +0000 (UTC)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 29E6F1EC054E
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 23:06:22 +0100 (CET)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Mon, 9 Jan 2023 23:06:21 +0100
Resent-Message-ID: <Y7yP3a6R3bQao6B0@zn.tnic>
Resent-To: patches <patches@lists.linux.dev>
Received: from deliver ([unix socket])
	 by localhost (Cyrus v2.4.17-caldav-beta9-Debian-2.4.17+caldav~beta9-3) with LMTPA;
	 Mon, 09 Jan 2023 18:26:41 +0100
X-Sieve: CMU Sieve 2.4
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 4DE601EC0622
	for <bp@alien8.de>; Mon,  9 Jan 2023 18:26:38 +0100 (CET)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 1C35861228;
	Mon,  9 Jan 2023 17:26:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 58A75C433F0; Mon,  9 Jan 2023 17:26:36 +0000 (UTC)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4A1F3C433D2
	for <x86@kernel.org>; Mon,  9 Jan 2023 17:26:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 4A1F3C433D2
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id kk14-20020a17090b4a0e00b00226f5087f41so2024852pjb.3
        for <x86@kernel.org>; Mon, 09 Jan 2023 09:26:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0Eo1lBK8ApovhBKXsTDyHqxwCxK6tRKp5OQaiBCmYMY=;
        b=JUv7UMN3ugdB90QKHT6mMT5xyqFpCWFVagJnMjfLRCUqWLNnicImv0nqvOA6nO9wnq
         KHg+LNhnIB31Y6fhcq7pgDAAVZrbgwJRfWxsQNmgQYEJgo7kOzd44BBOGiSYPN17cIc2
         g2FfbRzs/ecTGq1fawlcoFEHKEJ0bJuHCaD7hg6so0pI9k4LBaQ+9//fCUV3batsQRIE
         g/XETobQIlpo6ETSkRvNc/ubCsee6aqpzHyyCb4fStE5dqensa+rnPr+5R+TKxnOx3S6
         uHU4VEJBcBNbmqWMLP4vQ6oP1JXDYISB62Tiz0w1CBP0z0DwOJ1hYxiSRQyfTNRELMjc
         wnxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Eo1lBK8ApovhBKXsTDyHqxwCxK6tRKp5OQaiBCmYMY=;
        b=Ekk0swANWXSyOrRO73WcajZS0qMZ1BwnZZoVJL4xKmb6hUzPsyozorqiItQVkn0pkc
         wNtunsG/6elTWErMAwhYkOf/pdNcAZRqyTbJDBmaNtgATsFL8NdIv0l0/A/Nsf27390J
         zHHa1EgY7JmkXqdsHIK7Vpqyu1TUxcntwvnL8Fo1i7QkQYi2eX1MrorZfu1PYiGLGD2L
         NOtI1gHvxd46kzI4MnnYQfSCFDtpMrZAV8NStTY8haNp84Mo6xVGqWkRPDrTsjb3FHST
         Cs3udfnOISKf5W0xCHWPS3KSEYZt+DijgGwmsx764TZUo22snzxOczeV0MWbjiJGQ5eW
         dOzQ==
X-Gm-Message-State: AFqh2kq0fCb4JKblQmvkj9tGwXtrswV6HKwj9R6XcgyUGFWTAzF8iaLA
	xvIg967q5lrlwOfoEupHhR5y2xPGeJtZqejr5Q==
X-Google-Smtp-Source: AMrXdXtFBQnIkU0lrTr8UTkJ5fg6wg/ddLi/CholjJjQtHcBI9+D8906Pc2qEeA2TDWjhK5WC5nfOWVEuQCB5RnzoA==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2ee6])
 (user=dionnaglaze job=sendgmr) by 2002:a17:902:e951:b0:188:fc5f:84f2 with
 SMTP id b17-20020a170902e95100b00188fc5f84f2mr4719744pll.137.1673285194725;
 Mon, 09 Jan 2023 09:26:34 -0800 (PST)
Date: Mon,  9 Jan 2023 17:26:17 +0000
In-Reply-To: <20230109172618.560581-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230109172618.560581-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109172618.560581-4-dionnaglaze@google.com>
Subject: [PATCH v10 3/4] virt: sev-guest: Remove err in handle_guest_request
From: Dionna Glaze <dionnaglaze@google.com>
To: linux@vger.kernel.org, x86@kernel.org
Cc: Dionna Glaze <dionnaglaze@google.com>, Tom Lendacky <Thomas.Lendacky@amd.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Joerg Roedel <jroedel@suse.de>, Peter Gonda <pgonda@google.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Borislav Petkov <bp@suse.de>, Haowen Bai <baihaowen@meizu.com>, Liam Merwick <liam.merwick@oracle.com>, 
	Yang Yingliang <yangyingliang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Authentication-Results: mail.skyhub.de;
	dkim=pass header.d=google.com header.s=20210112 header.b=JUv7UMN3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (mail.skyhub.de: domain of SRS0=rLJw=5G=flex--dionnaglaze.bounces.google.com=3Sk68YwsKA_sglrqqdjod2hjrrjoh.frp0B9nhuqho.ruj@kernel.org designates 2604:1380:4641:c500::1 as permitted sender) smtp.mailfrom=SRS0=rLJw=5G=flex--dionnaglaze.bounces.google.com=3Sk68YwsKA_sglrqqdjod2hjrrjoh.frp0B9nhuqho.ruj@kernel.org
X-Spamd-Bar: -------

The err variable may not be set in the call to snp_issue_guest_request,
yet it is unconditionally written back to fw_err if fw_err is non-null.
This is undefined behavior, and currently returns uninitialized kernel
stack memory to user space.

The fw_err argument is better to just pass through to
snp_issue_guest_request, so that's done by passing along the ioctl
argument. This removes the need for an argument to handle_guest_request.

Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Peter Gonda <pgonda@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Haowen Bai <baihaowen@meizu.com>
Cc: Liam Merwick <liam.merwick@oracle.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>

Fixes: fce96cf04430 ("virt: Add SEV-SNP guest driver")
Reviewed-by: Tom Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 drivers/virt/coco/sev-guest/sev-guest.c | 35 ++++++++++++-------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index 4ec4174e05a3..f87d52dd3efa 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -318,11 +318,11 @@ static int enc_payload(struct snp_guest_dev *snp_dev, u64 seqno, int version, u8
 	return __enc_payload(snp_dev, req, payload, sz);
 }
 
-static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, int msg_ver,
+static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
+				struct snp_guest_request_ioctl *arg,
 				u8 type, void *req_buf, size_t req_sz, void *resp_buf,
-				u32 resp_sz, __u64 *fw_err)
+				u32 resp_sz)
 {
-	unsigned long err;
 	u64 seqno;
 	int rc;
 
@@ -334,7 +334,8 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 	memset(snp_dev->response, 0, sizeof(struct snp_guest_msg));
 
 	/* Encrypt the userspace provided payload */
-	rc = enc_payload(snp_dev, seqno, msg_ver, type, req_buf, req_sz);
+	rc = enc_payload(snp_dev, seqno, arg->msg_version, type, req_buf,
+			 req_sz);
 	if (rc)
 		return rc;
 
@@ -344,7 +345,8 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 	 * sequence number must be incremented or the VMPCK must be deleted to
 	 * prevent reuse of the IV.
 	 */
-	rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
+	rc = snp_issue_guest_request(exit_code, &snp_dev->input,
+				     &arg->fw_err);
 
 	/*
 	 * If the extended guest request fails due to having too small of a
@@ -366,24 +368,22 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code, in
 		 * of the VMPCK and the error code being propagated back to the
 		 * user as an ioctl() return code.
 		 */
-		rc = snp_issue_guest_request(exit_code, &snp_dev->input, &err);
+		rc = snp_issue_guest_request(exit_code, &snp_dev->input,
+					     &arg->fw_err);
 
 		/*
 		 * Override the error to inform callers the given extended
 		 * request buffer size was too small and give the caller the
 		 * required buffer size.
 		 */
-		err = SNP_GUEST_REQ_INVALID_LEN;
+		arg->fw_err = SNP_GUEST_REQ_INVALID_LEN;
 		snp_dev->input.data_npages = certs_npages;
 	}
 
-	if (fw_err)
-		*fw_err = err;
-
 	if (rc) {
 		dev_alert(snp_dev->dev,
 			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
-			  rc, *fw_err);
+			  rc, arg->fw_err);
 		goto disable_vmpck;
 	}
 
@@ -430,9 +430,9 @@ static int get_report(struct snp_guest_dev *snp_dev, struct snp_guest_request_io
 	if (!resp)
 		return -ENOMEM;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg->msg_version,
+	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
 				  SNP_MSG_REPORT_REQ, &req, sizeof(req), resp->data,
-				  resp_len, &arg->fw_err);
+				  resp_len);
 	if (rc)
 		goto e_free;
 
@@ -470,9 +470,8 @@ static int get_derived_key(struct snp_guest_dev *snp_dev, struct snp_guest_reque
 	if (copy_from_user(&req, (void __user *)arg->req_data, sizeof(req)))
 		return -EFAULT;
 
-	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg->msg_version,
-				  SNP_MSG_KEY_REQ, &req, sizeof(req), buf, resp_len,
-				  &arg->fw_err);
+	rc = handle_guest_request(snp_dev, SVM_VMGEXIT_GUEST_REQUEST, arg,
+				  SNP_MSG_KEY_REQ, &req, sizeof(req), buf, resp_len);
 	if (rc)
 		return rc;
 
@@ -532,9 +531,9 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 		return -ENOMEM;
 
 	snp_dev->input.data_npages = npages;
-	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg->msg_version,
+	ret = handle_guest_request(snp_dev, SVM_VMGEXIT_EXT_GUEST_REQUEST, arg,
 				   SNP_MSG_REPORT_REQ, &req.data,
-				   sizeof(req.data), resp->data, resp_len, &arg->fw_err);
+				   sizeof(req.data), resp->data, resp_len);
 
 	/* If certs length is invalid then copy the returned length */
 	if (arg->fw_err == SNP_GUEST_REQ_INVALID_LEN) {
-- 
2.39.0.314.g84b9a713c41-goog

