Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AB6244693;
	Tue, 11 Nov 2025 00:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822786; cv=none; b=VUvJSM9fiBBymQSza89udv9y2Ryme9jgN1ECT+yAY6Em7ySOcnU88wbxtZUH0RO/8BE317EdhJPW/RyE6mGdqv/UGLGMcsIpP5gPjhU2jqBnm8LQ6/xCzKirHqdyfTzHQXWecctarKu0ec44rAahRppIefiAbU6Mpm60KG18ays=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822786; c=relaxed/simple;
	bh=+3g18BZRfAIFgvBi/PqZYA0t7O+pkJskftaXOXfVXlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZ+1Zdu5TzA0ryUsX5OpiuItyI9IocfxgHgrJjeunz1aX9XPo3M4rQOj6nFk06jY+f7apOZIfab8TsjQNS5SHeaRuidRNr1B8SPdf9969TrHJ3yBICkQBbQCC2LFhQyOYlzsNooFgV92IDcqm5Q1t9OZepdhqgrvezOonVk+YMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+h/vlMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+h/vlMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E492BC19422;
	Tue, 11 Nov 2025 00:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822786;
	bh=+3g18BZRfAIFgvBi/PqZYA0t7O+pkJskftaXOXfVXlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+h/vlMTIrCmscEp0u6iOKBaSPbxw5jk5kqq8HSaHCnG1JMDmyIH6EiHSOj2nszW+
	 0eCggh5XEEWQ5YNMPURY62gpt+nk2Ju1zpdgMgiNKPjQNm9YDLZ5BqjeTGnF0la9Cy
	 r1cJx/quAwvnhRba9V5Lh+5tB/wNBetQ8zokvnw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Winona Schroeer-Smith <wolfizen@wolfizen.net>,
	Antoni Aloy Torrens <aaloytorrens@gmail.com>
Subject: [PATCH 6.17 171/849] ARM: tegra: transformer-20: add missing magnetometer interrupt
Date: Tue, 11 Nov 2025 09:35:41 +0900
Message-ID: <20251111004540.571274074@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit cca41614d15ce2bbc2c661362d3eafe53c9990af ]

Add missing interrupt to magnetometer node.

Tested-by: Winona Schroeer-Smith <wolfizen@wolfizen.net> # ASUS SL101
Tested-by: Antoni Aloy Torrens <aaloytorrens@gmail.com> # ASUS TF101
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
index 67764afeb0136..39008816fe5ee 100644
--- a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
+++ b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
@@ -502,6 +502,9 @@
 			compatible = "asahi-kasei,ak8974";
 			reg = <0xe>;
 
+			interrupt-parent = <&gpio>;
+			interrupts = <TEGRA_GPIO(N, 5) IRQ_TYPE_EDGE_RISING>;
+
 			avdd-supply = <&vdd_3v3_sys>;
 			dvdd-supply = <&vdd_1v8_sys>;
 
-- 
2.51.0



