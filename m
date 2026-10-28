Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214442;
	b=NdIKEJ1sGJoCpun3qwh1OUYMkJ43hQT/J+jWmkBPUgionNs9GmI5ISB3ucsl2mxGQ6FJ
	 9xOOsXUqhFWOM5r5CQFBaP5YHJuCwntFZ6Dq1dtj2oOEvEq+dv+JnnTrCZL+lOhWsLpJq
	 0kGX7SQwkZ38dtYZwjMcTvuwd1eNBMtH52Yjf7w8XSq1Z6N1LbHhiIaIlCSlPfJ6EoS/Q
	 OXtGZy2ts3afl09hr37ck0ReKq5LG39EdPulAGCCNf9HtsBGL9bSGF82Xnmrd858WnqJP
	 AzEIomjv1mCbWhalty+tIxacrTxArgx3yb2BQWUJi0eVyauVZB30mznfO5f+77IOxjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LBS9fDaEnAaViYjU0Ol9HwRS5D/wJVXU3uEj5X/9M9g=;
	b=1JU4WMTaWKrcYoEs3oMZx0omt4fRmpWzZBq8kbM9I6q47cyQ/k2rMV4adn9dwdqK/hKi
	 0fDJ9N3FJQYTJcaIA+77JCn8rq8XhJohTkDCOYbtxGgR8TmksYb02ykSMjTW2lrMBqHn2
	 rC3q+A+WNcQuJ9vIGsKB9TdlNFUmeBT0Nny624jk4wV6y6YnuO8v1FsH3og3VfTw+7odx
	 XuPZq68vM+1BMdWD+L3wMQjEUI8J+PIASmB2S7GIWXgDv4ZAwT1+FFGfDBovEWl11j1Zz
	 dpFdxcpyrapNavm9jgCqVo1mqAcAGV0mkL2qeK8pIpwoOC8cpYQoA0Hs44Ho7BOBHtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZyScV1W0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B4B606A31E;
	Wed, 28 Oct 2026 19:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZyScV1W0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75B4E1F01825;
	Wed, 28 Oct 2026 19:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214442;
	bh=LBS9fDaEnAaViYjU0Ol9HwRS5D/wJVXU3uEj5X/9M9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZyScV1W07Zhr44oY5XJMKkZPqwB6DKdE/gsoN+91q9fGRGE5H1QJJvUQpx3ehgtWj
	 b9thSfRSAizgbX61QrUQf0voKKbKqHZhsQY38d7K9J1+xFadk8J1gnWlzq55g0OSKW
	 SU1KkQG5SXwShnZt1IM0Gg0K5a68QAN4Tqx+x1KQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Daniel J. Ogorchock" <djogorchock@gmail.com>,
	Silvan Jegen <s.jegen@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0807/1887] HID: nintendo: avoid bluetooth suspend/resume stalls
Date: Wed, 28 Oct 2026 17:48:23 +0100
Message-ID: <20261028170517.793340282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Daniel J. Ogorchock <djogorchock@gmail.com>

[ Upstream commit 4a0381080397e77792a5168069f174d3e56175ff ]

Ensure we don't stall or panic the kernel when using bluetooth-connected
controllers. This was reported as an issue on android devices using
kernel 6.6 due to the resume hook which had been added for usb joycons.

First, set a new state value to JOYCON_CTLR_STATE_SUSPENDED in a
newly-added nintendo_hid_suspend. This makes sure we will not stall out
the kernel waiting for input reports during led classdev suspend. The
stalls could happen if connectivity is unreliable or lost to the
controller prior to suspend.

Second, since we lose connectivity during suspend, do not try
joycon_init() for bluetooth controllers in the nintendo_hid_resume path.

Tested via multiple suspend/resume flows when using the controller both
in USB and bluetooth modes.

Signed-off-by: Daniel J. Ogorchock <djogorchock@gmail.com>
Reviewed-by: Silvan Jegen <s.jegen@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nintendo.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-nintendo.c b/drivers/hid/hid-nintendo.c
index 44edc50be6e56..7a1bb4c876659 100644
--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -301,6 +301,7 @@ enum joycon_ctlr_state {
 	JOYCON_CTLR_STATE_INIT,
 	JOYCON_CTLR_STATE_READ,
 	JOYCON_CTLR_STATE_REMOVED,
+	JOYCON_CTLR_STATE_SUSPENDED,
 };
 
 /* Controller type received as part of device info */
@@ -2341,14 +2342,46 @@ static void nintendo_hid_remove(struct hid_device *hdev)
 
 static int nintendo_hid_resume(struct hid_device *hdev)
 {
-	int ret = joycon_init(hdev);
+	struct joycon_ctlr *ctlr = hid_get_drvdata(hdev);
+	int ret;
+
+	hid_dbg(hdev, "resume\n");
+	if (hdev->bus != BUS_USB) {
+		hid_dbg(hdev, "no-op resume for bt ctlr\n");
+		ctlr->ctlr_state = JOYCON_CTLR_STATE_READ;
+		return 0;
+	}
 
+	ret = joycon_init(hdev);
 	if (ret)
-		hid_err(hdev, "Failed to restore controller after resume");
+		hid_err(hdev,
+			"Failed to restore controller after resume: %d\n",
+			ret);
+	else
+		ctlr->ctlr_state = JOYCON_CTLR_STATE_READ;
 
 	return ret;
 }
 
+static int nintendo_hid_suspend(struct hid_device *hdev, pm_message_t message)
+{
+	struct joycon_ctlr *ctlr = hid_get_drvdata(hdev);
+
+	hid_dbg(hdev, "suspend: %d\n", message.event);
+	/*
+	 * Avoid any blocking loops in suspend/resume transitions.
+	 *
+	 * joycon_enforce_subcmd_rate() can result in repeated retries if for
+	 * whatever reason the controller stops providing input reports.
+	 *
+	 * This has been observed with bluetooth controllers which lose
+	 * connectivity prior to suspend (but not long enough to result in
+	 * complete disconnection).
+	 */
+	ctlr->ctlr_state = JOYCON_CTLR_STATE_SUSPENDED;
+	return 0;
+}
+
 #endif
 
 static const struct hid_device_id nintendo_hid_devices[] = {
@@ -2375,6 +2408,7 @@ static struct hid_driver nintendo_hid_driver = {
 
 #ifdef CONFIG_PM
 	.resume		= nintendo_hid_resume,
+	.suspend	= nintendo_hid_suspend,
 #endif
 };
 module_hid_driver(nintendo_hid_driver);
-- 
2.53.0



