Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF28C28B4FA;
	Sat, 12 Sep 2026 09:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204304; cv=none; b=IVnA04F8pUjljjEyyl+JH9R/24Vog73Yh+7gMk2R2ODqBNhDPLKirRPi8QuFggRvrgmAv+NyaFHLHOqQ9mw13LHrUrkVaxP83HXSB1asZg0mLSDUks8KKDbx6Wey+OOvbe/ZCWw0MCLzd2oMDiJcI3uLc7miIofk7MAjiagz5ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204304; c=relaxed/simple;
	bh=fOC3eIdeU38lgOR40kgERLuJ7q1jR6/qDiPP5Y8THFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nyoKMSx9gD+Ta1ZVX8S9OB6wWdd2ILDyMKGUkoQivkrcf3XnwXM3/CB46LSYE6B9CGNir3/PwRCavYJXwkgLRsHK0mSASfwwLxTXJRJytXURwhD1lwuDUbZoXcVpiuBHR8suAJf6DKkY7oOAqAH6IIBTUkhNd28PmdF5MfNwwUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PioL4Vll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PioL4Vll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09EA01F000FF;
	Sat, 12 Sep 2026 09:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204302;
	bh=QewiBvC2oFCalL6VtR6RWK8vgrlWFmiamyHuaLuPdjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PioL4VllAe8m6oP81kr1uvkvqYKwu7J2gwcnSlQhYwoP7rema+6wJnxszoHkXp+xH
	 Xg4fxFT3cL8CPHXtbpb528bHxv04io/a3TFf13IN39rqcvOoGv/ltqXGY5Y8lLaM2D
	 H5e4QTEa+WMtv7l7sO7EiXcekjJAS3IyevJnQ2S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 7.2 1584/1815] soc: qcom: ubwc: Fix missing include
Date: Sat, 12 Sep 2026 08:55:34 +0200
Message-ID: <20260912065726.174872159@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Baluta <daniel.baluta@nxp.com>

[ Upstream commit c6441becf4d064bb1dcbccbd3e2276833804cff5 ]

When CONFIG_QCOM_UBWC_CONFIG=n, compiler needs to know the definition
of ERR_PTR otherwise there will be a compilation error:

In file included from drivers/gpu/drm/msm/disp/dpu1/dpu_hw_sspp_v13.c:7:
./include/linux/soc/qcom/ubwc.h: In function ‘qcom_ubwc_config_get_data’:
./include/linux/soc/qcom/ubwc.h:45:16: error: implicit declaration of
function ‘ERR_PTR’ [-Wimplicit-function-declaration]

Fix this by including <linux/err.h>

Fixes: 1924272b9ce1 ("soc: qcom: Add UBWC config provider")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Daniel Baluta <daniel.baluta@nxp.com>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/soc/qcom/ubwc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/soc/qcom/ubwc.h b/include/linux/soc/qcom/ubwc.h
index 83d2c2a7116c0..f35c29440f4de 100644
--- a/include/linux/soc/qcom/ubwc.h
+++ b/include/linux/soc/qcom/ubwc.h
@@ -8,6 +8,7 @@
 #define __QCOM_UBWC_H__
 
 #include <linux/bits.h>
+#include <linux/err.h>
 #include <linux/printk.h>
 #include <linux/types.h>
 
-- 
2.53.0



