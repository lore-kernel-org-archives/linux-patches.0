Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FE91442F7;
	Thu, 11 Apr 2024 10:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830060; cv=none; b=qCoy/Aje1dMF2rV+r7EPjkBcYARs3RXej8RjULzkPx/UT49LaoSj6kb1AuEomzkRO03n7/e3XAWGuByfWTgZIQQ/a/8l/k7uk4/Aji6CbvMd2H9i+2I7TUnBqLavTYIXPSFAB4K2i7APZzCHWfp6ZPQvuzUYoF9ciqoPv2JxIT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830060; c=relaxed/simple;
	bh=c6ZUbTGSavtMiV7jWRYZHfwB/hnfDn1vv5t9dGzw3sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lPbViM3zsz6ij+cVQWSNmiy4DYts4Ou3isETXefqGaKPhU62dH7zQOuelpsJQvSdqb23YASquhvLs4D8MRq/s69eSwcLo9IKre+iv1nNGT53BSKFh7AckO60kDnqbeDDUylnZysm0gZrKfrz+QvUdQxQ4fFXEfwFggWi2t9HL9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6pjDxTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6pjDxTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E126C43390;
	Thu, 11 Apr 2024 10:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830060;
	bh=c6ZUbTGSavtMiV7jWRYZHfwB/hnfDn1vv5t9dGzw3sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H6pjDxTYJ/Pzca2qovZueiOzrWYHRV1SlNc3KCewChOCInJvXkC2ig4S3g1iKIuGU
	 RAwnrrWBQOioNtRF39QCEAd5LyTydHgk6ovg/Q2taVVpo9UPjEH/fEMovULdzLZSX4
	 G95B5N5s55kWU/ifSYyyT0u5fMwYfVA6D/6imbSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 022/143] arm64: dts: rockchip: fix rk3328 hdmi ports node
Date: Thu, 11 Apr 2024 11:54:50 +0200
Message-ID: <20240411095421.579150208@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 1d00ba4700d1e0f88ae70d028d2e17e39078fa1c ]

Fix rk3328 hdmi ports node so that it matches the
rockchip,dw-hdmi.yaml binding.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/e5dea3b7-bf84-4474-9530-cc2da3c41104@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 7b4c15c4a9c31..b6f045069ee2f 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -744,11 +744,20 @@ hdmi: hdmi@ff3c0000 {
 		status = "disabled";
 
 		ports {
-			hdmi_in: port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			hdmi_in: port@0 {
+				reg = <0>;
+
 				hdmi_in_vop: endpoint {
 					remote-endpoint = <&vop_out_hdmi>;
 				};
 			};
+
+			hdmi_out: port@1 {
+				reg = <1>;
+			};
 		};
 	};
 
-- 
2.43.0



