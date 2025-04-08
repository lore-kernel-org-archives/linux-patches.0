Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CAF268C72;
	Tue,  8 Apr 2025 11:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110339; cv=none; b=lggGHSHwJl3wSMDd/Xa1w8+HgWi8ZNH0Itzl1XqL0BEC2AocwN/tPO1c3lNpsMbLcpuTjkkQUaJM1DzdOc0k3jkT6bI5+jBxHho9fg5W8CiaIo6f3qbiSzd03a69rmzy7ijgL+awTHLmlG7oinigcrGQFpEUj6xVgfduxdSNM7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110339; c=relaxed/simple;
	bh=3MS+XuX1TKrv94vD5xKgrHNXcvS67DFCTGtkM4HOsBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPGy8eJZu0WAq3erVtSbkOOL6Ai1AsNc0bSm01DCV30KtBQkLSMPix3ZicrPfxj0Lf6thykb1k50GUdjKdEXNdhQUlupiHjtKjSvFPZtPwqwxFZqxsQfXlQaCqKacXufvt0PX9u0X4tfQOWV3c97c84YXI5VkFl5aNNrMMKT5b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DsO4aBil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DsO4aBil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146F8C4CEE5;
	Tue,  8 Apr 2025 11:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110339;
	bh=3MS+XuX1TKrv94vD5xKgrHNXcvS67DFCTGtkM4HOsBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DsO4aBilcE5yLmPg/15zHpgMecF6cYODGZmrrDLGdem4IVfyZYe+Pv80pPih/4bPr
	 huBoRy2/mdlZkI6C+w9fAM79eIRnyokqqcKuMPx4j/D3wajglYxhpAX9n3PFHY9hjb
	 03YF//XoV6irrLycjz6mKJVC3bjjPg6Rz45tCjP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 027/731] cpufreq: tegra194: Allow building for Tegra234
Date: Tue,  8 Apr 2025 12:38:44 +0200
Message-ID: <20250408104914.898903826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit 4a1e3bf61fc78ad100018adb573355303915dca3 ]

Support was added for Tegra234 in the referenced commit, but the Kconfig
was not updated to allow building for the arch.

Fixes: 273bc890a2a8 ("cpufreq: tegra194: Add support for Tegra234")
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/Kconfig.arm | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/Kconfig.arm b/drivers/cpufreq/Kconfig.arm
index 9e46960f6a862..4f9cb943d945c 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -254,7 +254,7 @@ config ARM_TEGRA186_CPUFREQ
 
 config ARM_TEGRA194_CPUFREQ
 	tristate "Tegra194 CPUFreq support"
-	depends on ARCH_TEGRA_194_SOC || (64BIT && COMPILE_TEST)
+	depends on ARCH_TEGRA_194_SOC || ARCH_TEGRA_234_SOC || (64BIT && COMPILE_TEST)
 	depends on TEGRA_BPMP
 	default y
 	help
-- 
2.39.5



