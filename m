Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C97C010A3B;
	Mon,  1 Apr 2024 16:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989258; cv=none; b=YBqRCgwVIxGBRyF2UKmAmo8Vrpk1uCONrTPrECHhj9xZJRgyizrZOv7a/Qawj6NZGATlsyXjLo64Uti8JcE42uKNh2MBQ+GCGxms/dt2x/aZqD+BgZ1ZhkEtrFcNygr4us3jgSb2rC6ADUV8fnncWYnwyE6ulmq2MScX9ZlgJjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989258; c=relaxed/simple;
	bh=H82MKDHLj3IGXUwXKncJC1Ec0Iv0Sa3UGFzL6IboYC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4wSAwP7LfR9kKrNoW4cSfDJcj41eerVmviIsZHenpVXp7YPHt6HJJj7jkmtT8KafMYeM5EtVDw9QhUAbuT2TXxBMT78Zc3xYTow6B3FflcvVhjrjYN17N2Obz+c2QjICJ2IKSH1FiJzGu4N5Ao89AVlEp8nIGOdU3F+Nidc2wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eauh8XSk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eauh8XSk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 334F4C433F1;
	Mon,  1 Apr 2024 16:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989258;
	bh=H82MKDHLj3IGXUwXKncJC1Ec0Iv0Sa3UGFzL6IboYC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eauh8XSklzA5QY+KZztJx5x/jGattGuT0ZK67qMGxLpaCD9CPgpO6oZ2mW/cmJUhs
	 8t+DRG9YVo6WoF6VJNyDK+gzLPMGAQW+a3eRPwV4fQk6J56u+ZdNYuC0oY56AiAc3c
	 d9wYa64nBxwnpIUxoI5hr6i2GBrfLifa0fyVGejU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Justin Tee <justintee8345@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.7 429/432] scsi: lpfc: Correct size for wqe for memset()
Date: Mon,  1 Apr 2024 17:46:56 +0200
Message-ID: <20240401152606.243103602@linuxfoundation.org>
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


