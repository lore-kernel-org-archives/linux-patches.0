Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016033;
	b=SCZYJStq6xqlEpBzwMNSsJbFXjoPDA0TXBDcX7cig4L1eD/PXmNOP8HKU3jnF+I7AlRc
	 obJeg5/y0VBbJm34C2N58JvixMW20oW/u+yOfvEbWFWfjxEqKUKsGj+C3epgxiLsL8EgU
	 wmW6KDxHmBt4XWMV7OgVqDKaZL9/pIef/bvg2HuGUV+aZ5Pfs0X/WGRIBhPMz1+i9n2VK
	 V1HGIAaKXeNNQ++76DEGoRt+esfem1MV07OJZxxniBoc8Z2hkajfVOI1zTZ9q5Ba6ieT0
	 +zoACcRcXi1U58w5UIsSwa0rOPG79Kbr7AxHid3szS0UxqVwxN6PK0dBv+IpbY648/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qkxG1FjWZykd0NQSOwEX3cYTofsT8kUIRVfXNojmUlU=;
	b=Ecm694Byr5eakij9SJX7PgYd6zpKlmE8x+gfyx7V5gNFl6BrwqJzm512cWVTyduk16TV
	 EAHaerhob1OMD9mAGoPfDUJO5GhGS7TW95HsbmisZqXj7Sp7oyZ2usepZL/FgUTRzrj0+
	 sZqpIFydHwgnFsfcqk6swkwtLUCLnQPWwwOieKjmL/6VFxrT41yzUhqlmDjLrRn8O1/zb
	 vBlSew2cXXwk4FRw24m8NWRcik4oXVYQqqjgzfO5tzqxREKFBnR1952saE072bKjDLJqp
	 bY41/9ssr5sq2rEIcpLiIk3zFosTwukfwsJc03d1m073+xCIUMxDSOSMhzAjy2mLNzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRCZp8ss;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE42606A338;
	Wed, 18 Nov 2026 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRCZp8ss
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED971F000C5;
	Wed, 18 Nov 2026 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016033;
	bh=qkxG1FjWZykd0NQSOwEX3cYTofsT8kUIRVfXNojmUlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRCZp8ss1sW0J1SOjkY7AW+19fwEgn+1OhiYtG2iYZTds159+9wEljwSqgLDO87YV
	 MymPfoCIKnDZ97e5TSvaQB46e1rxU35tbthAQYc6dSR3njp05ozPwQ9AdmMJhdap4X
	 BWAsofRfz6BI4N+u5dJf7lKIMtRt7dCmdWYfslhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0344/2651] scsi: mpi3mr: zero out diagnostic buffer status memory
Date: Wed, 18 Nov 2026 15:26:24 +0100
Message-ID: <20261118150300.227723864@linuxfoundation.org>
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

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 052aea807cfbcefaf5b6ed8202f65da1fc65f4a0 ]

Memory allocated for the BSG diagnostic buffer status is not zeroed before
it is copied back to user space. Several fields in this structure are
reserved and never written by the driver. Use kzalloc() instead of
kmalloc() to zero out the allocated memory.

Fixes: 78b506984ebe ("scsi: mpi3mr: Add ioctl support for HDB")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-16-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 313688029620c..3751b30efea3a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1244,7 +1244,7 @@ static long mpi3mr_bsg_query_hdb(struct mpi3mr_ioc *mrioc,
 
 	length = (sizeof(*hbd_status) + ((MPI3MR_MAX_NUM_HDB - 1) *
 		    sizeof(*hbd_status_entry)));
-	hbd_status = kmalloc(length, GFP_KERNEL);
+	hbd_status = kzalloc(length, GFP_KERNEL);
 	if (!hbd_status)
 		return -ENOMEM;
 	hbd_status_entry = &hbd_status->entry[0];
-- 
2.53.0



