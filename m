Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831869;
	b=3AlglID8KIrqfmzjYppdp5f9nUF91bT7D5KTHCtkB0LsIfVbdYv3NFgcS6DH8KDz4dLt
	 b4CPMtu4uvqkmqCpfOJqaybB7opqT/gRmDBRtzMSxaU5+DpAZQmMtBRsEUcLlgO6jJahH
	 4hxVHVnpBpA/1Bd9eRLG2h692J1AWZv9D6mNUirDIkhI5YLwQR4MyP16lsoT7J3+cKzgy
	 kpUwk4KrOkEQCMmOfe/gNngUep3KjYB6zlHSBggmrhwLf7+J1Qe2MsZ3sdyIf75KF2RMp
	 qCaWxm0hjXkMTnXwEQyARYkLPAyNO8xHVTuDE3aeznZG40lB7ffaY5f5jyi1npIyPUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uO7Fy44hQSfO/lL8wiPmGgTolVSUcnOF5pRTdUroMQw=;
	b=RmHBYUXy5NFTxWM1To8lnDlzhYceXLA5YoNAYvBPtFkhJC0oSFYxojhZbvE1bJfuaD8C
	 B6Lo2/nMR5Co0jimy8W93NwjcJcMWWaM2/cd0p4f1k4H4+VCaGz8x/0nH0CzwRXqOzGB3
	 4XUIMvKWE9glucyR6vCNxlWcgsIbd1/ZR+sxB9u9q+fOt00BjrpkDkR35pnhzto0s8HVx
	 QgiRRBT1tPnGNTxhrFlSvez76xVEV1ZZoIxMtTA6ek3zfxhaalQEmN9yfnQDom+iweFwQ
	 MgsYZnKCmY1133+P08poY9Qj3pan2JANyUm0fblIReiEcl+vSdHvdPlwrZgvBwifEWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4xZUi06;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F2DE606A326;
	Wed,  4 Nov 2026 22:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d4xZUi06
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF271F000C1;
	Wed,  4 Nov 2026 22:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831869;
	bh=uO7Fy44hQSfO/lL8wiPmGgTolVSUcnOF5pRTdUroMQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d4xZUi06ukcn1QSP/96SDnPDoFIyv++Uu/knK3Dwl4pZKWNDLPmEl8MmtpWVt5ncg
	 ZeGt9CzLWMofFzJvOoSd2OYQKnnHGXJiCIrtIoUj7AhLD6sej96BVS1s5zbOUjwJF6
	 0IqifXMLy+O8QLS4ncasYPsobA/ZYVu9aLldo/2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 0965/1005] HID: roccat: savu: reject short special reports
Date: Wed,  4 Nov 2026 16:11:38 -0500
Message-ID: <20261104211110.105378705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 76c51fdc825a0486f8d88ff896d39acec8f377b4 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to a helper which inspects data[0] and, for a
special report, reads the complete struct savu_mouse_report_special.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the special report before calling the helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6a2a6390cf09 ("HID: roccat: add support for Roccat Savu")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-savu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -182,6 +182,9 @@ static int savu_raw_event(struct hid_dev
 	if (savu == NULL)
 		return 0;
 
+	if (size < sizeof(struct savu_mouse_report_special))
+		return 0;
+
 	if (savu->roccat_claimed)
 		savu_report_to_chrdev(savu, data);
 


