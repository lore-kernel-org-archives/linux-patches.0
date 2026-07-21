Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C47B4746CF;
	Tue, 21 Jul 2026 21:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667845; cv=none; b=qnrGRBbZIbyFmkFQVZhLO7w0ZGbTNeeDSQF1uQdLJOIOvLzJJMg19K5Q2OYF7QscV6Uxcj2aCRXEmQxGQp33hDIVv9AF1+yB0i1qMvBMaOlY5b9TIulbTtfx5ep7MW/N9y+8LvdTrSVGTA1o5iwpoDUd5X8m1bBTyzbaFQ+VVjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667845; c=relaxed/simple;
	bh=gQ+5qGL8wbr2uLsu0Op1xVRPgPxk3jKMiDfH4lQRAW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lrqlwXASV/nyFEy7vIhb1SlPKF/IBWXbnmYnUczZCmNIJqdjdS8Hu10ksLkqq0BV2mI+iTQahLfiFVTX8HcD4G9xH019XAGCfJcUjDEIx1uZU9RTsXCtWf1sPUbnolazFo7UMx8c08EVxj7frmNf3yRqOP0CnubioGvMVB0reh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y526PABT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y526PABT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0541F00A3A;
	Tue, 21 Jul 2026 21:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667843;
	bh=ZkCD6AOq6OLeKbbXeqjnB11TOojMI/HtWfT2txrqJZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y526PABTZUSCOeZ5I3yIHSBBmbI3Qnr8OeANmFGN7W6yjgmqmmbDbK8Y87QzAvGBR
	 QCe45jPpTR3AtAiM7cwMTaP/vQQYS3L1UGJuNUz2MuDSSVyBpNRnw6RYMlyhaml5ht
	 L5+LGeg+TX8RdCS7UETNREbYdkzUxRondPICrqaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1214/1266] treewide: Switch/rename to timer_delete[_sync]()
Date: Tue, 21 Jul 2026 17:27:31 +0200
Message-ID: <20260721152508.967421783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 8fa7292fee5c5240402371ea89ab285ec856c916 ]

timer_delete[_sync]() replaces del_timer[_sync](). Convert the whole tree
over and remove the historical wrapper inlines.

Conversion was done with coccinelle plus manual fixups where necessary.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Stable-dep-of: 75fe87e19d8a ("HID: appleir: fix UAF on pending key_up_timer in remove()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-appleir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-appleir.c
+++ b/drivers/hid/hid-appleir.c
@@ -319,7 +319,7 @@ static void appleir_remove(struct hid_de
 {
 	struct appleir *appleir = hid_get_drvdata(hid);
 	hid_hw_stop(hid);
-	del_timer_sync(&appleir->key_up_timer);
+	timer_delete_sync(&appleir->key_up_timer);
 }
 
 static const struct hid_device_id appleir_devices[] = {


