Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FE64DA9B0;
	Thu, 17 Sep 2026 16:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664112; cv=none; b=n3CCjkBpuFTvj7FPYwtW+Y4f0ybSBzSdfA39woYQvshN/YHmZ9d+x8DshS3OBDgiLZrP0ZXjTQSVRJ3Xg5vBbBOZRP8wMC6sl/Lrs7AJtk+lKzGox1BtcJRxOnQQzTUXKxbM4bEUKS4zN01UbR8dpJ727OLz56+th32GTPYy7nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664112; c=relaxed/simple;
	bh=Dmw0CQ89Mt8y5KWn5A0mATAr5yA0bL14vw7AjBeozrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KeXmKx/WbcM2cTdnMWcF39mHOLrHS+gsCf4d1joTyxkdUxtJDjgRO9WFbZszFnxs3eBAluhFvWc3hDPd6auBSr+TX7wXO9wT2qQWIOivq6FNHyTbLF+Pu1hGKuCPGcNqn8WzOlhzn07K19IO2ECc3JmW34YDf/7ndtXJqh9slxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mTceT0+r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mTceT0+r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AD61F000FF;
	Thu, 17 Sep 2026 16:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664111;
	bh=Cu0Rwk6rLyHHSesuFRF0OMpLZ/Uh2viC3MsZoLLBD9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTceT0+rN/0+1P9fRCC/U02tjMyRq7m+azSFtUZhwFycctH3wviQc0iskbLPvxHby
	 a6KELDY1ko2UT9AHQft5VwY69FXH3+673AlXOqUf+nHTmbYlE/+bp5z5HbdxGtpMjj
	 e0iqW/zKcuci+XM5WzEqJHwvtDsWJ8LwhSK5VIgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Westman Dorcsak <hedmoo@yahoo.com>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0264/1250] ARM: tegra: tf600t: Invert accelerometer calibration matrix
Date: Thu, 17 Sep 2026 16:00:59 +0100
Message-ID: <20260917151559.303263185@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit 774bc2764647cfd6b65727cfa978d809f11df392 ]

IMU calibration matrix used in the device tree is inverted when testing on
the device which results in wrong screen orientation. Invert it to match
the matrix dumped from the device.

Tested-by: Andreas Westman Dorcsak <hedmoo@yahoo.com>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts b/arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts
index 5d9e23a438204..856b1bb8b6f37 100644
--- a/arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts
+++ b/arch/arm/boot/dts/nvidia/tegra30-asus-tf600t.dts
@@ -1040,9 +1040,9 @@ imu@69 {
 			vdd-supply   = <&vdd_3v3_sys>;
 			vddio-supply = <&vdd_1v8_vio>;
 
-			mount-matrix =	 "0", "-1",  "0",
-					"-1",  "0",  "0",
-					 "0",  "0", "-1";
+			mount-matrix =	 "0",  "1",  "0",
+					 "1",  "0",  "0",
+					 "0",  "0",  "1";
 
 			/* External I2C interface */
 			i2c-gate {
-- 
2.53.0



