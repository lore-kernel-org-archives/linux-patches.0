Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB99482C60;
	Tue, 29 Apr 2025 17:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948175; cv=none; b=ezxCTe7q/yHM52JyLnjT5vj33JiwJb/4858Nqn6bCU8Mg+7SqQr3Pqse1+IyueN+2n/Qw1v2LwLlfepN9lcJ/phdRUWeeGLIUwLQoR2gZUwXdq5TtmC3xpLmOf6NRzbUPNZCaVzwVTIaqn2hHbbLm0eSHGZKJFeDgrJYGdMfCVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948175; c=relaxed/simple;
	bh=Larah3RbYLI2OyhuQxC4dtcIKM5bZWiTKs5qjE09h0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TSMc9gubHWtop3Fz0Wk9FDAfD+3YDEw8L7aIdNVHeW8RULV14xtHJ+jA0h8OyjPdG1U5YVvtrxcaeReQEeGBxOjnDmRA7bXZohZZCSCEEW9ip15JxdY4IxWF7nuj4T7X4P0uKuTdz/PurYx7TT9ShHefgEICPaeSYG1MfRR0H7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQ/2vxcQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQ/2vxcQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422C4C4CEE3;
	Tue, 29 Apr 2025 17:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948175;
	bh=Larah3RbYLI2OyhuQxC4dtcIKM5bZWiTKs5qjE09h0Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQ/2vxcQeId4mPADwNyHrnkjGG/0kERYTLk8/KoxMmtg3Yvj3JMwq8yVsPStzzZRm
	 wYbL4e6hv6/oQhq2TzS3eOaw64Yjk/RvVLmPZArqZOtZmG1QVIYBYa7q44RwoCtzIM
	 6KqWZ057iCZWsOPaEwH0/OyA95LyEeTZH5mFdkGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julia Filipchuk <julia.filipchuk@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 211/280] drm/xe/xe3lpg: Apply Wa_14022293748, Wa_22019794406
Date: Tue, 29 Apr 2025 18:42:32 +0200
Message-ID: <20250429161123.758993536@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Julia Filipchuk <julia.filipchuk@intel.com>

[ Upstream commit 00e0ae4f1f872800413c819f8a2a909dc29cdc35 ]

Extend Wa_14022293748, Wa_22019794406 to Xe3_LPG

Signed-off-by: Julia Filipchuk <julia.filipchuk@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://lore.kernel.org/r/20250325224310.1455499-1-julia.filipchuk@intel.com
(cherry picked from commit 32af900f2c6b1846fd3ede8ad36dd180d7e4ae70)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa_oob.rules | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index 264d6e116499c..93fa2708ee378 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -29,8 +29,10 @@
 13011645652	GRAPHICS_VERSION(2004)
 14022293748	GRAPHICS_VERSION(2001)
 		GRAPHICS_VERSION(2004)
+		GRAPHICS_VERSION_RANGE(3000, 3001)
 22019794406	GRAPHICS_VERSION(2001)
 		GRAPHICS_VERSION(2004)
+		GRAPHICS_VERSION_RANGE(3000, 3001)
 22019338487	MEDIA_VERSION(2000)
 		GRAPHICS_VERSION(2001)
 		MEDIA_VERSION(3000), MEDIA_STEP(A0, B0)
-- 
2.39.5



