Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78245274FE3;
	Fri, 21 Nov 2025 13:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732333; cv=none; b=VdVFGmIiCPqgsUN61UzIZFmJDgDQBcJVQ9lTkVh0RdYIHWVDTyzxNsuf3RlOQbN9CD5YaFguIJ/WAWYCKlSj3SJ0BiZMS30FFspDcDThA6PDkUznmXt4hyQQIIAa0frhxr7AvwCCHI97/u6tmeOLyjz1IddSDhpX3SEdp7JChdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732333; c=relaxed/simple;
	bh=N0a9R6vRXp+oxK8JOm5oC3N7MI/FKF/6zOCFMter+J8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyPavIoR3RD9QOJAPE7zYOcnbga/upzAhbOYqHK7BhZuuTeKZfrcxh3oPUW4MwFqimy5iqOJZCTvtS87pEkkGvwBce0W+Dh0Pt4Ks6FYmGClEpExmY6bLMswFcsRJ6h/3PmtC1ehBbeKWjnB3gQ0jdyNOuPY+tlgpPhNiMvbLVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pQACec1t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pQACec1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF4DDC4CEF1;
	Fri, 21 Nov 2025 13:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732333;
	bh=N0a9R6vRXp+oxK8JOm5oC3N7MI/FKF/6zOCFMter+J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pQACec1tPiw0DFetX0gWmvKWpPi6PAHW6+Rvr5fk6m3qgvG1sBOpYq1Cz52H2tlVg
	 cdUY4h5NWAK2BF+nnNyxVtI+jnSsumCFFzUh3MLn2h2DLM9k3eggnRHocnxVRqmeqX
	 8GRegu6DaP4nMoAMsNG4HnWvN3TO4TXS51zy7NC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Winona Schroeer-Smith <wolfizen@wolfizen.net>,
	Antoni Aloy Torrens <aaloytorrens@gmail.com>
Subject: [PATCH 6.6 084/529] ARM: tegra: transformer-20: fix audio-codec interrupt
Date: Fri, 21 Nov 2025 14:06:23 +0100
Message-ID: <20251121130234.010010147@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 3f973d78d176768fa7456def97f0b9824235024f ]

Correct audio-codec interrupt should be PX3 while PX1 is used for external
microphone detection.

Tested-by: Winona Schroeer-Smith <wolfizen@wolfizen.net> # ASUS SL101
Tested-by: Antoni Aloy Torrens <aaloytorrens@gmail.com> # ASUS TF101
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
index 408cec997adb3..071a31191ec27 100644
--- a/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
+++ b/arch/arm/boot/dts/nvidia/tegra20-asus-tf101.dts
@@ -518,7 +518,7 @@
 			reg = <0x1a>;
 
 			interrupt-parent = <&gpio>;
-			interrupts = <TEGRA_GPIO(X, 1) IRQ_TYPE_EDGE_BOTH>;
+			interrupts = <TEGRA_GPIO(X, 3) IRQ_TYPE_EDGE_BOTH>;
 
 			gpio-controller;
 			#gpio-cells = <2>;
-- 
2.51.0



