Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6661A6166;
	Tue, 30 Jul 2024 16:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356656; cv=none; b=PzulMGrMmwKI5ojoGcxAKw2YsAdyiIRKthgZkXvryWDOBiP2N9Pb5ahNoQSxmVh52ODN1j0Izv83FYYX4KQhhy3oVOtA18kZafA0KzeQj/8fvEDhRk/dG8GFzZOa/AyyadCa4r7rj8UANvxRIKJjkWY8QGyG4E8qC3Dc0pGgpt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356656; c=relaxed/simple;
	bh=7t7yVgcQTFzkfizSe0zU5O4OwGjknqUuaqDfrvRr1U4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLgFbxc8pfk1i9R7NQLOXxnXd773cseBUsS/qlnD5jK/dO1ozcRhwA/kUDLHN9YJIpDQRhHPDTZ9ejw5bx8i0TeLNkUkaEMYJ2TawFM+GHEvQHtXdYyiisrVkelPYFbDS6unvbASdWpohMh+XDP1RwPxSkwgXewTpW3Huq6kZNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHh1c8KM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHh1c8KM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 221A1C32782;
	Tue, 30 Jul 2024 16:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356656;
	bh=7t7yVgcQTFzkfizSe0zU5O4OwGjknqUuaqDfrvRr1U4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHh1c8KMPTbOv2UiEMTIL13lUnj6LuxcolY4OhiXLzRujJpsYGmc/X673A+g4P/Nl
	 1n41KvXiemBkmu1ro3Al1GugnnIaGtjY0gWajlJFna5rWUVLyVd3oGGDl44JXCXQab
	 17H3eQRCHFY7zQLtT2OhNNOXvIiEyFUr6Rrwmv3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/440] MIPS: Octeron: remove source file executable bit
Date: Tue, 30 Jul 2024 17:47:29 +0200
Message-ID: <20240730151624.298763320@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



