Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8634B1D5ABA;
	Wed, 25 Feb 2026 01:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983177; cv=none; b=tmYHzBon+eO7YjPzj4y+08wjU8+fVA6/4tFu9zyEtQvPGPJj9bU+fyIeQ/9P6JY8XYdKSiji9wXRta2OGakd/07Y3MKp171Ieh6MlgCiF2Hqhl3pG2dHURvXqyzCSZwtp3lM5j7GbI3vhuDN14C2AZGqu4T7HARihlHK149sZyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983177; c=relaxed/simple;
	bh=d3E/9qU4wvA1p1P4+fuadpw/EVgVOMkGS/S33/YrVBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5FI7GhXroCEguuQ1u0oYOfvePZxooqawnax/SsoUaohUxW1UmZrzbnO3jl2dmAnDMHzuJmkqGNBKKG88URWk98A6E5aFasbTyqlmjU0uPg8lISeCbD0gRzljzg9sS03MrqzqqM7PuemzdgK/vFhcJlYGx97cj1mdZPtJhYTCWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bEsos3SA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bEsos3SA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E858C116D0;
	Wed, 25 Feb 2026 01:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983177;
	bh=d3E/9qU4wvA1p1P4+fuadpw/EVgVOMkGS/S33/YrVBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bEsos3SAwNr5o6e+s5b3zo2TS23xEb8vRtIZgHGj5/d5XBR5aPtMl0yDKXfF+WmWs
	 VfNu1XE1JDqIwAXxs5fCa4zsa6iwyRSg1tzbh3G1sfd4coqZ2r/yr9V5IObujjwDQj
	 hVNZ7FN4IzMbIecX3ELtFNpCMR4HcsmnzanvLbbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 302/781] ASoC: SDCA: Remove outdated todo comment
Date: Tue, 24 Feb 2026 17:16:51 -0800
Message-ID: <20260225012407.116405811@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit b27b57f85fe3f0eca479556ac55bc9cbd1a5685a ]

Support for -cn- properties has already been added, however the TODO
comment noting this feature was required was not removed. Remove the
now redundant comment.

Fixes: 50a479527ef01 ("ASoC: SDCA: Add support for -cn- value properties")
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260204125944.1134011-2-ckeepax@opensource.cirrus.com
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_functions.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/sound/soc/sdca/sdca_functions.c b/sound/soc/sdca/sdca_functions.c
index 5a1f120487ef0..e86004c9dea03 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -911,10 +911,6 @@ static int find_sdca_control_value(struct device *dev, struct sdca_entity *entit
 	return 0;
 }
 
-/*
- * TODO: Add support for -cn- properties, allowing different channels to have
- * different defaults etc.
- */
 static int find_sdca_entity_control(struct device *dev, struct sdca_entity *entity,
 				    struct fwnode_handle *control_node,
 				    struct sdca_control *control)
-- 
2.51.0



