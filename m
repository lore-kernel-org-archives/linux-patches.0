Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F1326D4F9;
	Wed, 30 Jul 2025 09:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868531; cv=none; b=cQaj7M5GO6zO8mRHHETyR5k4704bxJbjgXGQdcyqUJK9Ita7WtFoDh+5P5EKmUdJp1P3KU5d0xo2WOC4k3tD80BmNQPJ4iKP+4wos9JwYf1WpkcpJp0Q1FQ8zfFzFkE+8lzJHYFZKjlnCAGavmolQ7xdgAxfCfeemhYGkSSc0G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868531; c=relaxed/simple;
	bh=XsEnYG4nEfObFacGmz/W2Rz7/7ZRmT5IEp7c5gMjRKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KrZ5kTWiwLqQ7W/y1ZD4Gs1zD5wycl23kFdXonAtGr6rnKLCxOBQY5eX9XP4EtrhHV8hHGfo9LPuuLgtjP9k6uHayZs6gYAypWxdOfyLXo36LyjG+5obn2uXO+fNjXa3E9n7zdXt3Tf+6f0r92y8dESq6N1FnYEU8fjzpRICJd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZ4NaJKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZ4NaJKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11BFC4CEE7;
	Wed, 30 Jul 2025 09:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868531;
	bh=XsEnYG4nEfObFacGmz/W2Rz7/7ZRmT5IEp7c5gMjRKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PZ4NaJKGYxQfa9dmRy05/fOOZ+vQf2FR6JBbyHoE2UvpaJTrfq61Zyv05luKx+YHN
	 9cjHp1EyCXHZ67EEZnGZxO6l7SXaZdNgfqOSmBXML48wK0TjygzRGosxfGECvaxi+8
	 V7/Z66KmPfzVhQ4pMogPorzaHhk8zs1w64UdZfO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 013/117] platform/mellanox: mlxbf-pmc: Use kstrtobool() to check 0/1 input
Date: Wed, 30 Jul 2025 11:34:42 +0200
Message-ID: <20250730093234.102955788@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravan Kumar Ramani <shravankr@nvidia.com>

[ Upstream commit 0e2cebd72321caeef84b6ba7084e85be0287fb4b ]

For setting the enable value, the input should be 0 or 1 only. Use
kstrtobool() in place of kstrtoint() in mlxbf_pmc_enable_store() to
accept only valid input.

Fixes: 423c3361855c ("platform/mellanox: mlxbf-pmc: Add support for BlueField-3")
Signed-off-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/2ee618c59976bcf1379d5ddce2fc60ab5014b3a9.1751380187.git.shravankr@nvidia.com
[ij: split kstrbool() change to own commit.]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index d305d23cf5199..9a0220b4de3c8 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1731,13 +1731,14 @@ static ssize_t mlxbf_pmc_enable_store(struct device *dev,
 {
 	struct mlxbf_pmc_attribute *attr_enable = container_of(
 		attr, struct mlxbf_pmc_attribute, dev_attr);
-	unsigned int en, blk_num;
+	unsigned int blk_num;
 	u32 word;
 	int err;
+	bool en;
 
 	blk_num = attr_enable->nr;
 
-	err = kstrtouint(buf, 0, &en);
+	err = kstrtobool(buf, &en);
 	if (err < 0)
 		return err;
 
@@ -1757,14 +1758,11 @@ static ssize_t mlxbf_pmc_enable_store(struct device *dev,
 			MLXBF_PMC_CRSPACE_PERFMON_CTL(pmc->block[blk_num].counters),
 			MLXBF_PMC_WRITE_REG_32, word);
 	} else {
-		if (en && en != 1)
-			return -EINVAL;
-
 		err = mlxbf_pmc_config_l3_counters(blk_num, false, !!en);
 		if (err)
 			return err;
 
-		if (en == 1) {
+		if (en) {
 			err = mlxbf_pmc_config_l3_counters(blk_num, true, false);
 			if (err)
 				return err;
-- 
2.39.5



