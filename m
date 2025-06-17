Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79292FA626;
	Tue, 17 Jun 2025 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179189; cv=none; b=iSMnkcgkKHDhokWLXv8PqUQ6Kvd/35gwjawm8GNPKx5t1KW6OSbqbyADuAMHl7NnhBAz6dhxZ9tESaa8iFRRIHJz6QrjFOOzFioRhySjRtmRvZgW0WJT7nVry+TB9R0gIv2ZxbtGRxx5A1nLFr2I9elzA/m2gKJNrJijv8w4jrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179189; c=relaxed/simple;
	bh=HFAZOieM4AeR9CEbVTV2edJ+9oPZ6ioHDtZobzl44iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ojovnteIqlsSL8FYKLX4zkGy8AJtZEtllF2Wzt/m1TCXSgZcTgRvGEaVkO0lzjAEgXtgKWoIrcriv7G0ucjvfZio0snzqtKeRCt/CXtPF/EGVbjw05Lqke3MSl7Z/eA29GZcSg/IRVm9F2gTm8Q0PUvivqxfhMIZUGJL4chUp2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mCD1GdqA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mCD1GdqA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A2AC4CEE3;
	Tue, 17 Jun 2025 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179189;
	bh=HFAZOieM4AeR9CEbVTV2edJ+9oPZ6ioHDtZobzl44iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mCD1GdqANOsBeLYajNGe/lPTSggJQiZPxJmZCTm/498cDact+iLIg9F83X0cfSbVf
	 BzOE4dZJ1NMyxlvcB4t/LTENalVBWs5g1YprYJpaHzxk+Ncx953xiMKONgkNKoJtyr
	 rzeiWkKPTb8Z72lZK+E5IQjyqpfws0R37aveSoYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 645/780] ASoC: Intel: avs: Verify kcalloc() status when setting constraints
Date: Tue, 17 Jun 2025 17:25:53 +0200
Message-ID: <20250617152517.748380792@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 5f342aeee2724d31046172eb5caab8e0e8afd57d ]

All memory operations shall be checked.

Fixes: f2f847461fb7 ("ASoC: Intel: avs: Constrain path based on BE capabilities")
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530141025.2942936-7-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/path.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/intel/avs/path.c b/sound/soc/intel/avs/path.c
index 8f1bf8d0af8f9..43b3d99539107 100644
--- a/sound/soc/intel/avs/path.c
+++ b/sound/soc/intel/avs/path.c
@@ -134,6 +134,8 @@ int avs_path_set_constraint(struct avs_dev *adev, struct avs_tplg_path_template
 	rlist = kcalloc(i, sizeof(*rlist), GFP_KERNEL);
 	clist = kcalloc(i, sizeof(*clist), GFP_KERNEL);
 	slist = kcalloc(i, sizeof(*slist), GFP_KERNEL);
+	if (!rlist || !clist || !slist)
+		return -ENOMEM;
 
 	i = 0;
 	list_for_each_entry(path_template, &template->path_list, node) {
-- 
2.39.5



