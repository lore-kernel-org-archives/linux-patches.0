Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794059982;
	b=bG/Lj3J0+avDFQayBAVuGBOMUwCzxm3DSGctivQkVbmNwSZsb98a+0wZXxAsb/5SglQp
	 MsyMcs7tayjtbKs/5LMNrnACRHYVdiZjSsCG1bFsXa/77ehLBqxVXgtQXbrw3Kk1w6HpK
	 3CdtjyxXcky/ctZj1QQUX2S8Ygjwzt2G2GcclEe/UmZBccSRtYyeWv9Qf9zuWpvQUFxkf
	 JkvOI24PxXjsY/CvbVQPcsqAY58v0HKZ89/Mq4rlUR0C/TuEo3n/FbyogcaHImkZQIPMN
	 JVxsB+Jfl4DeGUUcFu8J1ca8w0cfS4ie5pZbNICcw2iNi7GBjX+GwuUSruA93dGRC/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794059982;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UZ1GntbeW+7RxqsCleqLGoE8q8Ky87PU4/ZBTwrLM4w=;
	b=YG8n2OnTnUc87wce3vd7SkFwAJvnNaUUe1iXltwHlKhx47JZKhrblwegHr9beCSv0dyJ
	 8k5GgsEChR8N5eTvxTOMsMLUYnApSeRL0EPToK4+0BVofd5FIlTe+dI+m0Oi2y2poEle1
	 3+54MNolI2ZkUwKnfNAQHIydoid9Du4zjEht6PF+JnScCzj0b1l78Rn2mnNRV48lpYeLH
	 tWr5FCHpWgMCynlBpSw9RT7ZijFlg/goGKlgoG1qgjhvIJ3EUz0ak6KyfwTI4ZRKtvTco
	 qYvv/H3Y+kTlSVJl3e4vTM680iNEju27IjYwj6PQwwnU4znJ8UBkthkqX2rPVtAW8Rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIlbyhAb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ABE8606A330;
	Sat,  7 Nov 2026 13:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIlbyhAb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F371F008A4;
	Sat,  7 Nov 2026 13:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794059982;
	bh=UZ1GntbeW+7RxqsCleqLGoE8q8Ky87PU4/ZBTwrLM4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIlbyhAb32NVmDocoYAOYDsoqXWe8A2UK/HCZ4DJVAs0m0Hze7XADUdy+4b7LNYQ0
	 ErDL8uuPg0CWtf4kPTM9DDC2MtuzLaUQe99yddomkTsxsuAIB5Pd18WoVVnFbYrEn0
	 FqmLEDqUuSMVxSZ584JFqQaJdN7v+o+BY+Cztcds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0002/1257] media: cx88: Specify rc type at rc_allocate_type()
Date: Sat,  7 Nov 2026 08:38:18 -0500
Message-ID: <20261107134939.508332120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit a127f5e9f9ea0470ee3bf83fab82441ae11af208 ]

Changing the type of the rc device after allocation is ugly and
this will also break in a future commit. Ensure that the allocation
happens with the correct type in the first place.

Signed-off-by: Sean Young <sean@mess.org>
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx88/cx88-input.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/media/pci/cx88/cx88-input.c b/drivers/media/pci/cx88/cx88-input.c
index 5d9ce4f9af011..c96d289e5ab78 100644
--- a/drivers/media/pci/cx88/cx88-input.c
+++ b/drivers/media/pci/cx88/cx88-input.c
@@ -259,7 +259,7 @@ static void cx88_ir_close(struct rc_dev *rc)
 int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 {
 	struct cx88_IR *ir;
-	struct rc_dev *dev;
+	struct rc_dev *dev = NULL;
 	char *ir_codes = NULL;
 	u64 rc_proto = RC_PROTO_BIT_OTHER;
 	int err = -ENOMEM;
@@ -268,11 +268,8 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 				 */
 
 	ir = kzalloc_obj(*ir);
-	dev = rc_allocate_device(RC_DRIVER_IR_RAW);
-	if (!ir || !dev)
-		goto err_out_free;
-
-	ir->dev = dev;
+	if (!ir)
+		return -ENOMEM;
 
 	/* detect & configure */
 	switch (core->boardnr) {
@@ -439,6 +436,13 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 		goto err_out_free;
 	}
 
+	dev = rc_allocate_device(ir->sampling ?
+				 RC_DRIVER_IR_RAW : RC_DRIVER_SCANCODE);
+	if (!dev)
+		goto err_out_free;
+
+	ir->dev = dev;
+
 	/*
 	 * The usage of mask_keycode were very convenient, due to several
 	 * reasons. Among others, the scancode tables were using the scancode
@@ -477,12 +481,10 @@ int cx88_ir_init(struct cx88_core *core, struct pci_dev *pci)
 	dev->close = cx88_ir_close;
 	dev->scancode_mask = hardware_mask;
 
-	if (ir->sampling) {
+	if (ir->sampling)
 		dev->timeout = MS_TO_US(10); /* 10 ms */
-	} else {
-		dev->driver_type = RC_DRIVER_SCANCODE;
+	else
 		dev->allowed_protocols = rc_proto;
-	}
 
 	ir->core = core;
 	core->ir = ir;
-- 
2.53.0



