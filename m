Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059647;
	b=fxwu9H2kxyPk8yEkIpLIiVn2g1vXUtlJ/m7erH9XRfjaO9yfruf+P9z8O4KW+j0poRWS
	 6MxpVXhfElz5SoT6snV03AD0M38e3H3bL5gq4yThM8PDebbhTbQq48ugfVwoY3ALD2FVy
	 cZefzOINqeHSCWReG8l4/UG0pi3GDRPYzmD1k1WYQhL3/k2PCLrJMRsUmV8Dx7Q2b8G1Y
	 wj5eErbJWBW6ho2WVKGe9g/I88+40MnmRXOfSaKr8YIhrq0nX0TV00Sd5h0Gj3jUcVq4F
	 QcaiXmtYonre68OIDqFKRfJ4bIYuApEWv2r0ZD+rwYDu5ediryCOlTjZ1tRzYjp0lEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=suiM6WtfDYFrgRasEXDy8nk5cXO3GuSgPhDPVtbFfqo=;
	b=Vgg/9XQM74zl+D7/uDFwg1QVUcbCrBDnbl0ycvCfz/w2Tt2vCzzYYQAbuwcwdEK7Z5iT
	 bbVn/sT6lDgZmbtIIyiJ9b83d5A/VooEYJ5ASqERvJlvrt5F0phMAK7TdxiXgepAikWrc
	 Qpc6j8l3n/Rp+eYaeL0EtlSR+s2gRifhPB2OVK9Clqh+C9DGLMhsOc2Lk8tbinj81j3S+
	 IzSK2kX6o1+aa7v2AjazAC4GBS7Vrin+Ei8qwC6dZODcu8baE/+XSch5NMsDk73rlKUMp
	 AXJXVQORZFVMN4Y6+oFifUoN4ajBOL0S9HBqXkUam1L1nvVsEwHt16lMomZ+TlstDEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1aCXVBj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF3C60A260D;
	Thu, 19 Nov 2026 03:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a1aCXVBj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6D61F000C5;
	Thu, 19 Nov 2026 03:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059647;
	bh=suiM6WtfDYFrgRasEXDy8nk5cXO3GuSgPhDPVtbFfqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a1aCXVBjRWyrfhebcCo+tLYBkLH4979tKaRwGevuXBv1RDQlJighwaBjhlVG/DQEE
	 +p6NXZ63FedpLi7uItml6igLP9xwfUVY/bRbnToKi+CCVHXYThecMw6vgRnde6iY9F
	 4hjTVhmemRLKyDmm9ijW/toI4HeOcm3PstfQ1hTM=
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
Subject: [PATCH 5.10 0915/1848] scsi: ufs: bsg: Clear the reply buffer before use
Date: Wed, 18 Nov 2026 15:49:13 +0100
Message-ID: <20261118145955.164709428@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for the existing error check and pm_runtime_get_sync() call ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index a7e1b011202bd..4b2d4169073c7 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -95,7 +95,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 	if (ret)
 		goto out;
 
-	bsg_reply->reply_payload_rcv_len = 0;
+	memset(job->reply, 0, job->reply_len);
 
 	pm_runtime_get_sync(hba->dev);
 
-- 
2.53.0



