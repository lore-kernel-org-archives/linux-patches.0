Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C8E1898E4;
	Tue, 30 Jul 2024 16:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357815; cv=none; b=ck5a/0fE9pYde5vbA92tpMmlWFt50/Yh9Yu71OQaZTvmer8MykUQu7/foe1v5kaTwIB/QUvRINj1yj+rAvFbAT4cQOwR7UY+onGpwCwKOZdGZGjs0xhfbSMLk5tNbI0dHnj7id9HHqcJENSE6Beg7q5P9BN1cNhi8fJLZgwCtv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357815; c=relaxed/simple;
	bh=m8vmfqBqWVYSAs37pNFG5uM2q9pyuaeLsbwtdzECX4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RRP2aMAByh5XtRzxsGDnS34A0nxR3Gxk+do0xrhkm3j1wpdpUdsHiTnpsGdFzpAHqHeZLtS5h1HhI5Hq1S7qNwAQoRPHuAJr76707y39R9AlI9Hec9Ll7lHbF5ew6ZZrIqUGlHDS6pzVx5mOnT243An5zSUkhOp1eUoBTSmxP6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g451rqaF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g451rqaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC4BC4AF0C;
	Tue, 30 Jul 2024 16:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357815;
	bh=m8vmfqBqWVYSAs37pNFG5uM2q9pyuaeLsbwtdzECX4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g451rqaFoJpdgTEJqheX2xP5HgUF4hygEhzuCMUgu1OnsE03YDB3/bhBW1/qeIu9O
	 Cg1v6E2nTKiS/xK9SfUpWLY/E6holfjfAtOpc5gJDKLISui690bIYhtz1rC4ekW5zi
	 mHfa77UjsCxAsoTq07z5mJzTCxRCuX/0x3hXnl4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 294/568] MIPS: Octeron: remove source file executable bit
Date: Tue, 30 Jul 2024 17:46:41 +0200
Message-ID: <20240730151651.369077117@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



