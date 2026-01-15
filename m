Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 907D42D94A7;
	Thu, 15 Jan 2026 17:44:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499044; cv=none; b=pFjaWpswu0qlYBPs+25fkDsdo7cRHsL5qPMOdhhUyw91zgCw8rIxM7d0RVcNhMvA0hixd7Z5v2giYAZOCyKrLj/AE2YzRm8pu1nugcWwaUECcHnEsAz0m4ghcd95d05LWj5qntHDiKwlyppS7+IYEKo5XmEnnkqYmCtsVnN3tv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499044; c=relaxed/simple;
	bh=g0PI9fkUmBS6D2iRkLjqFnQZEXNSgPe/M/cmYOLfyts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9HK8ejDmINvOa3uWac/x6ow2SGVwox4DoFUAASRbSB2aHRFXl1xUkROVFHj8MYoV28Hkj5uneJ778SxPO3kfpSF7lMHQFhtH58cbLhlbMjXVOP0sagI7cUNOb1dxdiBROmgnmbMl5b0CDN2z+/3oEHEiZxSMy88YJjFoGV27zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xbv3VLj2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xbv3VLj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2316C116D0;
	Thu, 15 Jan 2026 17:44:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499044;
	bh=g0PI9fkUmBS6D2iRkLjqFnQZEXNSgPe/M/cmYOLfyts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xbv3VLj2hlGOfOIxkyatCkrZ3XmIzY4B8S6LK2EtQWQhW8jzi946JrpFma1kwjtDC
	 uKtcG4+bWvFKAdXw1MvWf6YvMUCi6cop1tFWRdfdR8Ecj6b7pua42ZZeENs5XCsnmu
	 atnHWJQ8bQvrgOtzp40a3+4jaNHiElaaU97aYIJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 055/451] scsi: target: Do not write NUL characters into ASCII configfs output
Date: Thu, 15 Jan 2026 17:44:16 +0100
Message-ID: <20260115164232.890241310@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c03b55f235e283cae49c88b9602fd11096b92eba ]

NUL characters are not allowed in ASCII configfs output. Hence this
patch.

Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20251027184639.3501254-2-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_configfs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index e6996428c07d2..182a89ecc5428 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -2635,7 +2635,6 @@ static ssize_t target_lu_gp_members_show(struct config_item *item, char *page)
 		cur_len = snprintf(buf, LU_GROUP_NAME_BUF, "%s/%s\n",
 			config_item_name(&hba->hba_group.cg_item),
 			config_item_name(&dev->dev_group.cg_item));
-		cur_len++; /* Extra byte for NULL terminator */
 
 		if ((cur_len + len) > PAGE_SIZE || cur_len > LU_GROUP_NAME_BUF) {
 			pr_warn("Ran out of lu_gp_show_attr"
-- 
2.51.0



