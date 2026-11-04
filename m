Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831868;
	b=R3tBUlBRd/b4tfvJ4GHfbGkd38xRnUhqmeQpkblwEEqLSJIMhoo6tJIwmvEs3rPjSwU9
	 XQ/9E+RRgS06ULO9Lv3WdsCAVSZjhHaj02kZRkwHW7Iq+fzWznQIb+OogS0uGaVSNYOTn
	 cHckmpaWnMYAdbLKQl8CdMjFfPn8KLv9Uh/7oV+njtaaH/aiqpLtaAG9OQhQJRKsYz8Bh
	 IKrz5WzS2r6IywAbBLKuxAfTXKmYt4ttdKMuaL6VhYhT34B/MH7X2SYrqoaqBjDTHES6E
	 A5TaWGx6Q9nCQ7DW3Y5mOCGiM5uMSfmsWTNhkQlrpuPdKPJtPpDHiy/Eci+QeqS4cvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hQpcI9XqBVdH8O4WbIQEVxcIdleTn4ncRZ0WeXV7F5Y=;
	b=nTgq3OER9CFkHvs9bRaFk9p9EUd0IrE8ZVTPlws5ukMBvX4c6AqrU6BTxQByKeoDVYFU
	 SvTzxSnjfGn6Vk/mD+Fz4uCZJTeS94HURtUeDWEkiAAQkKafsRZJyBlub7AtKSC1wExuI
	 UqE03LG0rhEpFRLeD/3Ll2VEW50AztVNN7+f4DB3H1qyrmmlKUhXnZXrqU1tYgylc31eL
	 tORAG/uBGznOF8tSAjvXM4QzhD4ffYdd+xXVf5PrZNRsshPNa0uKID1CgoMepoEIBenZE
	 OeBq9kN4GUBjtyijt0qYmrb8+FAd1lRtKKDYyfiQbD9ErhV2uoNh0s0xd1REQTgb3LA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZddHP/gn";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1602606AB34;
	Wed,  4 Nov 2026 22:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZddHP/gn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF2E1F000C1;
	Wed,  4 Nov 2026 22:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831867;
	bh=hQpcI9XqBVdH8O4WbIQEVxcIdleTn4ncRZ0WeXV7F5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZddHP/gnY9RzIO73Zqx0S6y1Z07brcCtDGgJPWcyBDwxIt0Flh2lhQH+U/DKMp3hQ
	 MYWy+AbMaM4Mp1Gs8KHTf4DN9x5M40L7Gg/KgBNLSDxyYDqsH0fm1MX8cZzMb9nJxk
	 +SyhKYs3cLfGiazL12Tu8Gk2ZjtWsRYgCIlVsTEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 0964/1005] HID: roccat: ryos: reject short special reports
Date: Wed,  4 Nov 2026 16:11:37 -0500
Message-ID: <20261104211110.077035924@linuxfoundation.org>
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

commit 02f3607d0beb82e76481568bf631235e6a319b47 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It reads the report number without checking the received length
and passes matching data to roccat_report_event(), which copies a complete
struct ryos_report_special.  A truncated report can therefore cause an
out-of-bounds read and expose adjacent data through the Roccat character
device.

Require a complete special report before inspecting or forwarding it.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6f3a19360545 ("HID: roccat: add support for Ryos MK keyboards")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-ryos.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-ryos.c
+++ b/drivers/hid/hid-roccat-ryos.c
@@ -189,6 +189,9 @@ static int ryos_raw_event(struct hid_dev
 			!= RYOS_USB_INTERFACE_PROTOCOL)
 		return 0;
 
+	if (size < sizeof(struct ryos_report_special))
+		return 0;
+
 	if (data[0] != RYOS_REPORT_NUMBER_SPECIAL)
 		return 0;
 


