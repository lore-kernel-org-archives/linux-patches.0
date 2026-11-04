Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831865;
	b=JEH9W5fL5SeGFBO/xAhh6wqwPBr8wGdKsZDAkxFayfpfi+uaT1Goz6lkfCPvU4pUqm7w
	 CTroxSms337/Wg3o6mAjVjqpUaLewMFN6ctF2W0oRR3tmtvNjV/72F5WZbeZNIKKSeY0j
	 n+0cVlL7plMspokLn7ZQu+WCZBdxXPUN3A9QPw3+kuHr+1xjzAQmBEGjT1rzrt23UiSyA
	 DuiEVDVLul3CV3r4wB5crDfoKPa96EatYtPgvC38S536xorhF2FnQM6x3Mer2ZF/yjFTf
	 7O6O2Ibp+kKuhl/tgGDGWEmW6AcmMuMaT3V/iWXPi9anXp9m/x/VYPARCfuHpHKUf/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831865;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z0IduZ8Tt3Wo4jtoXooz1WVxULzr8ZqJ3Al0vUuU/PA=;
	b=5XAQS6G6DtPtqrIkJUR71rLLsSRp2Oqg3fMZMeexUPrvK+aCuJl84T8T3rJyHVVq8+4T
	 mYiLme22vosn869Rha4bpSX999tnI5s/kJ8En/kkLjUF3C1O2KScwdBYaBsKDqo1oj/ON
	 hXbp+Hd2tm4qfLgNr/iewtTjDrlk7YTiLTEOoXAXKNSE5mjjkyvbR8ex75cpRTM+j3JYh
	 fiYGpJDqyt1qx+LK6X8+WFtyIASZydHgtB1DwzdPFWJgFHN7u2241pRD47Ly+wrg9qnog
	 91BoYd7FcyAiUrAG5GzBgj3C5VqkwWGUiy49E9AR/tiriPEnWC6jfFFErgn0Ryfu7AQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqjotpW+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB49606AB30;
	Wed,  4 Nov 2026 22:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IqjotpW+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EAA1F000C1;
	Wed,  4 Nov 2026 22:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831864;
	bh=z0IduZ8Tt3Wo4jtoXooz1WVxULzr8ZqJ3Al0vUuU/PA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IqjotpW+b9qGF5oihqGk1Y5/VSOToJNANEnjlSOvFeDe+MJPs5QuPc0Yr4WVVmZia
	 WD097qBipX3KI8N4HsQz6NxJoAsmepSuapOwaXqycHOE4NLaj/Smr83SzFfMCcvWHI
	 a3JhfLr1fEq8aX732F0fuFB3gw7nJzLBi51lGd7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.18 0962/1005] HID: roccat: kovaplus: reject short button reports
Date: Wed,  4 Nov 2026 16:11:35 -0500
Message-ID: <20261104211110.023669633@linuxfoundation.org>
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


