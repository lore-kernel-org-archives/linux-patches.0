Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4978C1C7274;
	Tue, 15 Oct 2024 12:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993708; cv=none; b=NgOdS8/JOyIhK59KfGGg5O/WE0IDn6UbG0CufxCqQlgeGYJMfkRVqj4CZSTQvgnU7yAwlLMlzPXAg/ZzfbJjeFucQDrgMWHiedJPQlTcIGgNVIKSulnSEMJc9Tda7TKAHubxtYPsDLzzpA1hElwrNmmlfkCojDeogkZI/RQX1QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993708; c=relaxed/simple;
	bh=JEEpJHtu36CL8tqjyaSjqwkrB7gQ4BzOG6NGuQ5qa68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaJSZOEAbfDhkJEYaszU9OFMh9sLrc7t3tSYQC++roYvyRr8mzltAnqAoin2fTLamNNOd/gMYhw3D74nxbf+sKcA/nr6V0JqK6m+Luv4SiE+Vs7+vLmYopNLVJ94bQVwCCVKC9/2CKTiAhs1fQ6JRYMj8ssVnhXPijgXElmYV9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wLsb3yOu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wLsb3yOu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBEACC4CEC6;
	Tue, 15 Oct 2024 12:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993708;
	bh=JEEpJHtu36CL8tqjyaSjqwkrB7gQ4BzOG6NGuQ5qa68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wLsb3yOuv1dtDMdlcbGieANCusJUb7WofYBg9RDl49sbNtiW3hXXqvzmJka0PH79p
	 ri9hdKvQ+SU1aycGveJ+BLCM00qYPqKKQt3tkxFBPZQaE1ocukMPbeGPZsRZCmELeL
	 VF6Evnzc2tE0jozZwxxjvBI5/65r+NkWMCa88Ztc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.15 492/691] firmware: tegra: bpmp: Drop unused mbox_client_to_bpmp()
Date: Tue, 15 Oct 2024 13:27:20 +0200
Message-ID: <20241015112459.871003729@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


