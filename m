Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044639;
	b=NipQrmxt0CixULVgcGe186KWcrpI6vGF+7v0u7xFNnXcMobStGDXvysystCfju7MoA5k
	 uO3KF0gohzA/RTiGzHCEqTLmptumh6EIxdWlCk+fOCYRyrGHA4AfqebpczC0cGsR2XbUe
	 s+epO9+WyXZ1AKf6+vLRXYXQ46q2k3EXJ/xPb7BD8dB8+yNJo9wQzbvjGoLs6PuLWgEen
	 3sr4ZVC0EFL0TLDMArlGoN2Ymo7nxzDL3qzK6pyXqDcaV/LonkvATmxwb1/XMk0ySBPeN
	 EwZGDKMipTF2DuPoCKBgvQYKF/yHSNDM2g+a0wfjc03QDuh3s+9kcP1wbctDxReoHbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eQY1xZixlBaMCeXcmT14SiR0Tx22RH+W9nKrxJotTFc=;
	b=tHmhjkhP3d8a63oz5ERbLbPtYHeE9UjdIbfawYdKj5FWbCq502oPFfUHda2zrx5Q45Dy
	 K/B6CnjaMSbKq0R03W+WUkHWjEOt4GHL85ymtm5LBJlRd2U0hXFkADwc7wDJgZeKqp1WG
	 0g6wqo04cw8ZY3iZb0ZQQ4+XCNxx+Lt5NplnVDTInYkONFA2LwpsRITox3tRJRA0C7wZa
	 pdlfjiPTLnKyhVufORLUEcx5OifW+m/2V4D35wk1r3XeApTA6fX7cKwfVP6jbdhB9NJul
	 +JiGnhDB+iFVIvA12Kulm79oYgS9v/6tZ5/2wdYcfL3G2CZJVM+QZ+/h4qJpt4JpBDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keWUDAI+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86CC606A33F;
	Wed, 18 Nov 2026 23:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keWUDAI+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F631F000C6;
	Wed, 18 Nov 2026 23:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044639;
	bh=eQY1xZixlBaMCeXcmT14SiR0Tx22RH+W9nKrxJotTFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keWUDAI+iXTnBvP4Ir+her5n0Envxfj1YW9dnPScgstsKi4C3XpFZoFn8tzXdVQXr
	 xtZ/BUcvqAssd+KOjsS0Zw27E+rNo8Npltn2NWVc/J3yLGiuCwDHZSo0JobxJSPJIZ
	 m5vfaN2ACEC/8H2mhLeKh6zaM3PRjAMguLqaRWcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0640/2857] HID: pxrc: reject short input reports
Date: Wed, 18 Nov 2026 15:27:54 +0100
Message-ID: <20261118150224.565097518@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

commit 0deb22da5a8c6663c3e071f55fd7d7e3189f5517 upstream.

The HID core invokes raw_event callbacks before validating the report
length.  pxrc_raw_event() reads byte seven and writes bytes one and seven
without checking that the report contains those bytes.

A one-byte input report reproduced the first invalid access under KASAN:

  BUG: KASAN: slab-out-of-bounds in pxrc_raw_event+0x161/0x260
  Read of size 1 by task hidtrigger/90
  Call Trace:
   pxrc_raw_event+0x161/0x260
   kasan_report+0x139/0x170

Require all eight bytes before reading or rewriting the report.

Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw_event length validation to hid-asus.

Fixes: acc3e34613da ("HID: Add driver for PhoenixRC Flight Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-pxrc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-pxrc.c b/drivers/hid/hid-pxrc.c
index 71fe0c06ddcd..e3755d8b85c2 100644
--- a/drivers/hid/hid-pxrc.c
+++ b/drivers/hid/hid-pxrc.c
@@ -55,6 +55,9 @@ static int pxrc_raw_event(struct hid_device *hdev, struct hid_report *report,
 {
 	struct pxrc_priv *priv = hid_get_drvdata(hdev);
 
+	if (size < 8)
+		return 0;
+
 	if (priv->alternate)
 		priv->slider = data[7];
 	else
-- 
2.56.0



