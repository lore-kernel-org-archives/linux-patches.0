Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F49211A0B;
	Tue, 29 Apr 2025 17:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946488; cv=none; b=jWhsKUF/oXhP6Gpj4elSQZuvtuJgpC5RoYJ1mVmSuSLqnmgMhn7aCxxX8RCCfeyQTdD1iGMbq+zMapIBEggubmDLhYqRz+srQIODfFhIAi8MMB4rSVZtD8U/iyR3T5PD9HlBs6E7UqU/PKKhiGcYxBYhHBIoWWSPs9CUSRGuKiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946488; c=relaxed/simple;
	bh=Hs/fII55j4lQ5a0VD7EA94GYTiD8wqe6qXHkPdtuKtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RNGjtnXAboozJvbP6YoZEgRqY46exgZVl4PevT7honMkEWw8UtFzmFc5cd7i//H7AmMYWvCPFQANylgJFzyZT3oQxOW7Fc4GHPm1lavubh7Q1J5XAEaIi7l3YyKmgK8XTWn79BSbuPo8YOlTJ9h5Hpr+FJvpGQRoP5qxLI+gj4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpYcaxdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpYcaxdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0229AC4CEE3;
	Tue, 29 Apr 2025 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946488;
	bh=Hs/fII55j4lQ5a0VD7EA94GYTiD8wqe6qXHkPdtuKtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpYcaxdR6DILLc9/fPNbuiVnWGkzoMYNDdDspLVaxI7/H3Wz7FAOd3oLsiibzprDM
	 aDqfGuMiMLrbfKvqTJMfbOLCXKppEec99hNkGd/bGlTImx4sbUC5wMLOOxOkWldiq2
	 KJBK8oKvdB7DupQdIwgXkNevnjFTnMnRVlsCzdLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 254/311] nvme: multipath: fix return value of nvme_available_path
Date: Tue, 29 Apr 2025 18:41:31 +0200
Message-ID: <20250429161131.428773437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit e3105f54a51554fb1bbf19dcaf93c4411d2d6c8a ]

The function returns bool so we should return false, not NULL. No
functional changes are expected.

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 2a76355650830..f39823cde62c7 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -427,7 +427,7 @@ static bool nvme_available_path(struct nvme_ns_head *head)
 	struct nvme_ns *ns;
 
 	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags))
-		return NULL;
+		return false;
 
 	list_for_each_entry_srcu(ns, &head->list, siblings,
 				 srcu_read_lock_held(&head->srcu)) {
-- 
2.39.5



