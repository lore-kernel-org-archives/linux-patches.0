Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044664;
	b=UX2hKDB1BhKeGhn7vYwyBri9Ctn6H3unwuMxBNip9b0EhIeezHkjHov7qbO20nmT6uhh
	 WITEhXLL+UKOqRjKnEPysMmmZ+2D/xXSn3E/2+QcFggGhoLJSkVEvipKLzyqIQwl06Fl3
	 w2wLC6Mukz/X4IPg5cHm8gnuDVWcORlOCRdzGthgEv2K0rH8IiNwaCMzjwfYvAIfcnvMW
	 Mcma4HMcSLIWB7mn7MvS0Zikj95m6aP2wIpvzjeBi9LpH3LwZEWrMgpeo2/LcF48SEQMn
	 xrezpNnhyN7EiLFO6xuv9uydrqviATz3LmrgVwyiIWELJvGGvZGbpxL9aL2FJBx85vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kg3xt1S02m8tyHdW4x1qZm4sOnZ+X/i50wKHaviYcOw=;
	b=4zwdcGC5VsdrE3W0yxf8o7WtEUkaUFFoH61kbR2WVJ6NyiVdzOK9D5RhlA1oW+p+yfTp
	 T8TX3AR0QCjb41OxLdMO8h/SqDJn3E48wBW+5Q86iIcaYDToUaVJMPGONDzy8xCZR3sb4
	 a4NNYpvweamyVcp/a+i6mMblpZFJLnV+95j8Sj4eli/PxBQFBob3QQ7ze6Wz90EFhWooY
	 Zjn5mamXcBQVE3Fwf2QcYOZy6PLetwQ1CwIczSixZn9jKwhj5UZ++/w6iVUErs2HWLeqB
	 izfbOGuFK+Yszyl3fYImEzk5U/gV91xaG1x/q4oveRp36jD+WLnFCSoGkR/fz/XNVDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TUccNVOS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55A3606A334;
	Wed, 18 Nov 2026 23:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TUccNVOS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267191F000C4;
	Wed, 18 Nov 2026 23:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044664;
	bh=kg3xt1S02m8tyHdW4x1qZm4sOnZ+X/i50wKHaviYcOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TUccNVOS9Y9Km7nyyEEhYsXVjqqXWeutJ57CMUsx5+z33om2GVxIGQSi+Mhy5QIZE
	 TBRFce6SeTINoq3eJfgSDiFNSoEX0gc42073UZZUZz4pe32muPXXoTWVXKc3P6d7Vy
	 7s6Q9PFIQQsf/20W7ADx0s8GkzD6lzUO3vQHB3Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Benjamin Tissoires <bentiss@kernel.org>
Subject: [PATCH 6.1 0648/2857] HID: roccat: savu: reject short special reports
Date: Wed, 18 Nov 2026 15:28:02 +0100
Message-ID: <20261118150224.880500533@linuxfoundation.org>
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

commit 76c51fdc825a0486f8d88ff896d39acec8f377b4 upstream.

The raw event callback runs before HID core validates and zero-pads the
report.  It passes the buffer to a helper which inspects data[0] and, for a
special report, reads the complete struct savu_mouse_report_special.  A
truncated report can therefore cause an out-of-bounds read.

Require enough data for the special report before calling the helper.
Commit 47669bec44fe ("HID: asus: refactor the two workqueues and init
sequence") added the same kind of raw-event length validation to hid-asus.

Fixes: 6a2a6390cf09 ("HID: roccat: add support for Roccat Savu")
Cc: stable@vger.kernel.org
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-roccat-savu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/hid/hid-roccat-savu.c
+++ b/drivers/hid/hid-roccat-savu.c
@@ -179,6 +179,9 @@ static int savu_raw_event(struct hid_dev
 	if (savu == NULL)
 		return 0;
 
+	if (size < sizeof(struct savu_mouse_report_special))
+		return 0;
+
 	if (savu->roccat_claimed)
 		savu_report_to_chrdev(savu, data);
 


