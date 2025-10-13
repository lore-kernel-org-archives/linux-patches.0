Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E83130AAC5;
	Mon, 13 Oct 2025 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367693; cv=none; b=rnv4NX894nP0C5mryUo+NGuu4lsX+4U+5zr1F77KkJ02+Dg6MYUFVVW9RM24V36KBsO0dqkLlC0rZKSzeBsXlfrwAzwnJ0IimRBXSaqohe60lm8N8j3fgMxI26aloF4Y4r9ZU70PhFi0jDRL+2IokZirFcuZL34VMZeGQMVBbbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367693; c=relaxed/simple;
	bh=3sdLnPEw+a0SKfTZds8OP1OYQ/5xaVAxP6n2GXwYjiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXxJ1WNqMTVD00CCJTLwRtKdVCIZViLzDmIevNGPyqKAd7HZvCZFWuU+9tdOqOzRNnRp5xQav17vEwNWL5WWb3TjUdfCpvKQAAtJO+b9QW01ZINwnfX0WuCTdVVPVe4YYSZZ//tSS7L8yOgcWdrR9ev+sE+9tZ4anspyL2o6UzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kyp6jtyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kyp6jtyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC267C4CEE7;
	Mon, 13 Oct 2025 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367693;
	bh=3sdLnPEw+a0SKfTZds8OP1OYQ/5xaVAxP6n2GXwYjiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kyp6jtyxd9xiIqV8IeVYQnb64Y10Ip2N17P7mzieWiCrJpQePW8ZFYlNG4OX6Bnr6
	 d2s+HcdN1QGWNAO7cDDQPOKS3Q8G/+nPfKoG9QZHKvlxeEu3FiklKgah7Ocl/2qbBH
	 qTH+enDFDsRXqYJAsReLNh0lijwp4ZIhr0qtmb8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 099/196] misc: genwqe: Fix incorrect cmd field being reported in error
Date: Mon, 13 Oct 2025 16:44:50 +0200
Message-ID: <20251013144318.898127639@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



