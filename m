Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8BF322C97;
	Mon, 18 Aug 2025 14:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525958; cv=none; b=AQWLXXsMu9k3N4HU1NJTMbBQnH/+JbRhhBiNZBuun1HRwinpANoRl0hWsfTveXwvQ5/2SJ8GQRpsYOVmtTUXtWqMFYqoUgMTZCnIuKGeMa2pReu7ZDWpFytRyJrVaU8z8qfLnoCdbit/PDkCICxbm62lgRV//5oKdyZTg6+wERY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525958; c=relaxed/simple;
	bh=ky6hTfr8SJOukVmMcn0iGJV/6y8dkdwKFS1QqvOX0Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wq2kiKZpOunJkRdA4NyXE8835wqQa9R6qK8vAdTXC5eRbT8/IHjUX9C4JsF9thuuavGEQxmtDc6JgREm0QE4eGF0c+ctaeCgAeOX0GeoJQvBrun9ORM3hSz1oy2TAFcNvgyATnhqQg7oCCTO3BCAeqjd/wuppGI/qcYIV+Vw2k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNX2jJ6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNX2jJ6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADE0C4CEEB;
	Mon, 18 Aug 2025 14:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525957;
	bh=ky6hTfr8SJOukVmMcn0iGJV/6y8dkdwKFS1QqvOX0Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNX2jJ6Igba+YflkIqdzY/srs2seoYNVnApAzbiYllcvCtiPwHVCjqNStOtV2gSzL
	 a5+V5r2B41rTLkKHQYkkkbRIhu69/Gjp9z/Qd7Q/1u97G0u8+n0N25xQRYWlgHupFU
	 8s0BUmJ7qWQ9fzp9Kzwk1J4PznA3mAVGja6ax7QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 383/570] RDMA/bnxt_re: Fix size of uverbs_copy_to() in BNXT_RE_METHOD_GET_TOGGLE_MEM
Date: Mon, 18 Aug 2025 14:46:10 +0200
Message-ID: <20250818124520.602789645@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 09d231ab569ca97478445ccc1ad44ab026de39b1 ]

Since both "length" and "offset" are of type u32, there is
no functional issue here.

Reviewed-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Shravya KN <shravya.k-n@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20250704043857.19158-2-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 063801384b2b..3a627acb82ce 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4738,7 +4738,7 @@ static int UVERBS_HANDLER(BNXT_RE_METHOD_GET_TOGGLE_MEM)(struct uverbs_attr_bund
 		return err;
 
 	err = uverbs_copy_to(attrs, BNXT_RE_TOGGLE_MEM_MMAP_OFFSET,
-			     &offset, sizeof(length));
+			     &offset, sizeof(offset));
 	if (err)
 		return err;
 
-- 
2.39.5



