Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5D8145FF0;
	Thu, 11 Apr 2024 10:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830815; cv=none; b=SlkZ5oWpmEWpQyZ8THtVIrCRScuEladPb4xqOCUzocNVoUw1r+ryibA6gh54joKyW/YmCGA5aANpxkqKzmpZVRzr4EOyF4aK6W0DfBZMrxQ5OzM1uYrOit/Ic+W2ijNEOvaB3IhdUgBytTTVdeBt+PGzCLtuVDqMoT/mME8O2p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830815; c=relaxed/simple;
	bh=vdJHy9lK7o3gU2f3a2LGqDqSustPpV6W7NLpi5SDZR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYQc33eO5vUna/835DS9ksakruUX1ASVP0NnJWTs/9FlmtkvMj7p3T4RnbvblN3Qb8iey2xwN5csJ+Gmldia3FUeKSWdBjsKnTCwdbUjMmmQGiT2OsYbwrAf+G9LySs69e+v8Enk8RmZixNXQT/sirJyWS9yU3t/+D/t+2EZ4UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OLH8XyZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OLH8XyZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C7EC433F1;
	Thu, 11 Apr 2024 10:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830815;
	bh=vdJHy9lK7o3gU2f3a2LGqDqSustPpV6W7NLpi5SDZR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLH8XyZmp4U4riA8k5HKLLqCfJrlgxYUKZBPSd7UvwCq/2Ezve4RcHMrLapoqREJH
	 LIdJjtzvhS3m6t2i1QDGSc5HhOmTXBge8lqkgS4OdtcrC2nxv5mvWlYBRiu8ruW7Vt
	 eZmLwCN+/MC7KsjCrusXY2WmwEh/EtVKrjyASJVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Justin Tee <justintee8345@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 127/215] scsi: lpfc: Correct size for wqe for memset()
Date: Thu, 11 Apr 2024 11:55:36 +0200
Message-ID: <20240411095428.713672516@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 28d41991182c210ec1654f8af2e140ef4cc73f20 upstream.

The wqe is of type lpfc_wqe128. It should be memset with the same type.

Fixes: 6c621a2229b0 ("scsi: lpfc: Separate NVMET RQ buffer posting from IO resources SGL/iocbq/context")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20240304090649.833953-1-usama.anjum@collabora.com
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Justin Tee <justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_nvmet.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1392,7 +1392,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_
 		wqe = &nvmewqe->wqe;
 
 		/* Initialize WQE */
-		memset(wqe, 0, sizeof(union lpfc_wqe));
+		memset(wqe, 0, sizeof(*wqe));
 
 		ctx_buf->iocbq->context1 = NULL;
 		spin_lock(&phba->sli4_hba.sgl_list_lock);


