Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E0E1A58C
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 09:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gBSzy6h4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E599C433CA;
	Mon, 16 Oct 2023 09:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697447060;
	bh=C4fWrygokFTgACE3bkVZ+so8ShlcpIhlpPFjJlmvx1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gBSzy6h4967p0dK5L37nGzEVSrcBM0/rNu0p6l22FDmxbDiBeUCTWz10gHUdwLEga
	 3zJKDSzpB4vgMBt1WCrkrRosR2ea6cZ7womiXRA1FgwOhDfswP15ScANT0L/Uyv4AT
	 V9PdS8d/VECxHPVd1+vCBfUw6FJwVz+jPum/Xppo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Stanley Chu <stanley.chu@mediatek.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.1 118/131] scsi: ufs: core: Correct clear TM error log
Date: Mon, 16 Oct 2023 10:41:41 +0200
Message-ID: <20231016084002.998556905@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
References: <20231016084000.050926073@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Wang <peter.wang@mediatek.com>

commit a20c4350c6a12405b7f732b3ee6801ffe2cc45ce upstream.

The clear TM function error log status was inverted.

Fixes: 4693fad7d6d4 ("scsi: ufs: core: Log error handler activity")
Signed-off-by: Peter Wang <peter.wang@mediatek.com>
Link: https://lore.kernel.org/r/20231003022002.25578-1-peter.wang@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6749,7 +6749,7 @@ static int ufshcd_clear_tm_cmd(struct uf
 			mask, 0, 1000, 1000);
 
 	dev_err(hba->dev, "Clearing task management function with tag %d %s\n",
-		tag, err ? "succeeded" : "failed");
+		tag, err < 0 ? "failed" : "succeeded");
 
 out:
 	return err;


