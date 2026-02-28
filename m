Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA6F39B94E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302554; cv=none; b=kr+/UluioEcGd/JBE3REeqyb/Ktvonh1uCTNjR48a5RHDaiRZQX/o+8+yaApMXEaEkQuUIHsWloU9maL186ReXHFRtmVnXcZYRK1FCAz+BRH6wG9XRnndJ/i97Iefq6yMTREpWcPsHkl01chX1y99ojyVtjMAHcPPjIZWhzFliA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302554; c=relaxed/simple;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aA94uP/vXZ+VurNbCm8hGPumWmX/FAnvcpHOqbuFT1ohuquabrpv89cruHRi2QrL3LLOfQE6S+JxQ7UGY737lQJokvu2WtwNjsJrpmCy5MKgLVQGqp/0Gm4emgwrMwkuEhClutlncFVbKM3G0XKUc/+f5NIvfPXw/gCDhnu8le4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mClCFUN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mClCFUN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE94AC19423;
	Sat, 28 Feb 2026 18:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302554;
	bh=p4rHJPC3o4GDM2pdN5sNIKwiZ0RKIBavWvKJkyUnTbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mClCFUN3strA5KWrQuPAJU/uARBbP+9TviRgLjldvtH0QN3zb0pE7xPn0uM/8xoDy
	 Lmo9dlyZ9zXQAk3CzDlUc7MLIlqteNajn8HXqWr7G5/sUIuhPL5Xn/QZ/zJatAWYXM
	 /JlN1ZQIYklFDJYjCA2d0T3ZjiCb1uzDxRI6sIPeYtTtKDELuuFqTtWz3hRplv40eA
	 AyHG95wYWNSraS3IZewPHIFitfkEDKu40CXTO7QCs4YsgwoRkkBYjy52k24ZASZoAA
	 Rr+GoMe+icOiMG3vhOpNuTKTPH88tlvYoyFpHKYT0oneziK5qD1Ny0fBrKQS9iJjK5
	 /f5HoOOxw4jdg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 058/164] spi: tools: Add include folder to .gitignore
Date: Sat, 28 Feb 2026 13:13:17 -0500
Message-ID: <20260228181505.1600663-58-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

