Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045860;
	b=G9Jj5spXU3hh+K7V3vST52HbH6i/H34LyD9FUVGuh8wphvBCuR1V5VANZcu9dbGchRor
	 suL2xMlMUvVv+Aw2oBpfAyoXLYjP2sgPbaeAEa9HtYxKjbtnXnA/z/sL4b1j4GyioNUvT
	 me/tqp+sQQy5u89hhiZ0yopKe2/6upZdqK/yygSP9t+0uVnseDleB/BTskHRwQJ2aDQJg
	 cmRPwDBNboOYfjsuxIHT+C8DVGmHzUGxHODeG1nL6+NCe8wc90eLm9mZdaaD1+r1GD2KL
	 urcPLv+BTbtMSTUqWg9OsaBrOxmE4CNlKtKMs9c2vJUNDS3RoU+gSK2775yxNIgmwQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045860;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cwUWNwzK7w66+lwc5s0sRNouIB0qSkZnRfgDSqNvCd8=;
	b=ASXb1cXvfvKApCf6jHniuFz+uxlQLJ0rhmE8hZ4r9MD7s9KlGkVJSp1G7aafC5pQiRUG
	 Ao7buU8uoYjHUd0xb6HIM6RwMmHl/Sa3DFcjzUiNW8nRVzuWqJoRXnL6lzRp8izTi9gVt
	 Frbri/77b+jNsyD/dde5qlJbobJf16Gax+q40eaZxxvrB/kKqPWh9lQOv0nNBGvSNnVYr
	 37X5mJkFYHNn9dDZcg43VcQiyTLLszdxT9SsuHdCsdjGkqLvLfB86iTGOsa00VKSVWVp5
	 Ciflxzw4FiTXkZwfzHE2hvuRYGSV4otrC8/hD8KY09Lpht5M4T4IzadhxSjhVCzY40w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LU4QuQFU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D0F606A325;
	Wed, 18 Nov 2026 23:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LU4QuQFU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAD01F000C4;
	Wed, 18 Nov 2026 23:50:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045859;
	bh=cwUWNwzK7w66+lwc5s0sRNouIB0qSkZnRfgDSqNvCd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LU4QuQFUMwuPLSXLjmYJl4YGhbOLb8bZYTZgvx0+ISXaTGEfITXv3pktvx4fzg787
	 cVAf0jnbIKGp2N3pV31owNYhrWbF9/L71slBBVIyqy75iovqYEH1gpL5CG7eqmTw9M
	 nlVcfiXmL/wYjWeJ2KAy3D/nfoDBJpGnlfIGCMcg=
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
Subject: [PATCH 6.1 1034/2857] scsi: ufs: bsg: Clear the reply buffer before use
Date: Wed, 18 Nov 2026 15:34:28 +0100
Message-ID: <20261118150238.827922082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ead55e063d2b5..118172fd66176 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -101,7 +101,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 	if (ret)
 		goto out;
 
-	bsg_reply->reply_payload_rcv_len = 0;
+	memset(job->reply, 0, job->reply_len);
 
 	ufshcd_rpm_get_sync(hba);
 
-- 
2.53.0



