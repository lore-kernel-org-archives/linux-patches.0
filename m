Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89FA18DB2A;
	Wed, 25 Feb 2026 01:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983158; cv=none; b=Jm4IqnfPydYcDK83qZoJeDizGqLp+3neEnqfsHVFADX5Gkg0q7ZXRJcEGGlD7G+SjNLiwtK+46a3+moIF5Zzw7XdEPAbJ29vEyHa8JuolwR9ab9YJ3py+iiI7ovuRS2crPnocg+LY2wC3j9xyHrgC9KTugKwLf8vqvvEDe5Rml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983158; c=relaxed/simple;
	bh=9aVD/rrKbEmCYhgyNp3PO8Ooqag4nFee53w+qvQKN4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TEuAa26hl5pwINz+BNuUmxzeBcIrVDm84qxz7CJu5K+ekUxX8cZ1rhUR7gnnpgRk6CvWCdQSfhWmKevD3E/1X4N2ItqFUABlKMoi6Idx7BfI0Qfg+UF139DMmvp1VfRGD+uVNLNZe1z3MVF/lRNNmb+kR3Il0OpQSwJ0RIolKKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsObK/tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsObK/tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787F6C116D0;
	Wed, 25 Feb 2026 01:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983158;
	bh=9aVD/rrKbEmCYhgyNp3PO8Ooqag4nFee53w+qvQKN4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsObK/tfTbhIFeTnbJ2hJ6+8K1uUXlSSJpm8C6zTsthTFIVQsQLFF7i1g4S1rBGiV
	 XymMwwugrVv6esSbIf0k+Rrcy0e1cdYkKr+tIolx8x5awJbuf67qwrzZtdvr38R5ZH
	 17JST9Er3NeHkR3rKC0dV9yz+4hdT2bIIKorh2Mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 312/781] spi: tools: Add include folder to .gitignore
Date: Tue, 24 Feb 2026 17:17:01 -0800
Message-ID: <20260225012407.355212737@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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



