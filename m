Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678E31E0096;
	Wed,  6 Nov 2024 13:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898441; cv=none; b=Lszx9SQ8O/wVV+/QfTl75ILk0H84z+TZGBDT1wPnFjoNGELxuf2+C7suhknFtupBR48ZkyVtXig21QcnTOl10dUFsbrTXS3LeETWpfSIpUfCoVhlDBYDfSgT9fuU6IbcSoVa+BmPDLUoo9OIXqD204RxOOsw27O82RNYD/WOsZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898441; c=relaxed/simple;
	bh=31KtCVd4C3jI2VuzAK+4rExrW3wx5I+j6IbKcWDI6iY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzOjBHoOiwaL/a0Ieg0EKolH//1qwsw+QaSSDPuHAj+OJtLumQbbS+IRiHjAy/sUOBVZje/7PgnkrMdTy0nrcvxhHHCkoIn1PDc0M4sYa7lDTYcZLejeGV38qe6ZdJx2eK8EyaPe+7gSnxdaS7oMADaYer1Gw/Pi1ancK5jhqC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4z22vL0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4z22vL0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1041C4CECD;
	Wed,  6 Nov 2024 13:07:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898441;
	bh=31KtCVd4C3jI2VuzAK+4rExrW3wx5I+j6IbKcWDI6iY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4z22vL0e454q/3NOhZMlaYIZqGhpfXVjWWGWMNIxsbR5pO6BFmtLW9kstFzPsuaY
	 +GzxI7rWpQ7/FPHhYUoR1RyS7+y+K+dNDFQS8SlFOsQ/i1/mXilYZfcN/sm8sAzEn2
	 IWggGzmNEQIrG8fQh5tDPk+OzvYRD5/cgDciuOqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 240/462] firmware: tegra: bpmp: Drop unused mbox_client_to_bpmp()
Date: Wed,  6 Nov 2024 13:02:13 +0100
Message-ID: <20241106120337.451293464@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -24,12 +24,6 @@
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


