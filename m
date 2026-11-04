Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829183;
	b=M1g8WtTlt10qGx0GRt2te6jqT9sF7kIOkg6+lYdYk6sYs6GvS5qgcB2UhE8bu59cvmF/
	 XjU7c8+DJlmEYL/MueTM54m9+4gMS0PDGKZXjbGuTqmXKsRmD5Fy/OVIup2vsBEaoyHGe
	 jjH988hvEK7sKdAiIy0e20iAZ6aXLQv/yDnK20/aMoX68iYjoqL9w/7FqkmqC9fHTSi0a
	 dt0frhGKXZ/1emO1XrH46dBN1H90ryZyt6ZucCrk1OEAHOSU6Z5sH83y9z6tVFjoJpawF
	 LhdGmKpJbf/wjqJk8RvC/qf4ETkdfnXYPyQI1erSgrHwjCv01pTT40I7XQiR9GwF8rw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aKyonGnIke5DszEkXa3pbohOKVrGW8Ebzd49HULNBCA=;
	b=sFennjODV6kJSRzxvrT7VXKId/kelKlssTZ0yhNJMcwCO9OwYWgmeViTsnTGgUV7n7F1
	 lYlG+kP6XgZKKmXL/zBLHHAGce9kwD9OMb9MH5F3PTnzQ36fH1toqM/Epa6aa1jOjWsp3
	 kNNVBolcKV/UAqgRS7payvL5e3GDUzKTfTynpd1Hx+JOS40QkmnaNub+IEtdV4KMYMSpf
	 0YWtqcg+UQL/bd/VVoFGcZBmbLzhzSZv3G2h7/qc3BdmWi8Sbu15nQpCDlsiYVonpYOiH
	 akrm7Ur1imJzQQabM//FVTt4DQIbu8kV56Xh+OXVWcFBVY8NwLuZLJ9K17SP+xX71tA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nS72Cj+D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA392606D806;
	Wed,  4 Nov 2026 21:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nS72Cj+D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 460801F000C1;
	Wed,  4 Nov 2026 21:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829182;
	bh=aKyonGnIke5DszEkXa3pbohOKVrGW8Ebzd49HULNBCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nS72Cj+Df4LVBFx6oLXCKELNgKqCV3xl/z/iSIauh7tWARiGV6vT/YwCCPbesqFnj
	 mPN9rDIWf0UTZ6EPMOznaPJIZpLDpxsTfk1Y32myYRG9+jUTKp4w/trqVKJSOHmIUt
	 3OS1c8DAAMvsJDItGVhfZIbE5nQd3k5/X+DHPvhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.3 498/547] HID: pxrc: reject short input reports
Date: Wed,  4 Nov 2026 16:11:22 -0500
Message-ID: <20261104211052.528988519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


