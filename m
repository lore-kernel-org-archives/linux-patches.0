Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E74D17E90E;
	Mon, 27 May 2024 19:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836979; cv=none; b=nXrFG5Z54keu84kWkGg96AAbMwAU9OstBuZ+KRjKROJZA/HPsUGk/1iYd6SR3BhAY0dWfuGor+gugZwa1ni7sHR9dshhz7eXn8cMDnv+jzHuZgCC4z6+bBdXM4mU8QqxW7dkr0KNxZv2cAXXqrWnEGIEaJPO0fvIXAnQIGeU65g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836979; c=relaxed/simple;
	bh=Xu0yNeBQsNNsrNgmj+h5xZkSDjlXZGHrCOmF4eH2d4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZAhyPCFbtszLSoRypflJKo7RJbuKVeJWnt7KSQVRbgXsgt/A47tZihzsbp+1WeV8dZgQ5dJTrsjNc+EEwrHXGKPZEZm2YAWsW23P2ppHIVkErwp4dHO1cD5eHfQqAUvIErYnLe6BiGqBTdRQAAU4brbszeKr2NHRSw2K+0q3uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p/Qxh/6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p/Qxh/6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F168AC2BBFC;
	Mon, 27 May 2024 19:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836979;
	bh=Xu0yNeBQsNNsrNgmj+h5xZkSDjlXZGHrCOmF4eH2d4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p/Qxh/6a3LEql585fmGfEQrQrNv6R7mVywWaqlHCkIU7xIU98gERVa4jU8Rmk80lo
	 86/VNhGrfWysxZi1fUR9VxHqkGBwcd1t8yWxeWX7HMBaTb5TrBLK8bgP12ppiDMTdk
	 zbeW+fPP2QxqjgbiPgnvYidqSpkN3mZt+JwFNdZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 262/427] dpll: fix return value check for kmemdup
Date: Mon, 27 May 2024 20:55:09 +0200
Message-ID: <20240527185626.938939654@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit ad506586cb69292b6ac59ab95468aadd54b19ab7 ]

The return value of kmemdup() is dst->freq_supported, not
src->freq_supported. Update the check accordingly.

Fixes: 830ead5fb0c5 ("dpll: fix pin dump crash for rebound module")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240513032824.2410459-1-nichen@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index d0f6693ca1426..32019dc33cca7 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -449,7 +449,7 @@ static int dpll_pin_prop_dup(const struct dpll_pin_properties *src,
 				   sizeof(*src->freq_supported);
 		dst->freq_supported = kmemdup(src->freq_supported,
 					      freq_size, GFP_KERNEL);
-		if (!src->freq_supported)
+		if (!dst->freq_supported)
 			return -ENOMEM;
 	}
 	if (src->board_label) {
-- 
2.43.0



