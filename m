Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A603D402BAA;
	Tue, 21 Jul 2026 18:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657709; cv=none; b=of5pfM6qWx4ciqpJtg5M6faom1KhcylVFzLRJKgc8cAIbRwOBaBKlqJNuamlASBmP+zjfzCy4AQ/y4eVmBVNO+t1Guu9QsrYtB9ztsnZQB0x6tLsaHWWl8w0R1xqS8kslt1QpMGHKU5vaS1buMP1VQdsmd8OmUwDPjafQk35OY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657709; c=relaxed/simple;
	bh=H/TWFvJblAojFDvtC6IRnnZ3yh8vp8joVw8reae6IKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMcxXEEH0iHZnfE0ItP2FNhTsNpnoLMW6WezmXbt2DF3Nra89pH0IO+YmVdzWjzRYnbRheQNH2rU4YuvfduDmaw0fMkCqfzOtYwcLQBetQNhsSVjQONLoQdQj/QPGBpQw4CQyuPgVX2dM2cfgg0QSrXBA89nn7LyxAELUoGqm8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kijeppT1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kijeppT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B20CF1F00A3A;
	Tue, 21 Jul 2026 18:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657707;
	bh=Z3niagI6DMldivgs30bKkmImXFw7U5V0SuI6k22NG50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kijeppT1dup+EMf4EdHfEvNbbCkybm0gg5bhybO4UxjFQBiA+1NhUYM6CY31pfJBQ
	 Zn8SeWU+uZ2SgXzYsnCWEe4S76nGSh16J8dyoNKc/eeQh5F5JCvU4M/J3Px0hkh6qu
	 Ahnvhm2otp+xwDIyHHqrqXg/YEG0K7T6QakX2gUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0866/1611] octeontx2-pf: Clear stats of all resources when freeing resources
Date: Tue, 21 Jul 2026 17:16:22 +0200
Message-ID: <20260721152534.870845007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Subbaraya Sundeep <sbhatta@marvell.com>

[ Upstream commit fd4460721fb4062ef470ecdfdaedadfe7e415c09 ]

When all MCS resources mapped to a PF are being freed then clear
stats of all those resources too.

Fixes: 815debbbf7b5 ("octeontx2-pf: mcs: Clear stats before freeing resource")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Link: https://patch.msgid.link/1781636420-19816-2-git-send-email-sbhatta@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
index 060c715ebad0a1..9a104dafe63f12 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_macsec.c
@@ -211,6 +211,7 @@ static void cn10k_mcs_free_rsrc(struct otx2_nic *pfvf, enum mcs_direction dir,
 	clear_req->id = hw_rsrc_id;
 	clear_req->type = type;
 	clear_req->dir = dir;
+	clear_req->all = all;
 
 	req = otx2_mbox_alloc_msg_mcs_free_resources(mbox);
 	if (!req)
-- 
2.53.0



