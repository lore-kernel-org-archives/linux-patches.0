Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1586B44C77;
	Mon, 14 Oct 2024 14:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917883; cv=none; b=gDZM9uKl4/c5ku0Wm7YZrlkpi7Es9ybrStC/67Ov5o1jOEo4+C089r6K/EVzSBgZMHrZF8bwYRUPeZCJ4eroG8f/jAJdgeyamle3R/IIPQjIE8F9S5KjxOTUKMj1EfSNnxI512NSinyH4i3Q5QyiaZZnBbZJCmscfmksWVFticA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917883; c=relaxed/simple;
	bh=MW39PBLtr38kkkCoPKKDjDVMG00kIFfeN3yhYABkRpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4ikhtOJRH1QdL8eXVWqLW6/836PeY1aS8eEVscXDAzvuqrf1YBiVbfQLBRfRIuQKyxw5WOsZCXXgVK/iAK03QW5dbZwyVfAQ9pSMKyZLlM/MRKI6IjqNqLesL4YBrUvVj6VeTxz1ccw+INh69pJcFi2y0cO+S10hYOBf0TW3YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HvIgahDA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HvIgahDA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B04C4CEC3;
	Mon, 14 Oct 2024 14:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917882;
	bh=MW39PBLtr38kkkCoPKKDjDVMG00kIFfeN3yhYABkRpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvIgahDA7ItQueQss/I2mvz/milt/owN+dGPzQxaERgjyjgjaRFtkCTf0F4OYP/BE
	 qj8M783WNJrz/1NoGoB/VQ/pr/cjTOItsl2/aHuW2ovH/DkCRa/Zp/cxIQc3sO/+YN
	 uIOMtzEqfn/n/EkfeXN2bRKy7TNPgvdg/muHxqGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Yang <sherry.yang@oracle.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/798] drm/msm: fix %s null argument error
Date: Mon, 14 Oct 2024 16:11:24 +0200
Message-ID: <20241014141223.030040659@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56a3063545ec4..12d07e93a4c47 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
@@ -356,7 +356,7 @@ void mdp5_smp_dump(struct mdp5_smp *smp, struct drm_printer *p)
 
 			drm_printf(p, "%s:%d\t%d\t%s\n",
 				pipe2name(pipe), j, inuse,
-				plane ? plane->name : NULL);
+				plane ? plane->name : "(null)");
 
 			total += inuse;
 		}
-- 
2.43.0



