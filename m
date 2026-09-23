Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 271AF3B388E;
	Wed, 23 Sep 2026 14:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172683; cv=none; b=RE7/1JFa6lysWkJTE0jzay1Omv+q4ek6jXhNih0s3LGkinJpMr5lxtnKfLfv9WDm0Wp8BE+JomWQoXOcICdUl7WC6SFjgxr0VWhYMi1/AGyosF2VzEZgqzkVaxZCoa0Pj52/dFIng56nqt3/SCrV+CrNkR8XJvVPSBn5ntY4Xf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172683; c=relaxed/simple;
	bh=1u2jxU9hPe+BspwTCqRdcBE6sUa6t2aBIVqTM7CB6H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQ7Nq9ToJZQK9kogfd7P4uniWParlVOng0sDbd2sqbYmKhQTZl/UcL4qVX5DvHOzDqHGvCMjfqscp0vgesRCWSek0GFQcBclbLaWuvRT3EJiKTDeXmzYG8rgarwduE/0hYnYjKtB8xNN2GlEucFBWtQEFcHY0gEs5qripKI/sd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/9e1sGl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/9e1sGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D0D1F000FF;
	Wed, 23 Sep 2026 14:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172681;
	bh=l41+Z/qxkqMPSgZJXtXSzeQcF2r42QBT8TjCHSENz7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v/9e1sGlQ29r1/dPQYFunXr8zxoLI+AfOwWGsnLpHPNdyeep4btPqDMxZQK+MAG18
	 bwNbsVmU0VVQgT3NXyeG7D0AEYaZmHHKA8Cj01HFaN8x0nHFMlNO9S0jtDNeFJgrBl
	 bP5HZVn1/dJLgYbbeiy24R0LaLk5CzL6BWG0vHcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 029/438] power: sequencing: Fix build issue with COMPILE_TEST
Date: Wed, 23 Sep 2026 16:00:50 +0200
Message-ID: <20260923140645.537132046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 3b54dbd119805361695cb50ca6a875f4c7518b74 ]

The POWER_SEQUENCING_TH1520_GPU driver depends on
(ARCH_THEAD && AUXILIARY_BUS) || COMPILE_TEST. This means when
COMPILE_TEST=y and ARCH_THEAD is not set, the driver can still be
built even though it requires AUXILIARY_BUS, which may not be
selected in that configuration, leading to a build failure.

Fix this by dropping AUXILIARY_BUS from the dependency and instead
selecting it directly, so the dependency is satisfied regardless of
whether COMPILE_TEST or ARCH_THEAD is enabled.

Fixes: 1a7312b93ab0 ("power: sequencing: extend build coverage with COMPILE_TEST=y")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Link: https://patch.msgid.link/20260826122742.153643-3-biju.das.jz@bp.renesas.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/sequencing/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/power/sequencing/Kconfig b/drivers/power/sequencing/Kconfig
index 1c5f5820f5b76..226c62704d9bb 100644
--- a/drivers/power/sequencing/Kconfig
+++ b/drivers/power/sequencing/Kconfig
@@ -29,7 +29,8 @@ config POWER_SEQUENCING_QCOM_WCN
 
 config POWER_SEQUENCING_TH1520_GPU
 	tristate "T-HEAD TH1520 GPU power sequencing driver"
-	depends on (ARCH_THEAD && AUXILIARY_BUS) || COMPILE_TEST
+	depends on ARCH_THEAD || COMPILE_TEST
+	select AUXILIARY_BUS
 	help
 	  Say Y here to enable the power sequencing driver for the TH1520 SoC
 	  GPU. This driver handles the complex clock and reset sequence
-- 
2.53.0



