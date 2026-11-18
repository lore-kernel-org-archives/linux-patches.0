Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057958;
	b=U+yRtlwFXKZEMnmryLZMsANPlizZ/JLl8hsyul/UcP6zjUBzfdg0yqi8B46HAt3TEBSI
	 dG9DsWGmaAnESBXXiyVNh3siybCGo6GW4gCjb5iXCVaH+IjSDPNibID2IBSBl0pD/pmoS
	 MhNzssKSZJk8Ti9hhS9bN+WNYvdNWcm63RzI6T9OX1M76hTIU2NXlt8dBfxSK77b4/pM7
	 pFvV/7tKR5JNtDSTxTuZnPH/dNKT1RqTG9AOMkL5PX3stBhE9rxBCxh0nnXHWFyUAI6Ur
	 B+pJPycRfSWSbw5xOXzmuGwtrMG2NDDP0kmjxBuKBYs0Dls7uf3/vWzc/u8RklK4u3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mzgggt6JdZZVtCDW7oBR+ySS2cWMFE0XwjDFRwS11WI=;
	b=Qbxj4Jily2WqjcTwa8w3sa3BgoaKpO15ajd/E6RN4ETtEwc7aOeFhJ8n054LFJDcC7IT
	 Gb8zBKF6RkFoHgerwvErHZDCX+X50rdYQdCnn4lnzt3jzyFZxA/DepQHMh3YZPHJ3Fbte
	 FdmAAtJuLSIVw6fUUffbZi5dqhFveLBUTEO24RsOP+IIsjZCBqsgSWBlbqGKW1wT2yB0d
	 XQg9ZYQlyOqJcbZOHRKxo7R+Ye1+0vaPAmPrqVMmOV61k1oVy32TicplZ72yz3zY350fm
	 7T3OjfnzMeDPtgtRLGMRXzlv5JmC3oAdLP54mKYwu44GE7eXWPAeHK8nLxlJIBXThqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1slI0Rze;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760C3606A31C;
	Thu, 19 Nov 2026 03:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1slI0Rze
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C031F000C4;
	Thu, 19 Nov 2026 03:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057958;
	bh=mzgggt6JdZZVtCDW7oBR+ySS2cWMFE0XwjDFRwS11WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1slI0RzeBRddbOaKgwOvBkWbBMqaXbOERc1a1wTsmQMRly9dsKiw3fsdWpU3j00mh
	 5DPMIPMEHgvrirb2DWALJOTFhXsdZluTLXe87GnaSoBHkOg5RMdVg3rVb6yoVnDb95
	 b5jtb8SpVx5iIerzpDHzzcq33Yiw4UDpY3dbsY2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 5.10 0316/1848] HID: roccat: konepure: reject short button reports
Date: Wed, 18 Nov 2026 15:39:14 +0100
Message-ID: <20261118145925.441307767@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
@@ -178,6 +178,9 @@ static int konepure_raw_event(struct hid
 			!= USB_INTERFACE_PROTOCOL_MOUSE)
 		return 0;
 
+	if (size < sizeof(struct konepure_mouse_report_button))
+		return 0;
+
 	if (data[0] != KONEPURE_MOUSE_REPORT_NUMBER_BUTTON)
 		return 0;
 


