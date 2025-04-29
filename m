Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2078155A4E;
	Tue, 29 Apr 2025 18:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950749; cv=none; b=j39fVyHOrKTqYfMm6CoRvWJmCfcC+3beRYz/o3XX2a/A/vtfKVjcso3iT+3KRMFN6lfY7Pr1pFvROG1sPChX1AQ7l4f87AFTGXhLtlSQzuK2Nsh+rUpkXYkqllMwXfgO04bcNW12Idvt0QnijfrwTgUb2LQ0D6oXiKRJJirzApA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950749; c=relaxed/simple;
	bh=2zNklv0WkDYYMAHvEoQHVefNihShRlG9cq+sijKIzPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=McmQlm0bfgMdwrbDltzOw0UZSHxKVgLFDEi3+8CKKET2KlGcN/eE9UgHel3FM4fWkqpbHc2xtuZW1DIp6HGR26OAg4yy82EYivH4oGZKqVN5LSkdjwRoDnZDmI4GFElHqdiaYVw8b6Rryz0fVAgMf11J+jrX4G1i/Ed1cccMHw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1mzmBmB4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1mzmBmB4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33342C4CEE9;
	Tue, 29 Apr 2025 18:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950749;
	bh=2zNklv0WkDYYMAHvEoQHVefNihShRlG9cq+sijKIzPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1mzmBmB4B6IFUx+kQ9pw1xGtgRbra2Z/guf/XB3HrJgFfdntS7HUtMsKyW+pziJJp
	 VUYo+CCAH2+53vY9z1B1r0NmWhBC1nfMpwTtMXNGiFejVXXwAM9Mr0hSkKYfBWTr78
	 MLfDWVH4W+6sEYr7mLL0grPEHPTVgaL5uG7xRy3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 163/204] nvme: multipath: fix return value of nvme_available_path
Date: Tue, 29 Apr 2025 18:44:11 +0200
Message-ID: <20250429161106.079482956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 32283301199f0..119afdfe4b91e 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -426,7 +426,7 @@ static bool nvme_available_path(struct nvme_ns_head *head)
 	struct nvme_ns *ns;
 
 	if (!test_bit(NVME_NSHEAD_DISK_LIVE, &head->flags))
-		return NULL;
+		return false;
 
 	list_for_each_entry_srcu(ns, &head->list, siblings,
 				 srcu_read_lock_held(&head->srcu)) {
-- 
2.39.5



