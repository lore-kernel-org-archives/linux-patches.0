Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AE73E3C5C;
	Tue, 31 Mar 2026 16:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975000; cv=none; b=DCYLekuJqpraKb7UPjZvR6WQ/T0+8FNC26kxvLuA8p1PfZogTyUyv9arBI53GcpVFJq32QDrPB5SjcpMgSAI3KKEXosKiXQBSQA/HBAUEK7U5sGYD4yY6b9OsmO3bUWSWYXsweTVtnuGMoFWkeixHxQVdl0PN+eFnIctcvop0uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975000; c=relaxed/simple;
	bh=r4yg3WzScmfU6IXJbhJUwCzj5+i4lIzJoOQhefDmUOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+qO/YLP/vEpImTmS7M1m4kqMaiDnzOBNmuXImNLOtB4UFdUt2m8BOJdLiWQ+RJZB6PZoSG5+pSutRjUt9g6nHNCN+3FFiY9pMPqq7zsNQ7IESc4tTXS1yWMpdJKa5G+Oh4LXiWRoAkrzmFT05c5n3MBF1bVomV/CD9itCkUfhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y4sTmLEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y4sTmLEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEDBC19423;
	Tue, 31 Mar 2026 16:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975000;
	bh=r4yg3WzScmfU6IXJbhJUwCzj5+i4lIzJoOQhefDmUOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y4sTmLEA2bc35msITbadeDalWbc9gujbyT+vZVTOtWPKVH02E54kdRily8ZZjbamU
	 rbkMOnJl//P++8SGHp5cL2ophJQOjeNbchd51H2BBJzvHcXDG3h0EchAmjB6hC36ae
	 JGUQk1OocpVcm7GYQOmnswHXrvsrITdWDAbuvs/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 092/342] pinctrl: stm32: fix HDP driver dependency on GPIO_GENERIC
Date: Tue, 31 Mar 2026 18:18:45 +0200
Message-ID: <20260331161802.406339022@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit c8cfeb4b9dda2cdfce79519aee4aaff16310a7b6 ]

The HDP driver uses the generic GPIO chip API, but this configuration
may not be enabled.
Ensure it is enabled by selecting the appropriate option.

Fixes: 4bcff9c05b9d ("pinctrl: stm32: use new generic GPIO chip API")
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/stm32/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pinctrl/stm32/Kconfig b/drivers/pinctrl/stm32/Kconfig
index 5f67e1ee66dd9..d6a1715230121 100644
--- a/drivers/pinctrl/stm32/Kconfig
+++ b/drivers/pinctrl/stm32/Kconfig
@@ -65,6 +65,7 @@ config PINCTRL_STM32_HDP
 	select PINMUX
 	select GENERIC_PINCONF
 	select GPIOLIB
+	select GPIO_GENERIC
 	help
 	  The Hardware Debug Port allows the observation of internal signals.
 	  It uses configurable multiplexer to route signals in a dedicated observation register.
-- 
2.51.0



