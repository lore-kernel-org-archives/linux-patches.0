Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565B01DDC24;
	Tue,  8 Oct 2024 12:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391114; cv=none; b=ioRJ/Kx686F4sxuPyi+Wd3aH5CIczstEDteGCAVC/lyNVx3kVGMla9AM6eKDqYq4TzOTIpQdL38jPb8wWcimKzaOv8t6M4zwnYywFMWQKxOQxQ/O+FLkmgoLAlSUZACb4kOWG6mGZiX0OvnoTEjPpYelTvYBeXXdWaMEW10VeWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391114; c=relaxed/simple;
	bh=vJQZ6zt1p4uuj8Z5femBQShRrDz4xpMmG/9KTwzaLOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEJ3jmSuXp0EDuhsLgJnFNBYgCahsDxjDigt49PxyYuzz1PUqlqDDSmgTeTSarIhM5sM4/ZLtU3ARA+tGAa0+1nVoMgihvMd/4KIo0wmvJ7U26fzfdcRbApuflWKm1l0bxi+3vvKEg+zqHxp/RlQnBWV2+xnV6RHQz3e1EPfZPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNLvHw9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNLvHw9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA8EC4CEC7;
	Tue,  8 Oct 2024 12:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391113;
	bh=vJQZ6zt1p4uuj8Z5femBQShRrDz4xpMmG/9KTwzaLOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oNLvHw9jVXN7kfpVkKZu2cHwKnvqaSsrJkIvf0sz0mdKTt6bqeT9xBodqMZTuGixh
	 PHlxzYF1j1Zw9a5okwPiqQ5RJhALIHKcagF5/DycjysGVMzq+BABtRoufZp2kAREZh
	 dhlQEnDiESvFzlVRnP2pUXONlDHG6ambZ2SOrvwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 012/558] mailbox: ARM_MHU_V3 should depend on ARM64
Date: Tue,  8 Oct 2024 14:00:42 +0200
Message-ID: <20241008115702.705809192@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0e4ed48292c55eeb0afab22f8930b556f17eaad2 ]

The ARM MHUv3 controller is only present on ARM64 SoCs.  Hence add a
dependency on ARM64, to prevent asking the user about this driver when
configuring a kernel for a different architecture than ARM64.

Fixes: ca1a8680b134b5e6 ("mailbox: arm_mhuv3: Add driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index 4eed972959279..cbd9206cd7de3 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -25,6 +25,7 @@ config ARM_MHU_V2
 
 config ARM_MHU_V3
 	tristate "ARM MHUv3 Mailbox"
+	depends on ARM64 || COMPILE_TEST
 	depends on HAS_IOMEM || COMPILE_TEST
 	depends on OF
 	help
-- 
2.43.0



