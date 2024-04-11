Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C891422C4;
	Thu, 11 Apr 2024 10:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829806; cv=none; b=rj2c6Xli3zSD0PwsZ4PdLSUU0SfUMVrwwbpfvF0LaHUAsdnosnG8KvHBXdc+NJYan+kWydHfsBgSIGr3aOHDGUSUQ4JC58UUAdLiQ8RU7V/sMTyu6lx8AyFBcc/SCx3fWACToF6LTA08uoq3gVfwbM8F7XFciMxg46zhc11N6dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829806; c=relaxed/simple;
	bh=lFyKAFvtuoGwD5wM0KjDQUoW0sJV5fI9cGr/sVB3jRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8FzmMmB3hquw2LXeM1yVbLktoS4v5MB3ZqowquKtWWmgkfeLTZZIAizZHYfIJ0eS0pqtrlvQbFvWMnLw3I++DO7eo0LaOWMdN0rCPyRIBwFm3o5WLu31iIhl1bbs64Ojqwe1hkYLbxWd7+4DyqfXarLfXAxLaYw7gVhF8G3HFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TSanq3u5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TSanq3u5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681B2C433C7;
	Thu, 11 Apr 2024 10:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829805;
	bh=lFyKAFvtuoGwD5wM0KjDQUoW0sJV5fI9cGr/sVB3jRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSanq3u5rZRc/sxKrWeVBLVAzZV3SSepNU8CtcBYH26J5W5QhWp9jRrv1HqMtKnkx
	 vSDw2nH85eUCGjNsH1ZI2rfQauxPjeb5EOpEBYVe+a1p4vrLSpnvCvU1L9ad5emcSX
	 yBZwxj+OS4E2eSGJO2hyJpX8w8x0Djh2SsW7FwWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Justin Tee <justintee8345@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 110/175] scsi: lpfc: Correct size for wqe for memset()
Date: Thu, 11 Apr 2024 11:55:33 +0200
Message-ID: <20240411095422.879470722@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1308,7 +1308,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_
 		wqe = &nvmewqe->wqe;
 
 		/* Initialize WQE */
-		memset(wqe, 0, sizeof(union lpfc_wqe));
+		memset(wqe, 0, sizeof(*wqe));
 
 		ctx_buf->iocbq->context1 = NULL;
 		spin_lock(&phba->sli4_hba.sgl_list_lock);


