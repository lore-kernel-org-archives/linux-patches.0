Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F19C2F2D;
	Tue, 27 Feb 2024 13:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040802; cv=none; b=rVR+KdM80c3rSh1dT8kQMC38je97RKVCPzxaiJhQloqQAjgqjTgRQhmAM83FFGLX9uboFJMwgc/p7fT7j7KlBqy8FM7VU7rTDcqDHSuDz0jDbUU3GjpQr1sohoFDCymKa1KsTEsn3K6yaza6gaDVGigA8fYXhSZjm5xdPA1DfZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040802; c=relaxed/simple;
	bh=cPVB2d0DpnhqJXqJyyUO9ugirlvQlxhNtfRE9E9DBVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwlFebWHNqH6Z8cqp84Bz6skEeTLM6jF/8kfnw9cwCdZxUkObCBQw9ybJS6BsgKmQw/WtuMgb8zXnVO6RhSUhnrUEQiQLkyiAqYgRFV8GsitHAtL4qEjo/1EEl2xX+3YQf13mbTuz8d/kZTEo49pQMekiYH9i8h+iln+FCqfHSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QYp1W+WO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QYp1W+WO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2D3C433C7;
	Tue, 27 Feb 2024 13:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040802;
	bh=cPVB2d0DpnhqJXqJyyUO9ugirlvQlxhNtfRE9E9DBVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QYp1W+WOVdAGaRH/bY1ONAEaebmnlf5ioxi6jDRQrELIrqsXX/Gsh4Tqfd7rDO6aG
	 E+EySslstgkLjda3HFpJ2oI36Tl9J8CALFf8+74XqigWdQOz1GFChyiFWJ0Z6yCam0
	 OpR12U/9uP75lH1xWro6TdFsl+M3Mb04jjIariTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SEO HOYOUNG <hy50.seo@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Can Guo <quic_cang@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 113/334] scsi: ufs: core: Remove the ufshcd_release() in ufshcd_err_handling_prepare()
Date: Tue, 27 Feb 2024 14:19:31 +0100
Message-ID: <20240227131634.126092478@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SEO HOYOUNG <hy50.seo@samsung.com>

[ Upstream commit 17e94b2585417e04dabc2f13bc03b4665ae687f3 ]

If ufshcd_err_handler() is called in a suspend/resume situation,
ufs_release() can be called twice and active_reqs end up going negative.
This is because ufshcd_err_handling_prepare() and
ufshcd_err_handling_unprepare() both call ufshcd_release().

Remove superfluous call to ufshcd_release().

Signed-off-by: SEO HOYOUNG <hy50.seo@samsung.com>
Link: https://lore.kernel.org/r/20240122083324.11797-1-hy50.seo@samsung.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 6f7cfecacd273..e197b9828c3c3 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6350,7 +6350,6 @@ static void ufshcd_err_handling_prepare(struct ufs_hba *hba)
 		ufshcd_hold(hba);
 		if (!ufshcd_is_clkgating_allowed(hba))
 			ufshcd_setup_clocks(hba, true);
-		ufshcd_release(hba);
 		pm_op = hba->is_sys_suspended ? UFS_SYSTEM_PM : UFS_RUNTIME_PM;
 		ufshcd_vops_resume(hba, pm_op);
 	} else {
-- 
2.43.0



