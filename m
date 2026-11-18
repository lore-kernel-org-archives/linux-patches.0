Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035538;
	b=1ZwwhKP9mhfZCLHAojpWUNYKvKJPXVDXsPz271sDlP+KmX1+x4Ga1XKJSg8sAoVTnQwM
	 kq5WOuGpX+a0FLAFCW9v1w8VyYDTrEeMpVqjnv1JdSylNfsfFVPg6f2F4/qD6k58JzPuT
	 UNlBhXEKyj7j93bfBdFOof1rvx0lBYe5UI7MUkx/RU0esHlk/U1h98JNqYTtQlHETae03
	 ZVGSTFtRK3/nG5k0ohhzB86ul4P394s3Lahry+Ynb7R3PKgsKc94iaLuIAbIVGrzpbAB/
	 fuIH2rz+F926vwq9GqzsrRW4+zy3GIqaUae0v4Um7CBA9/BjflCVW9LC4HHHUxCZmMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pK5EbanUDOMSuU7KhD16qUTQ4Ixcqffv19+SW/J5lnY=;
	b=dydcZfc+I4YxNYve0cMQOtpelNSima8ZXcZwgxd82oeiTCILzg9TCfJajJdUwwQab0Vl
	 vphNsB8hDwRnuWloNx4q2xL6gwQ1zMwaRIcQujElwRqeZoyE8g8/mWpA6iMusvnc/16UV
	 CY8zq+Ttby0orzSSVZSYmFu8AM/oik3R0YHuwkDqasDqPdTWXQmSVwsgFhrS17ppYG3mF
	 GSaNHES7xCU/6iClntBmz4gbh2pZPYU8yNvobCrN1dFmKZeYC6221KrRQX9KbRONmabN8
	 eKlfpcH21H/kTy68LmG4AzdRPJ+kACSUf89dMGhdLFMJJCm7YQfuBdpoHvgayGc9JYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7iZ6awc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78CF4606A320;
	Wed, 18 Nov 2026 20:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s7iZ6awc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7211F000C4;
	Wed, 18 Nov 2026 20:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035538;
	bh=pK5EbanUDOMSuU7KhD16qUTQ4Ixcqffv19+SW/J5lnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s7iZ6awcvcfVXXcs4PxrQ5twyxG1bqADb+/DLvfeTU5ZDWsJ548ARDHIqshLV06/O
	 b9paXE/fUL0lbsYeOvujl9v2p2WQqoPtQsYP3HhGg/ALBQ0P9E7dvG0Oxtkbz6zYO3
	 o9+HhCJvY0yxTr3gzHxZlabvTASk7AwFSkVwe68A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.6 0738/3318] HID: roccat: kovaplus: reject short button reports
Date: Wed, 18 Nov 2026 15:22:40 +0100
Message-ID: <20261118150340.715893751@linuxfoundation.org>
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

commit e95917a606f486e46f5136fc1b72190742a091d6 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct kovaplus_mouse_report_button for button reports.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 0e70f97f257e ("HID: roccat: Add support for Kova[+] mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-kovaplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -614,6 +614,9 @@ static int kovaplus_raw_event(struct hid
 	if (kovaplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct kovaplus_mouse_report_button))
+		return 0;
+
 	kovaplus_keep_values_up_to_date(kovaplus, data);
 
 	if (kovaplus->roccat_claimed)


