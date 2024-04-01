Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602A821105;
	Mon,  1 Apr 2024 17:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991447; cv=none; b=m6m3eb0RvUaSSupFjUhnvL5lb3TwZPHCjOl/EAy6C2KC6AT9m4h4UGagPEBHY1vESi1J9rcx3QaiytHVTrYAM1i0U875cBuDJhql9doXRFRI6pCLh+u88AMC5lv7HY187LsYqd8Y9O66vP4TpU0Q4ddE1XwzQyJPtJGp4R/d3+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991447; c=relaxed/simple;
	bh=ueJiPpwlxA2ccuk1g5/3W3d+WLm+UlAY089aj08Ker8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9BaKAMMeVbVvKVdUwSf5mHdQ8ShMMARc2d9vI3eDhNvJOKJznQVf/xJnl3QlRHOcjpVpQppGtpzQgaRikjhjSjVLXITzIfFNTYGCuJ4inMu1GEpc12fMzFXPsySL6JLaKanZj0XTh7ha94U3oBvnJ04DO0xJVqv+uiRFVEi7K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WsYPKZM0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WsYPKZM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5E1EC433C7;
	Mon,  1 Apr 2024 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991447;
	bh=ueJiPpwlxA2ccuk1g5/3W3d+WLm+UlAY089aj08Ker8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WsYPKZM0naD/E3rkKAKZOz8rQr5OyX3OSxaAGx3c7XHh+9gi60TYDKg8r17uFVtCB
	 cQHqj4xfZybv/iEG15GtHR7PpIA2koAjoEc9y0rPmY4b+HFZ35uI5D1J+AwTLGU0nX
	 odqwFO6v5Z1rCvLUSD9Ys1mYjHT87rPnOPXf0IGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Justin Tee <justintee8345@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 267/272] scsi: lpfc: Correct size for wqe for memset()
Date: Mon,  1 Apr 2024 17:47:37 +0200
Message-ID: <20240401152539.409553116@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


