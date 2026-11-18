Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036868;
	b=r1U0+zP64OD1N1SywWsTggz0MMKVOKTDwBpbp22L6BWs/BMQJWxIjJSfGBVFXNLVHeo6
	 cXn1UDKMHv4qa4dsIrWwkzPZKf4Dt5PDTeZAhcHyCEyaFDfMUlmW9jEYiCFEqlSilAbn6
	 1NXmTVN9u9ubDH/z4RWnL/jt1rQ7/PiPPW9cg8xg2DErktUx8dcyqR0VuYhVYBQLfWLDI
	 sRd/9l/vbcYVsHCCQ0yVhXAvV7HhU536MKyRV69MEC4bs+Vi3i7egf9evkaj6Sfhw66k6
	 KVNLdgRpe7kA3a+/TUyzsae2Spjeseuc3aWJZ8c0l0SHNmaQKqMmxhh6gjU7tRgOyiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YP7KdO3dH0PNRc8ujzAW/GVDUgjrSSewK9B07MRlorQ=;
	b=wFPKO4QL2WjgZzdgzT8wu3Yjt/lFIYBZptSdLmWsvlJhCZf0FB7TwYL/QjJe+b5Pajg5
	 OO5t+xgHJKDbDJpF+2UXLXeE7gzxn+auQbeqjcrkO58oOe4GkVtuGnjCWCV0Jjbc/B9Km
	 pkG645eUraq7x/gB0ia1J6nWPlYgvdnDbaQ9NoDuwrluQeRVLbp/lvUGeF5u/Pmcwzbna
	 O7XqnemUvFZkuaJzTSBVKD3Rz9yWvFdfQwMHeTlGCluWuxoGUYQmryW7Ju8MeS51OcFMH
	 MtFNTwpSL84w36HIF6rhg4IbGV7cYGvhg6c3FcFVqryIm1WY7LBQLuivgYg318axUag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="o/HblVjO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0B6606A31C;
	Wed, 18 Nov 2026 21:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o/HblVjO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E951F000C4;
	Wed, 18 Nov 2026 21:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036868;
	bh=YP7KdO3dH0PNRc8ujzAW/GVDUgjrSSewK9B07MRlorQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/HblVjO3OrEqh2qPNJi9P/nojlxZ41n3fRHRF1Fo6x1ngMuvHmH93mDBA/F7h9JC
	 yahyi/JhcG/X7j0g85zGPl0gB2wnPsOPXy4EPSzMBY3GRCLqlX6geIL74Byx2oIaKr
	 WWOTX8CXpCuNMFCTdrjQwNbPGLyF73g/i0Ymab8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1213/3318] scsi: ufs: bsg: Clear the reply buffer before use
Date: Wed, 18 Nov 2026 15:30:35 +0100
Message-ID: <20261118150356.559160225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 2e63ac76cc08ea376ba61fef52f7b7849e35024d ]

The reply buffer is allocated once per tag and reused. Requests that
complete with a positive status do not fill all of it, so user space
receives bytes from an earlier request on the same tag.

Clear the whole reply buffer on entry to ufs_bsg_request().

Fixes: 95e34bf930ea ("scsi: ufs-bsg: Add support for raw upiu in ufs_bsg_request()")
Cc: stable@vger.kernel.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261015001855.3450573-3-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs_bsg.c b/drivers/ufs/core/ufs_bsg.c
index e2f03243643e0..0d7ef0cc0055e 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -142,7 +142,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 	int ret;
 	bool rpmb = false;
 
-	bsg_reply->reply_payload_rcv_len = 0;
+	memset(job->reply, 0, job->reply_len);
 
 	ufshcd_rpm_get_sync(hba);
 
-- 
2.53.0



