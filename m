Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C48820969B;
	Thu, 12 Dec 2024 15:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017368; cv=none; b=skwTjBQxTDnpwO9Yuxq0V6Z7M2yGzT0L3b0O/y7EzOF0I8+zmoJKplnByJR1JxnuM9OuTnybcWyNK7a7bP+uGB2wPau6UnwV38u4sYL9t//J7SkftgBuI8TGOjFSKIQmYE8L89MyZH4G60dan8EJ9SG7PW1AP6gRuS9DFngkrko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017368; c=relaxed/simple;
	bh=7ntHzSNyOsN4aJZHO3XWslkt8DF1ocyuzj801oYcl9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2BX5N2z7AHPpvObvoZPl3Dz+dXxmWdhzPhzl60zUIQe/q6uKWu7GtS7PoSEoASFuGbfxv108Gd4xukYoSc49yQXjjKgI3UL1xbFapIynecbVfbiUWTzZpzV101UEJDYSHSAKpK5AB0k964hJ9spOPZFsEgRfwyQbYz+NZ7dkFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IV4k0now; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IV4k0now"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C974C4CECE;
	Thu, 12 Dec 2024 15:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017368;
	bh=7ntHzSNyOsN4aJZHO3XWslkt8DF1ocyuzj801oYcl9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IV4k0nowfUsMYy3rxl9rRIJipVre6Q/k+yj2vDi2a5kz1kVykFn4+tBd+SWHzxPmc
	 dvnJnoJ1fNAgvd0LgKsBqV3Y3CC5Jx3JvToXTSkMt/myofZvffR6uKli6oDeVIHqQ1
	 bJli17uJ+EmU61w1G/Y8AQAhT+SYIiuKvFGOUfHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Peter Wang <peter.wang@mediatek.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 430/466] scsi: ufs: pltfrm: Dellocate HBA during ufshcd_pltfrm_remove()
Date: Thu, 12 Dec 2024 15:59:59 +0100
Message-ID: <20241212144323.860823793@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 897df60c16d54ad515a3d0887edab5c63da06d1f ]

This will ensure that the scsi host is cleaned up properly using
scsi_host_dev_release(). Otherwise, it may lead to memory leaks.

Cc: stable@vger.kernel.org # 4.4
Fixes: 03b1781aa978 ("[SCSI] ufs: Add Platform glue driver for ufshcd")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241111-ufs_bug_fix-v1-5-45ad8b62f02e@linaro.org
Reviewed-by: Peter Wang <peter.wang@mediatek.com>
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufshcd-pltfrm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
index b8dadd0a2f4c0..505572d4fa878 100644
--- a/drivers/ufs/host/ufshcd-pltfrm.c
+++ b/drivers/ufs/host/ufshcd-pltfrm.c
@@ -534,6 +534,7 @@ void ufshcd_pltfrm_remove(struct platform_device *pdev)
 
 	pm_runtime_get_sync(&pdev->dev);
 	ufshcd_remove(hba);
+	ufshcd_dealloc_host(hba);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_put_noidle(&pdev->dev);
 }
-- 
2.43.0



