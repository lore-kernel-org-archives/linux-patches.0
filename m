Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035532;
	b=TiBq9qbGC/94zdm/VO1S4nXMsGQ3xtcPrqikRibZoKUK1Gw5Yi76iickxuKCGKQm1CS2
	 WtYT2U/ISgPOkiPdRHPgjum5nDg26hOz/8oErY4DPaiKHUjHfdHt7nFW41QG/NnYIFkA7
	 OP6lqb+jjVmtoUbPPBNjyyya2Y/hpSi5XLrLVhsXJbYZgpXvMUoasYsItTfp9KWRYWzqG
	 cu0q7O0YmniD2HQ0/G1//v5K8hhulOyi1BRt0Gsbx9qA59JA+/6iujEFbsCyrzHBsmeuE
	 vhju0zwuZugIL+Z9g4/xYGq8aiafd6RwxvdUq56jjaRhLHiWilrEwgwI0go+2FCgkFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qWRxL5zsX+oZ/0C9ArYu3Tt2GkyofUOjnmKyAu/Vbew=;
	b=sp20phH8Y2zYK9y+JdcIe3zGLfJIYDUys927G9iFd0a1/RDha3Nea3hTFcXPhm3S1yBg
	 fwdJR5CvJs+sPGBrvMSo9KF89FCY4Ph48IM3kDC/LvF4I4R8AuRdZoWkl3OcEVtcH+8uH
	 Z2pGoOoSVAnVm0rgdBPVhYkVKa5wr79Wrip2/HhpuY1FmYJASmO2hOVsAYCdBaXJBKG6V
	 FvfZusrS82CcAaYrg21UJwNhOsnwb3qWAuVgbrxMPBlRB0TVco8uBlQd453a/NAFqby9I
	 cDHNY4Y80U8WQnFj31r8or/SuoUynnKWS7y4OOwRgzytD/hE9akF8qJN13dXdKtTjoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=blex0Wpy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7084606A31C;
	Wed, 18 Nov 2026 20:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=blex0Wpy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D1FF1F000C4;
	Wed, 18 Nov 2026 20:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035532;
	bh=qWRxL5zsX+oZ/0C9ArYu3Tt2GkyofUOjnmKyAu/Vbew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blex0Wpy+REBuUGKKdReer1sSm5N3BxyKUJwRuIaU7D9TWI3G9LQBLujdSpS3HqZi
	 mzSuk6VcYGkYVl7ZwlDCG+DpvmtpDuFdjZevxfwAPh9DrL4qgehGPqwHt9wtlTOZ6h
	 GghkziqTdCb48DfPJ0NTJqoWLrerOegqocM74Jpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 0736/3318] HID: roccat: koneplus: reject short button reports
Date: Wed, 18 Nov 2026 15:22:38 +0100
Message-ID: <20261118150340.645579478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

commit d879e17a8b4c572c0b53b4e42a36849484e8f00c upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and, for a
button report, read the complete struct koneplus_mouse_report_button.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 47dbdbffe15b ("HID: roccat: Add support for Roccat Kone[+] v2")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-koneplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -523,6 +523,9 @@ static int koneplus_raw_event(struct hid
 	if (koneplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct koneplus_mouse_report_button))
+		return 0;
+
 	koneplus_keep_values_up_to_date(koneplus, data);
 
 	if (koneplus->roccat_claimed)


