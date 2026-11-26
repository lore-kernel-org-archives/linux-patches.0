Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705587;
	b=3NwBw413rm9JyoPa19UgbHbQAwSTvZB2VJfVmuNpqmR4x/uV3MQUQuHXsSpuqbsK5jn+
	 Ifo8eN33TU1GjSQQhy22JekJPXw2phOOc9H4ko+3kK1c69yD5aRYJ9WkYXy79pegvVMWa
	 qYWGQXxOpZi18mjnqNQDvQaGErWdp0ERxVhaq+aFIW/j5pIKbXH56gzKOcgcHzTaFLX+m
	 Oo7qv0UFjkuBCARE4/ZU22UzJz6oOVc8INjFgkRUmBxLKEEamafkqeg+xlP0Vhywa3qgU
	 SfLN6wFlFmVWUItvtBW/FHCKTvfq/puIhk7PzLlNw6y8lAKTI83zt5Hz3adA7siZ/yg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705587;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gNkL7RWAOyYWnC5q8pin6qaEA0PntVfzMzkrT0jaNFQ=;
	b=EZ9UjQMC6mQsP5UbiY+xTJhMREjn9APjmUu3ZSTAqyw99ECxDUDWbFamLju9owWlE5ak
	 K0APO0gFz5Yvmj/OlSMtHBp4sDvYM2fJEPiDWrDURGxk5GFV0ytB1wp9MkPnYzgG5eOVQ
	 trgGvpJz2rhPoiqBv2vgqPVNq/LhRAKDIqUUMI83emUdTpqYpAgdryNWrUZaF6ZPK02Vk
	 Kv08itOlDLjhjPqOnGAmbLnCc/OnZseRHFzLDW83Ntf+Hu5w/YO4+uZ0/AtTWi/7+rIGT
	 mYpKOycZ82HJJ5u05F75kg/t5nrAa9plevgtPXMDdMiBmHtij1snEnMqudiSBj2CTiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zzkZF6xs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD6C606A689;
	Thu, 26 Nov 2026 15:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zzkZF6xs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789621F000EF;
	Thu, 26 Nov 2026 15:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705586;
	bh=gNkL7RWAOyYWnC5q8pin6qaEA0PntVfzMzkrT0jaNFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zzkZF6xs87n43cH8P3j8IDBT9EehXmlE3JcWeFu491bBqQPxhDuWO/UelPrhKxKPO
	 moDlgjhG+fmVcJZt5IPqIlb4evzDcm289bY31bT9Vt48LuDv0coJuLxFTDYp/hWC9T
	 Bo59bCAvHPAaZabis+/bSndzTi8QFcuAsT7QoCms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 221/319] s390/dasd: Dont trust userspace-supplied result field in format check
Date: Thu, 26 Nov 2026 15:39:49 +0100
Message-ID: <20261126144011.736551457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -309,7 +309,9 @@ static int dasd_ioctl_check_format(struc
 		goto out_err;
 	}
 
-	if (copy_from_user(&cdata, argp, sizeof(cdata))) {
+	/* copy only input fields, clear the rest */
+	memset(&cdata, 0, sizeof(cdata));
+	if (copy_from_user(&cdata.expect, argp, sizeof(cdata.expect))) {
 		rc = -EFAULT;
 		goto out_err;
 	}


