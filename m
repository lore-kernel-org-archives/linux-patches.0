Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893BA13AD22;
	Wed,  5 Feb 2025 13:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763472; cv=none; b=PAS/eF3lRtn+5N9IrdH3/2yTRzpsRak1E22XqHyCtmexEqFIY1qLjZ1srbQPwypl00OAtSqulDBag09lWceIM4KsrJIx9ROmFI5Gr61EdZEw9jmlRQBxug+EDZxLtNH+QlDSx1drnTHgMnXejDPXCy0r3NUxZbDpF5D9BZ0VY/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763472; c=relaxed/simple;
	bh=to23bMQnMcHLKexH2Ou3t9v0S9irKIu2HQ8EA8/6/4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WiTndebN1/wL2IhUMcaII/Q3Q8YYGqzzfSMFDDn9XK8yqVaTX+OyFqfrbOHZ/LVK49b1/EnJojFfawvOxwX7gGpiEGaTdpVijp/sw1KeMxc2xmf11ja4aIN0MgB8joQBb5lAaPczGaRgmat5txyc2tSyvchulzgC8zyGgFp9SBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWII33sN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWII33sN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED142C4CED1;
	Wed,  5 Feb 2025 13:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763472;
	bh=to23bMQnMcHLKexH2Ou3t9v0S9irKIu2HQ8EA8/6/4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWII33sNfdJTDYks93kpt4FZ1F7mEd4HvDeQs2zdMmlGLS9MRzIN1ipipXAhw3V7j
	 Nmgwdxn5LxcMfRZrJFwBkrLi3Vspyk28MlHJ7dO3xDh5wGGvVzTpgcChRqfW92xMdw
	 ZJtRpUe46AfOB29GJ76/5q/nWduhJF1b323bKgiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	He Lugang <helugang@uniontech.com>,
	WangYuli <wangyuli@uniontech.com>,
	=?UTF-8?q?Ulrich=20M=C3=BCller?= <ulm@gentoo.org>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/393] HID: multitouch: fix support for Goodix PID 0x01e9
Date: Wed,  5 Feb 2025 14:39:49 +0100
Message-ID: <20250205134422.971686824@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e62104e1a6038..5ad871a7d1a44 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -2072,7 +2072,7 @@ static const struct hid_device_id mt_devices[] = {
 		     I2C_DEVICE_ID_GOODIX_01E8) },
 	{ .driver_data = MT_CLS_WIN_8_FORCE_MULTI_INPUT_NSMU,
 	  HID_DEVICE(BUS_I2C, HID_GROUP_ANY, I2C_VENDOR_ID_GOODIX,
-		     I2C_DEVICE_ID_GOODIX_01E8) },
+		     I2C_DEVICE_ID_GOODIX_01E9) },
 
 	/* GoodTouch panels */
 	{ .driver_data = MT_CLS_NSMU,
-- 
2.39.5



