Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD9D1F03DE;
	Wed, 25 Feb 2026 01:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983978; cv=none; b=COt6OknTW6gfKnhbOUBz0RfprbzPu6Ul+3GrJXRxegU5JmhtHIyma9k3ik4NDbAJV6yjQ7MoqDsKZqS/oIa8EG1iRirKK0JbK6rfypW8dsL0rfGS26K0ZeP5aj3AwmxVj2q27DlS3y2MDzaV3Yqtn+SrRTkhwOEfr17RqTj3izc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983978; c=relaxed/simple;
	bh=CX5HWE5psYBNMlvIF9VUEuuPcpIm+zgtxzcKLgbNdfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yeap6+TqoJAK9k/V5fpaRwrydixzQR9HH6wchA1Uua6adeu/a0uKRRbqsGZH4BRSX6xfj/J+skReE8Vi5ZnUwlDoFXhgq6c3IMartmwqpCcqFAZKRkQ/biREH1I0C51Bgpi3rltdy3A59lQleiXWmpMmSDwQMX1Uei5Vp215WiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9kAann1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9kAann1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0732C116D0;
	Wed, 25 Feb 2026 01:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983978;
	bh=CX5HWE5psYBNMlvIF9VUEuuPcpIm+zgtxzcKLgbNdfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9kAann1XIt3TM1tsl7PcoQNzkU2oYjuUFv4AwMjLtCBbGFFPCj78Y2S4aT8QJT26
	 TWh8n5lb2kpmlDJNM+mtgzEAaOR0Y0O4lumkkTF1LqBMi7TSArr/eLIsDd+zSRjHKW
	 5SGvrhyf+0QYZE8cq/zdPdIgoLmMx9wKCYU/q9q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 231/641] spi: tools: Add include folder to .gitignore
Date: Tue, 24 Feb 2026 17:19:17 -0800
Message-ID: <20260225012354.493601564@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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



