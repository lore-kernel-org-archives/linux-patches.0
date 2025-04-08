Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D6B26B0A7;
	Tue,  8 Apr 2025 12:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116100; cv=none; b=RochSC90nrSTuTLZHjAuYtvFMKt2etZWgswlIoggJgI9AIh+agpasFRbYFACsiqYxhnUUHngzzbMia0oSI5vb6yqSTgOWIceQr4JA1g/8dU/OIPoFGEHhj1ltE2YxK8b7CVCF50gb/zBcEAomrOYMS8Uyrsx/fTjicJj5E+aG0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116100; c=relaxed/simple;
	bh=52Gc5GjLR6gitlcKBkW+KF4wpXvnTxqdHdc/eNIRylY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8mBbMl5As8ON59Iov3kVYVxmff76gKOOSBT+bGqZxmN2aAAhMN954hH4VRbsbtWyYMxVW77QkFZ7/23rilko0W6sTFrnkm3UKKQtqUfti6SUT/JQ+LXcwKPtz5QWynYuzbO8oznONHBeqw8cZRYFVb2wdX73RL6Ojl4wQAWOS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgLmoYRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgLmoYRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB62C4CEE5;
	Tue,  8 Apr 2025 12:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116100;
	bh=52Gc5GjLR6gitlcKBkW+KF4wpXvnTxqdHdc/eNIRylY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgLmoYRFPHamWvMTSlFtAR/D1Y03vt+nO+uv95WEnQJwMTzDlR3ZZbMlCD5juEr9a
	 Yi2H/DiJLg/aAbKMkMDLbtN6wN/J194G3gg+BfT1wfteG9Q08jRiEzR5UPCE8u/Xdk
	 ii257cHEjJy+ybjBaekQ2x13zQpk74WHNmHqefqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/423] cpufreq: tegra194: Allow building for Tegra234
Date: Tue,  8 Apr 2025 12:45:42 +0200
Message-ID: <20250408104846.109264387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5f7e13e60c802..e67b2326671c9 100644
--- a/drivers/cpufreq/Kconfig.arm
+++ b/drivers/cpufreq/Kconfig.arm
@@ -245,7 +245,7 @@ config ARM_TEGRA186_CPUFREQ
 
 config ARM_TEGRA194_CPUFREQ
 	tristate "Tegra194 CPUFreq support"
-	depends on ARCH_TEGRA_194_SOC || (64BIT && COMPILE_TEST)
+	depends on ARCH_TEGRA_194_SOC || ARCH_TEGRA_234_SOC || (64BIT && COMPILE_TEST)
 	depends on TEGRA_BPMP
 	default y
 	help
-- 
2.39.5



