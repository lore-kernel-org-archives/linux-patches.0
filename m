Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E2A17623C;
	Tue, 16 Jul 2024 16:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145678; cv=none; b=BN4U34/Lva6liZtaKadE1NjnD/+i8Nqn1L+QanS7NW9S8UypcSoEKX+fqoVuBb5UCoY5UiGIY8ZT/iKlkTxsfpRKino1ffzu/G8w7FVb4AzO993HM46OjAxmupJvZKhZ3kGfS/Q3KveI74m8KAaZTwITkVwXG41xa+PCPlvLwJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145678; c=relaxed/simple;
	bh=bHvQiK5zy4tCOTK2bdmY7Ispw/obNwcaeWOkAJBk8ng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uc8NsQkmvlJTKIU8S21S3zpe4RkV0a+AeSqV9btoOcGJtCDd1ndlJ2hbUsyDFY2TpLhgskeotwLXd73p2ni3ns52IcvKalH8hV6ysmvgMqZ1JCPX1gUImounajC4t6Q2XxSkrb6RHO18oSePrLOqTA3Kgenqhv0VTWy889EGXtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06QGm95/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06QGm95/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58951C116B1;
	Tue, 16 Jul 2024 16:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145678;
	bh=bHvQiK5zy4tCOTK2bdmY7Ispw/obNwcaeWOkAJBk8ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06QGm95/zYxM5PW3DMqgVLS31221Au+t5ygbGNapxwY0PGYcM+/lF78Rzov5YRIgE
	 lCa7nsJkfm39hwvhKfLpGN9qdmOGlytLn9zLyY1zeB/0OF6MGBmsBdS4nIrtQdEroK
	 XX3lVvb8DDpV9yBsnG+JIrmswYo9+CV618bzf0Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srujana Challa <schalla@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/121] octeontx2-af: fix a issue with cpt_lf_alloc mailbox
Date: Tue, 16 Jul 2024 17:31:49 +0200
Message-ID: <20240716152753.135524206@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srujana Challa <schalla@marvell.com>

[ Upstream commit 845fe19139ab5a1ee303a3bee327e3191c3938af ]

This patch fixes CPT_LF_ALLOC mailbox error due to
incompatible mailbox message format. Specifically, it
corrects the `blkaddr` field type from `int` to `u8`.

Fixes: de2854c87c64 ("octeontx2-af: Mailbox changes for 98xx CPT block")
Signed-off-by: Srujana Challa <schalla@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 4c73575fba7be..e883c0929b1a9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1661,7 +1661,7 @@ struct cpt_lf_alloc_req_msg {
 	u16 nix_pf_func;
 	u16 sso_pf_func;
 	u16 eng_grpmsk;
-	int blkaddr;
+	u8 blkaddr;
 	u8 ctx_ilen_valid : 1;
 	u8 ctx_ilen : 7;
 };
-- 
2.43.0



