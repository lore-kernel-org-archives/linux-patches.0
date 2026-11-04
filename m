Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829174;
	b=YZ4MuiuN+21vY7/yD9DpZzRqjAvdMhtR3n/rtMQ/PNZQ3NdKbSrXr8tSfW7/V89+CBZ7
	 iOoOhR69+orqeF02qDkBd4G1lkCky+QogcerzsEaKWNSYXW8W1RGJc1H+F2k/HiIsXPjo
	 D/NKvOrkhGI9qPvt3E9YNV1bCxFEowVYvqswk/Wm34K194sfcfETQY4tRAP9UBf/nfmTx
	 6arVfhuGwa8WjGp1Xu9jCR5qAJuLhPENIyLh5svFCModTN4T6oc7LIYXpBufZgVpL1eln
	 t4WfZAt3nhRk8J98KSCOnsT0gybqVSeNfDiEPRY916cLJ7jsGdU8IHo2Va8QjM9hR0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W0B2uT8d75vaN7tUEj2Trqj50f/wLeZeKosIzBqNN0k=;
	b=gDOfoZqHBOe1vEZQxJjA/T7dl3nsS0PW7Wlb2MO2u6Xm5tTV7BBPahqLFRQf2cjEPjaQ
	 LdfWpoQlkRUbkBvoQ1/0IpGX9JqwVMNbhLfcr3tAT8pjY8+smWBhck8qUTzsXqKlX58Jc
	 0DKp/AMO62eKhyQFZO1SiPJl9DR+7J7PJ08zrkwrrzQNOfJDJ5TTo8bhBJ8WtlxR+hxIF
	 jKWMc7xQN+HpA4IylUAHEz6EAEN6oY540+IrapN52VjVbvTozaVRO9sq1mWtAg9KX+y2W
	 R6bKaHXIPMCLvWNLFC3cX2iVRq4EcM/O6GkecmdUFzT2O0B0CfR4PAbdLeyDgdUz5tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oyVEkbeK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5160607099B;
	Wed,  4 Nov 2026 21:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oyVEkbeK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF791F000C1;
	Wed,  4 Nov 2026 21:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829173;
	bh=W0B2uT8d75vaN7tUEj2Trqj50f/wLeZeKosIzBqNN0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oyVEkbeK0YIbEm1VLFap5PK+HqLgcUjDGwW6LNzFwM9Z7rWJyTjXCHAkUTd9wbQe2
	 EM0WqmvNO5w3gveX71Y0YUEMArZzJKqmHsIUlrD3iMa7Y3KHJiZAUIpOCLDFREd/U8
	 BobjHq3tdWezlmdH0xh0s5s6nz0zwL6V5bSYOYpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 492/547] HID: logitech-dj: validate unnumbered keyboard reports
Date: Wed,  4 Nov 2026 16:11:16 -0500
Message-ID: <20261104211052.353644691@linuxfoundation.org>
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

commit c2deafcb4c8227771f768d77ed3c0a489250e9b2 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  For an unnumbered keyboard report, logi_dj_raw_event() uses the
second byte as temporary storage while prepending a report ID.  A one-byte
report therefore makes both the initial write and the later restoration
access data beyond the received report.

Reject unnumbered keyboard reports that do not provide the temporary byte.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: 74808f9115ce ("HID: logitech-dj: add support for non unifying receivers")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-dj.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1790,6 +1790,9 @@ static int logi_dj_raw_event(struct hid_
 	if (!hdev->report_enum[HID_INPUT_REPORT].numbered) {
 
 		if (djrcv_dev->unnumbered_application == HID_GD_KEYBOARD) {
+			if (size < 2)
+				return false;
+
 			/*
 			 * For the keyboard, we can reuse the same report by
 			 * using the second byte which is constant in the USB


