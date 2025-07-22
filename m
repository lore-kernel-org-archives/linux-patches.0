Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A6B2DEA8E;
	Tue, 22 Jul 2025 14:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193316; cv=none; b=Zt0JY86lK2c1jwmPivx7bCn4S1lbOoyhhlEvAZugoCIZtiK4LAd9OTqLrXs/CmJrtwQ2EA7jK0K50XE4SixCU/wlFPOp1+GzEP7w0bQOK/ekn555kOcGc0EnmoNG5DigbLbh4GtYIrdOEOLN9FHjoywi18z86Zu/OlqPXvewC+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193316; c=relaxed/simple;
	bh=r3inO5oyQksrRC15o1YS3uh3ATHcCjyyBhJ8mgZeFnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHSwt39aKfpDSi0kcoh4rmrBlxXsSuGLrl+JEp3H+UA5GkV3HJpROvm0fzWGm6GtaYc1yS/Tnh7Z8dkLK/DcIHFs8wTsLUNuuieZ6wpqB+0uIb1K5gNiyzaOUXqDstbUwg75u3ApYKD25z6KUFAKfC0TlaqWKqv9kGCvHZEV2oI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJWB/HS+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJWB/HS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D58FC4CEEB;
	Tue, 22 Jul 2025 14:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193316;
	bh=r3inO5oyQksrRC15o1YS3uh3ATHcCjyyBhJ8mgZeFnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJWB/HS+wzxoN2lExiBMTckq8gvt04giSxZdgAjMKhUk4/GpfIZkoVnR2VmAAT2NV
	 vMJKv9Ij/ozYMJoYTF7rMNzkApVKCF0InmGweEZq1A52JHcCo7NUC4mjAtEZcI+HOE
	 z2Dsu5e07MxDF988oEVsz+qLQJtdQr/A/AasV8Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Alexey Charkov <alchark@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.15 055/187] arm64: dts: rockchip: list all CPU supplies on ArmSoM Sige5
Date: Tue, 22 Jul 2025 15:43:45 +0200
Message-ID: <20250722134347.816113356@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@gmail.com>

commit c76bcc7d1f24e90a2d7b98d1e523d7524269fc56 upstream.

List both CPU supply regulators which drive the little and big CPU
clusters, respectively, so that cpufreq can pick them up.

Without this patch the cpufreq governor attempts to raise the big CPU
frequency under high load, while its supply voltage stays at 850000 uV.
This causes system instability and, in my case, random reboots.

With this patch, supply voltages are adjusted in step with frequency
changes from 700000-737000 uV in idle to 950000 uV under full load,
and the system appears to be stable.

While at this, list all CPU supplies for completeness.

Cc: stable@vger.kernel.org
Fixes: 40f742b07ab2 ("arm64: dts: rockchip: Add rk3576-armsom-sige5 board")
Reviewed-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Tested-by: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
Signed-off-by: Alexey Charkov <alchark@gmail.com>
Link: https://lore.kernel.org/r/20250614-sige5-updates-v2-1-3bb31b02623c@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts |   28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

--- a/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3576-armsom-sige5.dts
@@ -177,10 +177,38 @@
 	};
 };
 
+&cpu_b0 {
+	cpu-supply = <&vdd_cpu_big_s0>;
+};
+
+&cpu_b1 {
+	cpu-supply = <&vdd_cpu_big_s0>;
+};
+
+&cpu_b2 {
+	cpu-supply = <&vdd_cpu_big_s0>;
+};
+
+&cpu_b3 {
+	cpu-supply = <&vdd_cpu_big_s0>;
+};
+
 &cpu_l0 {
 	cpu-supply = <&vdd_cpu_lit_s0>;
 };
 
+&cpu_l1 {
+	cpu-supply = <&vdd_cpu_lit_s0>;
+};
+
+&cpu_l2 {
+	cpu-supply = <&vdd_cpu_lit_s0>;
+};
+
+&cpu_l3 {
+	cpu-supply = <&vdd_cpu_lit_s0>;
+};
+
 &gmac0 {
 	phy-mode = "rgmii-id";
 	clock_in_out = "output";


