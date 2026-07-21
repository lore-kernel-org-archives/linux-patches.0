Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E163C4B93;
	Tue, 21 Jul 2026 21:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670670; cv=none; b=mgEcCl/IcOwkTeGIXdsVgSj9octNKLLhWMmqICzIbLR3UOYV0lzrM8xeHMJt+pYjalDVxKkzeueIVoFGRZyTiKgMVubCbswXa/RLfDNmR6V9A3F3/TSRMtKi9R1DmVIBVWMR2tJzvhfuybuaQ4b/gECa6RNKFgyjPasl0+e9y0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670670; c=relaxed/simple;
	bh=IPN/5fTg6hfpIF2vSYLgiiYX6cnqMpD2e2E1DXUwP6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTDVzqyVReQKM5/9jIQMbWNVf56+cB9rahqJzNc8qiGeUUjag3QB/6AsZkvOR9v3ixU0v8SNbBBHCE5Oi5RoLs/lqG76JzR4Fj/gpQLJluySJR3pQZm6Mg+2tPc6WtwoWrpkPrpdSiuu/nHyruOQtDxwbxCzUTydpj56NdacDWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYKYMcdZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYKYMcdZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5051F000E9;
	Tue, 21 Jul 2026 21:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670669;
	bh=8Wat5qfIbqcHXTS9/P8CBszw/Oiz7KzEL84BDJqBpn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oYKYMcdZZR1mpt0b70dMHTgBTnuw9P1cEu1/8ERd7VsmxuOm76FS8OdbZCWW7C1SE
	 O+2jOkRJy86clgb/mI5KKhyYMW5ssrnY6nJF1cgbK/BCy7yLQxdgyYAv0/tDztXniu
	 aUHh3gxaWNXeALugJUyAaEYXArsDNfDHFEL3L7n8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1018/1067] treewide: Switch/rename to timer_delete[_sync]()
Date: Tue, 21 Jul 2026 17:26:59 +0200
Message-ID: <20260721152447.344051930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


