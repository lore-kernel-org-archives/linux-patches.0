Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B07646420;
	Mon,  1 Apr 2024 15:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986920; cv=none; b=pzEa5rDgRyVcMTVzRM4OLuYAdg6B8Zs0PrKLlQ0hzzdCgqtg6C/BAC7CuXVC0TDB1jdVJF/LKmRBgPR+IaqjDFJ9DNp5ZYkXZhxRf1cs/8dSi0dHK+svYIQqT3oqY1gKbVjmYBb6MVZ1RuSR017AsTytI6uItCjxh3iFHfMatDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986920; c=relaxed/simple;
	bh=17pmepThxCU10q5znq7lS2NrAwZCzAXwjtHgXqL8bp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qsvjd0VmusJCeU1weAFpBTo81sEvp5NTcJOcm0KucR3Ttt8TlsuW1A3SvHaqB0Bymb54SYhmA9xTVnH2vQYV0jSB4usYhNllLAM5szsRHavhAvfUs/cOCpnYY2uCW4VyOR/+u6jmD1IqluWoQfGGtiZciYaHt7ekLjC1lpAlDEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IU6qmcwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IU6qmcwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9B3C433F1;
	Mon,  1 Apr 2024 15:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986920;
	bh=17pmepThxCU10q5znq7lS2NrAwZCzAXwjtHgXqL8bp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IU6qmcwGcZ67Og0FReTBfawyd8WIXjO6jh2jBtxJ2KkgUrm3bAx19toJHuEUvtSXQ
	 ZCZvsv52QwP10hCLMCMaGuJE7HZYjXqstPMlNBQe9FIugQzhqAnC+QrzZw+jqnkaZ8
	 Zvl7L5YyUWEJPTuLbQP2xrcs7j3D/Ln1CERDkquw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 127/399] slimbus: core: Remove usage of the deprecated ida_simple_xx() API
Date: Mon,  1 Apr 2024 17:41:33 +0200
Message-ID: <20240401152552.979766249@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index d43873bb5fe6d..01cbd46219810 100644
--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -436,8 +436,8 @@ static int slim_device_alloc_laddr(struct slim_device *sbdev,
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



