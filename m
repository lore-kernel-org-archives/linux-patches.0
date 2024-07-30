Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1481A76C5;
	Tue, 30 Jul 2024 17:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359223; cv=none; b=HLJH7HgNoTTGxPHC4tRWHWGoPqsbmGiah6dMlRv7T2lV8Mb+EG1q4XeXcYCRbsK2DgK4Gefvy1b796fYJPHgHsHLKc66SaKMGg/Y5Fe1NUH/gttJM/hbWcapOAJdi0DvZANhLqvu8Oj/aRlaUsMcACnwxlWkU38dQFL6Aix6Hys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359223; c=relaxed/simple;
	bh=Xge0ZkupSJjSIOKD1jc7WS7+IPoq405yaZqMyhR9Huk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEmlFmPEjBxCKh5DgWDI7C6qmNNyKvGFKsQIns+LmlaYESVk6qK6KQwnW5OCGpM1LT+kFzQ+br/f3AzzOgt0cBArmZFIjjzCPi2dsGKBEGsyRBP/IL7VGpFXMany2YUiaffbNACqSqXZrlY1s0m6Acaqj3I2EJPHZC5Tm3g13D4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HMInluf6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HMInluf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8125FC32782;
	Tue, 30 Jul 2024 17:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359223;
	bh=Xge0ZkupSJjSIOKD1jc7WS7+IPoq405yaZqMyhR9Huk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HMInluf6c7j3ea5SuCakX8Tu8kwtq/GbkNv7JtLiJf+s+MVt0OTBU8bPUWMizRZQJ
	 5B2qVOcTQcJr2/9hPHmgD/Gd0ad8macd/CGGMKUIeDKXh7HisV2+Vq/EcA1+gvjOUl
	 leeHaVlrZ0P5BJOJmALrcl7srN3JvGIuJRuH+y+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 453/809] MIPS: Octeron: remove source file executable bit
Date: Tue, 30 Jul 2024 17:45:29 +0200
Message-ID: <20240730151742.600090081@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

[ Upstream commit 89c7f5078935872cf47a713a645affb5037be694 ]

This does not matter the least, but there is no other .[ch] file in the
repo that is executable, so clean this up.

Fixes: 29b83a64df3b ("MIPS: Octeon: Add PCIe link status check")
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/pci/pcie-octeon.c | 0
 1 file changed, 0 insertions(+), 0 deletions(-)
 mode change 100755 => 100644 arch/mips/pci/pcie-octeon.c

diff --git a/arch/mips/pci/pcie-octeon.c b/arch/mips/pci/pcie-octeon.c
old mode 100755
new mode 100644
-- 
2.43.0



