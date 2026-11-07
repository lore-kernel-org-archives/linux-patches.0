Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065291;
	b=aGxIfrVB+WXHGxlRTCi2RpbQAUwusgfARBLB3aT3/K8EfoolPoZcYELodkR/UlN9Ekq7
	 yxVwjrBQK9luyg95R9KZf4ewHIr/AeDIiLFMA7pCQH/5HxCprZaFLnV6wY+gad8f19ts3
	 nswE1Lj0gdXwnw2HBvCyJm0/PqJuhekGvHH+I0En3Drjv3fJmko0Ew/CvpVg9ZF+VwQZy
	 VyUuR3bYy7qPZ+GjAbxFODdDy7nATkuebl0C/WpnvBjcjTQ4Zdqz0B6ky7MTxr4ezlCfk
	 416Bnx8y7yRD9IgC0e44mbfLbWG/580G9/Bk/x2Fmd/En7JHXO7DqxgrJr8dPH/M83A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HUeZCllJfS4LKeWv8mQjqezXvyEkE7eEtSln08lsbJU=;
	b=f0ZWZj5/Xh/VluIkUavkn0affvgF34gZVn7qCzOw1C1gfIH5oRbjLpisj+tTcTUyQhVH
	 C9ZcbSfKEh7srkj8ODgsCRnsrZ5fTZ2EZSiccJ2x1ABXBdsexLB3Z8uvUlpgIL2XRgDtH
	 0w0uRlAksm0HW2nY6ShcipzyVrMlzYAAP4BYTFv1Bc1WyYSsHVjcT7zYbOxHRq8irT2Jp
	 VZ5UdpYwIeT5TyIloSRKMm11vNXM6MsBPOVm94cwxCTKlrjXXTURLmRThwX2cN0XuzX1t
	 x+/T1KMLhTAyMGBC+udwmflaSvPSm/OKmHLsACf6jl6zK4gJj64K8aA0pE2HPkkoD6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dw6kIdzG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D64C606D802;
	Sat,  7 Nov 2026 15:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dw6kIdzG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DE41F008A1;
	Sat,  7 Nov 2026 15:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065291;
	bh=HUeZCllJfS4LKeWv8mQjqezXvyEkE7eEtSln08lsbJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dw6kIdzG9TCOyr4FkmkqONr2CTAXsxv9xDCV6YCJQpxfcJuQfN2Vuux++33nQRPm1
	 +gAUB1ms087eJcy++pWNiy1zC3FVHXS2RFOyVecj5LKzn77ZsT6gd4wdVZNyoDlv9s
	 uF/OL/SmOsguurg/pD3iYZYPgSolazLlr2glAUi4=
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
Subject: [PATCH 7.3 1049/1257] scsi: ufs: bsg: Clear the reply buffer before use
Date: Sat,  7 Nov 2026 08:55:45 -0500
Message-ID: <20261107135008.270101531@linuxfoundation.org>
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
index 1519a9ab9a43a..0fd4dc18e2729 100644
--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -140,7 +140,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 	int ret;
 	bool rpmb = false;
 
-	bsg_reply->reply_payload_rcv_len = 0;
+	memset(job->reply, 0, job->reply_len);
 
 	ufshcd_rpm_get_sync(hba);
 
-- 
2.53.0



