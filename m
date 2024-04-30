Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D04512C486;
	Tue, 30 Apr 2024 10:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474006; cv=none; b=rGH30dN8cak6xngbgzL3NirTVSNnuyN9PClTOHjUydcZCcxMwPC24Q7QVbmb4fGSqAzVleOVHstMI4qglFqc9nNYB8edNZcd2I3j3qH6gQr24i6wTJSA2fN/upOR1ErJ/Yya+Deku2UEDR3ntfkr2t/U3qi86ghVAnirYsfZDzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474006; c=relaxed/simple;
	bh=dOOJhd4PqlnkKdTM+2dJQA01qdkeOL6em7keGZwnY/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW9pZkMI20+pn9q0pjzfASueeWkFhlK1os0JSbgGKNJP3l0ghSlCJQ5zag0UKpRTmeutbHiucQLQ6VYtrUucmQ03sSl7a0aUbCxTCgau21jkaV2svp5QVU6GzRTeRzxRkPAvk9TmTHpbBaPgKswln7fNHYu0mwH25Xndvb+IsBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=To1Ch3Jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="To1Ch3Jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8856DC2BBFC;
	Tue, 30 Apr 2024 10:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474005;
	bh=dOOJhd4PqlnkKdTM+2dJQA01qdkeOL6em7keGZwnY/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=To1Ch3JyIqp7IXIVJZm/Yy01bH/eIc67tIcBF0Jfn4fFreEZb41vJkuSWbxsvtyWf
	 rZuSKt/6/8ye7MAHIj/ysKnMtpaeqyzF+IajhHHjPd1zhiiRzf2bM8UMdBBmoX143S
	 RD5RnEmyUn9wnxveBpyvVtze3RZADkPUbj6uP148=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 033/228] arm64: dts: rockchip: regulator for sd needs to be always on for BPI-R2Pro
Date: Tue, 30 Apr 2024 12:36:51 +0200
Message-ID: <20240430103104.772704192@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit 433d54818f64a2fe0562f8c04c7a81f562368515 ]

With default dts configuration for BPI-R2Pro, the regulator for sd card is
powered off when reboot is commanded, and the only solution to detect the
sd card again, and therefore, allow rebooting from there, is to do a
hardware reset.

Configure the regulator for sd to be always on for BPI-R2Pro in order to
avoid this issue.

Fixes: f901aaadaa2a ("arm64: dts: rockchip: Add Bananapi R2 Pro")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Link: https://lore.kernel.org/r/20240305143222.189413-1-jtornosm@redhat.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
index 87c45d8be420f..dc5892d25c100 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
@@ -416,6 +416,8 @@
 
 			vccio_sd: LDO_REG5 {
 				regulator-name = "vccio_sd";
+				regulator-always-on;
+				regulator-boot-on;
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 
-- 
2.43.0



