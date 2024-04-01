Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2AB3613C;
	Mon,  1 Apr 2024 16:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989251; cv=none; b=Jc5zRK+sDv0Jweym/N4Anui6G6XV7Ymj3DUdifdsXvensCA8sxFurmjW328h/vB5KGPit6RZi8NxAFt51H+sC54w9WAIFAl6XJZnbl3y2Pv5rKdrNTX6Ap7yUzcWFS05qJDldgcxOZ4D63SxE6lTYPHQoknDPlPLXXGgC5fdQjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989251; c=relaxed/simple;
	bh=EsYi+bLJNIVo2k9CrfafN58dmAFY6CdRItgniV72Nrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G+44UWcpYNE7OdbQJRLQEnol06SN2JIihPfmSwOiIsICzjerv6/aI3cVZWXOvGNePSeQtWKL0Xe/HyC3ZfAiJfct6LVrw14S1jmUpaFJEvXzrPNC/eOTH5NQbe3GEYZxtbAGJGcpH7wt5SrQOaAJnPXPgXkPZoUg3fLHN+in/uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtS/IoeW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtS/IoeW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B87A6C433C7;
	Mon,  1 Apr 2024 16:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989251;
	bh=EsYi+bLJNIVo2k9CrfafN58dmAFY6CdRItgniV72Nrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtS/IoeWQqvk/rg8B66QFxbqpuc+U39zoAq3XkWbb79lpZLMZSbVHmPjIW+5gakXJ
	 AP4B79n0ab96AdBLqmRKb/qsOSry5UL+oDAZ8xiBHFwlV6YTInP9NaG78ZLD5Gg+sa
	 2w5legKJPwgyptT7OIMeYAV4MoREyAaIqHPNB+dE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 427/432] scsi: lpfc: Correct size for cmdwqe/rspwqe for memset()
Date: Mon,  1 Apr 2024 17:46:54 +0200
Message-ID: <20240401152606.168895094@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 16cc2ba71b9f6440805aef7f92ba0f031f79b765 upstream.

The cmdwqe and rspwqe are of type lpfc_wqe128. They should be memset() with
the same type.

Fixes: 61910d6a5243 ("scsi: lpfc: SLI path split: Refactor CT paths")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Link: https://lore.kernel.org/r/20240304091119.847060-1-usama.anjum@collabora.com
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/lpfc/lpfc_bsg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3169,10 +3169,10 @@ lpfc_bsg_diag_loopback_run(struct bsg_jo
 	}
 
 	cmdwqe = &cmdiocbq->wqe;
-	memset(cmdwqe, 0, sizeof(union lpfc_wqe));
+	memset(cmdwqe, 0, sizeof(*cmdwqe));
 	if (phba->sli_rev < LPFC_SLI_REV4) {
 		rspwqe = &rspiocbq->wqe;
-		memset(rspwqe, 0, sizeof(union lpfc_wqe));
+		memset(rspwqe, 0, sizeof(*rspwqe));
 	}
 
 	INIT_LIST_HEAD(&head);


