Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1111729ACCD;
	Fri, 21 Nov 2025 13:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732596; cv=none; b=Jsic1o1lhBABKtMXWAp2u+05RIFV+NF0kK7Mr9H5dHm9FaxyvOonnbzRdfs2OXV395GF5TGhwWbil582gTdmvprNcWtZKgB0OYRSSv1cpqayRuiZDLrUfiInSu5k0ACRikcCKfRP9W+1EjWJ2Wow49F/SFtLzz6AaYb10IzqAmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732596; c=relaxed/simple;
	bh=dskfT72203DxGUZrSgn7eFt5npZaOIcQqKodH3YxxPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1YtgXf88ms+J/niCElVSyD+2GoWQscMdDFfltZ1gqUViP+Q/UnO3CIOu5nobz0C1w1vHrF00bk/JvCXEMe3zbHqtOaYY4nspMmuTIZfDE9O8jmYQxDCMIntWBxSk9E8IUPPO+XpHGL6WBzQWgrfzCy9BEZHgg6F4/darPm7tZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANVGiGcS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANVGiGcS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6B1C4CEF1;
	Fri, 21 Nov 2025 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732595;
	bh=dskfT72203DxGUZrSgn7eFt5npZaOIcQqKodH3YxxPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANVGiGcSSTIrREs3FJzzQo9cMJ+egczySBkJkFxVI8epWJPG6YenFaviK8swkyfC0
	 KRMNKY24RP1o3QK8c4T7F6r3OF0HvyaxsUTl2srGautnd+x1uKBjAZj6Cb4i/hGJpx
	 Z+UZJqDtqxD6MbLqQmN5nN+GwUD5w/PtwW+D70g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 177/529] scsi: pm8001: Use int instead of u32 to store error codes
Date: Fri, 21 Nov 2025 14:07:56 +0100
Message-ID: <20251121130237.315723338@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 20c4e10f7bb57..d3ff212d28b2e 100644
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



