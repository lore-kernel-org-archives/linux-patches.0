Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048110;
	b=NMDe4ENevymaNZLcNVqgXuXXcDwXSlqnnNkFqGfZjI1RmXK0QhZ6UAs0yeEMhPryyovb
	 r3pVsR7dvAN0UwpohpQrBfo2VPrkm9fxz3Ng4qyLz4nMeKN6xDcgGjkFwlJCAx+PvT2VI
	 upityL9/883Hr2ZwEjvZPbv8gmOUUg4cjK6v/xVohBKwVEZy8OD7zYy9wgNHQIDTejym5
	 YkgT7mZza9ukES6Xmv+ofRt2ZQslskwu6+E5Y57bBti55kMUSDuLT8cSd7eAzDgJjXcvU
	 fr2AtdBE4HT1EZlW2R82OSjae6d929fYl55AQ+ZZHliD7c4TYt5HLWKG+nIRSA2x5IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z6QtwPKWT/M2dm91Fk8ftgVdmallI19Jx3jols1Q+6M=;
	b=RYWavf3J6HlwDeUGEDnE9Q0VkZzyRLaEwf8cw2PFtdS7pCETTKU0P16drGSFTKiwBB3Q
	 DFlEQ+XNkHvVPSR1Eg7y5mxGqhHogWVL/g/+qN1PWKB1ng+TLza0ydBYUrsLAMb48gtw8
	 8cUBpqvZweroJFJp8H2FAOsYKlG69afINnvbQyz1QAJTmVPTd8LYPWBgQv3H4YhCaywqz
	 xMRxs8JET1XpdkI4UGShTB6b8ioxpw9buI+7dujtiVHdXenDswQilD21WCoPfFUt+RJzp
	 Mp8vNpMgunoyXbY3ZIQgrpd0dMK0dJFyw8I5d88pZHKmT8HSQV/Beayn/yd4JK35ohQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUwEEedN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE10606A31C;
	Thu, 19 Nov 2026 00:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mUwEEedN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F631F000C4;
	Thu, 19 Nov 2026 00:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048110;
	bh=z6QtwPKWT/M2dm91Fk8ftgVdmallI19Jx3jols1Q+6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mUwEEedNhU3W/Z1ryBXtlaHPYy0BUIzVcpuqMEc2nzQX9IkKfQvHPjEI9P4INBl4g
	 mKL3uTlabqTcZlYm864hyYbkRoiM6XvGTWDDSvGwHGWsyW0A01fGDSgTXIC0YsgoYl
	 OwEnPhJDfCIXELyJCmUfJpAEpInKgQkfF48mrVpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com,
	Keisuke Tsukuda <tkdkei@outlook.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1878/2857] usb: gadget: composite: avoid warning on aborted delayed status
Date: Wed, 18 Nov 2026 15:48:32 +0100
Message-ID: <20261118150308.851313318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keisuke Tsukuda <catnyaaan@outlook.com>

[ Upstream commit 048884b782b137229399b9f727b6437d9b4f1071 ]

A SET_CONFIGURATION request that disables the current configuration, or a
disconnect, can abort a control transfer whose status stage was delayed by
a function driver. The asynchronous function work can nevertheless finish
later and call usb_composite_setup_continue() after reset_config() has
cleared delayed_status.

This is an expected consequence of aborting the old control transfer, and
does not require a kernel warning. Keep the diagnostic available under
dynamic debug and ignore the obsolete completion as before.

Fixes: 2bac51a1827a ("usb: gadget: composite: reset delayed_status on reset_config")
Reported-by: syzbot+a83a5a1ba9ff57935171@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a83a5a1ba9ff57935171
Signed-off-by: Keisuke Tsukuda <tkdkei@outlook.jp>
Link: https://patch.msgid.link/20260908203348.95825-2-tkdkei@outlook.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 0bca544fc7691..57d3a03a8ae9e 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2629,7 +2629,7 @@ void usb_composite_setup_continue(struct usb_composite_dev *cdev)
 	spin_lock_irqsave(&cdev->lock, flags);
 
 	if (cdev->delayed_status == 0) {
-		WARN(cdev, "%s: Unexpected call\n", __func__);
+		DBG(cdev, "%s: Ignoring obsolete call\n", __func__);
 
 	} else if (--cdev->delayed_status == 0) {
 		DBG(cdev, "%s: Completing delayed status\n", __func__);
-- 
2.53.0



