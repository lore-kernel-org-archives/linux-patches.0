Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A3625EFBF;
	Tue, 11 Mar 2025 15:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706559; cv=none; b=q1guApsrj58XuZuCcQ+GoKyRU04x+epslO3vbk88Ck+UxHqiJDdiBtawjxZBlMqkI2omcW5p/Tsp09oIJf/OeimGM4bMqXJpRhV/oFe94Q0dcyKi/QRgEyWLSo7RhahmGEJcHDMXC9v3VPZw7W+THsTf1yO+Bndtes/0pp5dkbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706559; c=relaxed/simple;
	bh=1MZIIsqmTEBD/VpUTv2EzC3n8dHUIPVFEIsI4nc9N/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F69J7tLJLYG0P87DouNfjEuZ8mwmhQsuDQ1b5qF0rLob1UU112U5gQqXqlkyV4Fc7aZkDKetS5ZAwHRuP5U3a/qCAblI+HN2Kxurg+KO+v/PTOMeq/V00vanF+4tzsCRex1wet+PMdigrrSPX5WffVuFgWxJq3ITc2dMVFGp8ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnqIH1vK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnqIH1vK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02E2C4CEF0;
	Tue, 11 Mar 2025 15:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706559;
	bh=1MZIIsqmTEBD/VpUTv2EzC3n8dHUIPVFEIsI4nc9N/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnqIH1vKPJPcaG0UOoKEYdnhv0zavS/QGUhEd93+LfRc53AizjxTwY5wDKqyNHHVV
	 K2lY/0p0fJ6Ga4EE4XPi59talFBTxsje8zVWoBhQOzgufvXn5HSgnUn294azZZ0RbS
	 FX7sq64kd1e4JPZWZhjbzNb+qfg8Qk17vJLw0plY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/462] scsi: mpt3sas: Set ioc->manu_pg11.EEDPTagMode directly to 1
Date: Tue, 11 Mar 2025 15:55:56 +0100
Message-ID: <20250311145801.909172360@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 768635de93da9..78b178aa46e94 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4771,8 +4771,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
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



