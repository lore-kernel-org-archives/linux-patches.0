Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1721B272E7C;
	Tue, 11 Nov 2025 01:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823959; cv=none; b=V3zuDmLtObiwZFWEHR5WPILX6ZQilVhG3zbCzcmzXkjS3A++6/JNbUucGatON1QJ9yoc5y6Q+sU3nmdZsk0rVaJYw6lPTx/1+q/b/3l/m6z/EtwM94b0uIBJ7XjYMeXnMPJnKugVqvXDUqfAXc+QcHXASxniAKksxKLY5Z/cWIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823959; c=relaxed/simple;
	bh=cKKVAOE4Z74X2pqAVAAHIqZvktMXn9KiAcolxhkVvVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkPVolIYdpsfGvFm/8NFY+q11ckEuu7dLZdoQt+LL4j1Rb6ylxAaf1c/+pM6+zgTB9O9JHOG7KxKgE/geY45V73kzOkNPjG1m8Z0EHIgTcbhZvb6G2BsIM5PhV+0A9cnyDql6tOsQyTPBrxlG50gloyKYovi0xXMBb6cZweqySg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VVO/DER; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VVO/DER"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D2EC113D0;
	Tue, 11 Nov 2025 01:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823959;
	bh=cKKVAOE4Z74X2pqAVAAHIqZvktMXn9KiAcolxhkVvVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VVO/DER4wLB7cdx++2fDeTDnhXWmvJ774+9wH3bjjQ8jcPt7kDkgzORz3iyllqBF
	 NCHYB8wcHn7+diK85kTkDHinIur9Ic9cfMoSgVcN0zi8Zd6fdLPOZj2ZzmebwueIow
	 M1ueBrBrdWoxEvu9wQh/er+U26O8F5OpNp6DFOjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qianfeng Rong <rongqianfeng@vivo.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 405/849] scsi: pm8001: Use int instead of u32 to store error codes
Date: Tue, 11 Nov 2025 09:39:35 +0900
Message-ID: <20251111004546.230233218@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0c96875cf8fd1..cbfda8c04e956 100644
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



