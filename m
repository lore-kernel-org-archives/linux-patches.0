Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF529403;
	Tue, 23 Jan 2024 01:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974749; cv=none; b=ow6LFEjWnXfsYN+ZEX8MvXWtRYpBUPKbJA8i2dMfBFOiV21en1VbYi+CwNW3MWUibXQJqxvbmAJTeEPc7eJp3LXLuDREifRZz5/M3wBlWMk+W00wYd1uZ8mKB0t3jSM9GqZHW/X99NG9RtpjTSjzfOKhyMhGUQQpbozttGbzfNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974749; c=relaxed/simple;
	bh=J39zBbUDAzxslJBVoj1Enz16+7P3BUiH1ObnGqlXTtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyyNUDAkpwTty0pcdJs7awW46qjL2iZQT0p8DE4W6BfH+FP5ZgFeZ7bYMB1mUHDU59nv7MNgXpe8V7BAKoZ93gvueHxWajwMVwqB7uxIgGuTL7jwNrQ4ZmizeWoKA4yziiu28HzZkyvArSiA2qjKKb17gilBQTPfLJfJyQsf2C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWO5Yz5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWO5Yz5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118DBC433C7;
	Tue, 23 Jan 2024 01:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974749;
	bh=J39zBbUDAzxslJBVoj1Enz16+7P3BUiH1ObnGqlXTtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWO5Yz5UgzZbwzIyMXddUxjSMKRfd7w38AlJvPLkVh6SuXcX1UV9fwpchyTXs2yNy
	 gq3sNZ983NR/x7QPjZX9PHt0zMVrL8YfWsu9R+tvEPN4+P6xroYPTxp0lwkw3TFQRQ
	 yWfIDJQl+P0Qt5++FoEIPi/bFIwQGIDOA8oHuGmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Herring <robh@kernel.org>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 155/583] arm64: dts: xilinx: Apply overlays to base dtbs
Date: Mon, 22 Jan 2024 15:53:26 -0800
Message-ID: <20240122235816.796210226@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring <robh@kernel.org>

[ Upstream commit 23b697ec85f3e7beed271b9f344c54821de2251e ]

DT overlays in tree need to be applied to a base DTB to validate they
apply, to run schema checks on them, and to catch any errors at compile
time. Defining the "-dtbs" variable is not enough as the combined DT must
be added to dtbs-y.

zynqmp-sck-kr-g-revA.dtso and zynqmp-sck-kr-g-revB.dtso don't exist, so drop
them.

Signed-off-by: Rob Herring <robh@kernel.org>
Fixes: 45fe0dc4ea2e ("arm64: xilinx: Use zynqmp prefix for SOM dt overlays")
Link: https://lore.kernel.org/r/20230911214751.2202913-1-robh@kernel.org
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/xilinx/Makefile | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/xilinx/Makefile b/arch/arm64/boot/dts/xilinx/Makefile
index 5e40c0b4fa0a..1068b0fa8e98 100644
--- a/arch/arm64/boot/dts/xilinx/Makefile
+++ b/arch/arm64/boot/dts/xilinx/Makefile
@@ -22,11 +22,10 @@ dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-sm-k26-revA.dtb
 dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA.dtb
 
 zynqmp-sm-k26-revA-sck-kv-g-revA-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kv-g-revA.dtbo
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-sm-k26-revA-sck-kv-g-revA.dtb
 zynqmp-sm-k26-revA-sck-kv-g-revB-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kv-g-revB.dtbo
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-sm-k26-revA-sck-kv-g-revB.dtb
 zynqmp-smk-k26-revA-sck-kv-g-revA-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kv-g-revA.dtbo
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA-sck-kv-g-revA.dtb
 zynqmp-smk-k26-revA-sck-kv-g-revB-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kv-g-revB.dtbo
-
-zynqmp-sm-k26-revA-sck-kr-g-revA-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kr-g-revA.dtbo
-zynqmp-sm-k26-revA-sck-kr-g-revB-dtbs := zynqmp-sm-k26-revA.dtb zynqmp-sck-kr-g-revB.dtbo
-zynqmp-smk-k26-revA-sck-kr-g-revA-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kr-g-revA.dtbo
-zynqmp-smk-k26-revA-sck-kr-g-revB-dtbs := zynqmp-smk-k26-revA.dtb zynqmp-sck-kr-g-revB.dtbo
+dtb-$(CONFIG_ARCH_ZYNQMP) += zynqmp-smk-k26-revA-sck-kv-g-revB.dtb
-- 
2.43.0



