Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053910;
	b=HAqolF/4E1u2rw4X4FoTdUFex1LldglUcVZ+2qZexNMX54dIIvxDE9/sPztmnV9cqEN7
	 /SO1J6g8akyCuAnePh/lZfnT2qW9DF1yEV+P5AHqCfJ8ni5lk0AgxHk1IJnNuVKTMF2+b
	 bhpPXlXc+Q+N6tSOIstgT5BnEOjP4PxXZ4xlRzf1MZ0bw2+UWM/4ZnvsP2pl5A9BWgJNV
	 AJcYsgYBweEDJ9hZ0X4qgxcOgw6SRbf8eectaFbZpAL7L//thWuVSCs50uG1H3Y+CBSvH
	 XmcD3qVXU2FpHEYyVPSi9lWxQpSrGt/oAdvILECzqF9FLTv24/z9CeSnGf0P4yQlrew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4vPyKnVXgJHADY5WNk6yWiJfPlwiVtlKzI6bx5s3CpE=;
	b=sPTLtXSAMt+gIlnzVQr8JAMAj/2oq0UOn6TfdCubBR9WZ8bnJIJMUOIOECMIJe1zs8fr
	 ZH2L+iohgU++GMBOzQ2T9g5yXFiPM0DpbPDhr8TmtCBi1vJ9Irhjg32xdDQ8wUpsiFm0b
	 d9g8OvADXOhY2/5ca2wH0mFxum6pvjqzkoj2iiCQYIfIWPy4/XPz71z3wMlN7ISSclstF
	 DZ41Eeict9h4n15ikfO3UDI4o527NozFgvl+3hDUx0wMDnCFB70JxZWUtOBs+Rl8Xjzxq
	 cTa7xSLtVecsYBWXQ0c8WQuIra4T+FMpXCJuJSBf78TLDMsZrNDnGM0c9Q7hV8aX+qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zkWyRrAE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93FA606A331;
	Thu, 19 Nov 2026 02:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zkWyRrAE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2260C1F000C4;
	Thu, 19 Nov 2026 02:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053910;
	bh=4vPyKnVXgJHADY5WNk6yWiJfPlwiVtlKzI6bx5s3CpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkWyRrAE2itpKNkaOZRkdZB1GQJ+kMFiTLSMezUwTgGye9nXmDUPo2OJjFx2z4+L7
	 y79foAaeWFe+8paYZhHlO9zJ+oq/OXbcdvYb4SAJJOacYetqON2IP12r3nL4ZXRpNJ
	 9buVJrQEN72MV2jkwxL0LAS0vObthWmR6rvYkCQo=
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
Subject: [PATCH 5.15 1087/2214] scsi: ufs: bsg: Clear the reply buffer before use
Date: Wed, 18 Nov 2026 15:46:03 +0100
Message-ID: <20261118150055.721701239@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the file location to the older UFS source layout under SCSI. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index b8bbfd81b8ae0..e27b059ae2d1e 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -95,7 +95,7 @@ static int ufs_bsg_request(struct bsg_job *job)
 	if (ret)
 		goto out;
 
-	bsg_reply->reply_payload_rcv_len = 0;
+	memset(job->reply, 0, job->reply_len);
 
 	ufshcd_rpm_get_sync(hba);
 
-- 
2.53.0



