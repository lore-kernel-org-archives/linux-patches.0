Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704609;
	b=y8w3FbmFSltxOIJg/XaSAL47dzHoa66dUcnB2oOlW3rAUw7/vHczzWpamzMkkoAkiV4H
	 YwEUkUkmTAvt4Tc/h1oARTIz/LVFjQnUUh703MBISa4R8LtRZUCynlVK6klY5BJkC5Puw
	 F3yb8ICTQGiBq3+NeHEvL63PQy7hZ+BV61YwV5whqLlSlgQ+bmC+t3gXYWwb8/deZ94AI
	 cxIi4x2vc0J5xed7T+0d9vaJG0qTGWVSAB61Uh+y/UoKyGNUVXHtsRI9qCLw04Eajr88H
	 /uYMlGXbgUdcjZDi1/aAJ5ATV2TX9wf0KovHYoBeRn2C6dA2AOyWgaN9UCgYdByRlRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lqVX1gXwQ2ogIcacsFBnHTJVJU0IZwme869vN656k1Y=;
	b=1HpcSK2/WdO81b8o2oeaU4lJmTCVrdNWRNrw2OQL86BiR3kyLR520y27G3CAr5BHu6SE
	 qPyLevTd5CuC0mzpaGpCr3jwHErbeEDwLvxs6sxA/DLZAJf+pGLqaRMJXt23nalTed7Fs
	 iG+W0FQ+UhmqVHcf9xQEfYMGIOBK0WFCkS+8b3+zcsDYiPRMX3+BxBBfOnD8vvZjqX5bZ
	 IfNFa+MuqRxwPtXNDEYsLQUqvg79+8TEUiNOn8wdoS5usfLlgOhGOERckfsPzBWG4aE4b
	 Utli0iVHJOsZYbz1KSdQdK6tvDecQo3+iqJeQrTtoXrkHJgyzJhgR/1WjR6gwAv+oaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DsR4TT7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19307606A31C;
	Thu, 26 Nov 2026 14:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DsR4TT7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CA11F000C6;
	Thu, 26 Nov 2026 14:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704609;
	bh=lqVX1gXwQ2ogIcacsFBnHTJVJU0IZwme869vN656k1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsR4TT7wZKgEfa/EwGlUNyOD+t3CCt9uVNyAAQ5v1Xt4VksY2rZ/lCxf4xW5EZayO
	 9Yukhkb+fppkQ/o5iq/h11phBJDGm8zg2Vkbtk8pcB/MqJqQRgtz9xBTku0MT7Q6Y7
	 QEzvYEmY5wL6qrx4Z5Zc6Ka4kQI86baSKn2O9Rps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 181/265] s390/dasd: Dont trust userspace-supplied result field in format check
Date: Thu, 26 Nov 2026 15:38:31 +0100
Message-ID: <20261126143617.866294290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -312,7 +312,9 @@ static int dasd_ioctl_check_format(struc
 		goto out_err;
 	}
 
-	if (copy_from_user(&cdata, argp, sizeof(cdata))) {
+	/* copy only input fields, clear the rest */
+	memset(&cdata, 0, sizeof(cdata));
+	if (copy_from_user(&cdata.expect, argp, sizeof(cdata.expect))) {
 		rc = -EFAULT;
 		goto out_err;
 	}


