Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA17433F8A1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300915; cv=none; b=kLai4Gll/EJBcvAPZw+09vupIcirFkFrrzP86P0XYDPF4BbAay9R1JKkBLLxbKcIDPk5jvchHIirx3BUHEWNOdJThr1x1ThvtVF8hSoSF5o81RL+Tr8ahlLPhioTvTNHAYdCzNugj9oKFWfmTaHJYPachVVaqbSXkDQI33o0qDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300915; c=relaxed/simple;
	bh=/zoBy3uGx+HR4XUY2HdxW4k0Go9xSXMWL9Xd5QeA3uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miOo2Pbhu1e5Nk92cBMjA33QnCWTV8vRG1Tvz91Da44/57D44iCRr+0BZT4olwyGViSJ9pt0xA+4WV2Q60soRqJB53NCEaapqjziod5z7pwoOzmcm/PJLQ9v/gB5spcorSlhjWr6DW5+8e0WGDApdwpmwe3wDbsoUr1ShrWbvtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hgl/ST9S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hgl/ST9S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 440F7C19423;
	Sat, 28 Feb 2026 17:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300914;
	bh=/zoBy3uGx+HR4XUY2HdxW4k0Go9xSXMWL9Xd5QeA3uE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hgl/ST9S6ZxJwq33tOxEGodvcmgiuS5nICtv5wY+kh1coeuBEqlqZAtlyutbsNAVW
	 g0Je2mtJLlzM3CQL4oC8C5McfiMOulqVGgScVsBI7y9kATNcROQBrPdMVva3oLk5+2
	 5C+9CFtdKkcnua0VrSEop8yHBPIfCN1pAAFC2LzGi9JqYxzPVmsTbA22ECwJ7KUG6T
	 MPtploJbm9E+rdYzv20wNxWyFfu8F7Ks5H9dlN1xwn2a8I/QziocwQyZeh1nPYPA6m
	 nTm6BVI76yj7i+9J522EBdI35FWBQQxVF5p9ZZzVr5/ZdFr/HyFxp92KBUj3PBzHia
	 RK8hE90QY00cQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Frank Li <Frank.Li@nxp.com>,
	kernel test robot <lkp@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/752] i3c: master: svc: Initialize 'dev' to NULL in svc_i3c_master_ibi_isr()
Date: Sat, 28 Feb 2026 12:35:41 -0500
Message-ID: <20260228174750.1542406-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 3c9ffb4db787428a5851d5865823ab23842d5103 ]

Initialize the 'dev' pointer to NULL in svc_i3c_master_ibi_isr() and add
a NULL check in the error path.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/202512131016.YCKIsDXM-lkp@intel.com/
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251215200852.3079073-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index e70a64f2a32fa..93531cb216d16 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -496,8 +496,8 @@ static int svc_i3c_master_handle_ibi_won(struct svc_i3c_master *master, u32 msta
 static void svc_i3c_master_ibi_isr(struct svc_i3c_master *master)
 {
 	struct svc_i3c_i2c_dev_data *data;
+	struct i3c_dev_desc *dev = NULL;
 	unsigned int ibitype, ibiaddr;
-	struct i3c_dev_desc *dev;
 	u32 status, val;
 	int ret;
 
@@ -590,7 +590,7 @@ static void svc_i3c_master_ibi_isr(struct svc_i3c_master *master)
 	 * for the slave to interrupt again.
 	 */
 	if (svc_i3c_master_error(master)) {
-		if (master->ibi.tbq_slot) {
+		if (master->ibi.tbq_slot && dev) {
 			data = i3c_dev_get_master_data(dev);
 			i3c_generic_ibi_recycle_slot(data->ibi_pool,
 						     master->ibi.tbq_slot);
-- 
2.51.0

