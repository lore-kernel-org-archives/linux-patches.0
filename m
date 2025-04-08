Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1139269D1B;
	Tue,  8 Apr 2025 12:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114204; cv=none; b=lVelpMYo3Mr5hYjWRosr/Z2tl42rVGq83vAEbFmh2veVGclaPppixmTzZleJEF1nIJeyiLiBiLG0CqFCKF2UKL6aAmA+etEz7H0p7lZOajpUHL0b4rUqBtgdZI2PJBNoJiKS26R7ggPwXPIM3GbDMXkmLCaEUEDZBxA3O4E8780=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114204; c=relaxed/simple;
	bh=AicrlRkubidpiwB+YdMPZa8yFbzgVccq7IQsGmkW+ME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P61bXWF53zrVZVG8FaouBf3JoGLNsXIUSLN/EYD5oTWzDPSkNPoJga4+11rr8U9rcTng11BAvhfeczrBJvfL16A3ND7ToQLcYY1hNnEJJ27OZrH6HFSx1IGVU4MOCBBIdzGHH4TR4yZaqwJE8iF1hLfl1au4HsFrQSoORyVNqCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFlw3QZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFlw3QZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53CA1C4CEE5;
	Tue,  8 Apr 2025 12:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114204;
	bh=AicrlRkubidpiwB+YdMPZa8yFbzgVccq7IQsGmkW+ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFlw3QZmUo/NfQOi0e3DWxzidStwziOvI/oT0sPUghzeEy4xrouyq45gDCOBdsvml
	 SRZwOvXD48zNzsBnWLkYLEM/gnHXUT0awlTtH+wesmMcLEZ1V7SHk0KkQ28qPZsmvj
	 X3/5OrdJIY5OebD5VLqcc/zyUnB6DIjciF22fd2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 020/499] cpufreq: tegra194: Allow building for Tegra234
Date: Tue,  8 Apr 2025 12:43:52 +0200
Message-ID: <20250408104851.754507203@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



