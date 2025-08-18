Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E57A21D3DC;
	Mon, 18 Aug 2025 13:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524060; cv=none; b=CU0T4RLUErZihJebR7ldxCbnjXIoROSZr0IUNJY3VZtCt6JqY9/cB7gyfAXnn9fC8xQwB21lcudK2q1hW3dULKZtPYkbFXKlEWLX3OwVgy7MH12vxj1lk8ny2mNbtd7Kr0WsyyxyBbFSugCUZHa+en5muLf3aGen6+WHISBwRCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524060; c=relaxed/simple;
	bh=2oeiI9Rp2h72sZQGA8NZ3YJ6bnyxaX3jZ9dbcbL0DeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nlmsubqyveu6LONyU8e7y+0/i0JgpUb6ALTi6HT5EyLrODOaNbgNWQD7yNTZMW69Ahd2Sk3ZxgBcmzGj5b2/pnuclv6w960OdF00HEEQNffqBNGRoZtAMJ93ulKEQjxFuimGKMTlYCgsq0aRfFj+CuRdWOydoAjFtyvXRwG63UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4VkHX31; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4VkHX31"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14224C4CEEB;
	Mon, 18 Aug 2025 13:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524060;
	bh=2oeiI9Rp2h72sZQGA8NZ3YJ6bnyxaX3jZ9dbcbL0DeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4VkHX31EUMuwoFmrrmFWhG1Kui6Xz/8X9uiANJBL4W+xDj1Ya9GPqgJWuns50zMS
	 wij5phi0dQcQ+o//0h9BNWSCHWHgdnh99HslVyzoq6oGg2UWPHEZglExKc3XBWNrv0
	 RJar00xHKT9cOpAo+5IhXrszzADMZjrF/p4LTXmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Shravya KN <shravya.k-n@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 354/515] RDMA/bnxt_re: Fix size of uverbs_copy_to() in BNXT_RE_METHOD_GET_TOGGLE_MEM
Date: Mon, 18 Aug 2025 14:45:40 +0200
Message-ID: <20250818124512.046082185@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



