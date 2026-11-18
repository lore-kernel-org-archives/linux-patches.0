Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044656;
	b=YwYIhnrhRSGz67WIEKvu4pOyet6BtLkvosxd0e+fq6KRTHS3pm2uf45L96jmD4OnIddQ
	 N7C6J3RT9MsDyDU6CR74VQrvvuaoXTHpf7jgl+IMOm3X1uITh11exFYnADK6STSvw/aHl
	 K14GKz0IuwlIx5bT/YnumxgTnZLcY48ewoggHjU0uiMqvj0D7Iei+23N6aRR4C97WanxM
	 Z7o9zt6Z5PEt0fycwSzYk3tylv5snybrnBTtbX86D+6cJO9ij34V8HaxExWhnC+89Zhqg
	 bkHdnDbvsT7MYJ83SKILcnt64+E2qpZu6l4mIo1zHPDcY0cDjGJ3L3EKr4bzQC6R6LQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Laxmzjz+A1Z4rhhx68Y+TnB0p9a/45SBH6iQ87SYY2Q=;
	b=1/9bHzmLRBDUxMB/pm8Yn7N4/gsjhg5o46mkuALbbTYvDnv5FKm5O/I4X1rj/qZJi8j0
	 dE8KWgz2mIm7G/6NwsswhCYx4sI1JLcvQitJ0IkgDprlFqxysNK8P66D/QsfYydh+9bgV
	 gnbe0/yM2BvhMwSaPv+SOSMZHcaKkcdpwK35X25w/GbDdVBIVjjtWvjF170kTZsc3TyZ5
	 XCxWDG2EaiZ7ODpevYBDnt07gOs1fX9KMOdZo20FtJZKZp0O7ppBuGFfRrWsVfjOu9FWx
	 Wu0HB4ZCPZJ+kDHW+ApH0j9VlD972RYxOf6iqfktlwyyd5p5RMIgoa0oTxwu3R1WcVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6r74quN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62368606A320;
	Wed, 18 Nov 2026 23:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z6r74quN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C0C1F000C4;
	Wed, 18 Nov 2026 23:30:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044656;
	bh=Laxmzjz+A1Z4rhhx68Y+TnB0p9a/45SBH6iQ87SYY2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z6r74quNUbE8szJ3sdU8UkkXYKv0HfwWlMNi68pux2trqW5G7xfBjCYqIVHj75Z9v
	 h4vZ442pFM5VBDiLlbHXcvR9ocTle9SNpxOxksO4jM16MC3HEgfmOaSFQjKH7EI5df
	 NjFbQmqcLTu33K9c83fCxhw8D4CowvtkuKV0BOPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 0645/2857] HID: roccat: kovaplus: reject short button reports
Date: Wed, 18 Nov 2026 15:27:59 +0100
Message-ID: <20261118150224.758760195@linuxfoundation.org>
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

commit e95917a606f486e46f5136fc1b72190742a091d6 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to helpers which inspect data[0] and read a
complete struct kovaplus_mouse_report_button for button reports.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the button report before calling either helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 0e70f97f257e ("HID: roccat: Add support for Kova[+] mouse")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-kovaplus.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -611,6 +611,9 @@ static int kovaplus_raw_event(struct hid
 	if (kovaplus == NULL)
 		return 0;
 
+	if (size < sizeof(struct kovaplus_mouse_report_button))
+		return 0;
+
 	kovaplus_keep_values_up_to_date(kovaplus, data);
 
 	if (kovaplus->roccat_claimed)


