Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A8212E8DE8;
	Tue, 17 Jun 2025 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176624; cv=none; b=ovNrZ1cteE2yDIw675Fpuy8IsVddMRND7H8moACFJIB/PkXamgmgILEKQ+EakfABKGt9o1gRPENL7uyffvF6yqxGTrEwvpocelXEb+GtZhPufgo72MWDtMglOMJNNDYZrJgGxCB/ONCy2XasMhiNJh3X57N0YoUMQ3ibVQw4OiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176624; c=relaxed/simple;
	bh=mckM8GQiBZXsezGG/Uedj1e4bwIi5ly3bsk2koN1URE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5j5N4AOFOoEuUQDPk8bMh95vAwCX9HHxE2SFV7JM1RRtCB5crzJr7NVMvALV25p20nywIz4s5tQ6v1/5to9QllFh3Q2SvXojYW94fsBXdxjZWGTKq1AvtGXYmPJDhvX33H+Iio7wBqasHvsKMHymLcDiJZOJHK1pS3qMMw37jU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mG30YIJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mG30YIJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C276C4CEE3;
	Tue, 17 Jun 2025 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176624;
	bh=mckM8GQiBZXsezGG/Uedj1e4bwIi5ly3bsk2koN1URE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mG30YIJUH4ApeCZRQmAHLA+7jcxZt3elLtKBL56+qHxQBaOoYWHBN1Q0Ryx0+L6BU
	 yQ+goRf2SJHoJtdjJlpvSrCaYaq5FtlSMom0kAsZaPD0Vobl2mzU2OUoO1qabqHoHj
	 JQNZH9SldNCUtXgnkId34NkHjW8896BlaricrcRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Tomasz Maciej Nowak <tmn505@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 248/512] arm64: tegra: Add uartd serial alias for Jetson TX1 module
Date: Tue, 17 Jun 2025 17:23:34 +0200
Message-ID: <20250617152429.655019194@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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
index 1c53ccc5e3cbf..9c1b2e7d3997f 100644
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



