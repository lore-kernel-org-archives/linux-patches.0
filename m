Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50F151C5A;
	Tue, 22 Jul 2025 14:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192816; cv=none; b=O2rQN1j9Rlp8PU7e0III4uGGMUFyvXVsZ7QyWicFbTICMSzhfuWedxAd+ksAC0vE5q0YrqIbaAQMMIu162xXM1Six4L8urJbl2HCMWTFtyRihbwi72GSgnA3w9X7bp6pzWsi2P8D6LjjTJDw/sr4zpYHqXjgB8+69w0af1x0PAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192816; c=relaxed/simple;
	bh=hKIUt5LXnifjK916PvIbxCc/HKymS+uMQdQ5iDhI9vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMYJA/UcO3m9bgZP2vhgSttHPGRzk7X7wOJe5nommD+7BdJmOs3Ys/ivoTUY1xfLwnc2a3kAI97WwCQ51E2dknLyMEekzCZKLzZNENqHMZ29HHWNX/IIz2Y/GtFxFWjaJ01rc2fXbuIdM/J+GQ7HjT6bMlo1nMs4vb6qJab4Gfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYsA/a2r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYsA/a2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541B1C4CEEB;
	Tue, 22 Jul 2025 14:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192815;
	bh=hKIUt5LXnifjK916PvIbxCc/HKymS+uMQdQ5iDhI9vU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYsA/a2raEIc1Z/fqY7F1c0bQzK+b9U3FMgA7IIPbz4Iyi1UnHZIg0Rj3HKvAFOkn
	 jEEkqVXhaz96UDsGiVK4XeNAgl3lJkoV9ZxVJOCSiFF4KJSMw/HUcs5K7Qc2LByZIP
	 k19zzjmG0ea2sGkPLxISkM0OCtfl0D0KYCiV0a18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Aberback <joshua.aberback@amd.com>,
	Clayton King <clayton.king@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 032/158] drm/amd/display: Free memory allocation
Date: Tue, 22 Jul 2025 15:43:36 +0200
Message-ID: <20250722134341.942997514@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clayton King <clayton.king@amd.com>

commit b2ee9fa0fe6416e16c532f61b909c79b5d4ed282 upstream.

[WHY]

Free memory to avoid memory leak

Reviewed-by: Joshua Aberback <joshua.aberback@amd.com>
Signed-off-by: Clayton King <clayton.king@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit fa699acb8e9be2341ee318077fa119acc7d5f329)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn401/dcn401_clk_mgr.c
@@ -1700,7 +1700,7 @@ struct clk_mgr_internal *dcn401_clk_mgr_
 	clk_mgr->base.bw_params = kzalloc(sizeof(*clk_mgr->base.bw_params), GFP_KERNEL);
 	if (!clk_mgr->base.bw_params) {
 		BREAK_TO_DEBUGGER();
-		kfree(clk_mgr);
+		kfree(clk_mgr401);
 		return NULL;
 	}
 
@@ -1711,6 +1711,7 @@ struct clk_mgr_internal *dcn401_clk_mgr_
 	if (!clk_mgr->wm_range_table) {
 		BREAK_TO_DEBUGGER();
 		kfree(clk_mgr->base.bw_params);
+		kfree(clk_mgr401);
 		return NULL;
 	}
 


