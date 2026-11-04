Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829190;
	b=xdWiTNLRQU649+FjME72JWHlyrh29JcGIJtySqjRAOpq1Jq6r6BdE9Rv7jCx5yjKfFFN
	 yBty87ABA06wvYo5R5eyx4b5Ku94gtCWNTHSeTGzIIUCSiyUSujeKL5LyRJhBnooe8IBb
	 1oGBH/CW6Ce5sJQ+DhOiq0mVyyaKFgzjXvZE+OSR3KWZ88o/pk+KMuvo2srP+5UtMglOa
	 OEA/CeLvVxi+eg1HXBuC8yA3+2fU3sVwPhXzw85EL19nndPnkmhQgYVxeNJJ4qGR2/xET
	 rYy1lLaNVuHpNqc/o3I+nOz+nn7NpAlxrN9kIgjsJiGeMaerX6z4fXtQ2JcHdYkyRsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829190;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gbs5hsp+BEPieHnEiOVjltwfReI4VlRXQbWjg02pxl4=;
	b=m9JE08cjDNPCBRuk+wdlwXiPopIqPBZlAlJ96n0vIKep/cs9o9bMjI2tu3zzKHd9/Vv2
	 kKUMoKqP2oPjuiK7UecVYkx/OyagZ9rJCnmpsIiGk3yp5F/5g7pMHrBvIx0tbG4LeMNPh
	 NPaBD5ykgvDe7VItgRFeIRvFGminETrXO43j8FKhik4QAllh4opPF5zJHXk8kc6LOvx4G
	 Mh+I+xBbPNF1DGNqc2Npe9pNRNm+gnFJ+4gsD6WZdjfQrOz2NM/zdfBD8gjEIUpPCFSfm
	 OwnyV9ScVi2iLIyPVEUmg7w1LCkzM1w3+BbbjPdxeF5qWZCTBvYvJiMO6vVWxUhR0UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goej2Zw+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB010608F129;
	Wed,  4 Nov 2026 21:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=goej2Zw+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C8601F000C1;
	Wed,  4 Nov 2026 21:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829189;
	bh=gbs5hsp+BEPieHnEiOVjltwfReI4VlRXQbWjg02pxl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=goej2Zw+civCBJp4vVY0T2BXyrxl91xJFoL8FC0vaXTiSp0NCcmWU9IDj4AqgxacB
	 qlCHrDj9O+/6M13TUufmsMyTgH7gTmvWU0A0kGy2/ujbRGG89mjLFvy4mFBktrV/q3
	 NUwg/1+IdJUUdeafbUh7Yh4fU2AwJZSCjxidSBg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 7.3 502/547] HID: roccat: konepure: reject short button reports
Date: Wed,  4 Nov 2026 16:11:26 -0500
Message-ID: <20261104211052.655246041@linuxfoundation.org>
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
 


