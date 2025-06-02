Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FC5233D9C;
	Mon,  2 Jun 2025 15:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876758; cv=none; b=mEhEahza/hCtVmfEpjRPGfKelGKl1ReMDAuoUC+D5uXQKYydazOtV3Cg25zkcUi+6MRY1Ujd5AiFLpzj9nUTPAYTZ84Y/BxuiHTu/a30FQy6w7kTT4qFZ4AeuOvblKJssDdzFJcdfbw8J4tQ+Vce9TRWonJv0p2+0J04CDVsYfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876758; c=relaxed/simple;
	bh=SIQviJ97hcTo9l6wuB4qt40pILqVizMhi2eVGND5DY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YQ79y5USCsGoO/sExW6VyBD2WYJV7xgPjpC88k+OE+2Dchd0o9b13+Jo+RpVel9b5era0A0Kh6bREDxPEW6W3J5fnUOvNPuC+xf0vH6fqd7mC656i0lOod6GwJpy3FYki0/nyXeY0Uj8kI4doqTal3Yqf9fpQwkoBkk5riVIP2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hTcS1zkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hTcS1zkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B559FC4CEEB;
	Mon,  2 Jun 2025 15:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876758;
	bh=SIQviJ97hcTo9l6wuB4qt40pILqVizMhi2eVGND5DY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hTcS1zkHFTcvCQKhcw+nuxUy54uilBp4MfdmLK8EjfT8yi7QZAcvxSyn+AhNj5Xes
	 Wo0xbWis6n5LfPn2XcCab8/ShlQiv4lL53zMBeRIVt5yV9gOUozCyEp4EUmIx7CJhE
	 7m2pUThBoTowZxf5v1gQ1qO/1q0+l3cDIfb4nT90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/325] scsi: st: ERASE does not change tape location
Date: Mon,  2 Jun 2025 15:45:40 +0200
Message-ID: <20250602134322.374924688@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit ad77cebf97bd42c93ab4e3bffd09f2b905c1959a ]

The SCSI ERASE command erases from the current position onwards.  Don't
clear the position variables.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-3-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 284c2cf1ae662..3ff4e6d44db88 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2887,7 +2887,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5



