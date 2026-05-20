Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C573EEAED;
	Wed, 20 May 2026 17:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296517; cv=none; b=tYkVhoMLiwA9aRjP3SUjZ9/mOEFeEqQ4T9B4BxRx8PLx16N42Zv5KqyiKcYkocVVeaH5EEty+NIOMYyfaDFlbo0mWEjpjRLjcgebXqf5DiXWOHWGdNZ+CDzIqY4l83G9/YHDG00Q8iAtISe02zl5k2mQPLYpOnND2vMd1TzIMvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296517; c=relaxed/simple;
	bh=5p3VAnXXHlnHqjUQY7wCe50HgfNUfmoLhNqUOojkzNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eMuy3eREGkoqsWtuOf157HJ+CRYuDumyUm+BUglzDD1UiywhHXEkG9jXXSUVpRI9eDAhG1c34aRJ6MNTMQiDNgl4c9Dmdrp+LCWcdh/EJCyc5WW9xrtYpRbNiCUxobXyk0upRtDTh0dbYdvcmJr2L3Bjcaqi/tgDBucLxAPuEmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPYwwhbH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPYwwhbH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243D81F000E9;
	Wed, 20 May 2026 17:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296516;
	bh=L2QVtkX6ejzk5ahFkFTE/kttV1AzIeo+nx+NUEpbRQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPYwwhbHaxmheedaRITLM6iN/mzrchreDrT8KSYZwkMSGWSqOT+GJjx738D5Wrr3s
	 NhbattgRojbbJvbcZdEDFhwbv9mh+01pan7aaJBikta6Zju++aGTrOJSIslNRThQEX
	 2HspYl9szYa3TU6jG2VV5ACgBVHD5GyvQVokYXmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anand Moon <linux.amoon@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0822/1146] arm64: dts: amlogic: meson-axg: Add missing cache information to cpu0
Date: Wed, 20 May 2026 18:17:52 +0200
Message-ID: <20260520162206.834183383@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anand Moon <linux.amoon@gmail.com>

[ Upstream commit 918273be0885362a9a00615b46e03f15f8b55667 ]

Add missing L1 data and instruction cache parameters to the CPU node 0
for the Cortex-A53 caches on the Meson AXG SoC.

Fixes: 3b6ad2a43367 ("arm64: dts: amlogic: Add cache information to the Amlogic AXG SoCS")
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
Link: https://patch.msgid.link/20260219103548.18392-1-linux.amoon@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index cc72491eaf6f5..f1f53fd98ae25 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -72,6 +72,12 @@ cpu0: cpu@0 {
 			compatible = "arm,cortex-a53";
 			reg = <0x0 0x0>;
 			enable-method = "psci";
+			d-cache-line-size = <32>;
+			d-cache-size = <0x8000>;
+			d-cache-sets = <32>;
+			i-cache-line-size = <32>;
+			i-cache-size = <0x8000>;
+			i-cache-sets = <32>;
 			next-level-cache = <&l2>;
 			clocks = <&scpi_dvfs 0>;
 			dynamic-power-coefficient = <140>;
-- 
2.53.0



