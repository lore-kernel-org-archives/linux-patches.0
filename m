Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5926E147C7E;
	Thu, 11 Apr 2024 10:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831951; cv=none; b=Cr9ADdDzAvErcxRinXFnwIOEo4rOtQIJbYLSpSIkHi/ZQtz/jR+mZLt2YK0XB1apCBRYBALm5BtvpO6ni0Qi046kcoYPbUuR9ygdITpXPZkoGIqn7Xyl1Ba68gV5Ugs/LSFQm1hfu+VLG3dHMRHj0VROA+7Y0VD6vUqssDrIYsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831951; c=relaxed/simple;
	bh=H2ef0z2Sanlu+KNdMWrnGdMX44lBLMQjU18L0JfcK2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBn1kVUUUMReJdJFEQp5g7zSeZpLh7wCiZzJO572VR11RaKHQvUPVJm0LaCX7oh+KPBJmA6EawobizI/fRzynqYnNKxI4HDoYOfG074evSRLuTn0Mv5FRNMXmgf+lwpjqg1xw9+sM4WqiTqdusr+8QZP8rhieoE2vA8RyngFhGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xs9Ci3Yp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xs9Ci3Yp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB9B5C433F1;
	Thu, 11 Apr 2024 10:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831951;
	bh=H2ef0z2Sanlu+KNdMWrnGdMX44lBLMQjU18L0JfcK2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xs9Ci3YpBQIqkCGwzxkbmi9bxT7vfGdj8Uc8ZlM8InULT2ihwVY62yIYwyVspfwJZ
	 DOm6VX5EouEKM/rCdKN3nRLKIS2E3JOLkyp17dBSrt6m06DOsoDi5WmqS0BO+Iwp89
	 OX4HjR7IW+8HBR14PhxRrSNuPSgTdAlYov92GaTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Justin Tee <justintee8345@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 180/294] scsi: lpfc: Correct size for wqe for memset()
Date: Thu, 11 Apr 2024 11:55:43 +0200
Message-ID: <20240411095441.043447176@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1579,7 +1579,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_
 		wqe = &nvmewqe->wqe;
 
 		/* Initialize WQE */
-		memset(wqe, 0, sizeof(union lpfc_wqe));
+		memset(wqe, 0, sizeof(*wqe));
 
 		ctx_buf->iocbq->context1 = NULL;
 		spin_lock(&phba->sli4_hba.sgl_list_lock);


