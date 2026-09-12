Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87620477298;
	Sat, 12 Sep 2026 11:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211666; cv=none; b=jnBcp/Dt+dpJlxeuEXrzgKrwAiv+/0prc5l7qe7W8ZzcPW1dDr/E0XQtXAtMzqjd22vWWE74cpEWt0NDlYHWvm+ig5mMy+EoFm6uk7xagx0G45dv3jOlJTmHzXfhELvbO4bu/WO+XT354D3e47l9M8Ow6Ja2zyl0uGBLE9xk9ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211666; c=relaxed/simple;
	bh=ln9IFjSwycAEBXRcFr5XpY+R8Xvi+AwXE6zs+4AVJw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCUXWT+F8BoLfmoEnbV5mOEShZVMAgtqVeye7fHA8SOhm0B46kXjZBC6r9K4Jc7XxySZNGWMPmpmZia+Oy6tVs9ewkSmCDe4laXIHVMxknXYiVhHPfy9CtdCQBlanuf/Bd35gxFq5ZgOv7Wk3GA3c+AnJUk/aQi1R62vDLowLx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4SmaLVM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4SmaLVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54411F000FF;
	Sat, 12 Sep 2026 11:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211662;
	bh=UwCTgr7Zhvj6K1tYv3p9XsXbVYrFDV1+VIZNFmqcJQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l4SmaLVMhqDmE2lQS0ZD1FAM60zewh8SkamudCGCtZgH8T7QRE6l6EzxXi3aNoxpk
	 bjGfz2He0iN3cRK9EH9mo8KLZFL/B0OQyF0b5iJKuAJxVvXXpVYIYOUxhTlTnrgHy3
	 UK9f80gD1rj9IVt7L4br6CLV8X50QA8c/824jaEI=
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
Subject: [PATCH 6.18 1276/1518] soc: qcom: ubwc: Fix missing include
Date: Sat, 12 Sep 2026 08:57:25 +0200
Message-ID: <20260912065652.375164387@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d9dfc9edc1b2f..d3bb18990f84d 100644
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



