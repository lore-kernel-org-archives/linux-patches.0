Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065313;
	b=gxFfFXuiU8nhm5NlhbILztuwsQlY7pjecyIn8nxobTvrmevl2t5TIu2kno8SKDOctCG7
	 ARntOGy6fFsRtmvOThWsHPQt7PqBwJeD3jTRTR4H/c3ff7I77NPPQfWSBt1zqxsUSllUJ
	 EtfcM5smh5P2hRi8PqFl7NVVr3/B8/w/sfhe8keAJ0NtNRegh3u0n2Go4suJdNxCrxfyN
	 qvhTOPM0LOkpHIMaJR9Z0KXro+LcQ1cyFT7cNLK1D3JIoKKHzbuNW0HgyEaQfUJF1PEtl
	 zpd+gVeFk44ZW5D4mzmX5DfCuutTv3pR30EUpgBvlOfB+4AcVOLYF9TkZBdlm52iqCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065313;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JGIw3dmTiL8+TyzryUthWx9g0ngjLn6oG/VslIIsyW4=;
	b=lSOu/yvZYfQutpWxejcoKblzyD0Qa8IyXYKuqCybCLDLg1t3DFAeoBlt0UT0fb7XjYyu
	 XLHoHxK52d8UY/1OryuhCu54ZKM5TKmhPtCXh8F7+HY+Bfl7WC9obWgLtCNXqYYmZKw2/
	 OO7aIY0+wqyopSDe7pYx7/uBKhF8ejN/abER8xbk3IA9qHwAbllovwI5Y5V+6OOhnwIZL
	 WZH8TClrDc2sTnBKsbgwfk/wCr/1azstCDz/7glc5+mhhTc0Eraycnsm9sgVigtAXM3V7
	 WLCbh15cOBhMVWv6+ruuHmQpodqUzf9yuh7uWuhYNTXJu2Qs04WyIu0kQ+5apdXEkWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2sU3Xwyj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAE6606A32D;
	Sat,  7 Nov 2026 15:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2sU3Xwyj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3A41F0089F;
	Sat,  7 Nov 2026 15:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065312;
	bh=JGIw3dmTiL8+TyzryUthWx9g0ngjLn6oG/VslIIsyW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2sU3XwyjWeq1y7NZ7hZjogCKgLQAmXyMq+tiVd2Rbylu2IogNYY8CS3JlATtSSySP
	 AOXzDHIQjwQhDnQZJ+lq0LwuLHWOoSIaPDqMCBKb7pSH5wZDjCjEffoQmigaI4wS/y
	 3cK7zLj5/Jhp8ocOJ+tIPNU9p1UhCGlNr6z72NEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1062/1257] scsi: ufs: core: Do not release a reserved request in ufshcd_abort()
Date: Sat,  7 Nov 2026 08:55:58 -0500
Message-ID: <20261107135008.611599096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Jhu <stanleyjhu@google.com>

[ Upstream commit eb2c4847a1cb2f426cfc702364df7a38ebbf730b ]

In SDB mode, aborting a timed-out device management request drops a clock
hold that the request never took:

 1. ufshcd_dev_man_lock() takes one ufshcd_hold() for the whole device
    management command. ufshcd_queue_reserved_command() submits the request
    without taking a hold of its own.

 2. The request times out and ufshcd_abort() clears its slot with
    ufshcd_clear_cmd().

 3. ufshcd_abort() claims BIT(tag) in hba->outstanding_reqs and calls
    ufshcd_release_scsi_cmd(), which calls ufshcd_release() for a hold the
    request never took.

 4. When ufshcd_dev_man_unlock() drops the hold from step 1,
    hba->clk_gating.active_reqs goes below zero.

Release the command only if it is a SCSI command.

Fixes: 08b12cda6c44 ("scsi: ufs: core: Switch to scsi_get_internal_cmd()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/2060a8da-581b-46d1-a510-779f4df716cd@acm.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Link: https://patch.msgid.link/20261022034443.3034432-7-stanleyjhu@google.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 47e0e6b8d3724..dfbcf036d356c 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8175,7 +8175,8 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
 	 * Clear the corresponding bit from outstanding_reqs since the command
 	 * has been aborted successfully.
 	 */
-	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)))
+	if (ufshcd_clear_outstanding_reqs(hba, BIT(tag)) &&
+	    ufshcd_is_scsi_cmd(cmd))
 		ufshcd_release_scsi_cmd(hba, cmd);
 
 	err = SUCCESS;
-- 
2.53.0



