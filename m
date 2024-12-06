Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B0A1494A8;
	Fri,  6 Dec 2024 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497473; cv=none; b=fDfRmKVO2kx0iBYTbOcmgUyPLUYmdZ203sH/3dooRphwfOkPIFs8UDUNCiwErwOZ7I9D+jpIhNaomsD0FX6Z0evsSVVmIOZj4fk+u6NPLkIL8+VP/JwTsUeSWNCvgLIE7hkEUAqwDLIo6NF+3dHz7H0wRs+NVl+31VA4b1+A/vA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497473; c=relaxed/simple;
	bh=akEuo3MSoODPJyWeWipKRD90FIw6He6K43lxGgvTyaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nckKM6UJwu0i9lRM3gs+7lKUzOW5OkYpfSBYUbYIxm23cgjGPQOeFWVErfg/WrSp9g9vt1D8isoSRgoLWfHo4As9tSz2tok2L3osXmhHycgK1PAva2udTZdbicgYf3ORFdU9HWDFapMVn9V68psOp7UI9eQweAXDG0QQIokjotY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF/4M7UG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF/4M7UG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D75C4CED1;
	Fri,  6 Dec 2024 15:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497473;
	bh=akEuo3MSoODPJyWeWipKRD90FIw6He6K43lxGgvTyaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vF/4M7UGJ/IOOcgxfTSmB9dPnMKzk7dVJApYu2yTcC0E3IXW9NGsphLquN0EAV4Hg
	 7sHIUomuEE1lsMVXyt+xwLP85lBudid9NnikVjsL+tmvOHcYakN4kQU9Wxnlnt6eKn
	 bac+NfsAuSEbStQwDY7brg7N5gulgDBiPgHVUJMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/676] scsi: fusion: Remove unused variable rc
Date: Fri,  6 Dec 2024 15:32:01 +0100
Message-ID: <20241206143705.138764524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zeng Heng <zengheng4@huawei.com>

[ Upstream commit bd65694223f7ad11c790ab63ad1af87a771192ee ]

The return value of scsi_device_reprobe() is currently ignored in
_scsih_reprobe_lun(). Fixing the calling code to deal with the potential
error is non-trivial, so for now just WARN_ON().

The handling of scsi_device_reprobe()'s return value refers to
_scsih_reprobe_lun() and the following link:

https://lore.kernel.org/all/094fdbf57487af4f395238c0525b2a560c8f68f0.1469766027.git.calvinowens@fb.com/

Fixes: f99be43b3024 ("[SCSI] fusion: power pc and miscellaneous bug fixs")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20241024084417.154655-1-zengheng4@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/message/fusion/mptsas.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 86f16f3ea4787..d97057f46ca86 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -4234,10 +4234,8 @@ mptsas_find_phyinfo_by_phys_disk_num(MPT_ADAPTER *ioc, u8 phys_disk_num,
 static void
 mptsas_reprobe_lun(struct scsi_device *sdev, void *data)
 {
-	int rc;
-
 	sdev->no_uld_attach = data ? 1 : 0;
-	rc = scsi_device_reprobe(sdev);
+	WARN_ON(scsi_device_reprobe(sdev));
 }
 
 static void
-- 
2.43.0



