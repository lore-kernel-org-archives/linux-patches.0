Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044659;
	b=mhui6GN+mqlGfgP0sLtsd3lUsUtXa8+v2y0HuC2ZHG/X9kOWZQ7mZbbhsI0FKSKRvHMB
	 AgOgQcyR6SZaqRv+tbYJ+nRiHVpf0UNvOatU1/fbwu3CCx+WC2v/LFudG8LCV4RkCLPgY
	 o89smdqm5rty4zX0FQON+AnlY38xljqHCY3qQXnP6NbIlaMoNW33T8In0yPPljvx2tYOk
	 yys8olJ7SDDuAxpbsnLtKcWaa/fdEjXkPGWB2PeQlgfa8e6HxB2S5EN1zZQeGlK3h7W+o
	 Zh4FTrgOr6adTmIhC3uoThtCP3pBkvNOWb6LcBf4rj1b5L1t4xmF43eaTCx7uV5+QPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HPf6fyNI9RPau4Due9/GZ7eLY4DOAWNauYnC0YOZm2o=;
	b=2hYdXObgBGv0zZieqNBeC/kYzAtxZO6v/ku3D8I1Jzl9eMSa2wqsBvHgE6MOYX1b30KE
	 4Zdixb9n+tYbCia8163MxWA+nW6kXEBX8w7C1DtyUvnTYm+tdbwqaKh3ExF1mEJCzi5LM
	 9UGrU9fo2aERKiSZy2FLMH1tksC8LZ16L/fCL7Vxzh7mkGvsgD5X6A4MaYZeyRz34kdWG
	 b01zfKHDDBbon+m+bAJlkTaYyqOmdxMsY5aryrVL5wxNxi6aXEZnv2beUZCoye2Nh/o+Z
	 RNiyoI98m54AtMNmn8/g4liNTcEHOf6cDSyVHZ4HgQsHfG3qAYLyb3L9Zdqemt3nNtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXmvo4qb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343CF606A31C;
	Wed, 18 Nov 2026 23:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXmvo4qb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 877351F000C4;
	Wed, 18 Nov 2026 23:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044659;
	bh=HPf6fyNI9RPau4Due9/GZ7eLY4DOAWNauYnC0YOZm2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXmvo4qb6BjC703ejB/movIDRgEFNt5m1mcBiQPgs5IPEa+DNk8lv43bo3INxYGjh
	 +CM575Mf3oLaR91v+Ga0BVVe01CaTicl1EcE++YqtXhV0vk2XdKigILOXuKkuVj+lY
	 mhTypTc5BGAYCnleIj7KloVv6+1al1f8T01JR4KE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 0646/2857] HID: roccat: pyra: reject short button reports
Date: Wed, 18 Nov 2026 15:28:00 +0100
Message-ID: <20261118150224.803001887@linuxfoundation.org>
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

commit 493268f459bb6aeeecbc77f2204c11ad74d05213 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct pyra_mouse_event_button for button reports.  A truncated
report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: cb7cf3da0daa ("HID: roccat: add driver for Roccat Pyra mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-pyra.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -554,6 +554,9 @@ static int pyra_raw_event(struct hid_dev
 	if (pyra == NULL)
 		return 0;
 
+	if (size < sizeof(struct pyra_mouse_event_button))
+		return 0;
+
 	pyra_keep_values_up_to_date(pyra, data);
 
 	if (pyra->roccat_claimed)


