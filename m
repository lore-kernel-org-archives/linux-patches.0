Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45154FC11;
	Sat,  3 Feb 2024 04:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933376; cv=none; b=WYFeXITZAXDlT+OSsvEwMT4hu4vl9S23Md8jIITohS66A213w93JlyJ9LDIstczJ5pjC7+wvz/+36u3xR2mLYqptC86ej0FU3EddlnCXYz5cvYKj++WiVE53jfHCmWEZPnFeWVws3gxcgBLsSLxxzBV6lXqZbfKmwlFugAo9Iqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933376; c=relaxed/simple;
	bh=E7ERQZ8HTO9OIYdbKh8gcPYBWdy4l2ssUZpjg+EFZnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhOP+BXBRuJsWw2wF/IqvRGAX3uIypSGZ0s+ZCvtUyRwHfsENOVCAAk0b7Bf52wzNR33kg2Mz4L4mN2UcpXPz9Tei7gI3y+nzWEovNINLWoCyQrXpoiIRu8r93Akt4DY9ziUlwzRVbYfkCPa45449BG5Y0vRrR1OoRN8+XOVNQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6ZERYeq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6ZERYeq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E3C9C433F1;
	Sat,  3 Feb 2024 04:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933376;
	bh=E7ERQZ8HTO9OIYdbKh8gcPYBWdy4l2ssUZpjg+EFZnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6ZERYeqhfzHO46Dh3+oKbmBGzPLjsZZbDxcRhA2M7Y+5kPiK2pwAAFVQY0i+WXPQ
	 yk+2Q1C0MtCyfRPociG0TRXsWpY6OC3PJd50JlSJz4TcEEylCSTndoXPbzIla1QylO
	 R5CEFQBp8oIE8qVd4R5taO5nq39f+aRe08L9tj0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/219] ARM: dts: rockchip: fix rk3036 hdmi ports node
Date: Fri,  2 Feb 2024 20:04:01 -0800
Message-ID: <20240203035326.380234551@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/rk3036.dtsi | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index 78686fc72ce6..c420c7c642cb 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
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



