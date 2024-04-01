Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1573F8F4;
	Mon,  1 Apr 2024 16:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987834; cv=none; b=p76a3qknWa3c0q4Knwyar24HKO8pEtTbK+VUC2u6JD7TvvJefUdeKKvJ10uhOQZueHriOT0/pwdVnY8YBfxS4TbXTNYU0o6oHJECsQZ7hEBtQ0rptv399uw3KqxkopddmrDif5rsQ23MbUcrsq312kvYGEBnfnX/1TjInGxRQJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987834; c=relaxed/simple;
	bh=NuqnME6StwSRFQqITQc8EG4jhZ7+8RelgvT1ZPvxK4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6K0oiZcRGDztVkG5FQxKO4CVDAKwyXNX1TEGUQLplExBAU2immXvMFwYT1VOPpLfhPO8SNHv/2eW+SUwEdNorXzeoNW94Sj5u2HRrSYX+x5FncieDkZt9YBlBp22BtztDJgSdQNhc7sY2nwwAv4Mv3HxHHY3y3JVtfYaKykuNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qX38S8Cr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qX38S8Cr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A2B6C433F1;
	Mon,  1 Apr 2024 16:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987834;
	bh=NuqnME6StwSRFQqITQc8EG4jhZ7+8RelgvT1ZPvxK4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qX38S8CrXeKV5rCv7gCxJcjCu/qfWxckgRFuedv+Yug4fv3RrcqZ329tWSvaD2BS2
	 1WdWvLQ3os1OOQqqgYR8ojqLMa2NhpuIa3tjBxFZik23iBr6kxfB68J5BlL7Ll3lj+
	 RPGbd8dzOChqmElyZ9QtEZz+TdDiTqttqfBdcER8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Justin Tee <justintee8345@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.8 394/399] scsi: lpfc: Correct size for wqe for memset()
Date: Mon,  1 Apr 2024 17:46:00 +0200
Message-ID: <20240401152600.934642683@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1586,7 +1586,7 @@ lpfc_nvmet_setup_io_context(struct lpfc_
 		wqe = &nvmewqe->wqe;
 
 		/* Initialize WQE */
-		memset(wqe, 0, sizeof(union lpfc_wqe));
+		memset(wqe, 0, sizeof(*wqe));
 
 		ctx_buf->iocbq->cmd_dmabuf = NULL;
 		spin_lock(&phba->sli4_hba.sgl_list_lock);


