Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0441B432E9C;
	Tue, 21 Jul 2026 20:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664428; cv=none; b=Xph9EmrCRf7yMrMwqWjNoFSmBmig4jZcWhRkCbeCGZr2jMyyhaUFkd4/uHyNCXkUZgFidGaFk4KOnvcNLebqYbcPdlvYrILobFPP7T3tT4SqsmX6EBxeS40vye1PGIuMLYEzlMmx3TJyeph67WVe5Q6HOG1HVu25urCxg2ElYZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664428; c=relaxed/simple;
	bh=5NIKfa49MFxhwp5Kfc005Y6e3fh26Y1vFGBDKwJWw1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1rb6tIUW0GZ9uRhRxklduf+RoSadiDeAb2uDb6u0p/XyoXLY6z9JLjxeSf2t2mSfgjxsGrtB/yihJxxT6QdsIEbIaw2qkjMFmVnmzU0DFw/3DnDi6nzPiRcAimEwt8OgAE5VTcgZjcMSucudvy0hTsiin5jRtuFedSz6BPHMjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtBK4w1S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtBK4w1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E421F000E9;
	Tue, 21 Jul 2026 20:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664426;
	bh=VVQB8ZIryDNTpllyvx2R75RuKp8E0gg5pMJzmIUvgew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JtBK4w1SNBRvywidFajsPX27pdUW/fNl5QrUDW3zBScNtPsXtpnYCQUepNwhYCgwT
	 rGaWrN69tI04CQ2E7qYC5QmZ7rjRNWIfk8FzRktrEInbmLHLDEAr/rFhMgjg71wHtY
	 A+vhjOQJdPXnQuowtvSb4JILk4x8G8frR5493iyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1194/1276] treewide: Switch/rename to timer_delete[_sync]()
Date: Tue, 21 Jul 2026 17:27:17 +0200
Message-ID: <20260721152512.771938241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


