Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BC621516E;
	Mon,  2 Jun 2025 14:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875464; cv=none; b=NVdRv5o39E7n3lnE4X9INbRCGXjRwSIIQXflkAeLbFPMRVvnrWt5HC12peq19qhlZMSFZ+K6dY1nM3ex2ohEJAmsZb9LTzskO2hlO4IXTsuaL2WCKgjT45CsclPCXo1P11qdeuav2P8i3Q7jQdSCisT/d8k9kEdEzNG/80yPeac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875464; c=relaxed/simple;
	bh=dteQeIK5F40Iqpj63kEObBbTlsyw7ziqz9lsaCjTxfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XcKbOqmUzTR4O7WktDESk3yOxon1mUtUX6QRyG5yqEoMcxNtjJE8mu5TSYaS4ODvuUebsjgI/LYsNKxY4QiFoeHbDhCjU5ohRk69xi0uhyTIzTYIvvBsd2WLZhluiEXocCCepv6pKOzSwenag1Bq2e004U4NIO2RyunwtE7gNQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmjMoINS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmjMoINS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C588C4CEEB;
	Mon,  2 Jun 2025 14:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875464;
	bh=dteQeIK5F40Iqpj63kEObBbTlsyw7ziqz9lsaCjTxfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmjMoINSUfpB14NXaNi4E2sqId/Q/4v5tmYKQsf8WxNjxCcmm+XlSlpAqtRiVs62w
	 /IkxffxQr7YqXSbBeLLUgUOOykCfqBVq8ujgdb753Aq/fh5DMf4jUQ5HZRPP0nj5cF
	 6goHR+xjQdrkh5SoMFhLJ3ItyU5O1Y91aeirzI/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/270] scsi: st: ERASE does not change tape location
Date: Mon,  2 Jun 2025 15:47:08 +0200
Message-ID: <20250602134313.078343968@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 47e59b74c09d2..747e69abfcfce 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2889,7 +2889,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5



