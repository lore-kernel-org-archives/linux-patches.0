Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015038;
	b=mSw+Nlum7bumuKONWjasGmlzifTQdRTtY2Qujv0+QIL4eixLdgDy6p+/NF34zXFYFEG8
	 OKLebG6CVLi/914gbuf/+pB6jXJ0TJi4/xMgYD4G7UzhMGRRq1qpIeBd/svTqAvi5FeCo
	 GeqX+7IbjdScVswHk+E1RfppHsGsPyBM7mvFWVd1ivA0CVrM8/HN321zYbut/a9MjFftt
	 BLJCN8PRMj2iUcAGbGDUfN/E1oEebNIew8WmIXPEEFPdMTz6lEXch/JAnblwl38PjjMft
	 vqXP0UHicQao+HjoS2gcZTZAknzWToYHTXf2zIKdLw5uh0Dig6+RK2PAMSks1EKuPrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015038;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lGL+qReOUcRIbbhDuOUL331WgUKbTwe7npLYa4KDwfo=;
	b=O2Tke114Z5BfNsAEe/5z4S9SlWiGILm8ycclDq7nsPxm5ddikHizoLAqKqMLO4MeN0DV
	 aBohb5Pwo/11BtOgaw13Bs/nN9pyWRASt/G9LJlacPQUrOrliHxdKfP1T71P0ezQWKUf+
	 HR6V/mCRAgpLCvWxEt8BHhMCnBSAyKS5GyNEGcqX6hZlYOiodYOUO1uVU7ss7GP3Ymo6O
	 YRpHEDM7h1SLaooCvYU5cIGTTBvduSULPhebqkgolNiUcrsY+BoNrEiNmkfe6ijE/U4hs
	 +oP+QPCiyBYWmhabxmuzKCTvvUsLfd8pZtLrde9/92XtFlVxuVVhOAyNKVUCCo6ACzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="u4lAcTt/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482D9606A320;
	Wed, 18 Nov 2026 15:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u4lAcTt/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B0C1F000C4;
	Wed, 18 Nov 2026 15:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015038;
	bh=lGL+qReOUcRIbbhDuOUL331WgUKbTwe7npLYa4KDwfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u4lAcTt/qM6Mza1tZpeU7utPuW8T529O5uifHPLg4gf4KZgls90MgQfqz+o0dCh8O
	 qqt/i2CxK1TM3Nk8H1ZrgeCHgjAWppnuV5nsaWWhedRF5A7xkpzNBvDCiSaFPTemVW
	 1oN4W5Nkj5sRr0+sxMjhSE241iFUEcNYxa+rt75A=
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
Subject: [PATCH 7.3 0011/2651] scsi: ufs: core: Change the error check sequence for auto hibern8
Date: Wed, 18 Nov 2026 15:20:51 +0100
Message-ID: <20261118150248.406346187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
[ sashal: Retained hba->host->host_lock without the address-of operator because host_lock is a pointer. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index dfbcf036d356c..490feaeee10b2 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5876,18 +5876,26 @@ static irqreturn_t ufshcd_uic_cmd_compl(struct ufs_hba *hba, u32 intr_status)
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
 	if (!cmd) {
-		dev_err(hba->dev,
-			"No active UIC command. Maybe a timeout occurred?\n");
+		if (!ah8_err)
+			dev_err(hba->dev,
+				"No active UIC command. Maybe a timeout occurred?\n");
 		return retval;
 	}
 
-	if (ufshcd_is_auto_hibern8_error(hba, intr_status))
-		hba->errors |= (UFSHCD_UIC_HIBERN8_MASK & intr_status);
-
 	if (intr_status & UIC_COMMAND_COMPL) {
 		/*
 		 * Store the UIC command result in the lowest byte of
-- 
2.53.0



