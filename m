Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A95E30CDA1;
	Tue, 11 Nov 2025 01:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823710; cv=none; b=f2iONYRO3U8R3RfbbF+fK5ygLK4IKNBmv/4BeHx3i4Yg2LW4MwchXKxX0PP+5orhJQPWC3ZVZadaYnVMT83mxCW5sCfAv69t6AK2KP34/QxxqiwT7eXQnqK1sVyf8+F+2U41zHBgdntkI85NSfswy2tpBcFcBG47y89EWb0EaLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823710; c=relaxed/simple;
	bh=ucHYa8wtLFXonw02IiikSKNlPqM1U7Y8p2LAKBAgCB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYa75NjrYgY0S7eEHl3FkWIIxWavT2YLyDOYOoRp6UzuNDh16hyXq6meV9GjpKnfgfjI4hjcURJyYm2m5CqAY+6FYgIO4AODVGwbb4MjqbsoTIYs1o9QbozoXScv0Zn0jcNMa4GV/lM5rAxuw3ED+ku84WoPDUOv7269S0x0eoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTI6Uk8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTI6Uk8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC83C116B1;
	Tue, 11 Nov 2025 01:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823710;
	bh=ucHYa8wtLFXonw02IiikSKNlPqM1U7Y8p2LAKBAgCB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTI6Uk8C9bOmd7Ld9PGDE7JFAu+0Kt3qh7YeIZKq3g0sLEjq4DSBmmHD+Ke55hUeQ
	 fwlvA1sdE4pGkcs8uy1Thw8M6XvGfw/4SyIlDJhqeFi82I7WuqxS65U0JRjR8JBygn
	 6DRNy9jPH0AVh3XnqJnnNaR0cIhBubTbJs63yxgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/565] scsi: pm8001: Use int instead of u32 to store error codes
Date: Tue, 11 Nov 2025 09:42:14 +0900
Message-ID: <20251111004533.134124674@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qianfeng Rong <rongqianfeng@vivo.com>

[ Upstream commit bee3554d1a4efbce91d6eca732f41b97272213a5 ]

Use int instead of u32 for 'ret' variable to store negative error codes
returned by PM8001_CHIP_DISP->set_nvmd_req().

Signed-off-by: Qianfeng Rong <rongqianfeng@vivo.com>
Link: https://lore.kernel.org/r/20250826093242.230344-1-rongqianfeng@vivo.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_ctl.c b/drivers/scsi/pm8001/pm8001_ctl.c
index 0e7497e490f40..34cddfdbc22f8 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -682,7 +682,7 @@ static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)
 	struct pm8001_ioctl_payload	*payload;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
-	u32		ret;
+	int		ret;
 	u32		length = 1024 * 5 + sizeof(*payload) - 1;
 
 	if (pm8001_ha->fw_image->size > 4096) {
-- 
2.51.0



