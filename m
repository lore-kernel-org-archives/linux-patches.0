Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D52234252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301762; cv=none; b=Inz2hsTRu0jMwkiQBu7Wwu+REZS8QVXOwso8pkNSiNcxTJ8Ml1Ma81tTZdal3nDMEHvdpxj/aPlk8pyFerDlG1ChfpHVhiX06WQAlcb4YP7Iv0Nyc6IdPiz4jYfEJ2D3rbL/Tn7VbDD/lV+zK4g/nex7dJcTFAcvkwtEajdNabw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301762; c=relaxed/simple;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq38R2qDAIQWE/AR105mlFzEUbJMp8fZ71qwWx7xEsyUNZlkNR3lUX4xjW9Hk22o3gp3N0iN3Cuax09DsAnO7AF58uUgVkx18iatO5J2iWijqR/JPi6J/ZDj/2lHxjcbxMnvDRahf89XVu4fYY7JMHoiNxSqDACZVNTt3oaicF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r7K94orU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r7K94orU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5C9C2BC87;
	Sat, 28 Feb 2026 18:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301762;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r7K94orUgjfexD25AkCOiiD6M/X76MYfPuJ7ZsRprRMktZanb5z4gBmzUwpeUlkrO
	 vJr48Gbr9JpFz5bULgUGFDHh7Up76dBL0935guFy9aLn24+QkuhGbzQ7ban55K6p8O
	 7EIY5EAVzARvqnaNLM9T8hcgkFCofaHdCr6guhYIAdeW+FG0cYXONsPW599jAxI9z6
	 8FsmS+ErGpvJh5uf5SbtDATretKhi8lIrLfLnua8ZOfT1Fvk9dFKDVuBhZWkmi+bRo
	 p++0dBC7m492pKBIPi1U4rkKI/auVTRMXYudP8mGW+MtShMBPBA2FdQxI+tWWmUUyf
	 izV/fK/Xkl2UA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/385] spi: tools: Add include folder to .gitignore
Date: Sat, 28 Feb 2026 12:56:29 -0500
Message-ID: <20260228180011.1568201-167-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit 5af56f30c4fcbade4a92f94dadfea517d1db9703 ]

The Makefile for the SPI tools creates an include/linux/spi folder and some
symlinks inside it. After running `make -C spi/tools`, this folder shows up
as untracked in the git status.
Add the above folder to the .gitignore file.

Fixes: f325b73dc4db ("spi: tools: move to tools buildsystem")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Link: https://patch.msgid.link/20260209095001.556495-1-flavra@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/spi/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/spi/.gitignore b/tools/spi/.gitignore
index 14ddba3d21957..038261b34ed83 100644
--- a/tools/spi/.gitignore
+++ b/tools/spi/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 spidev_fdx
 spidev_test
+include/
-- 
2.51.0

