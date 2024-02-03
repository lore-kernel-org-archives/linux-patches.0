Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AAA8107B4;
	Sat,  3 Feb 2024 04:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933557; cv=none; b=QM10WocS5ChZ5zBh3VnI6Dfn3fFPygSt/+gpa7MlXxw+BazcTFB3lZs7F3aiBfpXiUYOHwsFbKBgHWXJU8zZxL9nKVnvaYrUNYfcLP1UmmCdHbDVdbWQNAkxDFd+fCw5/dVTAvz/Q3CR1AtI0oPo9CEbks035WSKRCTEDIEB7Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933557; c=relaxed/simple;
	bh=dYBAHSU/s68DrcllzAWRVQNy8PpvUXrYIW9kj0ILGzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAh4h+1ovVTV2mwbBk7/M87+FOxVhY827qQql2i7tsinzCiY/sMn5yQq0AljhoqJVFYhi8o6232+vHmaTbr5IByBU8Uz1zs6uus5KcMIt8ZqsuFmrvHGs8VYknNjzIiNvzpYToo4rMpYDWXe+HNfFtC7xMSCpZ2+MxlSvUgAV+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pFXFF1in; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pFXFF1in"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BD5C433C7;
	Sat,  3 Feb 2024 04:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933557;
	bh=dYBAHSU/s68DrcllzAWRVQNy8PpvUXrYIW9kj0ILGzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pFXFF1inBgxJ5fIGrB0VMXmrRBUv5oObiloXYo2MKC6pTpXFwrI6dmkICAIvMDTJZ
	 AZixA7CdxKhcRPMb4OT7feBTk0aFmxflM9Ek4BDBq8AMhCU00sHEgcJ+3lBEpLR8U2
	 2GcBfc/4C7ksGZNL0GMZU5NwJvj2NI86RF/GMzm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/322] ARM: dts: rockchip: fix rk3036 hdmi ports node
Date: Fri,  2 Feb 2024 20:03:27 -0800
Message-ID: <20240203035402.703022999@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 27ded76ef0fcfcf939914532aae575cf23c221b4 ]

Fix hdmi ports node so that it matches the
rockchip,inno-hdmi.yaml binding.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/9a2afac1-ed5c-382d-02b0-b2f5f1af3abb@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rockchip/rk3036.dtsi | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3036.dtsi b/arch/arm/boot/dts/rockchip/rk3036.dtsi
index 78686fc72ce6..c420c7c642cb 100644
--- a/arch/arm/boot/dts/rockchip/rk3036.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3036.dtsi
@@ -402,12 +402,20 @@
 		pinctrl-0 = <&hdmi_ctl>;
 		status = "disabled";
 
-		hdmi_in: port {
+		ports {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			hdmi_in_vop: endpoint@0 {
+
+			hdmi_in: port@0 {
 				reg = <0>;
-				remote-endpoint = <&vop_out_hdmi>;
+
+				hdmi_in_vop: endpoint {
+					remote-endpoint = <&vop_out_hdmi>;
+				};
+			};
+
+			hdmi_out: port@1 {
+				reg = <1>;
 			};
 		};
 	};
-- 
2.43.0



