Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E865233
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 22:06:26 +0000 (UTC)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8556B1EC04EE
	for <patches@lists.linux.dev>; Mon,  9 Jan 2023 23:06:24 +0100 (CET)
Resent-From: Borislav Petkov <bp@alien8.de>
Resent-Date: Mon, 9 Jan 2023 23:06:24 +0100
Resent-Message-ID: <Y7yP4OURDcHpdfRp@zn.tnic>
Resent-To: patches <patches@lists.linux.dev>
Received: from deliver ([unix socket])
	 by localhost (Cyrus v2.4.17-caldav-beta9-Debian-2.4.17+caldav~beta9-3) with LMTPA;
	 Mon, 09 Jan 2023 18:26:43 +0100
X-Sieve: CMU Sieve 2.4
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPS id 52DE81EC03B3
	for <bp@alien8.de>; Mon,  9 Jan 2023 18:26:40 +0100 (CET)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id D4A10B80EA0;
	Mon,  9 Jan 2023 17:26:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 93FBCC433D2; Mon,  9 Jan 2023 17:26:38 +0000 (UTC)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1067AC433EF
	for <x86@kernel.org>; Mon,  9 Jan 2023 17:26:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 1067AC433EF
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=flex--dionnaglaze.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id y2-20020a17090a784200b00225c0839b80so3272271pjl.5
        for <x86@kernel.org>; Mon, 09 Jan 2023 09:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=97o2DihGbjDRUWCNCawEOluipLENpkzRQnK+3mm1QfI=;
        b=BU8Kcsq5S5sZJPmEkRg6YUDGGeVpQzarPwXkkrfF9oK79uyb6SzEKJguP0HnrmhYxF
         JrFn+u3I8QCC2OFDQzrnt5wTP81UEdjoPpQsgg561GWJ2YRKTojdleXE8cfHxT//G/+q
         tGMf0xe5zHzIhBEJTEQnFXTCI6WGIRm7Q/vJvDN56UwM5HJEFdt9kt58KYf+nGvSjEEY
         YKZqYlub2zYqBcLRp915z4ElPyIWQb0hcVzewzrSrbScXo5BavMvEKXRzQOPoViWF7Lx
         AwWlmu/wHxo06T03qCo1cCJBLAlhHBWC8P1fgdN8pv3OWsQFGUUS1fYoY26tWXiPrHcy
         XLcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=97o2DihGbjDRUWCNCawEOluipLENpkzRQnK+3mm1QfI=;
        b=ElmCyXepKbhokCjfG5m/j6Olv2jkVbl2ficVeY0DtaSaR33JeQ3a0DtHKoREJ9bxWy
         RPBmFCExQQoBaOT/KJcVp6eyz7SzMS8c3Z4EkBX9HJ4erK7qMxDgqXrBgFIY7yZKy9r5
         oIVEfqvdRUZYRkndeoMhfma4rNEQ5MoYNAzxPZV8C7LLTBBvpbzqxO9HAJpLMx3W+c6S
         D9kffhwpezzEkz495jZDH9Hkr6S4Amg5wg/48VBuoUZPk9eI9neWctU+RWSJZExlwxHy
         gejp+tWRWyVMv2awKLFdK5XrHGCskDo1SgfkGbEM7OP3A9Uss+Np0AvTgte9Epaff+PF
         2Sig==
X-Gm-Message-State: AFqh2ko7JYM+wBYvnJ/Rb2xIhSR4P6AppwqozYgHwZRW6u0+mxmve6jf
	+CdRrq8ZBHxwhfi12OJzS5SJPvxQyTmNYjlSpA==
X-Google-Smtp-Source: AMrXdXu00AqN6gzbCl0XNSE0BzFheyxyM5jPudZmcddEQd9aKly2sDP9lHvwf+xSmM7oxKBtopCj1fueQnm8xlBGQg==
X-Received: from dionnaglaze.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2ee6])
 (user=dionnaglaze job=sendgmr) by 2002:a17:90a:7182:b0:220:1f03:129b with
 SMTP id i2-20020a17090a718200b002201f03129bmr155355pjk.0.1673285196303; Mon,
 09 Jan 2023 09:26:36 -0800 (PST)
Date: Mon,  9 Jan 2023 17:26:18 +0000
In-Reply-To: <20230109172618.560581-1-dionnaglaze@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230109172618.560581-1-dionnaglaze@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230109172618.560581-5-dionnaglaze@google.com>
Subject: [PATCH v10 4/4] virt: sev-guest: interpret VMM errors from guest request
From: Dionna Glaze <dionnaglaze@google.com>
To: linux@vger.kernel.org, x86@kernel.org
Cc: Dionna Glaze <dionnaglaze@google.com>, Tom Lendacky <Thomas.Lendacky@amd.com>, 
	Peter Gonda <pgonda@google.com>, Borislav Petkov <bp@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>, 
	Liam Merwick <liam.merwick@oracle.com>, Yang Yingliang <yangyingliang@huawei.com>, 
	Haowen Bai <baihaowen@meizu.com>
Content-Type: text/plain; charset="UTF-8"
Authentication-Results: mail.skyhub.de;
	dkim=pass header.d=google.com header.s=20210112 header.b=BU8Kcsq5;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (mail.skyhub.de: domain of SRS0=QP8U=5G=flex--dionnaglaze.bounces.google.com=3TE68YwsKA_0intssflqf4jlttlqj.htr2DBpjwsjq.twl@kernel.org designates 145.40.68.75 as permitted sender) smtp.mailfrom=SRS0=QP8U=5G=flex--dionnaglaze.bounces.google.com=3TE68YwsKA_0intssflqf4jlttlqj.htr2DBpjwsjq.twl@kernel.org
X-Spamd-Bar: -------

The GHCB specification states that the upper 32 bits of exitinfo2 are
for the VMM's error codes. The sev-guest ABI has already locked in
that the fw_err status of the input will be 64 bits, and that
BIT_ULL(32) means that the extended guest request's data buffer was too
small. Add BIT_ULL(33) for "host refused the request for throttling
reasons".

The driver interprets the upper 32 bits of exitinfo2 for the user
anyway in case the request gets throttled. For safety, since the
encryption algorithm in GHCBv2 is AES_GCM, control must remain in the
kernel to complete the request with the current sequence number.
Returning without finishing the request allows the the guest to make
another request but with different message contents. This is IV reuse,
and breaks cryptographic protections.

When throttled, the driver will reschedule itself and then try
again after sleeping half its ratelimit time to avoid a big wait queue.
The ioctl may block indefinitely, but that has always been the case
when deferring these requests to the host.

Cc: Tom Lendacky <Thomas.Lendacky@amd.com>
Cc: Peter Gonda <pgonda@google.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Liam Merwick <liam.merwick@oracle.com>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Cc: Haowen Bai <baihaowen@meizu.com>

Reviewed-by: Tom Lendacky <Thomas.Lendacky@amd.com>
Signed-off-by: Dionna Glaze <dionnaglaze@google.com>
---
 Documentation/virt/coco/sev-guest.rst   | 21 +++++++----
 drivers/virt/coco/sev-guest/sev-guest.c | 49 ++++++++++++++++++++-----
 include/uapi/linux/sev-guest.h          | 18 ++++++++-
 3 files changed, 70 insertions(+), 18 deletions(-)

diff --git a/Documentation/virt/coco/sev-guest.rst b/Documentation/virt/coco/sev-guest.rst
index e76393e389eb..fd8bf833f1cd 100644
--- a/Documentation/virt/coco/sev-guest.rst
+++ b/Documentation/virt/coco/sev-guest.rst
@@ -37,11 +37,12 @@ along with a description:
       the return value.  General error numbers (-ENOMEM, -EINVAL)
       are not detailed, but errors with specific meanings are.
 
-The guest ioctl should be issued on a file descriptor of the /dev/sev-guest device.
-The ioctl accepts struct snp_user_guest_request. The input and output structure is
-specified through the req_data and resp_data field respectively. If the ioctl fails
-to execute due to a firmware error, then fw_err code will be set otherwise the
-fw_err will be set to 0x00000000ffffffff, i.e., the lower 32-bits are -1.
+The guest ioctl should be issued on a file descriptor of the
+/dev/sev-guest device.  The ioctl accepts struct
+snp_user_guest_request. The input and output structure is specified
+through the req_data and resp_data field respectively. If the ioctl
+fails to execute due to a firmware error, then the fw_error code will
+be set, otherwise fw_error will be set to -1.
 
 The firmware checks that the message sequence counter is one greater than
 the guests message sequence counter. If guest driver fails to increment message
@@ -57,8 +58,14 @@ counter (e.g. counter overflow), then -EIO will be returned.
                 __u64 req_data;
                 __u64 resp_data;
 
-                /* firmware error code on failure (see psp-sev.h) */
-                __u64 fw_err;
+		/* bits[63:32]: VMM error code, bits[31:0] firmware error code (see psp-sev.h) */
+		union {
+			__u64 exitinfo2;
+			struct {
+				__u32 fw_error;
+		                __u32 vmm_error;
+			};
+		};
         };
 
 2.1 SNP_GET_REPORT
diff --git a/drivers/virt/coco/sev-guest/sev-guest.c b/drivers/virt/coco/sev-guest/sev-guest.c
index f87d52dd3efa..6936184d6b58 100644
--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -14,6 +14,7 @@
 #include <linux/io.h>
 #include <linux/platform_device.h>
 #include <linux/miscdevice.h>
+#include <linux/ratelimit.h>
 #include <linux/set_memory.h>
 #include <linux/fs.h>
 #include <crypto/aead.h>
@@ -48,12 +49,22 @@ struct snp_guest_dev {
 	struct snp_req_data input;
 	u32 *os_area_msg_seqno;
 	u8 *vmpck;
+
+	struct ratelimit_state rs;
 };
 
 static u32 vmpck_id;
 module_param(vmpck_id, uint, 0444);
 MODULE_PARM_DESC(vmpck_id, "The VMPCK ID to use when communicating with the PSP.");
 
+static int rate_s = 1;
+module_param(rate_s, int, 0444);
+MODULE_PARM_DESC(rate_s, "The rate limit interval in seconds to limit requests to.");
+
+static int rate_burst = 2;
+module_param(rate_burst, int, 0444);
+MODULE_PARM_DESC(rate_burst, "The rate limit burst amount to limit requests to.");
+
 /* Mutex to serialize the shared buffer access and command handling. */
 static DEFINE_MUTEX(snp_cmd_mutex);
 
@@ -339,6 +350,16 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	if (rc)
 		return rc;
 
+retry:
+	/*
+	 * Rate limit commands internally since the host can also throttle, and
+	 * the guest shouldn't create a tight request spin that could end up
+	 * getting this VM throttled more heavily.
+	 */
+	if (!__ratelimit(&snp_dev->rs)) {
+		schedule_timeout_interruptible((rate_s * HZ) / 2);
+		goto retry;
+	}
 	/*
 	 * Call firmware to process the request. In this function the encrypted
 	 * message enters shared memory with the host. So after this call the
@@ -346,7 +367,15 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * prevent reuse of the IV.
 	 */
 	rc = snp_issue_guest_request(exit_code, &snp_dev->input,
-				     &arg->fw_err);
+				     &arg->exitinfo2);
+
+	/*
+	 * The host may return EBUSY if the request has been throttled.
+	 * We retry in the driver to avoid returning and reusing the message
+	 * sequence number on a different message.
+	 */
+	if (arg->vmm_error == SNP_GUEST_VMM_ERR_BUSY)
+		goto retry;
 
 	/*
 	 * If the extended guest request fails due to having too small of a
@@ -355,7 +384,7 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 	 * and thus avoid IV reuse.
 	 */
 	if (exit_code == SVM_VMGEXIT_EXT_GUEST_REQUEST &&
-	    err == SNP_GUEST_REQ_INVALID_LEN) {
+	    arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
 		const unsigned int certs_npages = snp_dev->input.data_npages;
 
 		exit_code = SVM_VMGEXIT_GUEST_REQUEST;
@@ -369,21 +398,21 @@ static int handle_guest_request(struct snp_guest_dev *snp_dev, u64 exit_code,
 		 * user as an ioctl() return code.
 		 */
 		rc = snp_issue_guest_request(exit_code, &snp_dev->input,
-					     &arg->fw_err);
+					     &arg->exitinfo2);
 
 		/*
 		 * Override the error to inform callers the given extended
 		 * request buffer size was too small and give the caller the
 		 * required buffer size.
 		 */
-		arg->fw_err = SNP_GUEST_REQ_INVALID_LEN;
+		arg->vmm_error = SNP_GUEST_VMM_ERR_INVALID_LEN;
 		snp_dev->input.data_npages = certs_npages;
 	}
 
 	if (rc) {
 		dev_alert(snp_dev->dev,
-			  "Detected error from ASP request. rc: %d, fw_err: %llu\n",
-			  rc, arg->fw_err);
+			  "Detected error from ASP request. rc: %d, exitinfo2: %llu\n",
+			  rc, arg->exitinfo2);
 		goto disable_vmpck;
 	}
 
@@ -536,7 +565,7 @@ static int get_ext_report(struct snp_guest_dev *snp_dev, struct snp_guest_reques
 				   sizeof(req.data), resp->data, resp_len);
 
 	/* If certs length is invalid then copy the returned length */
-	if (arg->fw_err == SNP_GUEST_REQ_INVALID_LEN) {
+	if (arg->vmm_error == SNP_GUEST_VMM_ERR_INVALID_LEN) {
 		req.certs_len = snp_dev->input.data_npages << PAGE_SHIFT;
 
 		if (copy_to_user((void __user *)arg->req_data, &req, sizeof(req)))
@@ -571,7 +600,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 	if (copy_from_user(&input, argp, sizeof(input)))
 		return -EFAULT;
 
-	input.fw_err = 0xff;
+	input.exitinfo2 = SEV_RET_NO_FW_CALL;
 
 	/* Message version must be non-zero */
 	if (!input.msg_version)
@@ -602,7 +631,7 @@ static long snp_guest_ioctl(struct file *file, unsigned int ioctl, unsigned long
 
 	mutex_unlock(&snp_cmd_mutex);
 
-	if (input.fw_err && copy_to_user(argp, &input, sizeof(input)))
+	if (input.exitinfo2 && copy_to_user(argp, &input, sizeof(input)))
 		return -EFAULT;
 
 	return ret;
@@ -752,6 +781,8 @@ static int __init sev_guest_probe(struct platform_device *pdev)
 	if (ret)
 		goto e_free_cert_data;
 
+	ratelimit_state_init(&snp_dev->rs, rate_s * HZ, rate_burst);
+
 	dev_info(dev, "Initialized SEV guest driver (using vmpck_id %d)\n", vmpck_id);
 	return 0;
 
diff --git a/include/uapi/linux/sev-guest.h b/include/uapi/linux/sev-guest.h
index 256aaeff7e65..8e4144aa78c9 100644
--- a/include/uapi/linux/sev-guest.h
+++ b/include/uapi/linux/sev-guest.h
@@ -52,8 +52,15 @@ struct snp_guest_request_ioctl {
 	__u64 req_data;
 	__u64 resp_data;
 
-	/* firmware error code on failure (see psp-sev.h) */
-	__u64 fw_err;
+	/* bits[63:32]: VMM error code, bits[31:0] firmware error code (see psp-sev.h) */
+	union {
+		__u64 exitinfo2;
+		__u64 fw_err; /* Name deprecated in favor of others */
+		struct {
+			__u32 fw_error;
+			__u32 vmm_error;
+		};
+	};
 };
 
 struct snp_ext_report_req {
@@ -77,4 +84,11 @@ struct snp_ext_report_req {
 /* Get SNP extended report as defined in the GHCB specification version 2. */
 #define SNP_GET_EXT_REPORT _IOWR(SNP_GUEST_REQ_IOC_TYPE, 0x2, struct snp_guest_request_ioctl)
 
+/* Guest message request EXIT_INFO_2 constants */
+#define SNP_GUEST_FW_ERR_MASK		GENMASK_ULL(31, 0)
+#define SNP_GUEST_VMM_ERR_SHIFT		32
+
+#define SNP_GUEST_VMM_ERR_INVALID_LEN	1
+#define SNP_GUEST_VMM_ERR_BUSY		2
+
 #endif /* __UAPI_LINUX_SEV_GUEST_H_ */
-- 
2.39.0.314.g84b9a713c41-goog

