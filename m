Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC2B9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:39:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4309C433C7;
	Sun, 13 Aug 2023 21:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962786;
	bh=r6xxFqHXQKdczOMH3cyrcoDiHV/QrNJ/yfoHFoe8hCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzGdrU19mzWdKWYTuchojSLvVultHEMUgjM4W87VDFTOh9dlV0Dwr3C7ktS+Vwf+2
	 gi7cPbbedUHkKU7zwF6E3NGcycuzVp1ESDSU9JCa8gO50bXTeR+zeCALS74eZEz+8w
	 DN88noeuY0fhd9V4KtQZI7AYdu5gD+CDmyoge8hs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 138/149] scsi: ufs: renesas: Fix private allocation
Date: Sun, 13 Aug 2023 23:19:43 +0200
Message-ID: <20230813211722.840205824@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

commit b6d128f89a85771433a004e8656090ccbe1fb969 upstream.

Should use devm_kzalloc() for struct ufs_renesas_priv because the
.initialized should be false as default.

Fixes: d69520288efd ("scsi: ufs: ufs-renesas: Add support for Renesas R-Car UFS controller")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20230803081812.1446282-1-yoshihiro.shimoda.uh@renesas.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-renesas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ufs/host/ufs-renesas.c b/drivers/ufs/host/ufs-renesas.c
index f8a5e79ed3b4..ab0652d8705a 100644
--- a/drivers/ufs/host/ufs-renesas.c
+++ b/drivers/ufs/host/ufs-renesas.c
@@ -359,7 +359,7 @@ static int ufs_renesas_init(struct ufs_hba *hba)
 {
 	struct ufs_renesas_priv *priv;
 
-	priv = devm_kmalloc(hba->dev, sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(hba->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 	ufshcd_set_variant(hba, priv);
-- 
2.41.0



