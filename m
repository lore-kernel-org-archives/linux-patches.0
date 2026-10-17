Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732033AA9F3;
	Sat, 17 Oct 2026 17:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256605; cv=none; b=g0Ujt0VUm13mB30CeYoPQQabxpUOCbCfQ5y0UdcYgegkD4RYXxjJNt4xwASN/PpEAHogz1GvbHrKLxZ6ZgriZhrda1QRGfRUIUKMLkTP8A5a0LQQo1xM5gJclJ3xKMeRGpomLWm0NxKyIR2iybsrB175dJucIcPXqjPtIBmNQpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256605; c=relaxed/simple;
	bh=uqiOpkwgGCjLpkSHiD4MLT5Z5uZDKxVjoXEZOo0qDxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnA7/pi3WePD0erXO5WXbZ/FFbWiewc0jtRN0CuEhHVPwfgdCZA0XPxxCn3A9JJ/AGSTKpHBuEH2P1hpgW234eoH8MNczH2LFLkZEY60q5RYj2mTpz7nor/Dj2a8sZ0xp/nuiJRh/Vm9OiAY8L+AqQTSmICoE1u7PAzXS51wKqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFkjOIBW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFkjOIBW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EEF1F000C4;
	Sat, 17 Oct 2026 17:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256604;
	bh=vBo3dQOp2IaBUlxIC9dFqCYcfnbzIo9QDuKA3Qo0tdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFkjOIBWaik7qaOIZ1Q6JSDYkl+0bpFxqwvuqh4exk6JAD7USxPZDesjJkMNQiWyJ
	 6efMK3mFhM+7JR3g/FMlEmgGygwPy5GIv8MPrVP7K8XGabAO1lsVoTZ+i9Uc0AQvwu
	 WOCxrluMxZhRGK8kr5UK+KABhybjPLuQTWy0QzSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: [PATCH 6.6 0254/1674] soc: qcom: geni-se: Correct QUP Core ICC vote constants
Date: Sat, 17 Oct 2026 17:42:06 +0200
Message-ID: <20261017160437.645418770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

commit 1cd9b1be5a9c56fd69e3f555b200a1844f9b873e upstream.

The GENI_TO_CORE ("qup-core") ICC vote selects the QUP Core 2X clock
rate. The CORE_2X_*_MHZ constants are expressed in Bps, but their
values are several orders of magnitude too small. For example, the
50 MHz threshold is represented by 2500 rather than 25000000 Bps.

As a result, clients using these constants can severely under-vote the
QUP Core clock.

Correct the constants to their intended Bps thresholds so that the ICC
provider selects the corresponding QUP Core 2X clock rate. Drop the unused
definitions.

Fixes: 58ffbba6a399 ("soc: qcom: geni: Support for ICC voting")
Cc: stable@kernel.org
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260915-correct-icc-bandwidth-vote-constants-v2-1-f78eb611204e@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/soc/qcom/geni-se.h |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/include/linux/soc/qcom/geni-se.h
+++ b/include/linux/soc/qcom/geni-se.h
@@ -287,17 +287,12 @@ struct geni_se {
 #define QUP_SE_VERSION_2_5                  0x20050000
 
 /*
- * Define bandwidth thresholds that cause the underlying Core 2X interconnect
- * clock to run at the named frequency. These baseline values are recommended
- * by the hardware team, and are not dynamically scaled with GENI bandwidth
- * beyond basic on/off.
+ * QUP Core 2X clock votes used by GENI clients through the "qup-core" ICC
+ * path. Values are in Bps and must be converted with Bps_to_icc() before
+ * setting avg_bw.
  */
-#define CORE_2X_19_2_MHZ		960
-#define CORE_2X_50_MHZ			2500
-#define CORE_2X_100_MHZ			5000
-#define CORE_2X_150_MHZ			7500
-#define CORE_2X_200_MHZ			10000
-#define CORE_2X_236_MHZ			16383
+#define CORE_2X_19_2_MHZ		9600000
+#define CORE_2X_50_MHZ			25000000
 
 #define GENI_DEFAULT_BW			Bps_to_icc(1000)
 


