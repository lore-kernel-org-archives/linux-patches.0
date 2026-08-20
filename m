Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51E625C6EE;
	Thu, 20 Aug 2026 16:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244518; cv=none; b=ASpD53+hDFzMBb9wA9hub7wNtWVu+9bqmza1i4lyLBwb4G5fqeB5N+ECg+xkMAC/BoGnuyNSZM7ytEWejM9piTZh8jBhTUwMngEulXsTMgagFXsu1O040DoSbYfkn8cC9ddRlQQS38d4KYUig1HvcOniAnu91hToNqVzpiI4Z0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244518; c=relaxed/simple;
	bh=L8dl+CoeMfNAZLIT6KkPb68q6DpMH18nstk3WE5UE74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nEJLKGXbwLSvuI4HRlWKGmSqaxYQcCLwew1np0tYfxs8r8+t96b/efvdeEQPHhhYd9C/P1rDQCskF/2X3b5AoVP8ddB2+vWUHFQ2e4ECFATVbnYzS/Iww5iGDE/If6mn8ZB+1DTtMfBPYTaSjjzIse2R1iGLjez2yPBhixKcEQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IUZU2krw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IUZU2krw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2DEF1F000E9;
	Thu, 20 Aug 2026 16:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244517;
	bh=6nLCURxJOoZHIdPkAH22+1gGNGoQuqVwKrC28Phv6kU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUZU2krwE9fuqJuMhi3sdlBMBHgEgordc5G1ZC0h/hEPT0XlnJBGgdRhbc3vbvEq2
	 CXPPzB7wpz82m5gAbB0w8SP5nMjI2bq1y5mTgubX/L7n+Dup8RdcVAdIy1SN5meloo
	 LNqI6CeccG3VrmO5fKchrG/HePWtIeEU4hrcxY4o=
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
Subject: [PATCH 5.10 197/235] scsi: sd: sd_zbc: Return early in sd_zbc_check_zoned_characteristics()
Date: Thu, 20 Aug 2026 16:57:13 +0200
Message-ID: <20260820145222.528400074@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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
@@ -591,14 +591,15 @@ static int sd_zbc_check_zoned_characteri
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


