Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1877E78F;
	Mon,  8 Apr 2024 14:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584930; cv=none; b=oOF+Cifa1JP9p2FtE7D+hDahL4gQlckdNaqbsTR4Eq5J8mjB6L20zUIwN8Ut1gttvLwP5BZ1tc9CMmlqfWlKwGB3dsuVu42o/f1x2ZJlPr+Sq+3vCTjPLeilIXewk/iiLjKVyiE3ufsCHCmEEgkT5zYcwrlRn6hn9jEXoyMVkxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584930; c=relaxed/simple;
	bh=X8RRAQJFwp9wBtLNBTGGcy7SdC8QrPL74FY3fOJE+KU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+2b8L5uFOjDuxwC7DRyeDGobAKf8n3P/yNaCCRLLeJB86sERrJrZGwyZNAHGMvV2Rzoaf1x3Er4YczG4RCPnzCwkvajFISNwWZkiv5Vzshd6gJ7AmM5piGcutNlAljwBS2MxW6LyjJqbxLIRQsPWfbZmtz8FUCh45dRZKOlScU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1E8581Vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1E8581Vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C02C433C7;
	Mon,  8 Apr 2024 14:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584928;
	bh=X8RRAQJFwp9wBtLNBTGGcy7SdC8QrPL74FY3fOJE+KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1E8581Vd6jLC5uQZ1Q1G9oW+t6rAaNOSiXN31oCibqRiS7nxhvNKEZlb3E/Iavn9N
	 +nSQQIgCejuuWymWxoXRhf6qvieTc4YIcJC7ke74xYNQS5uXt9f/jHlMoz2Zs/KpRK
	 YF/JkCxD/UT/4ST4FH3fs6pDEdxK4PceTIsVIlTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Justin Tee <justintee8345@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 604/690] scsi: lpfc: Correct size for wqe for memset()
Date: Mon,  8 Apr 2024 14:57:50 +0200
Message-ID: <20240408125421.484826541@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 
 		ctx_buf->iocbq->context1 = NULL;
 		spin_lock(&phba->sli4_hba.sgl_list_lock);


