Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061794;
	b=bhLSs3jaxmag3D1T8WObf6aAKjDIhAWESZubsI58H+S93WYNLi2+EW9aKX1/leOtzsEh
	 OA42FufrfRhqdmDdKSJ6OeGvpyyx0e/FmaH3gKee3RZLI+pCPri09IYrH0HcLXtAGt+Gn
	 64dWL8tJwcRO9ooegTNE+ohN4wS1OGs/YfIf9pnJt/Xf6zQ6uleTzIQqjLAI33i/Uq/X2
	 Vu2m0x128SHwXW5rZHo0lNeWk1Tk0SDmkXWKMu9ijK/Bzh03S7BqUQlGxiE9V+IFIWPbb
	 3V0dFg+qLuXOKuYebiICouNPR+cAQZxG2oI5QclKfpucbeUdL8xj/eQJUiI3YHEYGpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9GxXMSIipNUhy3ZtkT2rRtyENFd9SBsgo2+NEks5OZw=;
	b=tJpYfCAYhDKavIhYnfF05xV6G5RJfKXTjd8q7W2BXona3dB7hSnGSDkzb0dBLF/wChTU
	 bR0xiKmadMUwzm3uiHylozY4Vv+ed7UqDaCdW0mDAVgfyN5GkMYSOtvdE7OIG27JM5czU
	 KiDoyC5D4r1gethMTSnzzPOz2AhgQA2tMYQEmpKBTocZm4ZaCL0xUgOSdoKSn/LWrrShm
	 zWzPIf1Ygx/M4yBaykIwUF2sFkOMSdAmH4U5MXGl3OvUa97oM1EJeu9zuJHHs5XBO6fF+
	 1/XW52Q6ZJFZQpZwtY2eE2uGEGQtBOvi9QVTagufA4jYRk1WnboTif09F7qDbPOKcRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHInXSvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EED89606A32C;
	Sat,  7 Nov 2026 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tHInXSvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1FC1F0089F;
	Sat,  7 Nov 2026 14:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061793;
	bh=9GxXMSIipNUhy3ZtkT2rRtyENFd9SBsgo2+NEks5OZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tHInXSvqFo20BZ61Z2e6+2hxcVPUPjTduXmSrvdfiwlp2fkjYmzzNpLcX0Z1shreX
	 NT8cieSBJ1AG4hZl8NFM5mZJmRfmRlYdhWgUJlO+LE/PidUnXMFU6k2pPArlZao1Xs
	 FD5f2gcxG4uubCJo6jDAlPtTxs1uYlTlFLqzcvb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 0822/1536] HID: roccat: konepure: reject short button reports
Date: Sat,  7 Nov 2026 08:47:18 -0500
Message-ID: <20261107135020.629350858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit 1590b7c9bea0abe7a5d25dbfe06287c48c238a6f upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It reads the report number without checking the received length
and passes matching data to roccat_report_event(), which copies a complete
struct konepure_mouse_report_button.  A truncated report can therefore
cause an out-of-bounds read and expose adjacent data through the Roccat
character device.

Require a complete button report before inspecting or forwarding it.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 8936aa31cd5f ("HID: roccat: add support for Roccat Kone Pure gaming mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-konepure.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-konepure.c
+++ b/drivers/hid/hid-roccat-konepure.c
@@ -181,6 +181,9 @@ static int konepure_raw_event(struct hid
 			!= USB_INTERFACE_PROTOCOL_MOUSE)
 		return 0;
 
+	if (size < sizeof(struct konepure_mouse_report_button))
+		return 0;
+
 	if (data[0] != KONEPURE_MOUSE_REPORT_NUMBER_BUTTON)
 		return 0;
 


