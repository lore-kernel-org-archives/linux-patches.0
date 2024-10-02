Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA8CC1D0B9D;
	Wed,  2 Oct 2024 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877831; cv=none; b=NdT3TTz0pTkTPhN3jqabX8B53HKvpgq16ZOLldifhx/ddvB5tsGREBvmL/EbAek9p9c3GBNbP675bQFbyp7jxjvLQ5PP9WCZal8/f1HlpQ/zCPWGQPeqX1w66B4VLWA3477qCxe6BqfIociQPfQOjRbcrpPZgbK2+ISeSH4YCD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877831; c=relaxed/simple;
	bh=xr9ldIci/n66YeJSrXTfwNMvhBnnoOhVO4qcll8aaFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EySLSpu8AAuTDkhrv0ZX3h9Bx6PDcpHTOvfUs2fSyTfiP9AJh118Rl7GYojDVXvg7E4tFLZAUBUajotzuo4H6rpk1ogh7vd6HFmcgHnbLKmSpJ7W+jb2/bwRvHyCIi7plVVv+oQfoyf+1eC/AwCMFZMOR5YNJ8jmtYi0GxqfWmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWsNpsgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWsNpsgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55203C4CEC2;
	Wed,  2 Oct 2024 14:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877831;
	bh=xr9ldIci/n66YeJSrXTfwNMvhBnnoOhVO4qcll8aaFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWsNpsgiPX0Oq+1cDoDoptrr8UCYv3TM8sbZ3jx3XuLgR/OO7KeoTUYA7rzJDpD7z
	 8J+4AN6/iTLpjaZbXfpOJ9UFlXRPR4YlPGNrqULxYgnfi3nqo1JTa8DpRJa33+xEsw
	 i17tylg3bv/ZFVzLSOwweeZHFt0pJ1pT2Mr2ePhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Yang <sherry.yang@oracle.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 210/634] drm/msm: fix %s null argument error
Date: Wed,  2 Oct 2024 14:55:10 +0200
Message-ID: <20241002125819.393841402@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sherry Yang <sherry.yang@oracle.com>

[ Upstream commit 25b85075150fe8adddb096db8a4b950353045ee1 ]

The following build error was triggered because of NULL string argument:

BUILDSTDERR: drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c: In function 'mdp5_smp_dump':
BUILDSTDERR: drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c:352:51: error: '%s' directive argument is null [-Werror=format-overflow=]
BUILDSTDERR:   352 |                         drm_printf(p, "%s:%d\t%d\t%s\n",
BUILDSTDERR:       |                                                   ^~
BUILDSTDERR: drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c:352:51: error: '%s' directive argument is null [-Werror=format-overflow=]

This happens from the commit a61ddb4393ad ("drm: enable (most) W=1
warnings by default across the subsystem"). Using "(null)" instead
to fix it.

Fixes: bc5289eed481 ("drm/msm/mdp5: add debugfs to show smp block status")
Signed-off-by: Sherry Yang <sherry.yang@oracle.com>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/611071/
Link: https://lore.kernel.org/r/20240827165337.1075904-1-sherry.yang@oracle.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
index 3a7f7edda96b2..500b7dc895d05 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
@@ -351,7 +351,7 @@ void mdp5_smp_dump(struct mdp5_smp *smp, struct drm_printer *p,
 
 			drm_printf(p, "%s:%d\t%d\t%s\n",
 				pipe2name(pipe), j, inuse,
-				plane ? plane->name : NULL);
+				plane ? plane->name : "(null)");
 
 			total += inuse;
 		}
-- 
2.43.0



