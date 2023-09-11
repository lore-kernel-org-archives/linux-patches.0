Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B03F1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDF0C433C8;
	Mon, 11 Sep 2023 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440973;
	bh=2+p1u9nU/hc217bj5DygjZuEKhaU5rWVTQeKI7rQwTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v8sQ2R2POoPXFxrm0ZbrctM3kv+37TlgAh4xrTiNzEAcmt12VH9qMQ+jr+duSEYZh
	 5HkWFMw1PE4lOP9CLvcUIOayDPklk0wIjl1NiIdXN8oGNlKffRPc6rXjDU0c2lZ9W6
	 Wt0xrhrZMH4F/oTYCC09n/LuqV4vDcox1jn5g/bQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 250/739] arm64: tegra: Add missing alias for NVIDIA IGX Orin
Date: Mon, 11 Sep 2023 15:40:49 +0200
Message-ID: <20230911134658.137371305@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit d97966df30ed8c7df0350b8ff6662e38ee88c39f ]

The following error is seen on boot for the NVIDIA IGX Orin platform ...

 serial-tegra 3100000.serial: failed to get alias id, errno -19

Fix this by populating the necessary alias for the serial device.

Fixes: c95711d7dbc4 ("arm64: tegra: Add support for IGX Orin")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts b/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts
index 43d797e5544f5..b35044812ecfd 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dts
@@ -12,6 +12,7 @@ / {
 
 	aliases {
 		serial0 = &tcu;
+		serial1 = &uarta;
 	};
 
 	chosen {
-- 
2.40.1



