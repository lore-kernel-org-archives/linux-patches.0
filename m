Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623262;
	b=zxnwicQu9CdIw8qI/WGqQcwLe8Q513hqf6Z+RkEgBC5Ddj1sVipm5RhCu7aF958zrAY/
	 UgFlJng0W5Y9F9O+Ucj3Tshk+5CRbn3w7cRt4aVOoEXy3f07zcvP3XyQl3vXLbagfF4P3
	 XnJFq4bTwuQlhEynhZDf3UYqtB0OWZfRYTn+XIrpiF+ZdIph7LhEWtvLcHnpzEcb5w5VI
	 KQA9UW7OD4YpLTmXWVdRDDlt9bP9xnbpwGlweMk5rKqxyfYguegqivdOAKkXyjiUWiPiP
	 5PMYU5DQUL13Ngd98YVl418ZEWnoRPu+B7qdcicrrczzs9nEBE2e2vo7WPe//QSNoow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qrgrAVlqAI03AUSyS0q9ifbfCqxOK5hb4d7WMBTPkl0=;
	b=wbYmjnmME3/XFyeg1yoC8G8A1WL2y9e59TTZu3si4h6bGl0+Bne6pdagdTL6paeDQRe0
	 JOHr+3wp73RhAH0JfwGKwu16fVdU3x1x3IdC8/hqOrlIKQDbhrlD16dS/dKG7pVLqQgMT
	 6ZqFeArCoQtYoidJt+L+Z8oK/cAZp6UaQz2hyUGSuNyjL9Bf2+7LjX7WiuzoKl/zbhNfG
	 LUrwvAn5t0Xc33RzyFFo0IjVgs4E/kBnUW5Jbf1LnRsNxh4ysDkgolQwwySg3Sj9sd3ac
	 vF/Fmj7b9Rr3fuSzkwotTc+eeGncRJW0VhEguB1fvsH9JrklKIbBojbeRTLoE6IQ0dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7SNgOY5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8554B606A330;
	Wed, 25 Nov 2026 16:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d7SNgOY5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B087A1F000F2;
	Wed, 25 Nov 2026 16:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623262;
	bh=qrgrAVlqAI03AUSyS0q9ifbfCqxOK5hb4d7WMBTPkl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d7SNgOY5fTR+F5HGaEHqCrhQjI9E6njPZHkPrk6DwBEceZRpqrEdCdOsVCT6vmJQ/
	 9f6Vc9LnvHgtHnLS9SvEFAW6weQNCF7RJbFk/bqIDage1ml4ErWOeOuh9FR18igGkH
	 zGcUYMrmnj6cn6VuA55LOA+ynymOPqsTUGxGBZA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 785/990] s390/dasd: Dont trust userspace-supplied result field in format check
Date: Wed, 25 Nov 2026 15:35:52 +0100
Message-ID: <20261125143840.434408012@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit 7cc2dda4f7aaf596c1796184649007151ff98f8d upstream.

BIODASDCHECKFMT used to copy the entire format_check_t struct from
userspace, including the result/unit/rec/num_records/blksize/
key_length fields that are output fields only.
dasd_eckd_format_evaluate_tracks() relies on cdata->result being zero
to decide whether to apply an index correction (i--/pos--) after a
successful check. A caller that pre-sets result to a non-zero value
can suppress that correction, leaving pos advanced past the last valid
entry; the (partially out-of-bounds) fmt_buffer[pos] fields are then
copied back to userspace, leaking heap contents.

Only expect is an Input field; copy just that member in and zero
the rest of cdata.

Fixes: 8fd575200db5 ("s390/dasd: Add new ioctl BIODASDCHECKFMT")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260722103704.1709668-1-sth@linux.ibm.com
Cc: stable@vger.kernel.org #4.7
Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20261112102608.1057852-5-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_ioctl.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -304,7 +304,9 @@ static int dasd_ioctl_check_format(struc
 		goto out_err;
 	}
 
-	if (copy_from_user(&cdata, argp, sizeof(cdata))) {
+	/* copy only input fields, clear the rest */
+	memset(&cdata, 0, sizeof(cdata));
+	if (copy_from_user(&cdata.expect, argp, sizeof(cdata.expect))) {
 		rc = -EFAULT;
 		goto out_err;
 	}


