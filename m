Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6F120E71E;
	Tue, 17 Jun 2025 16:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177971; cv=none; b=qtZssy/31Wj4q4NKyrQSJbYNk2zGqivXYIBRe4IvpZ8zV9ktE/nQaTwNUQAtB3Wg+CaF8kDjT17tN/+Pk0esZxHlC1hrJIfkTtAa3SrYS/GT4WSies9MP8DwNeEf9sTP4MCMjBjJdc4Qua9tmGNYMqNQvw73D1c+N5EbjJnNbhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177971; c=relaxed/simple;
	bh=DIlQO5q1fTu7eq9svwzncX28tHuo6uAsEmHr8XxDP58=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJPvZjSkEtRD8KDqg3bVmVEl6q2HY5mKWDLc4qkfw86LQ2GvVVZ/AyAo3Vj7Zt9Ml8fFO2k2+lcYz4wxUfqY+E5c67tjgEJs3OuowjJcjgTMDSNgcRE6BObb0luVh4Iecgk9LEwX4L5o8ZADsodYis1gFWcmlh9gGx3J1Tx4EWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IG4oIOnN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IG4oIOnN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F84EC4CEE7;
	Tue, 17 Jun 2025 16:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177970;
	bh=DIlQO5q1fTu7eq9svwzncX28tHuo6uAsEmHr8XxDP58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IG4oIOnNp3VvDWTFQ5VCBAXPzAy5s1k5gY7qbUSVQK2gsxRIMpgnkTYhvLFfLgkHI
	 Bon+YBE20MqdIUgkz6RiWXTZvakL6nz2hb56p3whlY/8BWAc1F0cDyRA6gG43ZLnIk
	 89/mZ7XYWbSWlUYbJL1uLn0tP17EK1wiiKKhL0+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanth Babu Mantena <p-mantena@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 390/780] arm64: dts: ti: k3-j721e-common-proc-board: Enable OSPI1 on J721E
Date: Tue, 17 Jun 2025 17:21:38 +0200
Message-ID: <20250617152507.338701814@linuxfoundation.org>
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

From: Prasanth Babu Mantena <p-mantena@ti.com>

[ Upstream commit 6b8deb2ff0d31848c43a73f6044e69ba9276b3ec ]

J721E SoM has MT25QU512AB Serial NOR flash connected to
OSPI1 controller. Enable ospi1 node in device tree.

Fixes: 73676c480b72 ("arm64: dts: ti: k3-j721e: Enable OSPI nodes at the board level")
Signed-off-by: Prasanth Babu Mantena <p-mantena@ti.com>
Link: https://lore.kernel.org/r/20250507050701.3007209-1-p-mantena@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
index 4421852161dd6..da4e0cacd6d72 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-common-proc-board.dts
@@ -573,6 +573,7 @@
 &ospi1 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&mcu_fss0_ospi1_pins_default>;
+	status = "okay";
 
 	flash@0 {
 		compatible = "jedec,spi-nor";
-- 
2.39.5



