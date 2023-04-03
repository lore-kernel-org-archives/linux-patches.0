Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101E55683
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:11:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEB9C433EF;
	Mon,  3 Apr 2023 14:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680531118;
	bh=doUINzl8CjaZfid4C522zUPd5p8Wyavp513+b6Q7ulY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=il5+Jc5d8XqwL547qAM55R2OgNSSS6H+uAPVLmJMqTRGKPwJkJGhbNL8kOg+Qt4GZ
	 JsKoPLGrWKrJU4INyXrrDzcxMosqzcWfYNxvjc+8L2nNVr0gmVLwnAtn6pbKug8sOR
	 nBHb4hVPVGNcVLj6dRnuilireHprT3iojpFr9VVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrien Thierry <athierry@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 27/66] scsi: ufs: core: Add soft dependency on governor_simpleondemand
Date: Mon,  3 Apr 2023 16:08:35 +0200
Message-Id: <20230403140352.880817701@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140351.636471867@linuxfoundation.org>
References: <20230403140351.636471867@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Adrien Thierry <athierry@redhat.com>

[ Upstream commit 2ebe16155dc8bd4e602cad5b5f65458d2eaa1a75 ]

The ufshcd driver uses simpleondemand governor for devfreq. Add it to the
list of ufshcd softdeps to allow userspace initramfs tools like dracut to
automatically pull the governor module into the initramfs together with UFS
drivers.

Link: https://lore.kernel.org/r/20230220140740.14379-1-athierry@redhat.com
Signed-off-by: Adrien Thierry <athierry@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 694c0fc31fbf7..fe7db66ab1f3e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8087,5 +8087,6 @@ EXPORT_SYMBOL_GPL(ufshcd_init);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
2.39.2



