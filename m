Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029624;
	b=WRoCkgDtu6CJiGvaTgxQZ8WmZ85V+sNTYcmwQCRit1dTQFRaGSrnu033O/JQ+li3DIYg
	 6zGuM5z5hlMYkKbzpQaU/GDRNqyOfhfWd5EIYN/Jey52E2CiPO/36aJtBVzRnE5lvMbtB
	 wPFwgphQy9rTzbRJ5jQ63rXeDxtRryLror7Meo5Pdwu7Gyu3oDcZN+CPltSU/k+gZobrq
	 U9Cg66vrlyskMQwTaux54G2JFvWKTDP6orAiQ6zckNyHSfEjhlQJwNkm/r0y3WReqvwQF
	 IKkNQQDi/X0g7/6J9YxzWiIO/BqkWHFf2qnHNOEyhTBxMpSO9v36D++2MJfQ22lmESw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bU8JidA/gMGc0HoWPaT+lG0DkRYxqis6zhBNSz/qOCQ=;
	b=R2fW51boY4MMkS2MU+VaIhiaVD1QbLk54vp5Gg10KB0yFtJNONjKwqEYAN2XimlLaNPD
	 lHAeY8fgfO/YyZCw/QUvWCTV18a65rAVquHQrN1KuvtNmCRrp6XE+RzU9VGepHuxMIWzG
	 RvuZThLPIg/Zvg0VPiCOwUkQOV9RsWZ4+zec4CMkVp57OmXUDF0sPBICCa8J0egvaEbr4
	 4kYIethsngj+TAquoTSXxhw7+Uaw8nFXZPuVXSbLA6H3uJTxDVfQ2b61/UU01XMceV2Qn
	 2+vGuBSUrcBwg7NaUdMfLZbg/pWjtaQYbMGEmH3Gu7e6ayO0H5BhNLWgD5Yi42vHi0w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhv4imbQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6206D606A32A;
	Wed, 18 Nov 2026 19:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dhv4imbQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBE11F000C4;
	Wed, 18 Nov 2026 19:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029624;
	bh=bU8JidA/gMGc0HoWPaT+lG0DkRYxqis6zhBNSz/qOCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dhv4imbQaWPOneOnMzd7T/vsZ0d58uLDDOuDsU+Mi/1kQVdkKqtmBT/02f0drw7yc
	 AY+W0hXtLKKeBs1+LiPJUYPmNZcuKEHA954iGnT2rT4GEfYyTW6A/IlWrgif0HsswP
	 yFfNv6QyFjsUnKRCWLavgQayoep9rQIclbWH9QXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0414/1756] block: Fix the thaw_bdev reference in bdev_freeze() kernel-doc
Date: Wed, 18 Nov 2026 15:42:21 +0100
Message-ID: <20261118150025.216074491@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit e14c3379be86854c203de1e0fdfdeaa0b45509df ]

The kernel-doc comment of bdev_freeze() refers to thaw_bdev, which was
renamed to bdev_thaw by commit 982c3b305843 ("bdev: rename freeze and
thaw helpers"). Say bdev_thaw.

Fixes: 982c3b305843 ("bdev: rename freeze and thaw helpers")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christian Brauner (Amutable) <brauner@kernel.org>
Link: https://patch.msgid.link/20260911233415.31271-1-kmehltretter@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/bdev.c b/block/bdev.c
index a1399a1bf9ac5..57aa344dc04a5 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -253,7 +253,7 @@ EXPORT_SYMBOL(sync_blockdev_range);
  * The reference counter (bd_fsfreeze_count) guarantees that only the last
  * unfreeze process can unfreeze the frozen filesystem actually when multiple
  * freeze requests arrive simultaneously. It counts up in bdev_freeze() and
- * count down in bdev_thaw(). When it becomes 0, thaw_bdev() will unfreeze
+ * count down in bdev_thaw(). When it becomes 0, bdev_thaw() will unfreeze
  * actually.
  *
  * Return: On success zero is returned, negative error code on failure.
-- 
2.53.0



