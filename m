Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 339E61C6B4;
	Tue, 29 Apr 2025 17:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948181; cv=none; b=DZ9cIq/I0ycLl2ciT/FItncfZKQ3SrKh3RVBN5uOAzr45HWkl0WSe5H1uTIe1+ZX7qgx040m3jarTDPSK/WFI0NTypVruA2QTFrn585YmJVAD01rCHYoB8kEBNcDTz38MrWKAQLJvOmUZ87C9Uv7H5e1TKi5SH4QIQ8wkdU7Jns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948181; c=relaxed/simple;
	bh=Gg73YJkQuUdHJr1UyaWtq4ccJ4ejzWZolBU7zMp4uK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HL9ptsP37zLMKLm928AVs86wQoofBBKSXdN6TUJrglo+l6Tst2mcFdd/Xqre9BagdcPWGnX4OH57moo9sPToF4H6cDEKDaDqzp8LEoWd+9O1z7YxHdOx4ZT6a++bkIYfgDgEb71gAqXcv1bfcmX5jL7Y7iWqU2Q1TtDop2pMJ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kUAMrHHi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kUAMrHHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD124C4CEE3;
	Tue, 29 Apr 2025 17:36:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948181;
	bh=Gg73YJkQuUdHJr1UyaWtq4ccJ4ejzWZolBU7zMp4uK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kUAMrHHi0LPPpt0d+4QX9HgtM258s1ZrjuSRXCFbYi2FHRNaF4UnLO/Iy7xjrjtov
	 /AzQmUcsctOmbyEEwB4UBeeCdGe0U5mg/q+5+pk6QAkKanddIVwv3uIdEZMbXSc8CU
	 mn9s+8PD6nQX+YWdeuDKaOE7iuOfib7N7nMVqypk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 213/280] nvme: multipath: fix return value of nvme_available_path
Date: Tue, 29 Apr 2025 18:42:34 +0200
Message-ID: <20250429161123.842340227@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f25582e4d88bb..561dd08022c06 100644
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



