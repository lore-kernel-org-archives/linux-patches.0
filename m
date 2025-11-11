Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D471C28E;
	Tue, 11 Nov 2025 01:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822896; cv=none; b=LRgU3ierrbAH9IJRSG0VQhh29KXeYHjWQL2Cx5tdtKKrLh+V0yosccLdvs1c2OwA7x756gTC1swgkKa3xelsb2p+r3gtCvOpPUsWtCoXY5meffbcOCtMojyzXo9xNewWDlH83PE1q7h0cm5kbbspxClHX3s+PFx3LMH+bgVq3dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822896; c=relaxed/simple;
	bh=V413ZodMG1xKKZqpiIup39OLaKSfA/pNH5xrD3ieHx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MrIc6ehpehZNCg6VSqgnsuEvstB0NnrfQr/HAUxtIS75AISVwJDltjcSWq0nmNbtvNmi866gh3AIgX3OJjkd1Mx0MQFF8zoK08IZx7HRNF2nb1HUYCQ4CRQAf4KeWF0w8+ubei+KGCgCTDfRnKkGUqJsJ/JTpg8qc59Uju1MEbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NjUzkENn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NjUzkENn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24790C4CEF5;
	Tue, 11 Nov 2025 01:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822896;
	bh=V413ZodMG1xKKZqpiIup39OLaKSfA/pNH5xrD3ieHx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NjUzkENnX+UqtQowwHm3f/9kA5npl2nMLPwYDLRwJZomGNwMrich9xe6YFVb7SXPc
	 mCbWFiAFMXnaLDrQmnh8PxarA6hWbXlzt08VwyPqKkHsTdbWxxeeLA/tdTbQW1Pjzv
	 k+IruLKDlu91VSxsR+4pvXD7KLfa3ywQjYhVpb9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jonas=20Schw=C3=B6bel?= <jonasschwoebel@yahoo.de>,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 129/565] ARM: tegra: p880: set correct touchscreen clipping
Date: Tue, 11 Nov 2025 09:39:45 +0900
Message-ID: <20251111004529.852597951@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Schwöbel <jonasschwoebel@yahoo.de>

[ Upstream commit b49a73a08100ab139e07cfa7ca36e9b15787d0ab ]

Existing touchscreen clipping is too small and causes problems with
touchscreen accuracy.

Signed-off-by: Jonas Schwöbel <jonasschwoebel@yahoo.de>
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts b/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
index 2f7754fd42a16..c6ef0a20c19f3 100644
--- a/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
+++ b/arch/arm/boot/dts/nvidia/tegra30-lg-p880.dts
@@ -108,8 +108,8 @@
 	i2c@7000c400 {
 		touchscreen@20 {
 			rmi4-f11@11 {
-				syna,clip-x-high = <1110>;
-				syna,clip-y-high = <1973>;
+				syna,clip-x-high = <1440>;
+				syna,clip-y-high = <2560>;
 
 				touchscreen-inverted-y;
 			};
-- 
2.51.0



