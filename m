Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 544EF2D63E8;
	Tue, 31 Mar 2026 17:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976706; cv=none; b=KPech6dNErfeNLyITTaWQaYXFS8elnLVuCsHrn0AwlO5rp16Gy1VMEqu2Kcpghu5wLNAhmpWGgV3b/PKm0OQ2ecV4Wd3A1hPEOorzOiywazwMOIqFsUVBgSvwqurD2DMDFlp5Wzz2N5S6+Z1gnmCwUFUpfAQ+LjGLcfZuQjGoMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976706; c=relaxed/simple;
	bh=TmxmD1gYTowWwplv1u+ZTUyfIdfxzcKd/ahYmq4uWPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xys19WncaOSfs0qJ8X+qV7ClCYEpt1yTvGioMJEWEOouj3B0v/Vj83mbF4MVTq18VZv1NrVXMi2IaKDMkw/7pgFViTcZV8RXu884wxg/TQwpgydZZXVL32KsJ9fSX+zmu8wjQX4V7Epfd+fGzvwMkZGeRz7fwQp8cUSnkaHrvhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suuShswM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suuShswM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE778C19423;
	Tue, 31 Mar 2026 17:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976706;
	bh=TmxmD1gYTowWwplv1u+ZTUyfIdfxzcKd/ahYmq4uWPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suuShswM9uxb8RlVY9cf7A3jyRL9XQhLo4x1/UpMe0y6LQUmAVtSze4NrtpowY9JJ
	 JnkqdM0yVB43jALg7i695MRrJmMsnoRshFpU207DdvW+kUyIjl2/4af/VqUmXIZYTe
	 ZBjvslid6iErEI72Wer/3GfP+nqiw4Xm7W24OH+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erin Park <erin.park@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.18 195/309] thermal: intel: int340x: soc_slider: Set offset only for balanced mode
Date: Tue, 31 Mar 2026 18:21:38 +0200
Message-ID: <20260331161800.634332028@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 7dfe9846016b15816e287a4650be1ff1b48c5ab4 upstream.

The slider offset can be set via debugfs for balanced mode. The offset
should be only applicable in balanced mode. For other modes, it should
be 0 when writing to MMIO offset,

Fixes: 8306bcaba06d ("thermal: intel: int340x: Add module parameter to change slider offset")
Tested-by: Erin Park <erin.park@intel.com>
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 6.18+ <stable@vger.kernel.org> # 6.18+
[ rjw: Subject and changelog tweaks ]
Link: https://patch.msgid.link/20260324172346.3317145-1-srinivas.pandruvada@linux.intel.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../intel/int340x_thermal/processor_thermal_soc_slider.c  | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_soc_slider.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_soc_slider.c
index 49ff3bae7271..91f291627132 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_soc_slider.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_soc_slider.c
@@ -176,15 +176,21 @@ static inline void write_soc_slider(struct proc_thermal_device *proc_priv, u64 v
 
 static void set_soc_power_profile(struct proc_thermal_device *proc_priv, int slider)
 {
+	u8 offset;
 	u64 val;
 
 	val = read_soc_slider(proc_priv);
 	val &= ~SLIDER_MASK;
 	val |= FIELD_PREP(SLIDER_MASK, slider) | BIT(SLIDER_ENABLE_BIT);
 
+	if (slider == SOC_SLIDER_VALUE_MINIMUM || slider == SOC_SLIDER_VALUE_MAXIMUM)
+		offset = 0;
+	else
+		offset = slider_offset;
+
 	/* Set the slider offset from module params */
 	val &= ~SLIDER_OFFSET_MASK;
-	val |= FIELD_PREP(SLIDER_OFFSET_MASK, slider_offset);
+	val |= FIELD_PREP(SLIDER_OFFSET_MASK, offset);
 
 	write_soc_slider(proc_priv, val);
 }
-- 
2.53.0



