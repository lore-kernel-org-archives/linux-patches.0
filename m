Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062549;
	b=t8l6wpEXeGBCLKpQ5pu4218+KclYONUT1SNR2/G9HMMiVKlq/jLwtg1dyRKkWyen44CO
	 EMBb1jnaTd3Sqy0CgL+4WA8XfVvYykIyOO7it30BpL0jO0OE2Wakl85+iAhGStrrA0v2R
	 XpFSmdQfDFAvlIyEpA2cvTOzuerCoft3lznEQMwYU/KTeXSouqs/7/TIZKd1n9ZBsB/ne
	 K005T3CU+FkwH4qzFu/i+0Ent2czFvaRoC9NgyN9H/b3+Q3aaK4Nv7JIkz4rkKDARHpnl
	 dkIGd+4XbOfoFjzyIwn5K+RCSsRsXXxLPfIZf5OvWkHoZ24lOf8iMf0SFG5oiYWzCqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YTy+FpaxoyuEwIq7Gh9zmdG5EtwbNvLMIBrQiAuhUSY=;
	b=WfGdtJTsXQqpsSoYsbffIYIZwer5CYXtvAylPDJ2CLEo/0vlb60MBkQ252dxlyPYe2bV
	 3hnNKJmYKdwLKyk9yQZcvCRuZWEgQkt9XODTsOovn+f7zrwyEbpFVVdzOQ2TVNjCqtr0C
	 op6zTsecNZxaEMywpanwYGXFyWDJv3MKSNNpN6F/R6BG46uRY3Erz00Xg25qsAJdQ4N+9
	 x6/9g+aLBQXR3RfY6VXI2k6bZq2HoXNVK/uLb7vFyIWkPL/cWu6VxgKkhhYNTKk8Y3khP
	 mNPc89OVbplDTngK3/tnC80yWqYSwHhSryf5XO9YBlgZymM04rtvHXOfSsw0H0AiD3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOLh1TbU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA61606A33C;
	Sat,  7 Nov 2026 14:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YOLh1TbU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827F21F008A2;
	Sat,  7 Nov 2026 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062548;
	bh=YTy+FpaxoyuEwIq7Gh9zmdG5EtwbNvLMIBrQiAuhUSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YOLh1TbUzx1WTYx19RFJED9gTlfgwpJphHDmGFTu6rVw/ED9gkxfqyRQBq4X6ajp2
	 VfjR67INLsjNDCqUKYyxU3kSPIAFQYDFZmcRJVGu2OmU5qpplofOzZKZ8Q4Kot+ztU
	 AaU/1Wxn9YNAYMrxc30SF4uxPA06GypO/JDf8mRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Jhu <stanleyjhu@google.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1436/1536] scsi: ufs: core: Remove completed-without-interrupt path in ufshcd_abort()
Date: Sat,  7 Nov 2026 08:57:32 -0500
Message-ID: <20261107135038.169021272@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit 7cfdfdd6557906fd09cf0a9a564a07012e7fb0c1 ]

In SDB mode, a command that times out right as the controller finishes it
can be completed twice:

 1. The command times out and scsi_timeout() schedules ufshcd_abort().

 2. The controller finishes the command and clears its doorbell bit in
    REG_UTP_TRANSFER_REQ_DOOR_BELL, while the completion handler has not
    yet cleared BIT(tag) in hba->outstanding_reqs.

 3. ufshcd_abort() sees the doorbell bit clear and calls
    __ufshcd_transfer_req_compl() without clearing BIT(tag) in
    hba->outstanding_reqs.

 4. The normal completion handler or the logical unit reset that follows
    sees BIT(tag) still set in hba->outstanding_reqs and completes the same
    command a second time.

This branch only exists for a rare corner case, a completion interrupt that
is lost or arrives late. Remove it to simplify the abort path and leave
such a command to the SCSI error handler, like any other command that
cannot be aborted. The cost is a slower recovery in this corner case, which
is acceptable since it only happens after a timeout.

Fixes: 169f5eb28869 ("scsi: ufs: Optimize SCSI command processing")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/fdb5c391-01ef-4a23-94c2-4f3853909348@acm.org
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261022034443.3034432-6-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index cc730a2463df2..4a78a5d9cd8b4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7700,15 +7700,6 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	}
 	hba->req_abort_count++;
 
-	if (!hba->mcq_enabled && !(reg & (1 << tag))) {
-		/* only execute this code in single doorbell mode */
-		dev_err(hba->dev,
-		"%s: cmd was completed, but without a notifying intr, tag = %d",
-		__func__, tag);
-		__ufshcd_transfer_req_compl(hba, 1UL << tag);
-		goto release;
-	}
-
 	/*
 	 * Task abort to the device W-LUN is illegal. When this command
 	 * will fail, due to spec violation, scsi err handling next step
-- 
2.53.0



