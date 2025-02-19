Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7661B85EC;
	Wed, 19 Feb 2025 09:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956514; cv=none; b=JDYut47/2oYnf9hQlihhiCQ+kKk1qHNQ2hy0Af26tiYdj4HAGa8UhE3dPnTUyEmSTwTaJ4h3rIgbpZNzEOdpM700deYzfkx1G34/6d4KVfDmMPqWNIz8D0Ni97DmDUsp1R3vuQLj6kTWyiaSwtITjbq7kQGO8ulZlPdszMWMwPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956514; c=relaxed/simple;
	bh=XdifSj7+YmIgWrdumQ+4BojIn6EY3iADZSUgoOXGe1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnnfKH67Ko9OCObYTQZQjX5IX66EcOKtDk6KezQLPsbzR27dyuRNV04drzAWwx9epx0LqoJZ6OKJF2x3HG0UlkH/mEfXQ6tkYppp/ZPDJbKUCIARTWGIupWuQxtB3sTszSFF+JbDzenqwRMw2vH4AeF0PQhnbIheUzEuyArKTtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdT2wz92; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdT2wz92"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF047C4CEE8;
	Wed, 19 Feb 2025 09:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956514;
	bh=XdifSj7+YmIgWrdumQ+4BojIn6EY3iADZSUgoOXGe1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdT2wz92ExOiCGnOh65Ex9or6TyK97DD1IKhl1eQgGzATCZDa3flg6Wm9p7ZyGikT
	 vzR8huz5bcRSFXwoycju2d8L2CjNz0Cbpj17LedEIZEj/J0hDiJViJLdeN7ytyq3xB
	 7Fb+DNaqxqmaaazixPdNl4VZT7U0U6NoChtimOwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/578] scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1
Date: Wed, 19 Feb 2025 09:23:28 +0100
Message-ID: <20250219082701.079893662@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5c13358416c42..b5a3694bfe7f2 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5649,8 +5649,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
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



