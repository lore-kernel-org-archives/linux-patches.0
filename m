Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21498522A;
	Wed,  5 Feb 2025 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765821; cv=none; b=pT9lz8kl6mgTltVy/lkRWAGP2pxBgy5Mh+eoHYqVns0nSkL40JhFJ+2W1Jww/aZrUyiVxtERj501xgLNuDX4KUdZulJi9Rz05gTQNsAu5IkbY4R77E+9ENQ5GsvO0f8h2yedR5jouliWBUO0yezLk50vzXWtMxvqYfkBtDkqjjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765821; c=relaxed/simple;
	bh=vZsbIRAmu6yMqgJbxxJxnPgwXoeE+3hMH1O+tQ9DlQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhYctd9YuLLFHqRwIjUg3qsl+k9x9/BG5fQHZZwa2Yl45VEd3q0+06TybeKkO8BJASWXYrjSvBBYF4Qm4p65D/RvOHpfh0oPwmbcRe5qXO+9MJgJUIW9zmQUHEKOleT7wPTKT3TVto/kTqVFjK33Cz32Zb9BTFZ8mDKZ30JwLeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yS2zX+lR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yS2zX+lR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8493FC4CED1;
	Wed,  5 Feb 2025 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765821;
	bh=vZsbIRAmu6yMqgJbxxJxnPgwXoeE+3hMH1O+tQ9DlQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yS2zX+lRXbJuBv0DXxGBBHHraj7fPZjIO5f63nmsthSf/5a+e7IA06vaGCNqP8v+v
	 2y8XuFwFUSUOCuQPoAhIp5q+pi7XronE0OGunUrx29rv+hJvho/6w43DYQpKZLh2c5
	 VKk25lHbgdJM3IkFotX2NbCe1/rpG3Ok2dZQwMCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/393] scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1
Date: Wed,  5 Feb 2025 14:43:42 +0100
Message-ID: <20250205134431.904931771@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Menzel <pmenzel@molgen.mpg.de>

[ Upstream commit ad7c3c0cb8f61d6d5a48b83e62ca4a9fd2f26153 ]

Currently, the code does:

    if (x == 0) {
    	x &= ~0x3;
	x |= 0x1;
    }

Zeroing bits 0 and 1 of a variable that is 0 is not necessary. So directly
set the variable to 1.

Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/r/20241212221817.78940-2-pmenzel@molgen.mpg.de
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index a5d12b95fbd09..cd00f19670355 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5638,8 +5638,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
 	if (!ioc->is_gen35_ioc && ioc->manu_pg11.EEDPTagMode == 0) {
 		pr_err("%s: overriding NVDATA EEDPTagMode setting\n",
 		    ioc->name);
-		ioc->manu_pg11.EEDPTagMode &= ~0x3;
-		ioc->manu_pg11.EEDPTagMode |= 0x1;
+		ioc->manu_pg11.EEDPTagMode = 0x1;
 		mpt3sas_config_set_manufacturing_pg11(ioc, &mpi_reply,
 		    &ioc->manu_pg11);
 	}
-- 
2.39.5



