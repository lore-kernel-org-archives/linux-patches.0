Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80CD43C7AE;
	Tue, 21 Jul 2026 22:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674635; cv=none; b=VD8oVMVTwO8jKWrG4+X7D4RzUK2ahvFebgCcB4wEdTQnoe/jkB47f0X+4AVFwTEnt/9WKROHm0VECSLs9X64XQMYXKp8tNxCOoSj86VIbwxvRv1ZxcUEPEboo09AIi6JApiELpv7u3AS3Q6DjVr/MXULZYw/p5Q7c1Y5AeRdC2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674635; c=relaxed/simple;
	bh=bgNlqQOuAXHgkd9sQ24kSRVcPnSeqQJnVpnkRAyG9B8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuiBIRfLrdtTNUMg8JYQ7RCOW2p/fflZbmqiyjOm8EGHJB0VagLiU2i9tgvc9YRh19XtqEsDhAnzNq//OeKvS9xFJZ9S0p3huP9Ler5XvRje/Np0/X1GH3SXgR4YgwER9OOD7lFE6ev5HRRtveU039pfGgIZVLvxOxCUNl4CCrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m9J+m8iU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m9J+m8iU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1DC1F00A3A;
	Tue, 21 Jul 2026 22:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674634;
	bh=I+oAGhb9t+RAQRd8Xhs9ev0aZjpqaev+04iCMLKVqvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m9J+m8iUoFfKvQJoP+VgNlfNgm72jGmQlgQdhZXZfmIhO3aTlFz7JGFwgYmnQy2FW
	 kOaIG9TXs+E9iQWfNHwLNbYvqjzyDTr3cd0pJ51Mbk/S1r5rZsmr/4Mf82czotXrDJ
	 vcORyzllxnyvYQl9R4Af/b8LK8aWTm4DT6Y98SLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@oracle.com>,
	Fabio Aiuto <fabioaiuto83@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 615/699] staging: rtl8723bs: remove commented out RT_ASSERT occurrences
Date: Tue, 21 Jul 2026 17:26:14 +0200
Message-ID: <20260721152409.618356730@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

From: Fabio Aiuto <fabioaiuto83@gmail.com>

[ Upstream commit 2172a6576388e63958f47923e435c46af8d006ba ]

remove commented out obsoete RT_ASSERT macro occurences.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Fabio Aiuto <fabioaiuto83@gmail.com>
Link: https://lore.kernel.org/r/3ee98d7bf1685af627e625f413de355fce58d52d.1619794331.git.fabioaiuto83@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a1fc19d61f66 ("staging: rtl8723bs: fix WEP length underflow and OOB read in OnAuth()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_recv.c         |    2 --
 drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c |    1 -
 drivers/staging/rtl8723bs/hal/sdio_halinit.c      |    5 -----
 3 files changed, 8 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -2165,8 +2165,6 @@ int recv_indicatepkts_in_order(struct ad
 			/* pTS->RxIndicateState = RXTS_INDICATE_PROCESSING; */
 
 			/*  Indicate packets */
-			/* RT_ASSERT((index<=REORDER_WIN_SIZE), ("RxReorderIndicatePacket(): Rx Reorder buffer full!!\n")); */
-
 
 			/* indicate this recv_frame */
 			/* DbgPrint("recv_indicatepkts_in_order, indicate_seq =%d, seq_num =%d\n", precvpriv->indicate_seq, pattrib->seq_num); */
--- a/drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c
+++ b/drivers/staging/rtl8723bs/hal/rtl8723b_hal_init.c
@@ -158,7 +158,6 @@ static int _WriteFW(struct adapter *pada
 	u8 *bufferPtr = buffer;
 
 	pageNums = size / MAX_DLFW_PAGE_SIZE;
-	/* RT_ASSERT((pageNums <= 4), ("Page numbers should not greater then 4\n")); */
 	remainSize = size % MAX_DLFW_PAGE_SIZE;
 
 	for (page = 0; page < pageNums; page++) {
--- a/drivers/staging/rtl8723bs/hal/sdio_halinit.c
+++ b/drivers/staging/rtl8723bs/hal/sdio_halinit.c
@@ -313,7 +313,6 @@ static void _InitNormalChipOneOutEpPrior
 		value = QUEUE_NORMAL;
 		break;
 	default:
-		/* RT_ASSERT(false, ("Shall not reach here!\n")); */
 		break;
 	}
 
@@ -347,7 +346,6 @@ static void _InitNormalChipTwoOutEpPrior
 		valueLow = QUEUE_NORMAL;
 		break;
 	default:
-		/* RT_ASSERT(false, ("Shall not reach here!\n")); */
 		break;
 	}
 
@@ -412,7 +410,6 @@ static void _InitQueuePriority(struct ad
 		_InitNormalChipThreeOutEpPriority(Adapter);
 		break;
 	default:
-		/* RT_ASSERT(false, ("Shall not reach here!\n")); */
 		break;
 	}
 
@@ -603,7 +600,6 @@ static void _InitOperationMode(struct ad
 		regBwOpMode = BW_OPMODE_20MHZ;
 		break;
 	case WIRELESS_MODE_A:
-/* 			RT_ASSERT(false, ("Error wireless a mode\n")); */
 		break;
 	case WIRELESS_MODE_G:
 		regBwOpMode = BW_OPMODE_20MHZ;
@@ -617,7 +613,6 @@ static void _InitOperationMode(struct ad
 		regBwOpMode = BW_OPMODE_20MHZ;
 		break;
 	case WIRELESS_MODE_N_5G:
-/* 			RT_ASSERT(false, ("Error wireless mode")); */
 		regBwOpMode = BW_OPMODE_5G;
 		break;
 


