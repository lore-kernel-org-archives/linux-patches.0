Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045868;
	b=pJSqrTjXWii9ioC1z1xa2tYB4Ajp8nWkEIRvR3Ppfx0e1qYfmOjbkaNk5NaJXG9LngbF
	 KyFr3qPtufKWACWwewSH6lbcmtN9cvzRc8u5SqFTN3clSFX6TSpMXwysXJ9if+rI7sXM9
	 hOuXyHwcigTqt9v39GzxBDYOqRi8dpPtttKvCLADczPspZrUeX0D+LvYoAHFmn/R0KXrC
	 PQ1eyvxRlTXtnUbWtvhIdb26DSGcY5E2RMoRg+hiRpedet6Aknt46FJmJKdPEOOtYTIst
	 yC9JUSjA3bVxG3xTCwzpfYWtIunBUc0CJcN0sjgBbLt18f87jJLiYCIWIDL1WPs4ivw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9ajW/AhWBqkEdmYTk8gtZiBB0pAbhV929SLaBdxBUKY=;
	b=xVOwAVdqtkt1qDWl5pQC0cYgd2qfIiHshXJD/XreGFAew0ikwmMJOcjG/yv6qupAU2Mh
	 wRek3PhzdjSB1fTDF8tvIRIxfeK0WCeDlK0TBRjiXafQckdrpalZB1hz5x+DiblAut40/
	 VFjY0UqCLV2I90JW2Jwm3X9ua0z7VJG92Ntv6mB14j499qQsMFOBRAiHbcztolIDHPjH1
	 DIFaQdjG60AFjGiIXiiKZpXYNL1aZ0SCl/UOZMP56FSFxNI64A65g+hE8XhzfJTHsD5/3
	 /Lu8CadwKf0E1t45tRE7UED9P7vFgWJscX/69CgbWt/EQn5mL68wDLZzQ+Fp9X9uMcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZuvjvFL8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55B1D606A325;
	Wed, 18 Nov 2026 23:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZuvjvFL8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBAD1F000C4;
	Wed, 18 Nov 2026 23:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045868;
	bh=9ajW/AhWBqkEdmYTk8gtZiBB0pAbhV929SLaBdxBUKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZuvjvFL884vmRPwZ7F/R1zGkNBngkAEMNTP6Tf7pLaPFRfXtwxMMyO1AnmRG/A7iL
	 VmlVSg6CYPZ4HAl1QohbX40szoGStFmNoiEFL3rGo0BQLG4q4IHqBkUItpVE9sHkTL
	 OxYtr5e5IxqkBDPtdCdKfZb3kAu4Taz371ndORUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bean Huo <beanhuo@micron.com>,
	Peter Wang <peter.wang@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Stanley Jhu <stanleyjhu@google.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1037/2857] scsi: ufs: core: Remove an always-false WARN_ONCE()
Date: Wed, 18 Nov 2026 15:34:31 +0100
Message-ID: <20261118150238.934966242@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit cd37a69c367b6a5f685db0ac7d01f08545081a30 ]

The WARN_ONCE() in ufshcd_poll() can never fire. completed_reqs is set to
~tr_doorbell & hba->outstanding_reqs on the line above, and
hba->outstanding_reqs cannot change in between because ufshcd_poll() holds
hba->outstanding_lock. So completed_reqs & ~hba->outstanding_reqs is always
zero. Remove it. No functional change.

Cc: stable@vger.kernel.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Link: https://patch.msgid.link/20261022034443.3034432-2-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 13cf6c80370f1..c86f4d226fb3e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5448,9 +5448,6 @@ static int ufshcd_poll(struct Scsi_Host *shost, unsigned int queue_num)
 	spin_lock_irqsave(&hba->outstanding_lock, flags);
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
 	completed_reqs = ~tr_doorbell & hba->outstanding_reqs;
-	WARN_ONCE(completed_reqs & ~hba->outstanding_reqs,
-		  "completed: %#lx; outstanding: %#lx\n", completed_reqs,
-		  hba->outstanding_reqs);
 	if (queue_num == UFSHCD_POLL_FROM_INTERRUPT_CONTEXT) {
 		/* Do not complete polled requests from interrupt context. */
 		ufshcd_clear_polled(hba, &completed_reqs);
-- 
2.53.0



