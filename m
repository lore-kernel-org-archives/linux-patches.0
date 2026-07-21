Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD9439B48E;
	Tue, 21 Jul 2026 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662221; cv=none; b=dKHlhOLfFusTy4k3iYEHZjI9J7pT2EmwxE9JeTg+7JySTxGM9kOZ0HzH28qriiFTWgYLOb36nWUyWFo5HtezMEFe27BS3ubFEi8lx5RfaPWQcu5SLK/tMiOzVddv6H2RkKryVO4n6EbyEkibh7sgjyCi0qAWLfZePRoK6bIDERs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662221; c=relaxed/simple;
	bh=4gm5SnYrQToNkhPFwVmvf9oY0rUfXrItAd1DgJz/iko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0j4Sou2shXRq8dDm8uuusLeUk7OxvUK3rzQLByAch25NKQBZ4akiHEobpwnBAIL4Nq2ud4d6UDsZ4X4+fpJ7gFFE2e4DQZvk9NXcOxEuU5v0lXtTCPwQZFwhJQYq5cg7AcNV0uzZusmmiZZbp8ua87PboOh3hPmHxAW6350Z38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=homLjIgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="homLjIgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE9D1F000E9;
	Tue, 21 Jul 2026 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662219;
	bh=12eNEKR7jERiCmXmvFyT9/SmngmNp4ApPbKrQWCnbYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=homLjIgLquARMxCrBNHMm5XVZz83bW3f5JxjyosF0f/yd8GIIs/boF0uH0zfFULW2
	 kQUrkz8PyU3QaYB5Dxt5vhcefAtelAZLsNqxGufNK0txGXUCKjW3Bs9uG5GCgFscYX
	 tggH4C8ZgZdk9GaprTu+e0i8op2ucoKLUSYPwCrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0360/1276] net: ethernet: mtk_wed: debugfs: correct index in wed_amsdu_show()
Date: Tue, 21 Jul 2026 17:13:23 +0200
Message-ID: <20260721152454.165414901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 14a8bc41ce9edae42d56466063a7f2c84a16c45c ]

WED_MON_AMSDU_ENG_CNT point to different entry by 'base+n*offset' mode,
correct the wed amsdu entry number in wed_amsdu_show().

Fixes: 3f3de094e8342 ("net: ethernet: mtk_wed: debugfs: add WED 3.0 debugfs entries")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Link: https://patch.msgid.link/20260612064501.203058-1-guanwentao@uniontech.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_debugfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
index 781c691473e14f..519c364e87d197 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_debugfs.c
@@ -310,9 +310,9 @@ wed_amsdu_show(struct seq_file *s, void *data)
 			      WED_AMSDU_ENG_MAX_QGPP_CNT),
 		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(1),
 			      WED_AMSDU_ENG_CUR_ENTRY),
-		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(2),
+		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(1),
 			      WED_AMSDU_ENG_MAX_BUF_MERGED),
-		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(2),
+		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(1),
 			      WED_AMSDU_ENG_MAX_MSDU_MERGED),
 
 		DUMP_STR("WED AMDSU ENG2 INFO"),
@@ -414,7 +414,7 @@ wed_amsdu_show(struct seq_file *s, void *data)
 			      WED_AMSDU_ENG_CUR_ENTRY),
 		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(7),
 			      WED_AMSDU_ENG_MAX_BUF_MERGED),
-		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(4),
+		DUMP_WED_MASK(WED_MON_AMSDU_ENG_CNT9(7),
 			      WED_AMSDU_ENG_MAX_MSDU_MERGED),
 
 		DUMP_STR("WED AMDSU ENG8 INFO"),
-- 
2.53.0



