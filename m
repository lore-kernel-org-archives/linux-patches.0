Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9546325710
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300973; cv=none; b=APagiNpieOVAkM0dA/1rqMboUPv3Q54LN/4vVeIIlRr60I2MKzpwOvmbqXFfQDZVmGvNd5/i2mgkhNIUIoNKgIIGsba5tT32+V9hnuSDThKVrRbYnhhSkXghAlkDlujsDLMiod+6hLH8wP1mg+NbFB4wpJA4/QVrTpfq/aRWImk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300973; c=relaxed/simple;
	bh=yImonkXw0LmD3jgTI0jyV1ufEXShaTFRfPts7soQ5OY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOvdddHC+EZOzaIgiztNpPhEjFQP4JDRZ7LGHVuSfeCUrKZ3/8/n56KWedvjkOuJVPERYlb7q9roj/47RkrVGGRRo56DPrAVOfwgQJ7w4tbgQOlcmdzHI+xaE8Ne7lUgpbmkt7ATqfHZRMNwC40r8h0V0uIhYByo2SW4QCLlbKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jHaDpYvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jHaDpYvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E40C116D0;
	Sat, 28 Feb 2026 17:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300973;
	bh=yImonkXw0LmD3jgTI0jyV1ufEXShaTFRfPts7soQ5OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHaDpYvbapKo4PFZl9zcBctsVajHOtClJzUtt+xqdAZMar7pDqwuXf0NIGUo5K5MF
	 yqZLT4dQHKpPF4oWok9ByH9TPELiekFwYhn8bd1C1b5pl90tLbUMTsMIsl8ROhCm/0
	 beZ+PvbB52IzcoDAdwS0oALnzKuwpQT1fMvu9Yv5aq7BafyDEUbklZjo0Aw2MYi//P
	 h1hS6Mvp70O8gJY+uakqnTm3fkiWTX9IMk+U53g8OBQIYq+/THmfEzcjh7w6y3G/Eq
	 vSd2/+CqjA/pufk3VF5ttPw9Ls29ziRv3tnX3YtoxW01lY2Oq067HrvFOyFJZleayR
	 MDLbn5oTlptPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 101/752] arm64: tegra: smaug: Add usb-role-switch support
Date: Sat, 28 Feb 2026 12:36:52 -0500
Message-ID: <20260228174750.1542406-101-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>

[ Upstream commit dfa93788dd8b2f9c59adf45ecf592082b1847b7b ]

The USB2 port on Smaug is configured for OTG operation but lacked the
required 'usb-role-switch' property, leading to a failed probe and a
non-functioning USB port. Add the property along with setting the default
role to host.

Signed-off-by: Diogo Ivo <diogo.ivo@tecnico.ulisboa.pt>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-smaug.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts b/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
index 5aa6afd56cbc6..dfbd1c72388c1 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
+++ b/arch/arm64/boot/dts/nvidia/tegra210-smaug.dts
@@ -1809,6 +1809,8 @@ usb2-0 {
 				status = "okay";
 				vbus-supply = <&usbc_vbus>;
 				mode = "otg";
+				usb-role-switch;
+				role-switch-default-mode = "host";
 			};
 
 			usb3-0 {
-- 
2.51.0

