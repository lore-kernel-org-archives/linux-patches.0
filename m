Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0BF719FA90;
	Thu, 15 Aug 2024 14:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732204; cv=none; b=CxSeaavqFJQyt93YKZS5SMkzb2A8F0F8ZEu0H+McgkaLTSEZjKXGxx+gupIy/XT7f9mVL/vab0SqHF0RfGZ01FoEaylm3uCZZtgtMX/aWJ5AujEB68CTinBdRVvCmI8CtoFNZbwPN0SDKimgkC/K2PHn4db3hwoll6h0LoJNz5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732204; c=relaxed/simple;
	bh=B3u5C+MC7Z9wijch+aviqACeKIzUk4yGyHizWjGrMhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uw/zjCKu1CM384Zg8Tp1TJ4hlriDlgeUnsMGmRRqla9VPjOjS0eQfmlmKiZ3MfU0hZkzPjjMCm3r6AF5ZvDqGv8S9hh10Fp8dnGdqav25bPqzeaB7nyoWecvCgCIAuuA22Q9WTQoUx8/5dwPbX6Lcb+8j2kvcjNSY6XJjG3L/RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFFgs3kn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFFgs3kn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BDAC32786;
	Thu, 15 Aug 2024 14:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732204;
	bh=B3u5C+MC7Z9wijch+aviqACeKIzUk4yGyHizWjGrMhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFFgs3knuIhKAkG+WHXAB8+VT+ald3aSTqeL7IfLRGFShXVRYcRlkBnDc4tymbRF+
	 LkKMJl6b10OR40A07SUBn7/X0PjigExTXTWPiURfGIq4eazpdYU7UiDmu06mvhq7Z2
	 65weZ3vwa9sUdjr0GI3Ti3UOGBeFYV7YpsH6rssI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/352] MIPS: Octeron: remove source file executable bit
Date: Thu, 15 Aug 2024 15:22:52 +0200
Message-ID: <20240815131923.355587534@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



