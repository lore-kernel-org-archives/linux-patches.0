Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0D815218A;
	Tue,  2 Jul 2024 17:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941116; cv=none; b=Xkc4qGzIPKyAgWWyPdhxshgguRiGf3yP1LAWwiBDiFKmQIs5OVr9ZOUIJ+8M6V8vfdVkxItzxIemXPMDYar8Gj7Kf/nHUtSTdBWom02xEi/iouWJue0r+fgjkWglYw6YOAkvKhiN9QuGxx5w8JaQ/oKto4P0Tfe8xUS5661H0I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941116; c=relaxed/simple;
	bh=rFqiatq8ndu47T55IRAZliYr90K2326MkC1Z/khveTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NU2B0nT3fJD2dwv3XyPJepj1CynZrjDBWWgXKDE6j0IwK0I6XSIpFJYKqdutACjN0ii/MlwrzvK87T8Quo2KUxw/FNZkyWPOP1Y65J1HY/bxzrLESSsmObCCTNIBYQ4Mv1UL0ZOWOFfhV6ot1+ojTicZF0zjMeJhzrPwld7psb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQ6bsNUH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQ6bsNUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D77BEC4AF07;
	Tue,  2 Jul 2024 17:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941116;
	bh=rFqiatq8ndu47T55IRAZliYr90K2326MkC1Z/khveTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQ6bsNUHPYoVoN1c9MxvmX+bKDnLpb/PIewap/0qESnHFg4ooKArxG2PPseK3ALlE
	 NulFiCfSj1AVkIqYmuoosouiFVB9YPVDnpjyXf1wQhkqmpvsWhcyirH2mlrxrE+YUP
	 JTtWHp/LYHUSVNXK9G1+x29rVK03cwKf0ZCYbWwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 105/163] usb: gadget: printer: SS+ support
Date: Tue,  2 Jul 2024 19:03:39 +0200
Message-ID: <20240702170237.033682784@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit fd80731e5e9d1402cb2f85022a6abf9b1982ec5f upstream.

We need to treat super speed plus as super speed, not the default,
which is full speed.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Cc: stable <stable@kernel.org>
Link: https://lore.kernel.org/r/20240620093800.28901-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -213,6 +213,7 @@ static inline struct usb_endpoint_descri
 					struct usb_endpoint_descriptor *ss)
 {
 	switch (gadget->speed) {
+	case USB_SPEED_SUPER_PLUS:
 	case USB_SPEED_SUPER:
 		return ss;
 	case USB_SPEED_HIGH:


