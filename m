Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035521;
	b=SRU8Pbz/npxbBaB2MnHbeHx7ZbGBtilOWR9FXCy3befQWxBl858Bkjg9zg4s8xwKDYre
	 yUCQc29sPmfZTfIcHX85MiwQP0FyC1LK8ViZDPiVXwqTwj/1PeaPOwSZ7F3v/03G90NI0
	 d9o6Adq/VcORQ+V6aHhPOn2e+NiWncSiO+uwTixNm+Z85aDAF8OS4W7NhkOJ12ExoY2Dq
	 5zcWjdI2bnx647QB71fhLUYD3W2O7WgQJx+RsXvXVF2SOmWs5FhEzpUsm6Hhm3TLLlQJ2
	 tkhVfBC95ADpeT9qJb1sWO4oaTogk3kjYBq8Yeux7dg/qvRQKPqxP4gqkBfPDOQ9qNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3knK/8FqSX6aoB/ZWJIz1lMqoC1V2RaQr0qV/wlLjos=;
	b=oOes/piIIKksWL3qvDop0fa1nNiNX/SSb0/5hgouA9O9CdGeu+8YJl7v9v/nAeU69/oU
	 vywKoAzp2edpt7Ix+9+P/IOWrRoOCn+YP1x6iWIRP1Zx30kWT9Pb3sVTtfk75+MJnqzy0
	 aLdopiNNpMbvyANk0D4fgg5CwTO/cUBeYRILWRlP/d8RKiV32SeNh+w1k7P8E/QnEUoP1
	 i0vyHfUBONABiCMG5IRKGv+3+efTvF0vpRXNi3k29/1geogiDSOrHhTlWtTIbWS3wv2Ck
	 XMXeU7S3PKBzx4QMxQimRlpaP2bG+RRCW/Py2KrnJDthBOeU0NC3mV62oWCzoTg6YRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k70uHVNk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9546E606A31C;
	Wed, 18 Nov 2026 20:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k70uHVNk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9F81F000C4;
	Wed, 18 Nov 2026 20:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035521;
	bh=3knK/8FqSX6aoB/ZWJIz1lMqoC1V2RaQr0qV/wlLjos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k70uHVNkbnebfbZNInUOUgqEy4b6SlXKt6ix37XoQW+Q3HFOIeSGTEeVB5DKgqt8h
	 DmxQW16epBqgxACZqFuMlFrHSIgkZsHemhrbC7diPaKYCKtkH566AS2XzCJeiaSVoW
	 Wm1wuQLurmtBHzYMK78t+5l8BoNrR2IoWMHoPDq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.6 0733/3318] HID: pxrc: reject short input reports
Date: Wed, 18 Nov 2026 15:22:35 +0100
Message-ID: <20261118150340.542440524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/hid/hid-pxrc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-pxrc.c
+++ b/drivers/hid/hid-pxrc.c
@@ -55,6 +55,9 @@ static int pxrc_raw_event(struct hid_dev
 {
 	struct pxrc_priv *priv = hid_get_drvdata(hdev);
 
+	if (size < 8)
+		return 0;
+
 	if (priv->alternate)
 		priv->slider = data[7];
 	else


