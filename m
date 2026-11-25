Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619937;
	b=MZR9RS5Vxkt313UF2GTZTQLoDejjoJmcn4evn+DNTeLp6gKIZ/oPRZC0PcxV6uyLMJDA
	 BY7e+1kYbSRGPQYlb+6iIp7zMd0eIfOWRFhqrdAKioIOom2/b1s/9wTY8dQthLtsfqTUT
	 M0dBIPP7/h6tPKxRznGTAfPFomXLE6clW3peNuBrV8GYrYpPA3DbbPRk62BWm2wtPaGCL
	 /xij5rSe5UmSwSRanSglNciJkvzjCV+Vtp2IwRNYTgAi6kkI6arv4a/fSzpu6cNHtsy4g
	 S2FZPnJQ1RplWpwXR6xZV5XLWlKVW133VzS2hkKlzVrB4nKhB2Af3H8mntIbBTNqrgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619937;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=OJlPhMJSebM+sBqcHfIxOCYkw9evUpkkuKSbZCbP80w=;
	b=S/p4EJ2k0W40fiJYOcdjAe//wy0rG1bIiwIZyi5yNDrng3JWzFrREgQdO3ikK0lxOE8+
	 N3LF4AMeb30G6PfscZLRSZ8cFtsXaO/S1p/BMZuMS0oM0JNzXm5icuYSgN6AV1QQ9j+Ia
	 rHhpgaviGYWVG7CI2BpBDafEbcCEg4O4IdSHNwdraPPahF5ko2sokHqFI8QM5SXG8kjXX
	 rPR8KfsLeSsLIt7eEYs9heTsuwuAVYVxErK04Z7qE9o+76oD/mXmHDo1batHxFSGAMiGG
	 DUEPnvVxe8oaKSyCe+2iKFutzCE64Ir4hyFE1bVc6VPiyg8O6dtwI8CA3T1lBBDGnWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkmrrfaK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E56606A31E;
	Wed, 25 Nov 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZkmrrfaK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7891F000C0;
	Wed, 25 Nov 2026 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619937;
	bh=OJlPhMJSebM+sBqcHfIxOCYkw9evUpkkuKSbZCbP80w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZkmrrfaK8ersuZG4t/f3aT/4NcgPXiBF93eh4KL9vLJVnPUlbXfrTYcDp5V3upYQA
	 fZuS2Ow+zaJU21wJ6bvsG62FrU5ztBew6wfulJr7gYDAXbkjMRhaugxfv8MdXL3fLp
	 956ZJzoHUl8hLGoV2YcCr2gX4sPpg5VITJiKkOKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.3 0756/1005] s390/dasd: Dont trust userspace-supplied result field in format check
Date: Wed, 25 Nov 2026 15:34:54 +0100
Message-ID: <20261125143839.455495178@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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


