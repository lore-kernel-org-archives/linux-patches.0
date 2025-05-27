Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2140A271476;
	Tue, 27 May 2025 16:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364692; cv=none; b=VOokb8CvZXI8zG8S0ymyLz4n35Qhdv5hChq7bk1sS4GUZ/zRBbXqNtweLGXnSl2HJ5+5/TcvsLyHEC5FAJIwgjeaLF2sPWUgVx0HLp4W0VEpcZejji4fBcCKUgnXSb9C38yq5dXJE2Ggnui71AFwUst3PhQhLdLREzj62a816I0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364692; c=relaxed/simple;
	bh=CPYAKZA9h/iooSYBM4NBIp+Uwo3bKNngYdpFIm6sdsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dO+wlWOjr7JroHXgv14xe+X5Iw4YtYp1bovsCZ+o2sncYR8NJWQTxCXd+dgDUXsjNJDEOzforGTzNlyzjpqAJPSo11Yogmn/B/Jzv+jadVfeJgdg5qxYFs4Mc2AEecq8Td9+kv0+1NeZIs0F1Y//FCK7VZ/5nt7uyR+v/j8egcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S7fv2DsQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S7fv2DsQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E4CAC4CEE9;
	Tue, 27 May 2025 16:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364692;
	bh=CPYAKZA9h/iooSYBM4NBIp+Uwo3bKNngYdpFIm6sdsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S7fv2DsQKm8F5KXtvYtkDGadvAcGTvLDt4214AA1OhmV0LJDtumz8qaYuEVVlz08n
	 ciCkCo6sG5uGxiHsFoGtW4rrLxRFyr7q9RSeAfgKCiWAYT9bkHNJD2pWZElJ5V7+Xy
	 UHMfOrTPU32X8ytgskWHmzdakde+79NnpYEkVEFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 136/626] scsi: st: ERASE does not change tape location
Date: Tue, 27 May 2025 18:20:29 +0200
Message-ID: <20250527162450.551892356@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1c0951168f646..1cfd7e71dcdde 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2894,7 +2894,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5



