Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71F8244693;
	Tue, 11 Nov 2025 00:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822795; cv=none; b=pwEABbNeGwj3BWoEUrX7V5uIURQmXjnMt3ljJAV3n/Wb8ehoWSkxPV6yrxIF3TE+pUm8VkcNXJmINbNyMoYhqkaphAyMRcr8JcVUZRq8Nt05E4fB+9LKVSM9XlSUVxByCwbXrJUu/nHbhsnR5Wc/qiGX8hbMBVg39ZO+saetSjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822795; c=relaxed/simple;
	bh=27OVNvLiVGlmnfBD5YG8DviGxivhjxZOSzzng1rtyUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYNgm7xBjNmt7QxOJjMgafiKKGE3SkKELaJ5AqM+gMusxue/OyRv2H8CaGAoYgTNXICxEyKvyEWq5wk4oDGeRd6rH12T8RTAJEm5OQ3P1fy1vJPvOfHrJpzibeRLnsZTu01RDrYNx0nRBNakN9oI/167jXGMBArlhVlsSkFgkgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQ2g9Zs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQ2g9Zs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CA2C4CEF5;
	Tue, 11 Nov 2025 00:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822795;
	bh=27OVNvLiVGlmnfBD5YG8DviGxivhjxZOSzzng1rtyUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQ2g9Zs5FmP6pcsVpVw4lAuQowug9mwztp1o6Q8byFRmBkwPTzC2PsLEWixom2IDH
	 H8Tw6Xfcgo2DkoTzveXFEeH2M/pwkSqNhaLu2jGEp/JTFqft3MlH7xqvF3dEK4lQad
	 sulwrz80OFGgQ9SfQlemfefxy3tn5EpQ+Ou8qwW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikita Travkin <nikita@trvn.ru>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 173/849] firmware: qcom: tzmem: disable sc7180 platform
Date: Tue, 11 Nov 2025 09:35:43 +0900
Message-ID: <20251111004540.619399923@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Nikita Travkin <nikita@trvn.ru>

[ Upstream commit 3cc9a8cadaf66e1a53e5fee48f8bcdb0a3fd5075 ]

When SHM bridge is enabled, assigning RMTFS memory causes the calling
core to hang if the system is running in EL1.

Disable SHM bridge on sc7180 devices to avoid that hang.

Signed-off-by: Nikita Travkin <nikita@trvn.ru>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250721-sc7180-shm-hang-v1-1-99ad9ffeb5b4@trvn.ru
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_tzmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/qcom/qcom_tzmem.c b/drivers/firmware/qcom/qcom_tzmem.c
index ea0a353556570..12e448669b8bd 100644
--- a/drivers/firmware/qcom/qcom_tzmem.c
+++ b/drivers/firmware/qcom/qcom_tzmem.c
@@ -77,6 +77,7 @@ static bool qcom_tzmem_using_shm_bridge;
 
 /* List of machines that are known to not support SHM bridge correctly. */
 static const char *const qcom_tzmem_blacklist[] = {
+	"qcom,sc7180", /* hang in rmtfs memory assignment */
 	"qcom,sc8180x",
 	"qcom,sdm670", /* failure in GPU firmware loading */
 	"qcom,sdm845", /* reset in rmtfs memory assignment */
-- 
2.51.0



