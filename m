Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B6D22127B;
	Wed, 25 Feb 2026 01:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983974; cv=none; b=dUHJRyZq7C/q1/vAvIOuKrTTd1DHxNPKLQZ9V+/xDTJlAoIU0qfi5aaEEYF1R3irfW06xPj4vSzf8MdYPLGwffi5WyQPbERmQ5qKX1zTeS+biFOLDFmMu3Gc6gWa5qGrgaHmhcnl4dIPg3DjZRvgYJNHFO1XvEiz62bdnGeehhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983974; c=relaxed/simple;
	bh=B1zFBZHVwa0gGmBvBCwmJsnn3JNFw6x6iRVarcjNy8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQofrR2eK5Ngx9YKOfl0iYynXX/JbKPIue9oHPJ1vY02xMSi7+02TVDOSiSIccTSxRmhU2W3swDLaRhtcDpBh3wC6W4lNapintMwXSxxiX0DxU48SXIaksr/sR9syLTaBlgMM9T8G/MjbqsQiwy8wa3wHUivgHeFVp8IGQfreJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkk5zAZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkk5zAZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B547C116D0;
	Wed, 25 Feb 2026 01:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983974;
	bh=B1zFBZHVwa0gGmBvBCwmJsnn3JNFw6x6iRVarcjNy8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zkk5zAZc2QTw8hQBj36kYRYhQJMmCNUO0CG3Bj7dJUS+PipUxdEN/g8IOG1CoFcvt
	 JZgiZNlP9ZB8SekwAOhZDubI2VNdnm00mppwGzces806sz86WOyiGNnIajSJzwfCTb
	 o2ucZGxI/wvWyQ5xYjL5RqFBRy5t6UuFwJCjlxFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 228/641] ASoC: SDCA: Remove outdated todo comment
Date: Tue, 24 Feb 2026 17:19:14 -0800
Message-ID: <20260225012354.428962435@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 19b12564f822e..7adbf653bd8ac 100644
--- a/sound/soc/sdca/sdca_functions.c
+++ b/sound/soc/sdca/sdca_functions.c
@@ -854,10 +854,6 @@ static int find_sdca_control_value(struct device *dev, struct sdca_entity *entit
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



