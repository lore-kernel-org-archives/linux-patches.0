Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53A639FC3;
	Fri, 24 Nov 2023 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+P5rv8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C54C433C7;
	Fri, 24 Nov 2023 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849745;
	bh=EZXYVmhcdOXqy1mNjGj5gBSGchuXAllhGuZsYoTijK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+P5rv8eVDnvJEHx2QB8oiHNw5RUNkTmuGyUGQVfa1vKLUvs9GEf4w391C5UzI6CL
	 X4gHXO+kfIiRNClwjP3Du/PMV68B5ejHdRaPkaUX9OuM4iMFnkNBzCs2Cx7jzbgMoP
	 0mixlhVlIh5t69+XdXn07+8E72VMmnJeumSiPP0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 304/530] pmdomain: amlogic: Fix mask for the second NNA mem PD domain
Date: Fri, 24 Nov 2023 17:47:50 +0000
Message-ID: <20231124172037.288577388@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomeu Vizoso <tomeu@tomeuvizoso.net>

commit b131329b9bfbd1b4c0c5e088cb0c6ec03a12930f upstream.

Without this change, the NPU hangs when the 8th NN core is used.

It matches what the out-of-tree driver does.

Signed-off-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Fixes: 9a217b7e8953 ("soc: amlogic: meson-pwrc: Add NNA power domain for A311D")
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20231016080205.41982-2-tomeu@tomeuvizoso.net
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/amlogic/meson-ee-pwrc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pmdomain/amlogic/meson-ee-pwrc.c
+++ b/drivers/pmdomain/amlogic/meson-ee-pwrc.c
@@ -228,7 +228,7 @@ static struct meson_ee_pwrc_mem_domain s
 
 static struct meson_ee_pwrc_mem_domain g12a_pwrc_mem_nna[] = {
 	{ G12A_HHI_NANOQ_MEM_PD_REG0, GENMASK(31, 0) },
-	{ G12A_HHI_NANOQ_MEM_PD_REG1, GENMASK(23, 0) },
+	{ G12A_HHI_NANOQ_MEM_PD_REG1, GENMASK(31, 0) },
 };
 
 #define VPU_PD(__name, __top_pd, __mem, __is_pwr_off, __resets, __clks)	\


