Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625828;
	b=AxcGmYruiq6llkrr9t4BuA3eU7QpZO3Wk7LKXrRLjWGJDmScYL9d23u8TofAYdKTbAs8
	 TWj0jd0K2aDQ2LUrBSn69P6YNsQA5nXIu/EYhw1p/zaJpultzkdoVYVo8cgKVKymtXCNp
	 jts8NKLZkN6PSEKhuqufLgf40XXjQJ8xv2uX8UygpFt8M2b4IVkxBrEC7NILhDOXQ2Rq0
	 QvzqS9XDVjVrGva+kM63SEKl0+dgnq1IZebUYm1jdOIx6LNlh0ue12ZuwphhaDezLUku+
	 muID54aiGuHvO+lWJcBaxXSOhSf3kboXZ2KghIcaz6ZvkUIiIZIbqxQDP7j35KFn/oQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qkF3jQcT7EL5IRbLW4qaqUV0jksdnZIzKdBPmoIqwbE=;
	b=iKnurLRmdsmuWZLPTBVzhdkI+aGNjIM+KjJkkxxGgPTVrbvn6mgjEGyhe0zLAuV/IBFs
	 nUyZ4TXbOMNSOf5a/F4uPBQBldlmJY7wJf8qY8Mkh3iEwswPKSg6BBVNaAdiAMJI/sSoY
	 se29vPcjvL0v3teWZMQaDyCF1HlPHhoSZCOghTkTf8wzNtPTcRcLR8wbI6zN8LyGxWvs+
	 KjaJ3H5JhiM1BqpvaOl3t3FLZRc2eeN+UnwjGM8ltgWQo835eKkw0vHXPzUePM8O7tPD3
	 H0wqMJ9XTxKRlv6zIJ54Lmdd0F4Gk92SAYL61xqCWdZzR3nvwe5KidqvwrS4qjVGpeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxsqz8eR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A59F606A331;
	Wed, 25 Nov 2026 16:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sxsqz8eR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D64A1F000D3;
	Wed, 25 Nov 2026 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625827;
	bh=qkF3jQcT7EL5IRbLW4qaqUV0jksdnZIzKdBPmoIqwbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxsqz8eRcKG3EowYjmdOBaZToEu5NqsPfOv8cFVe9BR6r3C3wQ4FJct5nYW98uJE0
	 cAgJswVREic0kcrLanNFI1VNuo/BKOmUpL78B8yaeowVaAO+rR10Yn/LUPaTWckSrJ
	 qMI/GQeGAFzyBUzZLnQuYTaui3cwNHz7yivazslk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 643/816] s390/dasd: Dont trust userspace-supplied result field in format check
Date: Wed, 25 Nov 2026 15:36:31 +0100
Message-ID: <20261125143904.067410913@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -303,7 +303,9 @@ static int dasd_ioctl_check_format(struc
 		goto out_err;
 	}
 
-	if (copy_from_user(&cdata, argp, sizeof(cdata))) {
+	/* copy only input fields, clear the rest */
+	memset(&cdata, 0, sizeof(cdata));
+	if (copy_from_user(&cdata.expect, argp, sizeof(cdata.expect))) {
 		rc = -EFAULT;
 		goto out_err;
 	}


