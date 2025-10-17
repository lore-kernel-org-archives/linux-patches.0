Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F31A2F12A0;
	Fri, 17 Oct 2025 15:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714905; cv=none; b=sazHTe6Le9YTwhqafWZkFOlc7VXV8UL5GQaeYRndN3+jCQefU/SH470XQxW6U4TJ/NzEhnyUZkYQk+el0uy/B88kr+GQ6GeAS+MoE5cTwu2ivM2mDofZHYs+LWpPiloNo/QxAYtmmRwLiiJBeirBqV0m2ZOvD1pRUQaMQtCvVPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714905; c=relaxed/simple;
	bh=UjAJWDzIWrEo74hC2I35yrY0OMunZKQtv7oYvOWqdtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSdJtClBE2SioI3ZBrJwB1N6LNJB9kfCY8/+cSx24e4/8E2vpH8grvi/gwVbHOdwtGhG9XfzfDRJ9ZBWhJYJfAkEt52p6Nvih6LSTPRaWRAdhTrdyDNt9F9hG0hXIOfEkQxD2PUIHXnRSJQvRve5jkZ/MmbtQyyCihImQVHNZwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/wcH4Mz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/wcH4Mz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B69AC4CEE7;
	Fri, 17 Oct 2025 15:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714905;
	bh=UjAJWDzIWrEo74hC2I35yrY0OMunZKQtv7oYvOWqdtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/wcH4Mz5uZiyi3byTklDeLWZp9ewFrs6s+20imYt9rsdfurvMh3T2b9R+oKiKFtn
	 xsCHDQDiH9+ajzndirshKmsdSrOzvRPcQORE97h9bwr7C33A526veVQDF/ntoXDdY+
	 DzkqysQ4K0KKtY1qErAxmuAf47uo73tagQL+vGY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lukas Bulwahn <lukas.bulwahn@redhat.com>,
	Imran Shaik <imran.shaik@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 030/371] clk: qcom: Select the intended config in QCS_DISPCC_615
Date: Fri, 17 Oct 2025 16:50:05 +0200
Message-ID: <20251017145202.889495825@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Bulwahn <lukas.bulwahn@redhat.com>

[ Upstream commit 9524f95c4042545ee8fc3191b9b89c61a1aca6fb ]

Commit 9b47105f5434 ("clk: qcom: dispcc-qcs615: Add QCS615 display clock
controller driver") adds the config QCS_DISPCC_615, which selects the
non-existing config QCM_GCC_615. Probably, this is just a three-letter
abbreviation mix-up here, though. There is a config named QCS_GCC_615,
and the related config QCS_CAMCC_615 selects that config.

Fix the typo and use the intended config name in the select command.

Fixes: 9b47105f5434 ("clk: qcom: dispcc-qcs615: Add QCS615 display clock controller driver")
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@redhat.com>
Reviewed-by: Imran Shaik <imran.shaik@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250902121754.277452-1-lukas.bulwahn@redhat.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/Kconfig b/drivers/clk/qcom/Kconfig
index 6cb6cd3e1778a..e721b23234ddd 100644
--- a/drivers/clk/qcom/Kconfig
+++ b/drivers/clk/qcom/Kconfig
@@ -495,7 +495,7 @@ config QCM_DISPCC_2290
 
 config QCS_DISPCC_615
 	tristate "QCS615 Display Clock Controller"
-	select QCM_GCC_615
+	select QCS_GCC_615
 	help
 	  Support for the display clock controller on Qualcomm Technologies, Inc
 	  QCS615 devices.
-- 
2.51.0



