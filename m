Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829196;
	b=qTG61grYmC4etB6BRZyZjyzTgcSt/A3Gd/FkAQqF5sbELypeyTDJaNnGspQW5FxnDr5f
	 0NE5na5jznTEnTnm238oVMjNUN+fXmV+WMtT2EwpSp51oNR2RjOTn93CKVO15mqMRL+Db
	 jQVNaLvjl0UgVkZYJS4f9giG71FpDa52vo/bLJGbcogbDxRii9uVCJEnLqdBtf7ubEhQb
	 yLQeDhdiQFAGH6Y4WUQH+7J3T2i/kBEn7tflsxsgxNkYCP09bDJiRArXUsUdB8bTSnsJR
	 3qMUFJHPxODoOTDgBGdAovRXPFTnt3cprFIHHNfUJ9avdVrJe2XAKIXxp+TX5xJkMYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s1gX1wfgMDmTUVIMnS0PYye0VAMw/Qbu823Thag1X2o=;
	b=ZPbQK+opVk5H+3AnCp6P1y4LB+Ps8o4s/q22H28ioYX5RBf4aPDyDLZlkc6pfcQTV2un
	 qyr3JAdoWfupiWHeZzq9vtjg2iiuGKRhnWfSthxYElSGiqeL6sHqawTAXWbtm1v7XXUln
	 yg3Qu68lvoaOVoONdo38yASS+TDxaXUaH/n69JJkcTyrd21hWownXEXBbjjNEdZv49jbh
	 kgv1uYbkgTSfIu+0UfP/W7aLv/yidiUxKfQBk/zefzSzoipXG4r9zNpsn7pZlwgyIMXil
	 C+AsellO67BFyNC2tojcX4fyRBF9VJHN0faUt4UUGXFYtPjOjBEQ4klRFAo7Plq7QLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEOLGeWE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55E9608F134;
	Wed,  4 Nov 2026 21:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EEOLGeWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856191F00A02;
	Wed,  4 Nov 2026 21:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829195;
	bh=s1gX1wfgMDmTUVIMnS0PYye0VAMw/Qbu823Thag1X2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EEOLGeWES4ncPSbalfOmEMpqWlH1Vzyx4V/CetPWN4BHgG9tbcdgTbHyhKsLniJul
	 7wIBhmRerwrjBDc5if6El5ZhZohQMQldC3m27HmM2wWioJebxRgnK+tmIuL208YLEI
	 FDrUImQH9PH+EX6FXNZM4ZaJtlUJjo1heLpn7MME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.3 506/547] HID: roccat: savu: reject short special reports
Date: Wed,  4 Nov 2026 16:11:30 -0500
Message-ID: <20261104211052.767688526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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
 


