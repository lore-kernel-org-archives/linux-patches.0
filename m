Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016410;
	b=Y4BjqEabVssqkfrGagpNCQkWMNIVYqFHBhx1c1ZgdmF2gEKPfSpU7SzFuDGfciquzxGF
	 0bmHubK6q/41+2t5GlEqrMEQIbdKAd5QwEeEQHIXiiaYiuN82/Xm0y+OYXq+Rz2hceaIo
	 BO/r9hFT27NVL2jm0YRbQSADFOb0IHSPKEulU7MDaBCWNubAcup0n9xC100uwIBi4kHNm
	 TlgznqZAZ0oCXXIWfM4z9AxAzToRfStOd9YON3ZhD/gIcjFuM0dpRYUusobxZ8V9fZkoG
	 L2sYmZnRwRZwhidDvKoGMuaiQH8FAZOpyhPWrhiRUCV8YMS+bBSgaMA5xMEDXBKOa/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016410;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZRkCqR0OlnfrjqLxs4LBIWOa1H3pDeApzTP0s8wuNww=;
	b=AKBogemT8Nk8ZM8xKMbxl5wha0SsotL2V6Y1LPYAAAJZBygMsRAtd/SZSuik02DWOm9g
	 WEckFLtFGb+pQr6zIYV0uLvegBpFUWbM9iFrUFlWn+qIVZ9agf0yzjFCGYJrEcwBiEMq2
	 6/0X4SBv8sYb2VfZ1/Zs7pG2GvcDkxVmPaRh4NB9C8tzt+cXPj9k1pWwcGU+hmgcoRe22
	 Sm2Z5NdEit1/uUfbvHo6Swju9+aFe9P1SUbNxGPTGBQAB/4LywtN4TPPQC+WbMtep/JcN
	 EGENsgHmLoMGIvLi7Meb6rdwaUDb64dF0tZp8I2l35YwsZPJwLAG8fXdsUShdZjeAlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vO67DGQA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5313B606A337;
	Wed, 18 Nov 2026 15:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vO67DGQA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D081F000C4;
	Wed, 18 Nov 2026 15:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016410;
	bh=ZRkCqR0OlnfrjqLxs4LBIWOa1H3pDeApzTP0s8wuNww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vO67DGQA/xQN5gyHBg5pPGBYLY8PR6wAyadBmv1+pKuzITtDJGUxibAtysQXKcKgu
	 mWWkowBWXyJrbYaT5uViKLfIVf2ZkAgFUpBrKO94BKdPmKrRsD9NPeqS3KSlOK52FF
	 yKo668XtF1XuKrSuhRB8eyreC4tQPmKKTb1SLZVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0478/2651] block: Fix the thaw_bdev reference in bdev_freeze() kernel-doc
Date: Wed, 18 Nov 2026 15:28:38 +0100
Message-ID: <20261118150304.992031746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
index cd83230837406..fac74319e9fba 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -292,7 +292,7 @@ EXPORT_SYMBOL(sync_blockdev_range);
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



