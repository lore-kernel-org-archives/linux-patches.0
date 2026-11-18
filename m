Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022481;
	b=YbgG2E89CWCYpr7IUUBkmu3KKPgK55Y7YT8GrLpfyLtGuSHOFPK7gLN9eAJ30GSgZ63d
	 K4dqeRLq+Z7YXVjkGk9r9+ekpe1cD69VnJySbYY9kv0YkzTQXPkDOdzC3e6uiUnPZZpLD
	 RT1Ukn+SaVX/NRMseQxHKVyHXYteoifQcjD0/P1tIEc2yGgltiXoFg+xbhM13Pi22jwaH
	 DR5YKpQvWDRJW7i0+qtzycYx6K2foR6ZfmW4rvCHwFm7pF/AV+dkyWSPRUirtb735yj8c
	 c6bMmFD5V+hg/hf7FYqokycrJBbH9QLlKFQv1iQTgmwpyOpkzUAnk2yI3AgAGq3lv/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022481;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zoQpz3HxgwqC+2+dOEclW6nEs7jNYpBbOcb3uRjOesc=;
	b=LceoTAHp7T5sVBBWN8T1GMTGgYXpQXQimydYD4xzyCwj83nvxwU+uBwKDb4feZTjndXq
	 +GXAe/YO78ZyewGMcsZJD1+tSzF/9V/TZ7y9k3nEY/YE65HZjuY/+2SGB4kzVQcQG6LDm
	 aukutEx3v6HRIq1RddAIiYxtvhbYtK83L8hs0m3w8C8TJz6VuTJ12npHn/cvRrIqJplPw
	 GIImE1PcezIbeQSGHGax/IrK7pcBM3R2r+i3Fi+WXRC3Nd2g8MObpgAN0elseY/wT7lG6
	 6zPiVK0/MAMt8zN8ar/IKPmyxFwiN8e6mUNOfNVq6JQCxTUdFAeKw28EFghccniFktg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrLLUtrJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D454606A320;
	Wed, 18 Nov 2026 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wrLLUtrJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F43A1F000C6;
	Wed, 18 Nov 2026 17:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022480;
	bh=zoQpz3HxgwqC+2+dOEclW6nEs7jNYpBbOcb3uRjOesc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wrLLUtrJYOhq8cFcD/HgGC3S9LqVZztpx8rHmYi3evlDUrEzMmUR4yuINv9pX9Txb
	 x2dh8KMqAT4/4u7rpq6WGGsFaY4xjdludmcRHZEcVDbtM/qiQ/4jbjCods1rGh8UlD
	 FA/DUx2ijXprZHXyk1sBzSIfS8wnuyv9+mXjWGtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HOYOUNG SEO <hy50.seo@samsung.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0028/2151] scsi: ufs: core: Change the error check sequence for auto hibern8
Date: Wed, 18 Nov 2026 15:29:23 +0100
Message-ID: <20261118150122.680110225@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HOYOUNG SEO <hy50.seo@samsung.com>

[ Upstream commit 6b2ff2b3eafa381db9b4c8a6ed98b353b2a09f39 ]

Auto-hibern8 enter and exit are performed by the host controller without a
UIC command, and the auto-hibern8 idle timer only runs while no UIC command
is outstanding. An auto-hibern8 error (IS.UHES or IS.UHXS) is therefore
usually reported while hba->active_uic_cmd is NULL.

Since commit fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl()
easier to analyze"), ufshcd_uic_cmd_compl() returns early when
hba->active_uic_cmd is NULL, before ufshcd_is_auto_hibern8_error() is
called. Such auto-hibern8 errors are no longer recorded in hba->errors, so
ufshcd_check_errors() is not called for them and the error handler is not
scheduled.

Check for auto-hibern8 errors before checking for an active UIC command, as
was done before that commit, but keep returning early when there is no
active UIC command so that a NULL cmd is never dereferenced. Only report
the missing UIC command if no auto-hibern8 error was found.

Fixes: fcd8b0450a9a ("scsi: ufs: core: Make ufshcd_uic_cmd_compl() easier to analyze")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: HOYOUNG SEO <hy50.seo@samsung.com>
Reviewed-by: Stanley Jhu <stanleyjhu@google.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20261027110357.3649301-1-hy50.seo@samsung.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
[ sashal: used host_lock directly because it is already a pointer ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d595072f7c0a4..572c0510d6bb4 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5581,15 +5581,22 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
 {
 	irqreturn_t retval = IRQ_NONE;
 	struct uic_command *cmd;
+	bool ah8_err;
 
 	guard(spinlock_irqsave)(hba->host->host_lock);
+
+	/*
+	 * Auto-hibern8 is performed without a UIC command, so check for
+	 * auto-hibern8 errors before checking for an active UIC command.
+	 */
+	ah8_err = ufshcd_is_auto_hibern8_error(hba, intr_status);
+	if (ah8_err)
+		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
+
 	cmd = hba->active_uic_cmd;
 	if (!cmd)
 		goto unlock;
 
-	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
-		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
-
 	if (intr_status & UIC_COMMAND_COMPL) {
 		cmd->argument2 |= ufshcd_get_uic_cmd_result(hba);
 		cmd->argument3 = ufshcd_get_dme_attr_val(hba);
-- 
2.53.0



