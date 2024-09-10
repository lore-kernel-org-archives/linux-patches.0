Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAFEC18FDA3;
	Tue, 10 Sep 2024 10:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963335; cv=none; b=i+pFK6qIaY9DSJNqbGOGJ3Nc88OIZde0p29QWsfOzqJPBDGRyyuxaCN1ejXeCfTbVl29pwAnHKPspiA4YyoKWnVmkAzdiXdYSiiUxypwhKzpEQydg1gBCVBmFBHDko3EFg0Sp84gCMUnbw4p+r5Ufob0G63qwtn2AWEdJfv0hq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963335; c=relaxed/simple;
	bh=qYoe0yvmlN8gccp/ld3eThvU0jWoJtJFsu4LGPwOF8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LGGIHksPtatrTTEOKFddIb3jcZ2WHior4jk7hK7J/bBn32zHogTrxVfv/gHtOCiWnG7+k4se2wcI59kCCIgEbBmTAdSiwlP2KZC0PCrsuqk/o66W/1MkxaR7MAVMTbYJCQ0Lk35QvClAp8lrBk/yh4V9eM8IjyNRVDeXKZWyjMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9joXQDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9joXQDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C84C4CEC3;
	Tue, 10 Sep 2024 10:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963335;
	bh=qYoe0yvmlN8gccp/ld3eThvU0jWoJtJFsu4LGPwOF8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9joXQDQwiHljtt5prc5riCTD3N8joU5c+L+PACB5fQMM0vNtb5p8Xf83fIbu2IGs
	 ydGEOkMRrRuVTYZ9BbTVh4qLtfogHFRonTiM9wm9WQ0d6FwRgjWBs5uAKwPO1r6U6H
	 iQmOrrXSmrlkg1yVicZ5zLiA1ed94gbVgar0r178=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 022/214] drm/amd/display: Fix Coverity INTEGER_OVERFLOW within dal_gpio_service_create
Date: Tue, 10 Sep 2024 11:30:44 +0200
Message-ID: <20240910092559.686116351@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Hersen Wu <hersenxs.wu@amd.com>

[ Upstream commit c6077aa66fa230d12f37fef01161ef080d13b726 ]

[Why]
For subtraction, coverity reports integer overflow
warning message when variable type is uint32_t.

[How]
Change variable type to int32_t.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Hersen Wu <hersenxs.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c b/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
index a7c92c64490c..a5de27908914 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
@@ -58,7 +58,7 @@ struct gpio_service *dal_gpio_service_create(
 	struct dc_context *ctx)
 {
 	struct gpio_service *service;
-	uint32_t index_of_id;
+	int32_t index_of_id;
 
 	service = kzalloc(sizeof(struct gpio_service), GFP_KERNEL);
 
@@ -114,7 +114,7 @@ struct gpio_service *dal_gpio_service_create(
 	return service;
 
 failure_2:
-	while (index_of_id) {
+	while (index_of_id > 0) {
 		--index_of_id;
 		kfree(service->busyness[index_of_id]);
 	}
-- 
2.43.0



