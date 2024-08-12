Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28821494B8;
	Mon, 12 Aug 2024 16:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480620; cv=none; b=g7mfI4MFExJBdk2GoETTdbs5f+eNltpv531h11Lzkssm93TodSYeMzPDo4k2/JG4xmQhGaD1z2ndj7k1J9O4+XbeWK2+YZWknd+HAN51mLx86Oc+3WD+fb6QhGp8bOnCiKvBEjPM/5dX4cWyAUXGSsnTUF9j6Bpjxnr8kC8grjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480620; c=relaxed/simple;
	bh=dmmtudcQCmiI4JE0z/iFu1RPek1fl++gH3UIfcB2ygg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G80LI5xTUlYShYJTsnEgwTntKl1HyAhlRRiiyJFJ/8mb7hDM11nvzl+EECWS+fu+0i0ulDZJoPAqyRjqIVW9ZzuvGOD7euF4gfUtqOJqVgYrpvwEosFtnorSr8OmjT7R/3F+DfDb5FDDnogEHplB4Vw/GwtmcJ2Y5YNL21NI3FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kp7xVrUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kp7xVrUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC56C32782;
	Mon, 12 Aug 2024 16:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480619;
	bh=dmmtudcQCmiI4JE0z/iFu1RPek1fl++gH3UIfcB2ygg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kp7xVrUlKa+XhLY7AFqjQ4gvwXKHMvT0GQ5nYsBk9JEOtsCsJXhwX3JTACJ6fBHdC
	 N65WYYOfcNH/BKx41rqJuFpPdaM6TTgOZjT0MMW0nNpdT3VTLJri6uoYQK9bGmGEeY
	 ZBf4xbSsQhQXSDZKbpv7IjxS0NRBaYw6eJNag4tc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Matthieu Baerts <matttbe@kernel.org>
Subject: [PATCH 6.10 250/263] block: use the right type for stub rq_integrity_vec()
Date: Mon, 12 Aug 2024 18:04:11 +0200
Message-ID: <20240812160156.113990583@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 69b6517687a4b1fb250bd8c9c193a0a304c8ba17 upstream.

For !CONFIG_BLK_DEV_INTEGRITY, rq_integrity_vec() wasn't updated
properly. Fix it up.

Fixes: cf546dd289e0 ("block: change rq_integrity_vec to respect the iterator")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Matthieu Baerts <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blk-integrity.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/blk-integrity.h
+++ b/include/linux/blk-integrity.h
@@ -166,7 +166,7 @@ static inline int blk_integrity_rq(struc
 	return 0;
 }
 
-static inline struct bio_vec *rq_integrity_vec(struct request *rq)
+static inline struct bio_vec rq_integrity_vec(struct request *rq)
 {
 	/* the optimizer will remove all calls to this function */
 	return (struct bio_vec){ };


