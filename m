Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774985;
	b=yzPvnYZhQSgiRrtfUlhtQExR2vTOoQ+8BimBSsU8/FUcWPUTNre6KoAwmQHbQ/5Fp2y6
	 IJQfRuT7P3SihPhVU26NhAgSUSVgClMqd3fOIPedyCOFRsNtQBwZlO2PYb+ZGQ4dDGSqI
	 gyi/Fd9j6IXeEYPsb1L/H4BnMt6M905ywfOiF6tq1/XO4V2ad4RfUvrruxlnlm+GPbuw7
	 8YqG2D89kuEYiTt24NmK+16ZTyuV7TYUduBmhiTj4goOhcQzl/VVe8wtYA5lwA1hCtP+c
	 /HbE31G433tBZEeGYUZGJeVrNx4BzK7lbwXNtgUeSsSZI3ktHEtAjKEvjwGX5qyqHyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XXYr2LWHuKu9TO3HOOP38l2xDL9JZNv4gW5zG9Fqu7Q=;
	b=wfsnbDsH3y2XJxqN5YNUKZOzg3HM3b+uxKrkUi7W0o/LfhCZMPq833r+Yu8EozKJh3KP
	 7jHWGKDDwPdG1sdEJdpwOOs+Q9hMyo7kV2Pc1uTR0g1KSZXu4g+zWL2DOL2CQ7QDcZgdz
	 /CT0bhwLBeBx7n2e5Uc7oacmCEpCcCsGUC9SfwgXy/nYj6CfEDuuV+PqpgawYbFpyG5Qn
	 nEAG5N0Y19yO62w02aqabbOgzcTgWSUydyhkPxgHrFClFoZSuFAwnqOLWfanDJ4o2B+U0
	 hLRHM6EwwCjfsVd34GEZ2Cgiz5t2XT3ncPHqi2uJ2MsqFz1b7MJDz8nJGORI+Ot/FPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ky70X6F7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D995606A31A;
	Fri, 23 Oct 2026 17:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ky70X6F7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC00C1F01825;
	Fri, 23 Oct 2026 17:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774985;
	bh=XXYr2LWHuKu9TO3HOOP38l2xDL9JZNv4gW5zG9Fqu7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ky70X6F7mSOjkDkpee37QejT8DaWhBybJG1n9B1ZEAgeid3CDXSSEa3U33w9RMr9y
	 fqj7JdNRc0NGiDkNrW6ug4Dr7qpQXuuMVYGCLLb4uH29udltc58a+XCUw5TNdxadWa
	 +O0n34OzXLco0FTxi+7lfajpsbLTWcJQb9TRY+Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Baolin Liu <liubaolin@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 224/242] ntfs: handle signal interruption in fallocate
Date: Fri, 23 Oct 2026 18:41:06 +0200
Message-ID: <20261023163719.133365380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongling Zeng <zenghongling@kylinos.cn>

commit 4dc8f4ee2d46d5d1e749ddd1b94912c72e796162 upstream.

The ntfs_attr_fallocate() function checks for pending signals during
allocation loops and exits early via 'out' label. However, when a signal
interrupts the operation with err == 0, the function returns 0 (success)
instead of -EINTR.

The signal_pending() checks at the allocation loops jump to 'out' without
setting err = -EINTR, so the function returns success even when interrupted
by a signal.

Set err = -EINTR when jumping to the signal exit path, and only override
when no other error is pending. This ensures:

- Allocation interrupted by signal returns -EINTR
- Allocation that completed successfully before signal arrived returns 0
- Other errors are preserved and not overwritten by -EINTR

Fixes: 495e90fa3348 ("ntfs: update attrib operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Reviewed-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs/attrib.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ntfs/attrib.c
+++ b/fs/ntfs/attrib.c
@@ -5845,7 +5845,7 @@ int ntfs_attr_fallocate(struct ntfs_inod
 				}
 
 				if (signal_pending(current))
-					goto out;
+					goto signal_out;
 
 				vcn += alloc_cnt;
 				try_alloc_cnt -= alloc_cnt;
@@ -5866,7 +5866,7 @@ int ntfs_attr_fallocate(struct ntfs_inod
 		up_write(&ni->runlist.lock);
 		mutex_unlock(&ni->mrec_lock);
 		if (err || signal_pending(current))
-			goto out;
+			goto signal_out;
 
 		vcn += alloc_cnt;
 		try_alloc_cnt -= alloc_cnt;
@@ -5892,4 +5892,8 @@ out_unmap:
 	mutex_unlock(&ni->mrec_lock);
 out:
 	return err >= 0 ? 0 : err;
+signal_out:
+	if (!err)
+		err = -EINTR;
+	goto out;
 }


