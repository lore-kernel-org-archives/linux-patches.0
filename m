Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035510;
	b=EATdPSXKHtnfKp3wdiQX7KpJFlHGV1/a8R33S0/cwWL2+T3VLvhlCdnitg04Bb+mx7J9
	 OSYxDJUEOS/zUh0H61w3uIfzumQkXPf20sTDOoGXeIkzYnJxC8qA51GjRh5uLUnpcLsfE
	 nx6sJSIzmIsL7EOsk3d7mACDoK2qkr7C6FHYGNv8lQpbDPKUYp50cqxaAkxo2QWbcSfmK
	 2SHtEbZ0aN0FYdbUuJBHF+d0gjjnkR6v5VuPQMYuWcliZUR5LHSS4ddYz5QYqgQJT7DEs
	 cUOgelLry9cEygZ/NaDITuNlKP3GADYh7uo1UnicZUR/I+jd2Dxo6AYre8Etpg5FVKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nv7DUKN2/doQvIygCwhtGfsx5tsVds1r4GN8lo5W8nk=;
	b=cG4IBiSd4tPIU1rb6IflWNaTYIsBQtVum5sqMDlVqRODTkqkmKKyC0n0uxhqGQ62iG08
	 vhDoCZd3PbYjJX62h+hmcw70TAv25UwQc44iC1bUC6AYhlQ9yxUKiVAofVlhdJ9WHkJ11
	 CCmDz/N1Tz0klCDGNeguOCI/M4wVvf9YTdG7H5w/y9DpdJf0uosigE5zYyrhVJNlvU6//
	 AyXEwg9F0Spr9AN+7UwqvSlGYADnDH8b6hFvdAFoID4+hrSQmY2/95ji2z/eTmqR/jj5W
	 AhQMEHrP4QY6t9bpnSKsbV+qX/5nU9N22DaTXe0nYvzOcho1zJab+p5mr5LbI4w1c8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FX3fIFp2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D39A606A320;
	Wed, 18 Nov 2026 20:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FX3fIFp2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35421F000C6;
	Wed, 18 Nov 2026 20:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035510;
	bh=Nv7DUKN2/doQvIygCwhtGfsx5tsVds1r4GN8lo5W8nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FX3fIFp2FFpDzjJd+Y7IpLuDleNpBB6+GbbFTmmQK/snuj5sOFg0nbvlkyVt+7736
	 jQr1+qyIlLhqtdzejRdABQDpz6S2EgOsvpLAy9ywA5cV0xo1Hm53cxjEXiVPTwGubt
	 KpMWNKCd8blA/YJFiQejEKZ2aqEnHxvOneCvEP8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0729/3318] HID: logitech-dj: validate unnumbered keyboard reports
Date: Wed, 18 Nov 2026 15:22:31 +0100
Message-ID: <20261118150340.398583766@linuxfoundation.org>
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
@@ -1682,6 +1682,9 @@ static int logi_dj_raw_event(struct hid_
 	if (!hdev->report_enum[HID_INPUT_REPORT].numbered) {
 
 		if (djrcv_dev->unnumbered_application == HID_GD_KEYBOARD) {
+			if (size < 2)
+				return false;
+
 			/*
 			 * For the keyboard, we can reuse the same report by
 			 * using the second byte which is constant in the USB


