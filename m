Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4433934C13D;
	Tue, 16 Dec 2025 12:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887049; cv=none; b=iOEjrtYUd3IzPMpLoFNhmbGVbqhVbbu387hdg6G2v2ooDPUh+7UrTB6xnVukM9uBg3Thwys/+HDC2HJezh+BoDuZIkP40BPi8oHc7xSHwcy06iq86pm6LhGucu4J7sI0GNKi73FjmQliOvuZ+mtARD7/UGbeD0NAbbvqYOnIbdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887049; c=relaxed/simple;
	bh=xGCOqtff8Oqt60pj3xtUzvAydtIxK4Ob5zgfQ+3Hmt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmQ9wWuWGHEzbR/r/l3vgDdlK9fyBV+4AoUjK4LWqF6AJokMTTU5gJZ0jg/DfLLfFp5akgNqlegVqfM3CHNRAzx+4PQy65Y997GqWCDPect/E+F82Rzor+ClSzpg+JR8HKSP50EpGC2fpEPJIZexZURP1mhDr31bsp2IpCxHMdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBlJirLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBlJirLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB514C4CEF1;
	Tue, 16 Dec 2025 12:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887049;
	bh=xGCOqtff8Oqt60pj3xtUzvAydtIxK4Ob5zgfQ+3Hmt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBlJirLEoVY+azkDdH/6krW5w+KgrnfTzana7Z5xOv90btQTg8rY+8g5CEDMhiNvJ
	 Tsfqm9ot/v/ycu1NbpkFHniOtb0QeSQ/JPQqoJgzkHrI47TIKxMg+ONz+L+nzxwvIr
	 rvIaHh9DUd9USHAptOiwH5AOxK210cs+SWMbS6XY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/614] arm64: dts: qcom: lemans: Add missing quirk for HS only USB controller
Date: Tue, 16 Dec 2025 12:07:59 +0100
Message-ID: <20251216111405.394007635@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>

[ Upstream commit 0903296efd0b4e17c8d556ce8c33347147301870 ]

The PIPE clock is provided by the USB3 PHY, which is predictably not
connected to the HS-only controller. Add "qcom,select-utmi-as-pipe-clk"
quirk to  HS only USB controller to disable pipe clock requirement.

Fixes: de1001525c1a ("arm64: dts: qcom: sa8775p: add USB nodes")
Signed-off-by: Krishna Kurapati <krishna.kurapati@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20251024105019.2220832-3-krishna.kurapati@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/lemans.dtsi b/arch/arm64/boot/dts/qcom/lemans.dtsi
index cf685cb186edc..c2d2200d845b3 100644
--- a/arch/arm64/boot/dts/qcom/lemans.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans.dtsi
@@ -4106,6 +4106,7 @@ usb_2: usb@a400000 {
 					<&gem_noc MASTER_APPSS_PROC 0 &config_noc SLAVE_USB2 0>;
 			interconnect-names = "usb-ddr", "apps-usb";
 
+			qcom,select-utmi-as-pipe-clk;
 			wakeup-source;
 
 			iommus = <&apps_smmu 0x020 0x0>;
-- 
2.51.0



