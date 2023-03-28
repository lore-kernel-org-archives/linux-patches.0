Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074D98BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB6AC433D2;
	Tue, 28 Mar 2023 14:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015040;
	bh=RYcBC3HBCCiDMVGylYrnYO7ODSvG3f9DOUuc91ts324=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6LVN5Nitjfiei46iFx+eBChS/5W8SLwPimJ1b3cj/mkecIRBBO4OfPNdBV7n7B2T
	 rROYQ5JPIuQAkILJmtHET4zArp6NhL7mAW51Fy8Ip4ksgZLWoA6G9I5JUoLlAIxXDR
	 MbXnfLVvVhyK2IRCqaqTOb5sBLu65HAzX3r3uNhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrien Thierry <athierry@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 145/240] scsi: ufs: core: Add soft dependency on governor_simpleondemand
Date: Tue, 28 Mar 2023 16:41:48 +0200
Message-Id: <20230328142625.762974503@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
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
 drivers/ufs/core/ufshcd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d7fa053a78965..0fe72ddbff64a 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10110,4 +10110,5 @@ module_exit(ufshcd_core_exit);
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
 MODULE_DESCRIPTION("Generic UFS host controller driver Core");
+MODULE_SOFTDEP("pre: governor_simpleondemand");
 MODULE_LICENSE("GPL");
-- 
2.39.2



