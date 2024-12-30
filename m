Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDD315E8B;
	Mon, 30 Dec 2024 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574209; cv=none; b=rPgUKWRPTN+fG8qm+ulTcr1U6f1McydglvcFDyoamuX0qr04ULd0YAsAERkt8aghxJirgnp4kLxeOcWNOZS93pto1d5ICWZZpHI4zMY91MfuARAa+EnAwLOJbDT1NPQ6KxjWrI+YvGHNWDp0fWd4oM/xbQ+ik8qjIQ5z+coSGDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574209; c=relaxed/simple;
	bh=pzTbLDdha45kJSBnweAJa0irnAfkyp1i8Ru2gFHqe28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvP5e2DuQhmYqB93LzDN+WL3k7bVj7wC67sAMLKGq95Jc72XtnBKPRkzcC/U4897uPhnsACM0pvK738uu5TkqdZZxK6gdvbv1hiOwdZDJVHRiwdJi7XlqX4nZskcDwOO8HCAih6pCIyl67dBlZbcIkZ4b6NoYm71f5HMCI87BJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CotT5/J0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CotT5/J0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEC7C4CED0;
	Mon, 30 Dec 2024 15:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574208;
	bh=pzTbLDdha45kJSBnweAJa0irnAfkyp1i8Ru2gFHqe28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CotT5/J0SIY8ScNXE97SBq+4X2MLJycO4tOR5TqUOErrrmHBKbYpYO/A5am53qPgF
	 XWkVIZbv5RV/nnlKjVssrulk168yD6bqwv/Ck9s1/6pGQJUswB6aXF3XHXKY2evIgT
	 s7z84xrH6Vu+kThuWOMyAsyJU0QUL4bAqCMbDoE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/114] scsi: mpi3mr: Start controller indexing from 0
Date: Mon, 30 Dec 2024 16:43:06 +0100
Message-ID: <20241230154220.754152477@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit 0d32014f1e3e7a7adf1583c45387f26b9bb3a49d ]

Instead of displaying the controller index starting from '1' make the
driver display the controller index starting from '0'.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20241110194405.10108-4-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 5f2f67acf8bf..1bef88130d0c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5215,7 +5215,7 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	mrioc = shost_priv(shost);
-	retval = ida_alloc_range(&mrioc_ida, 1, U8_MAX, GFP_KERNEL);
+	retval = ida_alloc_range(&mrioc_ida, 0, U8_MAX, GFP_KERNEL);
 	if (retval < 0)
 		goto id_alloc_failed;
 	mrioc->id = (u8)retval;
-- 
2.39.5



