Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612B249659;
	Mon, 14 Oct 2024 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919185; cv=none; b=KR+Bm5wVgz3Z8DbCYkf9eDra+0f8kQMQWN47G/lsJYuTOA1r2XH4S4Qj2eEF+UXGGKwlrgMj9t36zckz/+fMW9l9+rchi/vl5SIkZqZ04tTGU/ddonoLHoW5Ytn36FR5umxltV1HzAc47XqTF2Mi30/gS36O9nwG9i7127ftJvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919185; c=relaxed/simple;
	bh=1AEPg4oatgaSloHHyJpaqOCcMY6sdFgW2bAYCOlfuk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLl0BvmVvIV7GD8tGtpoh9DBWA6SZaTCmt+jWStm7Ukuqx3MjctYOocDxu3+pEA2ApSryrf59U2PullNLxXLBz5FOZv8mSFrpKG+kf8PI0NjziBp3b47tS05tZnSgTH4i09qMyOBmrFmSPoWq97piAxzcYWAfU7OQh+CRXTe9PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eD/HglVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eD/HglVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C839AC4CEC3;
	Mon, 14 Oct 2024 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919185;
	bh=1AEPg4oatgaSloHHyJpaqOCcMY6sdFgW2bAYCOlfuk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eD/HglVQjIAfS13fH+ZfkbusrECQJPGEpHpHdUZTJB93TwiMZFdm79Ir2+mfWzsqK
	 UUzUEVoYUVG4UupTUDb6W5sKOQ4MoOqunaboJRHOeouOTXtiaeXELPR4g93aqflj7H
	 ycO9iZ+5pOZdQXivrgHECqOLaQn+zHGeKH8E2zzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.1 529/798] firmware: tegra: bpmp: Drop unused mbox_client_to_bpmp()
Date: Mon, 14 Oct 2024 16:18:03 +0200
Message-ID: <20241014141238.773063171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 9c3a62c20f7fb00294a4237e287254456ba8a48b upstream.

mbox_client_to_bpmp() is not used, W=1 builds:

  drivers/firmware/tegra/bpmp.c:28:1: error: unused function 'mbox_client_to_bpmp' [-Werror,-Wunused-function]

Fixes: cdfa358b248e ("firmware: tegra: Refactor BPMP driver")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/tegra/bpmp.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/drivers/firmware/tegra/bpmp.c
+++ b/drivers/firmware/tegra/bpmp.c
@@ -25,12 +25,6 @@
 #define MSG_RING	BIT(1)
 #define TAG_SZ		32
 
-static inline struct tegra_bpmp *
-mbox_client_to_bpmp(struct mbox_client *client)
-{
-	return container_of(client, struct tegra_bpmp, mbox.client);
-}
-
 static inline const struct tegra_bpmp_ops *
 channel_to_ops(struct tegra_bpmp_channel *channel)
 {


