Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061791;
	b=k6qPrTiuEV+HXEbBkV3pCwjllDi1TDqO1vAVS0Jo7A00BWYRuhhHdUdyR43gpC+QSxpo
	 RHqvOyxmuKMpSx4yzQU8o6+HmCYECAqNFgBYalWqdYOPxkC/jrvcNjUtFwrx3lRawYXJ6
	 y8cbNbm2pbQiRS+ubk0TbtVgNFelCCKR470yuzMfy5Ot7gphtcuzUby1UwoSz1qgv6lBG
	 m9m6nXr+S+5+I9X96fE1coMVkJL2XgdcobZ6XWv0t+CGxXAqcU2CwjGtdW8nVGwZwcM49
	 LOjj2Tm6aeCHQ8QPwLEiEGl95vBnnyZEgPW0SrzdEWiSZugnzhYKjGx+BhkYM6L17YQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/Lf4DitzZIqLjmYLMwOqRS/bluvSHRaFPSa03Zxr9jE=;
	b=m7z4qlGpV8CER9Rc8Y94QvSzkVLWBTgkPGOo4IvPuGfKF2/DjjIhgXduZILnxe+JDoNV
	 gJLZFypSzAFj6aUMnMUuIBZ3w01Npj0RtxPFbpfqXxkyD0PZZ5OzoMc+BruzeL7IxConD
	 cor1Ed+FPX4GhxTfHh6BedEKPoK+l9fBI/sZmnVgj6eD8Iuy0MQsoUuBRLatUnemRJr57
	 DI4T/Er2EfoROtCK/gEE3pS9KZxnoJ7dBiTpa33fSM0rP+byeq4PNbjrEaNREnwVQkQBM
	 D7MlXGqJV1m9ppJKd4HQSX47VDuReHXKY6VKgvF73AFiZVVLGwA4756E8mWgqiTeL4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Szmzk9w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B94606A32E;
	Sat,  7 Nov 2026 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2Szmzk9w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD261F0089F;
	Sat,  7 Nov 2026 14:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061791;
	bh=/Lf4DitzZIqLjmYLMwOqRS/bluvSHRaFPSa03Zxr9jE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Szmzk9w1rejXY/nsBPhc/e9zYDMJR1sSUKjx2Q0aY9ULf/mB43MSHk1KgIvfe9Er
	 vm6gAjr2A6jvIsjHDr3XyRzP5S0pRXy3j9WoHJziPvNCcxM1924/9LJ41JwTu8bVdp
	 H/YuHMNw70ISQHIQy4zq8L1LvUG320/UPk/JJGxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.12 0820/1536] HID: roccat: isku: reject short button reports
Date: Sat,  7 Nov 2026 08:47:16 -0500
Message-ID: <20261107135020.578708909@linuxfoundation.org>
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

commit 93e5f7f6189af76a2b2e2dfe647838a7b9f99d21 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and, for a
button report, read the complete struct isku_report_button.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: d41c2a7011df ("HID: roccat: Add support for Isku keyboard")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-isku.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-isku.c
+++ b/drivers/hid/hid-roccat-isku.c
@@ -411,6 +411,9 @@ static int isku_raw_event(struct hid_dev
 	if (isku == NULL)
 		return 0;
 
+	if (size < sizeof(struct isku_report_button))
+		return 0;
+
 	isku_keep_values_up_to_date(isku, data);
 
 	if (isku->roccat_claimed)


