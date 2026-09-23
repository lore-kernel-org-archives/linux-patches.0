Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5C632B125;
	Wed, 23 Sep 2026 14:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172933; cv=none; b=cImtk4FpIx90oiLieHi32eDt5anDqdGJCpwDuDIolEHpdW2hyy5fGE6ke7JAEvZ4EnpNhf7ViAufujFGfmJ/MBCm9YN0whY8dxxazQdpfxzNHuacKgGL5dzaEGwYxC+9CSbBTsdft6If0m76lrawB736fkXOmZZ0fvjiicKXQf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172933; c=relaxed/simple;
	bh=PasXGBlWVhHflBA+JRZlojgjk4clj5Gz3k5mWRljBRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLExji4wt832EqAqF/KNc0cQO31UCFyAJKD8uRg9uNWEOUML/1QHURv3VW04SYmeV94mOolYjvjLn1ZXJ+Diq6Pb4ac9LvgTj4tlYI1zgyd7JmjFCn1SLMu0iRNxvvyb9Xagw6glrSretejFTZVRAxzEyzpQrca8QJB3cqBzNoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W4HnPwOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W4HnPwOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2DDA1F000FF;
	Wed, 23 Sep 2026 14:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172931;
	bh=QOFQvYgUJwDxadyzsLck2Y1vV41TZRVaXHVXlVhz+to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W4HnPwOnYQjSH9nTg3dk/LVc/5GE2kQIIRAuhujBjVTZ/z0rC4KX7RkrzIVftkMDC
	 iu5QoCdAvsBAK42tKINOiqLNbvXJhbjv837fzpTgk/Id1K5JSsbXuLeUemSkZ1Ni3h
	 j3JTx4XHAEncmTqNCDgcWCzTX7pi4tHDcJ424dG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 103/438] drm/msm/adreno: Fix the skip_gpu parameter description
Date: Wed, 23 Sep 2026 16:02:04 +0200
Message-ID: <20260923140647.449021126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 8061ee61b9426fe38350fa9eead2d9c50b03deb6 ]

The module parameter is skip_gpu, but its MODULE_PARM_DESC() names
no_gpu, so modinfo describes a parameter that does not exist and shows
no description for the real one.

Use the parameter name in the description.

Fixes: 3f17991488af ("drm/msm/adreno: Add a modparam to skip GPU")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/751406/
Message-ID: <20260906170301.2393-1-kmehltretter@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_device.c b/drivers/gpu/drm/msm/adreno/adreno_device.c
index 7f20320ef66af..05c77fe27e620 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_device.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_device.c
@@ -25,7 +25,7 @@ MODULE_PARM_DESC(disable_acd, "Forcefully disable GPU ACD");
 module_param_unsafe(disable_acd, bool, 0400);
 
 static bool skip_gpu;
-MODULE_PARM_DESC(no_gpu, "Disable GPU driver register (0=enable GPU driver register (default), 1=skip GPU driver register");
+MODULE_PARM_DESC(skip_gpu, "Disable GPU driver register (0=enable GPU driver register (default), 1=skip GPU driver register");
 module_param(skip_gpu, bool, 0400);
 
 extern const struct adreno_gpulist a2xx_gpulist;
-- 
2.53.0



