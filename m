Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF2CF22E415;
	Mon, 10 Mar 2025 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628815; cv=none; b=TeqU/xVAiuAtTiOVLt6HVg/I6sKFofiqbb9hwB3eB43uAEsC59bSWEEcNWou2OzREY1/KypLCt88cF95DX1knIIEgYNqwKuYjEfnuTHfsjcGNFYdUvZdaAf/uDNOugx3KrigOWbQT450KZqnlPllsdOYpEDKe9Ra6UBrOWdrbk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628815; c=relaxed/simple;
	bh=YvYVRT44lkieXm/OZsXnrlComOvxWdpu6t8QncfDKus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iSWKcIA1c+Gjyk5rlQh467zX7GvZEh8+HdWCOQx1lDp+u6FxsKCwbL836W6+oCKW9tixEEJ0d4xHEsYSumLUsvBdYBJSS+azaAv5Ag2rofWYWJTaZ5IXelmv3GO6M0xx5U1kSvuFK5mM+nLIw7vb55BbFdx5BoUEZEJmvRW059c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s593MNDe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s593MNDe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E56C4CEE5;
	Mon, 10 Mar 2025 17:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628815;
	bh=YvYVRT44lkieXm/OZsXnrlComOvxWdpu6t8QncfDKus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s593MNDefPOE8VTw0wj6YwbvzabrTYjQOncnKrdwfdwHhU+xbTFPfogkPhRHznXIK
	 MyKkJN65STRDgO9bC56sPMrGm/HgGXaVOWMLFzD24zJqmh5t7hX39w2ZX2PKpvHjiT
	 vK2BW8ibfbZMBtE/CVOFbxzjFYCugIeKEpddR+eU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Lugang <helugang@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	=?UTF-8?q?Ulrich=20M=C3=BCller?= <ulm@gentoo.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/620] HID: multitouch: fix support for Goodix PID 0x01e9
Date: Mon, 10 Mar 2025 17:58:13 +0100
Message-ID: <20250310170547.436097872@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 8ade5e05bd094485ce370fad66a6a3fb6f50bfbc ]

Commit c8000deb68365b ("HID: multitouch: Add support for GT7868Q") added
support for 0x01e8 and 0x01e9, but the mt_device[] entries were added
twice for 0x01e8 and there was none added for 0x01e9. Fix that.

Fixes: c8000deb68365b ("HID: multitouch: Add support for GT7868Q")
Reported-by: He Lugang <helugang@uniontech.com>
Reported-by: WangYuli <wangyuli@uniontech.com>
Reported-by: Ulrich Müller <ulm@gentoo.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-multitouch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 57e4ff1ab275d..df7b620fa23ee 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2070,7 +2070,7 @@ static const struct hid_device_id mt_devices[] = {
 		     I2C_DEVICE_ID_GOODIX_01E8) },
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
-		     I2C_DEVICE_ID_GOODIX_01E8) },
+		     I2C_DEVICE_ID_GOODIX_01E9) },
 
 	/* GoodTouch panels */
 	{ .driver_data = MT_CLS_NSMU,
-- 
2.39.5



