Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACD52E5B36;
	Mon,  1 Dec 2025 11:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588507; cv=none; b=WxaenhNO7S0Le3ZzsHmNHZDqehFDLyCggYSo7Uq1485adOsBSl8nvzySAD6v5ERmRAHzW7rVn05E21ZqjQSscME8zuOLi2g0R1qSchv7Sr4sTe974B2Rv87eCDZoMgvfrdOm/MZ6GgATvQ9wKPST21+U3TgzAwRNnheUoS2/nkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588507; c=relaxed/simple;
	bh=9A82KLVmlQ17BIpFrHA8PPcTElDhLVp99xM8TqnNTtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPAmcELazCS1uezxJyGTrRPCDC+cczWeHRLQlK2J3gyz+53zp8k/Q/Bu/RuuSuew0QrhLmHt7R9aekR7K15I+DG7ZaHv/0lfMYp87DxyBaUSfqCXk8rpso3oNq7rbtIYOz3mFxZ6z6yaUufsqBPkG8NRodWhyySVGhWkWGmkuXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpZZk7GR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpZZk7GR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C3BC4CEF1;
	Mon,  1 Dec 2025 11:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588507;
	bh=9A82KLVmlQ17BIpFrHA8PPcTElDhLVp99xM8TqnNTtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpZZk7GRjR5iT6yljqzq3CEh+0QjTT0+CBxM2qI6bdstuthD1mR8nQSr+TI2xX6eD
	 MvhsBB1JFDeXqPMTzSILMcgHO0R3xy9dVpS+X2WUjU6KM9evN9qJOKgDGQEpvQWuS1
	 UM0AtdvqSEkWUVYklwmwEgyzATsXTsJpyMSuQdWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 072/187] scsi: pm8001: Use int instead of u32 to store error codes
Date: Mon,  1 Dec 2025 12:23:00 +0100
Message-ID: <20251201112243.837194960@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 6b85016b4db36..4aace2c34f062 100644
--- a/drivers/scsi/pm8001/pm8001_ctl.c
+++ b/drivers/scsi/pm8001/pm8001_ctl.c
@@ -596,7 +596,7 @@ static int pm8001_set_nvmd(struct pm8001_hba_info *pm8001_ha)
 	struct pm8001_ioctl_payload	*payload;
 	DECLARE_COMPLETION_ONSTACK(completion);
 	u8		*ioctlbuffer;
-	u32		ret;
+	int		ret;
 	u32		length = 1024 * 5 + sizeof(*payload) - 1;
 
 	if (pm8001_ha->fw_image->size > 4096) {
-- 
2.51.0



