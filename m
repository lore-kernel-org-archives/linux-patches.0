Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAF21DE2AD;
	Tue,  8 Oct 2024 12:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390479; cv=none; b=Xd5J3lVQZ2DHrvFhnTsEsrSw0NmCgPD8hOqZhadRhDpvRm//A5o56zOtbyhUd9JWbxfV5UtVTcOZMdH2FtW31PqLMHdEh3HOf0KD9eTMHmaQ3B6sbdaqDN63jMmicol0eOomyW09FN8Wc23PsHre7k5SpWonpoPOUUo7/bFAs/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390479; c=relaxed/simple;
	bh=HV+AH9vEBkiYg8DmN7nbtbXGtirhkb+o2aEJ1Tsmt4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VgB2HiBumuzu0XSo6sSTdjteEA7qgEp8/5VKobFC33mcVT2xdzh6nuEf38ggXZhlTalaq9HEM02WNiQaEHdm5IzvVu9d7deH/EnEJUchjNRqbbXiY6BTrG48A49NR5M1kLDyilNQHvSXG9rAkXXDlHkkWgXNTOf7vD0NjCJAM+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLkY6dvg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLkY6dvg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9605C4CECD;
	Tue,  8 Oct 2024 12:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390479;
	bh=HV+AH9vEBkiYg8DmN7nbtbXGtirhkb+o2aEJ1Tsmt4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLkY6dvgPX8E4GF3lzQh/X5Dt2vsHycdvEJPcQMNj2YfljFhU6aJrXffjJaPD8k0L
	 aEyCq8fp618u6nuF7BpweS8NH503MB5/sP0oPjWeQwtxD51Bn6XqcZySCQIkSJPS22
	 WMj+rNXRhXFYqahpQqDmD3lehVV2wgcKvd3OLNvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 6.10 302/482] firmware: tegra: bpmp: Drop unused mbox_client_to_bpmp()
Date: Tue,  8 Oct 2024 14:06:05 +0200
Message-ID: <20241008115700.322418976@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


