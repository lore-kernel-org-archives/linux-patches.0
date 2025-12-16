Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAE2376BD5;
	Tue, 16 Dec 2025 12:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888056; cv=none; b=QPwvaj/6d99ajmgkitE4HHmxIfJCDNLk00yJFA8O7CQsvgtEzWy5RcU4K3CCK69b4dfePxg8b0Djh9KEHOsoLjoGIC+P60GnboLwqOq3d/vqr4xYs9uV9FyYVUuS8nBqjona9SDYUHUyo3n4UxDBtJz0l3MCySflS27Jj6To+Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888056; c=relaxed/simple;
	bh=kiAM5AHd90wdE80LiUWUrpGWLWsuGzFFhJJvZTt+bNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2Xg15yHv0Sm0aLYb0l4zNzVr3VtxvN1vwFJd68/32qVvUTW/C+9RSCjpyALrwwt1FrmAJB7ORVVv8yLK65dBUBb5zkRzJeae5/YHKP3VFfVOrqUeV3daiVasM8Ugx/aN2vhn+uOObegwipn+ugAL+dlt4dIB4e+QTgXA8PGJ6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E4Br1Rw9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E4Br1Rw9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339DCC4CEF1;
	Tue, 16 Dec 2025 12:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888055;
	bh=kiAM5AHd90wdE80LiUWUrpGWLWsuGzFFhJJvZTt+bNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E4Br1Rw9HkfHihe1BjhuCNF0BxeyAwFmw6nPJ7evetc6/RPLRWqHpJOrLO8oIPk9r
	 wFSiIOLNX7zp+nU3xpB58CQWYR7lG0x42xgISS+obZkj32oNf4ho0q9i9y1gAatXKG
	 32gNeZf6KGrRQeJHyAdugsBdp0EApVOZIhLeHGlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 386/614] wifi: mt76: mt7996: Remove useless check in mt7996_msdu_page_get_from_cache()
Date: Tue, 16 Dec 2025 12:12:33 +0100
Message-ID: <20251216111415.354804015@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 2157e49892c5eae210b8fa6ee8672bd9d0ffa4b5 ]

Get rid of useless null-pointer check in mt7996_msdu_page_get_from_cache
since we have already verfied the list is not empty.

Fixes: b1e58e137b616 ("wifi: mt76: mt7996: Introduce RRO MSDU callbacks")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202510100155.MS0IXhzm-lkp@intel.com/
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251014-mt7996_msdu_page_get_from_cache-remove-null-ptr-check-v1-1-fbeb7881e192@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 9501def3e0e3e..284f2eea71e5b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1681,8 +1681,7 @@ mt7996_msdu_page_get_from_cache(struct mt7996_dev *dev)
 	if (!list_empty(&dev->wed_rro.page_cache)) {
 		p = list_first_entry(&dev->wed_rro.page_cache,
 				     struct mt7996_msdu_page, list);
-		if (p)
-			list_del(&p->list);
+		list_del(&p->list);
 	}
 
 	spin_unlock(&dev->wed_rro.lock);
-- 
2.51.0



