Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6028D76C99;
	Wed, 21 Feb 2024 14:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524909; cv=none; b=jymFmKTfec8mMnLBLPcvXCYPu5Q4fyctkHqZwuUvXBn+dT18cMXbJVvMRsM2uBhXElc++/2RtFR3I5jL55iLldwIlsIVp9B/7Ntd7JwqJFPMHv9tmUdr966n/b+ZAXi9jW6KK0VLoDSWs5+/by4ez0oASwk0yoLCVxn0I3H27jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524909; c=relaxed/simple;
	bh=Ds/41fnbdpC1r8hkGr15Hhad3KTQi9wI0iuZZGnr9qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JpAyFFLCiZh9zUU1Sv0F0mhM0buRo7SVpDPcASg5c/mbAPBNNslPCzZC1DeFVhWoo/JtPSlRFm9AZh9i501cBS/EvRShVtXNwKxCr+w6Kz2HkeGtwsqBLMJLLdjwaSFjRVaUcVY9bUZ9BnRuaUhAfVNGx2mNPwaY0HfVjJEkbpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y4FyzcUg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y4FyzcUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA9D7C43394;
	Wed, 21 Feb 2024 14:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524909;
	bh=Ds/41fnbdpC1r8hkGr15Hhad3KTQi9wI0iuZZGnr9qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4FyzcUgZrYlyPfDYsb0JARZsNPWugENPKqbloChWP5nAML7SdlXoLUo8O+dZxhk1
	 MqqQzG9bHVkt1TxQhtBMgmve/oMshU8NUkpO/E0s6mh1/zMLtud4m9gtS7JMlubp+5
	 URzqRuYuO8yB1zQ0RK2+yUtQgqTZsuQ6yPWyOE58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.10 376/379] drm/msm/dsi: Enable runtime PM
Date: Wed, 21 Feb 2024 14:09:15 +0100
Message-ID: <20240221130006.185300875@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 6ab502bc1cf3147ea1d8540d04b83a7a4cb6d1f1 ]

Some devices power the DSI PHY/PLL through a power rail that we model
as a GENPD. Enable runtime PM to make it suspendable.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/543352/
Link: https://lore.kernel.org/r/20230620-topic-dsiphy_rpm-v2-2-a11a751f34f0@linaro.org
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Stable-dep-of: 3d07a411b4fa ("drm/msm/dsi: Use pm_runtime_resume_and_get to prevent refcnt leaks")
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/dsi/phy/dsi_phy.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
+++ b/drivers/gpu/drm/msm/dsi/phy/dsi_phy.c
@@ -710,6 +710,10 @@ static int dsi_phy_driver_probe(struct p
 			goto fail;
 	}
 
+	ret = devm_pm_runtime_enable(&pdev->dev);
+	if (ret)
+		return ret;
+
 	/* PLL init will call into clk_register which requires
 	 * register access, so we need to enable power and ahb clock.
 	 */


