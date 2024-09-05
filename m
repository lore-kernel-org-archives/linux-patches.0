Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB46154BFF;
	Thu,  5 Sep 2024 09:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530117; cv=none; b=WzjcnQAnB18IRa9FU7bHImxCcpkWxB5CML/0js9tt0FL0LnN2IXp0XErOmS9jL5rWm7rRzgy81FzH2Eiqc3FqEj97Gt2tGQN5SLouipNzBjN8JHh2pmTHdSx6hIn5TIId+cHJAzuhj6kjIAmrYcCl8gaNV9bgk+7F2t83g4CWYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530117; c=relaxed/simple;
	bh=EV7tRVmNeBuv/AaREc+KvNR0Z6p7W0LlznrkR/5Fffo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KgAH1z6uQypmUz3WqeralqbSgraKqtSr5oEtMR1dIytg/MlerndxwJyvgJk8yP0s0Qn8O8c3no00JkPigpvcZf46VVbi2ndH7eAD86ajvTg5+rC22OMFQ2W4bUqJkTm5J7P0gMNwV1dFNTzZZCCxnGh9hlMXd64fBY/drvd6zAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tep2NY7A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tep2NY7A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99B5C4CEC3;
	Thu,  5 Sep 2024 09:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530117;
	bh=EV7tRVmNeBuv/AaREc+KvNR0Z6p7W0LlznrkR/5Fffo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tep2NY7Avs9jqH5ZM5IPGfEv49Yfc6jO6dmsrXa1XgBiwOS7y5pBHuHBSI8wamYps
	 qitS29PZKx33TRCUgPwpoDRDvY9xMZWKRbGgdAKgy0KycJ3ZhSd1Iu7Ef4IYzLly/E
	 9pA5+8P2IA3XTL3cwdGnY195RBZiuqTON/meyxYk=
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
Subject: [PATCH 6.6 058/132] drm/amd/display: Fix Coverity INTEGER_OVERFLOW within dal_gpio_service_create
Date: Thu,  5 Sep 2024 11:40:45 +0200
Message-ID: <20240905093724.513592380@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093722.230767298@linuxfoundation.org>
References: <20240905093722.230767298@linuxfoundation.org>
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
index 2f8ca831afa2..f2037d78f71a 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
@@ -56,7 +56,7 @@ struct gpio_service *dal_gpio_service_create(
 	struct dc_context *ctx)
 {
 	struct gpio_service *service;
-	uint32_t index_of_id;
+	int32_t index_of_id;
 
 	service = kzalloc(sizeof(struct gpio_service), GFP_KERNEL);
 
@@ -112,7 +112,7 @@ struct gpio_service *dal_gpio_service_create(
 	return service;
 
 failure_2:
-	while (index_of_id) {
+	while (index_of_id > 0) {
 		--index_of_id;
 		kfree(service->busyness[index_of_id]);
 	}
-- 
2.43.0



