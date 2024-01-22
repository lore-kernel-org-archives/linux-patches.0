Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D69C31FDB;
	Tue, 23 Jan 2024 00:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969488; cv=none; b=OE4bFynP9mlAJ5YP8Nc2TsSWJ54ccs84elHNOhP7rg99CGC9skDil01JjWHYAqHEbjS/+ZeXh9V+1JsZ6ph3yQ8In2eL+bzjNKEau4lYbqgQKdw0ImdqrhdR4YyiVlkcPjsMKqOLqoF6v+NNj8iu3/crTpRLL3XIzyymAY9+CKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969488; c=relaxed/simple;
	bh=N/mdc422U8S8qQ28tKuRS3M6oiqaVCAjyu+FgCXwpBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGo1nrQP6NSh43Bk/vUXXz+PYqZhLMuaXZqyLjzcViyKhXv/SWsNFux9Yk+cgOYAxVyEDpB2F++FC3mJWCPl5SladCpEhjlTfBlvVJUY27geW7pV6NGSre5099WAwA/2aD1dU02GpqHKRH6JHBS7fYwv+HiG0VSt0sRqlMxyZh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1pD3R2N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1pD3R2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A05C433A6;
	Tue, 23 Jan 2024 00:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969488;
	bh=N/mdc422U8S8qQ28tKuRS3M6oiqaVCAjyu+FgCXwpBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1pD3R2NBuzqAOoqTVRGlkLdCHwIMy3o6yAggI0VFu1BPXixIXK68ETKco4Fw8IMO
	 44ela/bZj/i/GwoPO4zuA1/jVzP/xYCe0u7cBngLjkxoK2Mstvf1EiY1tJ1EumRV5f
	 ARfkDuQl/ujr7wnmlHefQMyJ9wAsLrIDlhsATtoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 278/641] drm/msm/a6xx: add QMP dependency
Date: Mon, 22 Jan 2024 15:53:02 -0800
Message-ID: <20240122235826.610235002@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 96ab215b2d5edc39310c00f50b33d8ab72ac3fe3 ]

When QMP is in a loadable module, the A6xx GPU driver fails to link
as built-in:

x86_64-linux-ld: drivers/gpu/drm/msm/adreno/a6xx_gmu.o: in function `a6xx_gmu_resume':
a6xx_gmu.c:(.text+0xd62): undefined reference to `qmp_send'

Add the usual dependency that still allows compiling without QMP but
otherwise avoids the broken combination of options.

Fixes: 88a0997f2f949 ("drm/msm/a6xx: Send ACD state to QMP at GMU resume")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/562945/
Link: https://lore.kernel.org/r/20231016200415.791090-1-arnd@kernel.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
index 6309a857ca31..ad70b611b44f 100644
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@ -6,6 +6,7 @@ config DRM_MSM
 	depends on ARCH_QCOM || SOC_IMX5 || COMPILE_TEST
 	depends on COMMON_CLK
 	depends on IOMMU_SUPPORT
+	depends on QCOM_AOSS_QMP || QCOM_AOSS_QMP=n
 	depends on QCOM_OCMEM || QCOM_OCMEM=n
 	depends on QCOM_LLCC || QCOM_LLCC=n
 	depends on QCOM_COMMAND_DB || QCOM_COMMAND_DB=n
-- 
2.43.0



