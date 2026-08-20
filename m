Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFE946D0BD;
	Thu, 20 Aug 2026 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243838; cv=none; b=BCMA+I064dLXa3ipnPY0TFvSRf+XikoSJ6rUMjY7Mp4qKgQPsq4sCJ/KrLc0ZBrDwZpOkQhBHAmu7dlLo69tgu8MjWN/oiWOZDhe5nUBwg96J99gf3Zm7Gc57dmbo/f0H03DxyCzTner/bqt/SKtieoxTmL1RGb9Ka4RTugFNc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243838; c=relaxed/simple;
	bh=NsI0JW7cYBL3GzJe+lL6Ho8qChL9AZtq3eDTCY/zDPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SOe5s/IqiE8GsSgrTTb036Jdc1+h4B8iDjONeaKGwxWKqQNCq8UssxAEXBVVWiOTs4yera/IJLFZow+IbzF3gImDakuId/XFpdPxbYkND0khQ64nFx1TGAQj+1b8SXNOBF4WLpvy/3+5zgQn5VOa51ax/vTJXuEY28p0eGtj4PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f368KCmu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f368KCmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2881C1F000E9;
	Thu, 20 Aug 2026 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243837;
	bh=Y8toczLjzcta9sXY+WIOTwm4PNcg1zliac/E2P/dehI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f368KCmu38cU2pVqAd84T1edpqUY8c6lZCa9FZBj6jdN99pgX5zWP0vqbFFJDjaB/
	 cJs/QF6LvlJyqj3RG734MuLA22JxB8MD3PntgZqoNmTIVamrQI8zGv9dtwFGRQoezC
	 K/vSzGWhI2UnPp2/CtzXiAZXzHekTLfjO+LW09Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	Douglas Gilbert <dgilbert@interlog.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 232/272] scsi: sd: sd_zbc: Return early in sd_zbc_check_zoned_characteristics()
Date: Thu, 20 Aug 2026 16:56:56 +0200
Message-ID: <20260820145238.568615340@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 60caf3758103b8edc90724ba781ff119f739162a ]

Return early in sd_zbc_check_zoned_characteristics() for host-aware
disks. This patch does not change any functionality but makes a later patch
easier to read.

Link: https://lore.kernel.org/r/20220421183023.3462291-6-bvanassche@acm.org
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
[ bvanassche: extracted this change from a larger patch ]
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 93dde0bf2f39 ("scsi: scsi_debug: Fix REPORT ZONES alloc_len underflow OOB write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd_zbc.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -593,14 +593,15 @@ static int sd_zbc_check_zoned_characteri
 		sdkp->zones_optimal_open = get_unaligned_be32(&buf[8]);
 		sdkp->zones_optimal_nonseq = get_unaligned_be32(&buf[12]);
 		sdkp->zones_max_open = 0;
-	} else {
-		/* Host-managed */
-		sdkp->urswrz = buf[4] & 1;
-		sdkp->zones_optimal_open = 0;
-		sdkp->zones_optimal_nonseq = 0;
-		sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
+		return 0;
 	}
 
+	/* Host-managed */
+	sdkp->urswrz = buf[4] & 1;
+	sdkp->zones_optimal_open = 0;
+	sdkp->zones_optimal_nonseq = 0;
+	sdkp->zones_max_open = get_unaligned_be32(&buf[16]);
+
 	/*
 	 * Check for unconstrained reads: host-managed devices with
 	 * constrained reads (drives failing read after write pointer)


