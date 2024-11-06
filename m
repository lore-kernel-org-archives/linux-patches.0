Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE53B1D5AD7;
	Wed,  6 Nov 2024 12:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894971; cv=none; b=sUN4mJVSYLsoT9enIUFBTzBoLcPFzQ0fs1MYgXKCpM/C1/jCmJ3iMHGWIjLObWKjSgUlwxVDeQMqdoUGsO/Z7A4Jjj8Dxaw9fMXDcmg73stvujMiqeS+ZS4BUDBy7SdwvYKbWEPhMUpw01BZIdIUI/lH29FadCJKL6WyA1g5S9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894971; c=relaxed/simple;
	bh=+vOHLq3hLbxjxMJUwa4uLy1gZIpQhYXd1bxI2B5TIH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IGbipEPGq+vANnz4QzQ4ElJpB0ozLRgvQQf/HBt4qhiossGUq2iVr8gabWm3vgpPkocI5jPpKnkARXLeFer72ImVb1cUqKmyNRxVCm0fHzNM88gz9UTYHC30lpFwWMUm5/w9XSvv/GUx/qVaeKIfAvSs3L/MtCAgu+7xpWDr9QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qy/JOemO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qy/JOemO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5DFC4CECD;
	Wed,  6 Nov 2024 12:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894971;
	bh=+vOHLq3hLbxjxMJUwa4uLy1gZIpQhYXd1bxI2B5TIH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qy/JOemOtuzr6jgLRAj3kGtNcEJIEn0ydbYLMADBLUkNCz1+5yd3WtaDB+DaiTIk4
	 kCbN7Nj4emwvzZB8/ofOmFXCXxRN23sacQmRIUak9xfV+Pqc47NM/qM/r6K8u7urcL
	 +UiTR8dLRVY3n74JqURo8Bs0nLqBMECpCOvBXtB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sherry Yang <sherry.yang@oracle.com>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 062/350] drm/msm: fix %s null argument error
Date: Wed,  6 Nov 2024 12:59:50 +0100
Message-ID: <20241106120322.422970346@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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
index 96c2b828dba4a..2d9027c8418ee 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_smp.c
@@ -366,7 +366,7 @@ void mdp5_smp_dump(struct mdp5_smp *smp, struct drm_printer *p)
 
 			drm_printf(p, "%s:%d\t%d\t%s\n",
 				pipe2name(pipe), j, inuse,
-				plane ? plane->name : NULL);
+				plane ? plane->name : "(null)");
 
 			total += inuse;
 		}
-- 
2.43.0



