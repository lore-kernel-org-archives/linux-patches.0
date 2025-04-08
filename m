Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA952135CD;
	Tue,  8 Apr 2025 11:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110573; cv=none; b=XeVtbqsmPL48NBHr19Xe00u3cJyJ8Z0o4G7eHEdvhRKGy9vYAinbmJNfwnhCz2sYZve3aaZGhI8uP/rqpbhXoDS1qxJP+dj6rjFpLrmR136AoNiuLTmAfWpj5k1JUQO8p2AyNhv69rm9B3iQLtC+w/Uhft7ljBnWBNk4WaGWYP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110573; c=relaxed/simple;
	bh=jU3PH/P/9dECguzw9Z4AUQn10t1xJD++SUGEv0PtnNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jIIPDKHbbQRAw7fde4yuzgrGN7o69JPwD9Jrficmr40iDsBvilAC6mJ0cS2KhFATGwoS8fvRVTu34iWTrbmq7y6wxVKF5EwF6VlCX5geJVKTPgswuBAk1S+NuyCQ8Z6LwGIiyBN+S2bkt19DzYJO395cr+Fvq5CTwTAarNu63t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YyEqkW2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YyEqkW2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AF1C4CEE5;
	Tue,  8 Apr 2025 11:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110573;
	bh=jU3PH/P/9dECguzw9Z4AUQn10t1xJD++SUGEv0PtnNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YyEqkW2xuGYtGpuQodOtTwZuPLQIKmxXn3P95GwWoKQu2PJsO5yu0g3o7IPibtXy/
	 P2rQptramqQ0MDRpCdC/Q/nayfDlH5wgI4L0yx9NyPoJzIzV8DFpBP8p4qLIIseZfs
	 jRay8sGjrIuxQhYB7gZk4MaxRwLUhqD1amWHHU4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Asahi Lina <lina@asahilina.net>,
	Sasha Finkelstein <fnkl.kernel@gmail.com>,
	Sven Peter <sven@svenpeter.dev>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 113/731] iommu/io-pgtable-dart: Only set subpage protection disable for DART 1
Date: Tue,  8 Apr 2025 12:40:10 +0200
Message-ID: <20250408104916.905392999@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Asahi Lina <lina@asahilina.net>

[ Upstream commit 5276c1e07679c44ee021e88045bbb5190831b328 ]

Subpage protection can't be disabled on t6000-style darts,
as such the disable flag no longer applies, and probably
even affects something else.

Fixes: dc09fe1c5edd ("iommu/io-pgtable-dart: Add DART PTE support for t6000")
Signed-off-by: Asahi Lina <lina@asahilina.net>
Signed-off-by: Sasha Finkelstein <fnkl.kernel@gmail.com>
Reviewed-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20250219-dart2-no-sp-disable-v1-1-9f324cfa4e70@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/io-pgtable-dart.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/io-pgtable-dart.c b/drivers/iommu/io-pgtable-dart.c
index c004640640ee5..06aca9ab52f9a 100644
--- a/drivers/iommu/io-pgtable-dart.c
+++ b/drivers/iommu/io-pgtable-dart.c
@@ -135,7 +135,6 @@ static int dart_init_pte(struct dart_io_pgtable *data,
 	pte |= FIELD_PREP(APPLE_DART_PTE_SUBPAGE_START, 0);
 	pte |= FIELD_PREP(APPLE_DART_PTE_SUBPAGE_END, 0xfff);
 
-	pte |= APPLE_DART1_PTE_PROT_SP_DIS;
 	pte |= APPLE_DART_PTE_VALID;
 
 	for (i = 0; i < num_entries; i++)
@@ -211,6 +210,7 @@ static dart_iopte dart_prot_to_pte(struct dart_io_pgtable *data,
 	dart_iopte pte = 0;
 
 	if (data->iop.fmt == APPLE_DART) {
+		pte |= APPLE_DART1_PTE_PROT_SP_DIS;
 		if (!(prot & IOMMU_WRITE))
 			pte |= APPLE_DART1_PTE_PROT_NO_WRITE;
 		if (!(prot & IOMMU_READ))
-- 
2.39.5



