Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A02036124;
	Wed, 30 Jul 2025 09:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868528; cv=none; b=nGOMY/bYpLU6DoUJ7vzqceioZJXxnQJPG0o0KeygU4DngwkMxX95/55wdtTHp5IRpfe1rImyHk16uBOza65Vd5cXlDUMJ68aIEs714PJxc1tMwUVyCNGATEijUXb8+FiGLhWYxA5pm1RCzXlcGg6tEaHDKDb3+81zlI5GfXN+t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868528; c=relaxed/simple;
	bh=JzQwLew3a+gRJ2TmNrZ2DIBv1bQfNo+rVWEZzMcp4ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nAhxTmphppoOUj5brnScHlFvbthn6HbGufwzhqYk02r5hbRftrMUhIJhKmR5/KgN6zBzK2EaJEXUvpiGJgCwISfQpN8vjvDDBdfDXCrfVl52Y5XSzxf9gSiX6K5P+wckilpsJ6ZL3/ubSYQOJT7RtNyoZ0TrT87oj439ti6DuE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8H/nslu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8H/nslu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DE2C4CEE7;
	Wed, 30 Jul 2025 09:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868528;
	bh=JzQwLew3a+gRJ2TmNrZ2DIBv1bQfNo+rVWEZzMcp4ik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8H/nsluiWmkmJKyOJgdv/eMfoVTHZPXJ+2VMd6rHsUldknuTAjVOzp9L4Pcx25+X
	 pRKuzNPbIjWyoObnp6/fdsIyaHi/mte3cntiy5ue3pKGrKtYasFE9RqrvOAXi5nm6d
	 r7CUBKoUOM+DnHL09RzVlc3Up9qbmPlTPgIwF6ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Kumar Ramani <shravankr@nvidia.com>,
	David Thompson <davthompson@nvidia.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/117] platform/mellanox: mlxbf-pmc: Validate event/enable input
Date: Wed, 30 Jul 2025 11:34:41 +0200
Message-ID: <20250730093234.065424226@linuxfoundation.org>
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
index afc07905e235e..d305d23cf5199 100644
--- a/drivers/platform/mellanox/mlxbf-pmc.c
+++ b/drivers/platform/mellanox/mlxbf-pmc.c
@@ -1068,7 +1068,7 @@ static int mlxbf_pmc_get_event_num(const char *blk, const char *evt)
 	return -ENODEV;
 }
 
-/* Get the event number given the name */
+/* Get the event name given the number */
 static char *mlxbf_pmc_get_event_name(const char *blk, u32 evt)
 {
 	const struct mlxbf_pmc_events *events;
@@ -1648,6 +1648,9 @@ static ssize_t mlxbf_pmc_event_store(struct device *dev,
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



