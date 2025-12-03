Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4D2313E3B;
	Wed,  3 Dec 2025 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776251; cv=none; b=Y8DP5rm1RJNgj4Y1fQ5uCBS5DJnS7PMWMWzqcJ6dA3CB5mTl6SVQ0IZQj5dRVt4ohkUp/xa81m8vAlvBsuVso5EBEQJFgb3qCPfxI6XYZg9cMYyLIDlvyqGdpyCCfkELGMWwjVqGVeJhOBW/Ufh2Cp/VQ2Yn1zga01k9b3h3DTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776251; c=relaxed/simple;
	bh=+CMzH91dEfo3ValNiNOwbcucJUMFsiz39MZar8G1dUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9G4Rsd7u8bPMvxyb7osbNvpmGCu4QZzFhFhGv1wu3btCcJBkBvkGeqBIugjXJeyfA5DTFb0NeJxu2oJfpxle3wu0s5CikDsuf/Ctppcvc68mX+Ftw2iXzd+KSDoSYBUTopZArA+E7G2ttmwNlmfR26QeZ7HwLCrAZwCshygxGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c2xKV2bt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c2xKV2bt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50DA9C4CEF5;
	Wed,  3 Dec 2025 15:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776250;
	bh=+CMzH91dEfo3ValNiNOwbcucJUMFsiz39MZar8G1dUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2xKV2btfIZx344CcubQCtb5vRnrMjUt1XqaUjve4FQ1qmlFH1oUPi5S48+l5C0HB
	 G57zwtV/cfDnoxRQ4S1zalJSNyqUtDB98jMkBW5f/sbCgYgeCGwhF352RsKiYQNbkv
	 hTArJ0V2/9jeBuoQ1FZyW/JD0dnkLBS+7Q3a/14o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 099/300] scsi: pm8001: Use int instead of u32 to store error codes
Date: Wed,  3 Dec 2025 16:25:03 +0100
Message-ID: <20251203152404.292230608@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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
index 9c117e4e7f5bb..d5d5965fa7a0e 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -683,7 +683,7 @@ static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)
 	struct pm8001_ioctl_payload	*payload;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
-	u32		ret;
+	int		ret;
 	u32		length = 1024 * 5 + sizeof(*payload) - 1;
 
 	if (pm8001_ha->fw_image->size > 4096) {
-- 
2.51.0



