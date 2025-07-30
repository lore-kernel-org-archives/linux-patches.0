Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155151E25E1;
	Wed, 30 Jul 2025 09:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869006; cv=none; b=ezyjyH7rlNBLTR4ewgDG273x2xomMo1CTbXEH9P5qbSN+Cr+/4hhNJv2RqN/lmw6VNdhqZB4vP+nc5RkInjLIlOUz6kW+ifBD5/ErkqfWYPhUdys8ee6AIMYERiiLslJci3LOTbmmAculxp8F3JUFHiSuxqv15P8ZgLldgc3J58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869006; c=relaxed/simple;
	bh=L+ykS5JjwgehocijCnhiBiU3S1Tib96QG2MforA1nyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ppUI9ZTnlHVvbvZsLu3zKOAkkG9ZKhw3aqH7wM/oX9bcD9cb8qh6WWBmBnRhxevvY/s1xsFG38gVAlXQ20t70BKGIwULhJHYZrWnCZ7B3mNWa7tePZMBvVeuS3D7X8v15nA04erNNI/cV27a1HxxtaywUXoscuBL/10DSUFlux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jq8SJrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jq8SJrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C214C4CEF5;
	Wed, 30 Jul 2025 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869005;
	bh=L+ykS5JjwgehocijCnhiBiU3S1Tib96QG2MforA1nyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1jq8SJrMZLP571x4Jf4rywm9EJ1RbGXzDjzB0MLyW34ywyd29XpDfJgEh8Q15tGWH
	 XzuicLLjKxJrptr9DwzPgLiv8P02yaPWwS2NL2ZXPLt408kJFyn8TfBZHfsH8/4sMO
	 mQquRnVwxnAJSq/NplN1TVdLJwPUcEFJ8GZpodIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 14/92] platform/mellanox: mlxbf-pmc: Validate event/enable input
Date: Wed, 30 Jul 2025 11:35:22 +0200
Message-ID: <20250730093231.172697016@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravan Kumar Ramani <shravankr@nvidia.com>

[ Upstream commit f8c1311769d3b2c82688b294b4ae03e94f1c326d ]

Before programming the event info, validate the event number received as input
by checking if it exists in the event_list. Also fix a typo in the comment for
mlxbf_pmc_get_event_name() to correctly mention that it returns the event name
when taking the event number as input, and not the other way round.

Fixes: 423c3361855c ("platform/mellanox: mlxbf-pmc: Add support for BlueField-3")
Signed-off-by: Shravan Kumar Ramani <shravankr@nvidia.com>
Reviewed-by: David Thompson <davthompson@nvidia.com>
Link: https://lore.kernel.org/r/2ee618c59976bcf1379d5ddce2fc60ab5014b3a9.1751380187.git.shravankr@nvidia.com
[ij: split kstrbool() change to own commit.]
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/mellanox/mlxbf-pmc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/mellanox/mlxbf-pmc.c b/drivers/platform/mellanox/mlxbf-pmc.c
index b8fe51e6d4d3f..76966b3dc4ff6 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1105,7 +1105,7 @@ static int mlxbf_pmc_get_event_num(const char *blk, const char *evt)
 	return -ENODEV;
 }
 
-/* Get the event number given the name */
+/* Get the event name given the number */
 static char *mlxbf_pmc_get_event_name(const char *blk, u32 evt)
 {
 	const struct mlxbf_pmc_events *events;
@@ -1689,6 +1689,9 @@ static ssize_t mlxbf_pmc_event_store(struct device *dev,
 		err = kstrtouint(buf, 0, &evt_num);
 		if (err < 0)
 			return err;
+
+		if (!mlxbf_pmc_get_event_name(pmc->block_name[blk_num], evt_num))
+			return -EINVAL;
 	}
 
 	if (strstr(pmc->block_name[blk_num], "l3cache"))
-- 
2.39.5



