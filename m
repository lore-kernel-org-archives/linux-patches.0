Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7691E2DFF18;
	Tue, 17 Jun 2025 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177964; cv=none; b=LLbngdbrkhm6DOkYlA27rwMehx0A1awF/9ZrlRt29o5cFU8a+YL2MLVOXpFO1+9eVZMMX4JJTy/J4hJihgHjIQS3X1nFunYvIuHTXPtaultJX46Wc9OSRXcRGreFkSymUQbR5JZWFDoLQnm0wtspRoQQp61AUAVVzsTqaHp2Ozo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177964; c=relaxed/simple;
	bh=camwjpo32DkZOgtV5mV9JHs3jP9us6HUfM74giQB3Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGgc2oJIHva49MIFxTMUwuSndGO3QU2qJYdTTLPY0dComdE5SE8eQ4yN8j2NQOJoEKynuIYSn0f5yMVcw3IFva3QQdJ+GOudnxaWefYrMp5JCy/56tl3YUw0aPLyQCXt/i+eRx1KqIFXE3aYifKlf4OXTIKhKkWfVPjZMWFctQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zdm8DqeB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zdm8DqeB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCC32C4CEE3;
	Tue, 17 Jun 2025 16:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177964;
	bh=camwjpo32DkZOgtV5mV9JHs3jP9us6HUfM74giQB3Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zdm8DqeBxGMka4BtH+xXHk38JaGinQgqkWtf0tUjXHaZlSWMQY3v4m3w2ifn9Zo/Z
	 qKwFc+2BuvjRfHVWOwDv2dqWV3STbIXQJVj5jEW37fOnqKpphbNNWPoR5B5RSCm2j5
	 VDLkP3X5w8yXLAatX/pfP7CQK+KMCAxfn+k/14Qc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Tomasz Maciej Nowak <tmn505@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 389/780] arm64: tegra: Add uartd serial alias for Jetson TX1 module
Date: Tue, 17 Jun 2025 17:21:37 +0200
Message-ID: <20250617152507.298393377@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit dfb25484bd73c8590954ead6fd58a1587ba3bbc5 ]

If a serial-tegra interface does not have an alias, the driver fails to
probe with an error:
serial-tegra 70006300.serial: failed to get alias id, errno -19
This prevents the bluetooth device from being accessible.

Fixes: 6eba6471bbb7 ("arm64: tegra: Wire up Bluetooth on Jetson TX1 module")
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Reviewed-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Link: https://lore.kernel.org/r/20250420-tx1-bt-v1-1-153cba105a4e@gmail.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
index 9b9d1d15b0c7e..1bb1f9640a800 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
@@ -11,6 +11,7 @@
 		rtc0 = "/i2c@7000d000/pmic@3c";
 		rtc1 = "/rtc@7000e000";
 		serial0 = &uarta;
+		serial3 = &uartd;
 	};
 
 	chosen {
-- 
2.39.5



