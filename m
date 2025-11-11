Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBDF1C28E;
	Tue, 11 Nov 2025 01:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822901; cv=none; b=Onwyy0SNvDfsIhBEvSYmdKO/o3EK3g1zgsS05YWA5nPV7T4pP+C+pMo/ffUC+eKHcEwlREzZIACeSbfz+0VC5/68CSd85YLbhcBSJy1qODlOK18Fbg4/O+Go+D75p9g+taXtNfvETj0TFOFgBwAsS/rHQLq4uzo8IxhheYBiXW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822901; c=relaxed/simple;
	bh=p244uT/glDJQTeeI5+ze/ulsA+hIyipOGoU9vxjVuVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8F51p6Ca0yhJNFYRwaTI3vtgoM1CGvu1jyC5n1f7Hkla7yzei0tj7mRWadnspYJZoflBloFCjbFk3bl/85EywxErLuY5lzKKTJvzlJ22cqwSs3idklg4EpN2dB3qcuq2N4u50CtyUvQHo3kBbZlbZ28TDqsnJYOwBgs6XxdTJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xXIk76Qm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xXIk76Qm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E69C19422;
	Tue, 11 Nov 2025 01:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822901;
	bh=p244uT/glDJQTeeI5+ze/ulsA+hIyipOGoU9vxjVuVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xXIk76Qmn06+6aOjbgQMDF6ZbZAEqoRRBGkbxZxbEYIwCr4DGmuXuKC9nthiFiaMD
	 ImsryZc6aYGvHSqeHlYfrL4HCt+lxg9gDkZxTf3hmrlku3WvzFX0tHIMRTRIjILa5A
	 3MZsmZVRjPamyIOyM3W+i9sYoO/CvVxOUALPtE/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Winona Schroeer-Smith <wolfizen@wolfizen.net>,
	Antoni Aloy Torrens <aaloytorrens@gmail.com>
Subject: [PATCH 6.12 130/565] ARM: tegra: transformer-20: add missing magnetometer interrupt
Date: Tue, 11 Nov 2025 09:39:46 +0900
Message-ID: <20251111004529.873766325@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e118809dc6d98..676ed51aa2cee 100644
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



