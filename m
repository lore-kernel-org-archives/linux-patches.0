Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F293603DE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300964; cv=none; b=DyQVqH4wFnjwIImrgPk1u6xdHxWfr7HNTVg/cs3T/VsDcfu2yiGXJDlwcO0WxqJV8jp7QIC9n1i/FeeFpzWnAlAgTd//oyo+x57aCFcOrqZpLbdBMjttGP2z+B9AqESy9hoTIPFSg0spIrp8U1kylCESRdIt91BSfFh+IYQrj/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300964; c=relaxed/simple;
	bh=RNuByR0iAxchPqmm0SKtD72E0tyKVNCLnYOcjaFCxeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI1Ug/WKSG2l8ZEgj9SP6rOnLs+AMJn+OWOAItFgKHr1dGR04Vo+LKwjiPT2E9lWXQv4EWdJt22JeZBsZxnz79NSfHEUUFeq04dcN69w+dcnBtTB0R1xswd38pw3VF8kHwmTghy1xEU900E9TLPbnkrOPt7PHFOOji4LbQQG8eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qyq1RhL2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qyq1RhL2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D97CC19423;
	Sat, 28 Feb 2026 17:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300964;
	bh=RNuByR0iAxchPqmm0SKtD72E0tyKVNCLnYOcjaFCxeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyq1RhL2SOZ4HsJwFklJjs3YNLDb2yDTbdpy42mp6pSRlUoiKk65s/a1H9ld/DiSI
	 RZ2G6lbTFR8xeJSzb5CZmKDB4LN+ksi2eCKUrfYJJ/AHUFW7lhhBnAdO7fPjeUc6+m
	 j1P8xxoHaz7GBR8Ric8gNXiUkk4afjfSuwaXK90Y5DzQO/j5pz/yO74tF4RQ2UX3dO
	 rcowx0Km2EpTbvvm7vCYJ/B+Ee+fXoGui02cg/wceTM3Gj94b/uXPDO7aCJToytxmW
	 v3LTERh+p4JE5/8MC/Ey2q0UW308Puc44ZFdBwXO72AqtFhsZ1poDJFSQnkF5ryD/Z
	 3Jh1bKs3c5KRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 089/752] clocksource/drivers/timer-integrator-ap: Add missing Kconfig dependency on OF
Date: Sat, 28 Feb 2026 12:36:40 -0500
Message-ID: <20260228174750.1542406-89-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit 2246464821e2820572e6feefca2029f17629cc50 ]

This driver accesses the of_aliases global variable declared in
linux/of.h and defined in drivers/base/of.c. It requires OF support or
will cause a link failure. Add the missing Kconfig dependency.

Closes: https://lore.kernel.org/oe-kbuild-all/202601152233.og6LdeUo-lkp@intel.com/
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://patch.msgid.link/20260116111723.10585-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index ffcd23668763f..1119fbd52e1c9 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -254,6 +254,7 @@ config KEYSTONE_TIMER
 
 config INTEGRATOR_AP_TIMER
 	bool "Integrator-AP timer driver" if COMPILE_TEST
+	depends on OF
 	select CLKSRC_MMIO
 	help
 	  Enables support for the Integrator-AP timer.
-- 
2.51.0

