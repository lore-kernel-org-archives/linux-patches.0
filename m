Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064956;
	b=1JdnQHulglzx6CFxiJPrm/xMvklrO80sNBWyrqqrBd43XP5BhEMD2Plbuzx0O1HQZPS3
	 YvJ4V4Fui2bOz687zGmzL/MP4ZC+EDIjGUPZQ1NqVNxdAo4HtDh9qxUGE4aBJRqOr54FQ
	 CKsfaerXGpeHjeojbPeuIxkBRJ79ixij4eofYL1fKnPeF24lVIuETLvHCePVNkeIx1UA2
	 srlybpchJ2nOESh/qXmyd5v9fyq0wFcj72CkJ92/6eVSE45LgWaSMDykodU4C8e9qcMYg
	 BHiW5LMzqjm0SA0IrMaAwoDkKoRb4WQKYJzosqS9TzyVVAm+GH3xu39qLWuW8LnKTzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d7+R5nsNtKIp2wLZboqzM4rp/IOB5jAOFAVdGKF0imI=;
	b=leyws6BArM2rxhh7JANALkSvNnGtxweWYv+fjj7olqDE70TuRlxi/53VG8PvEfzUUzt6
	 WVrM/kLC+l2B9/W9HGXk1MvIpqQ4+bMBYS1xpsHNGQrJKQ7s4UxFCapAFpLN90Ueul61D
	 oXCYBeNt54pKZa7krT+mAScEWbxiV5pWmnbEeDopvX2YnJgtwUCqwwAoVQTHBG4xYakM+
	 Y1UqgtuIxwMJTR1KGfjg59zBof3u0eIWi/dlgXQHxN+Oo7fjioL46UcbYiGzh3QgwRIWH
	 vcTRUm0j4nSHwz9PxcKmGmxDBv7KH0pf02emrhlm1wuL2CwZpWDkrmfaNEcThB9xuMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ESWILpfX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3DC606A9C1;
	Sat,  7 Nov 2026 15:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ESWILpfX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9401F0089F;
	Sat,  7 Nov 2026 15:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064956;
	bh=d7+R5nsNtKIp2wLZboqzM4rp/IOB5jAOFAVdGKF0imI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESWILpfXaO8Me+2qSE7Ev/fPtl4/lbRwiE6J37cx4kNcgPUSxOHeRuhoKEN2bLRak
	 lTquKXev1TIdpq+vuuHlHIwp+H6/88/6oE3Dvuy243WvOTv20dSYUqPnFLWqSXAUA9
	 SFD6mcB6NsSJYXt9POhykoQYnOkWfUp9qpNTvPTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sonotri <sono7ri@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0842/1257] ublk: pin module while release work is pending
Date: Sat,  7 Nov 2026 08:52:18 -0500
Message-ID: <20261107135002.580149042@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: sonotri <sono7ri@gmail.com>

[ Upstream commit afc9cde716b29ce814798d649a95f9128ba42b43 ]

ublk_ch_release() takes a device reference and queues exit_work.  The VFS
module reference held through the file operations is dropped after
->release() returns.  A queued work item does not acquire its own module
reference for the callback.

Consequently, normal module removal can start while exit_work is pending or
executing.  In addition to the worker callback itself, the final device put
can invoke ublk_cdev_rel(), which is also module code.

Take a module reference while ->release() is still covered by the file
operations reference and drop it only after the worker has completed its
final device put.  A rearming worker retains the same reference.

Merely canceling exit_work during module exit is insufficient.  The worker
is the terminal path for the device reference taken by ublk_ch_release(),
so its cancellation would strand that reference and skip the associated
cleanup.

Fixes: c5c5eb24ed61 ("ublk: avoid ublk_io_release() called after ublk char dev is closed")
Cc: stable@vger.kernel.org
Signed-off-by: sonotri <sono7ri@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261015120654.241354-1-sono7ri@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index a49bd30154e01..1ef01ce18f4f0 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2637,6 +2637,7 @@ static void ublk_ch_release_work_fn(struct work_struct *work)
 
 	/* put the reference grabbed in ublk_ch_release() */
 	ublk_put_device(ub);
+	module_put(THIS_MODULE);
 }
 
 static int ublk_ch_release(struct inode *inode, struct file *filp)
@@ -2652,6 +2653,8 @@ static int ublk_ch_release(struct inode *inode, struct file *filp)
 	 */
 	ublk_get_device(ub);
 
+	/* Keep the worker's callback and final device release code resident. */
+	__module_get(THIS_MODULE);
 	INIT_DELAYED_WORK(&ub->exit_work, ublk_ch_release_work_fn);
 	schedule_delayed_work(&ub->exit_work, 0);
 	return 0;
-- 
2.53.0



