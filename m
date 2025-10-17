Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AD9330B3A;
	Fri, 17 Oct 2025 15:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716084; cv=none; b=nuQskOs4hADGavJtw0kwgDk5yI/SrZcx2K7UK7y3KLlbgmsbliuwIR+TMlqSJn+d/SPM4aQtZ1JcXr8gsAIom7Ka3tDeYtmGGFgyE0VsBLY/IonJmTQLr8VRj/d6vbpTHUTpakXe8TpiFob2yxsLNepdUaOSU2SlLvUEwgg8AT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716084; c=relaxed/simple;
	bh=m1VWT1ad9ymHjHjEYoGfn75SID5LYEz/aXr3pj3pHm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pMtn4NBrcSBTzfry0bnXabG2WPfpn0kV8QNosq0jbsRK9g4Id/TsUD6cDBBrnP9aR+kENYwwTaEAUxusfbCpwoHPcllTtzIqCRJ8ThALboHz0T9Z7yrarM37yVjzCStumZfCX4w5WIUZbHKmApA1gLmFdYamuPxKhyH8tP4digQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrpLLNNW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrpLLNNW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCC0C4CEE7;
	Fri, 17 Oct 2025 15:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716084;
	bh=m1VWT1ad9ymHjHjEYoGfn75SID5LYEz/aXr3pj3pHm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrpLLNNWdccveljb6JJGqwaxpRyiq24PDVRikgxsi1bgJd8DASYygWF1dRKBKus4F
	 7r+Pplx6/+2WDHXjg9axuQqeWlyfEuHWKUWSGaEQXYhpEx+yAuvQlDMQnE2L+1GO45
	 oJysLywncMvdpKpukLdIfo+yMi4XajN++yfpGvzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 066/276] misc: genwqe: Fix incorrect cmd field being reported in error
Date: Fri, 17 Oct 2025 16:52:39 +0200
Message-ID: <20251017145144.898320394@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 6b26053819dccc664120e07c56f107fb6f72f3fa ]

There is a dev_err message that is reporting the value of
cmd->asiv_length when it should be reporting cmd->asv_length
instead. Fix this.

Fixes: eaf4722d4645 ("GenWQE Character device and DDCB queue")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://lore.kernel.org/r/20250902113712.2624743-1-colin.i.king@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/genwqe/card_ddcb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/genwqe/card_ddcb.c b/drivers/misc/genwqe/card_ddcb.c
index 500b1feaf1f6f..fd7d5cd50d396 100644
--- a/drivers/misc/genwqe/card_ddcb.c
+++ b/drivers/misc/genwqe/card_ddcb.c
@@ -923,7 +923,7 @@ int __genwqe_execute_raw_ddcb(struct genwqe_dev *cd,
 	}
 	if (cmd->asv_length > DDCB_ASV_LENGTH) {
 		dev_err(&pci_dev->dev, "[%s] err: wrong asv_length of %d\n",
-			__func__, cmd->asiv_length);
+			__func__, cmd->asv_length);
 		return -EINVAL;
 	}
 	rc = __genwqe_enqueue_ddcb(cd, req, f_flags);
-- 
2.51.0



