Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8491448EF;
	Thu, 11 Apr 2024 10:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829622; cv=none; b=gIf42km/WFf234qgSU+7JF7pJokLAH788p29X7xIeICzSFuLplH91fR6RJXCo+SRqlYqds/ZTTK/EP9gen4rBRZ10o4Ec0hApJTFLvZD0MbK9UzgKd87IfyrttIQdsAV6d240U8q5yvX7sfxj1MPvPeAFOOFBF/dnvYHfzZzG9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829622; c=relaxed/simple;
	bh=xmjvXQ17Sn5YZJksf7HfYp5hfPFuqdJgXTcO8IH1XcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8LFQAP8VSr1gkWGxrCNNIW09ifXt5G7MvFJUjXSQwh+4jq0y5DADQ5G3Ps3CcvgeKSc/rg8x60zJcPVYsD0uCJt0sQO+RNxgAaO2uWEHvtiK1zkwMCPodt+3tDuN0fZNFtwQQHZ1rw/yQF3sDqbKrtA+zOV3DLWPtpuoJqmAoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih4TDO4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih4TDO4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5760EC433F1;
	Thu, 11 Apr 2024 10:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829622;
	bh=xmjvXQ17Sn5YZJksf7HfYp5hfPFuqdJgXTcO8IH1XcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih4TDO4fe02vXh1MO0TfhsgJ2k1Lbmk2D1r4OU22PV2Pica5DTHW6R+JS36kUgT2f
	 0hfT27+vUc4kNFvzhs6h8seLFuTGlqVGWieuNw6BQxMGNq0bG0C0b7Bn3vmSJ64r86
	 0PfwvDcHjc+VVPr6KDVXkM/RMHPg02T5Ui6vNA78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 050/175] slimbus: core: Remove usage of the deprecated ida_simple_xx() API
Date: Thu, 11 Apr 2024 11:54:33 +0200
Message-ID: <20240411095421.074242501@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 89ffa4cccec54467446f141a79b9e36893079fb8 ]

ida_alloc() and ida_free() should be preferred to the deprecated
ida_simple_get() and ida_simple_remove().

Note that the upper limit of ida_simple_get() is exclusive, but the one of
ida_alloc_range() is inclusive. So change this change allows one more
device. Previously address 0xFE was never used.

Fixes: 46a2bb5a7f7e ("slimbus: core: Add slim controllers support")
Cc: Stable@vger.kernel.org
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20240224114137.85781-2-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/slimbus/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/slimbus/core.c b/drivers/slimbus/core.c
index 3e63e4ce45b04..6270b4165644b 100644
--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -409,8 +409,8 @@ static int slim_device_alloc_laddr(struct slim_device *sbdev,
 		if (ret < 0)
 			goto err;
 	} else if (report_present) {
-		ret = ida_simple_get(&ctrl->laddr_ida,
-				     0, SLIM_LA_MANAGER - 1, GFP_KERNEL);
+		ret = ida_alloc_max(&ctrl->laddr_ida,
+				    SLIM_LA_MANAGER - 1, GFP_KERNEL);
 		if (ret < 0)
 			goto err;
 
-- 
2.43.0



