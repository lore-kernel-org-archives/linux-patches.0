Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17DEB157E6A;
	Mon, 29 Jan 2024 17:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548293; cv=none; b=YiMsxBUX6XEJ3nggDt5eXf7O1RH/IFx4S1iUu3QVHc8bSdZxPFZcvRfkaNqvvxwEnx4WowxUQVaKy/aIN60qCBQ+Di9S+l4GRnt9IBcitC3X9DFlHNCyek8lOkWmPm7dNSsPxuPz/WxfOhbUNvfc0qYmdGQVaGsG4XlQr2VsgJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548293; c=relaxed/simple;
	bh=cbpVvNjll1xR8gD/GM9XSQvECkCSUzXLfzP1sB5vZ44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8CqcoUVYJd5Si6hGEkqt0rr2Bx+QT3QTOUoaPq0a9lcEVIMbBudoyNg9nG5Lb46JjWmwreJKjtSxdjHtAGTDhAept63nTopxyhAAkpOLema0eApLhfG6hICT0YviAFR5dnA8K8BK9+REdPXB6HdYM+TJKl1l6ISrPbbTKvxPEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jJpKS3M+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJpKS3M+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DD3C43399;
	Mon, 29 Jan 2024 17:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548292;
	bh=cbpVvNjll1xR8gD/GM9XSQvECkCSUzXLfzP1sB5vZ44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJpKS3M+iZ0OIgVwaeKBkwI/b4A4OyjdPsPejZtiBFCqSaCZhdYcj2m2iYQoCbntO
	 t57tAHM71LD+Cy+BNrME2dAQJURZXbUUy39ZisgfcJSAShjUGAwB2JOBiGWjTTsH9f
	 DQc8ouLXAJORbOL6appIvsdbadUzboWCujTgOpJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Martin Leung <martin.leung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 302/346] drm/amd/display: Init link enc resources in dc_state only if res_pool presents
Date: Mon, 29 Jan 2024 09:05:33 -0800
Message-ID: <20240129170025.316787670@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <dillon.varone@amd.com>

[ Upstream commit aa36d8971fccb55ef3241cbfff9d1799e31d8628 ]

[Why & How]
res_pool is not initialized in all situations such as virtual
environments, and therefore link encoder resources should not be
initialized if res_pool is NULL.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Martin Leung <martin.leung@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index c16190a10883..990d775e4cea 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -3774,7 +3774,8 @@ void dc_resource_state_construct(
 	dst_ctx->clk_mgr = dc->clk_mgr;
 
 	/* Initialise DIG link encoder resource tracking variables. */
-	link_enc_cfg_init(dc, dst_ctx);
+	if (dc->res_pool)
+		link_enc_cfg_init(dc, dst_ctx);
 }
 
 
-- 
2.43.0



