Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D0053365;
	Thu, 12 Dec 2024 17:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023133; cv=none; b=QqM3A8mlY1Bgv6tHGp000PYsaFVr+pjxTqeOqv4AD8RuBfkyW4BsKW2WkIdyWdp+3UETvPytYpjMdPywbL9gB17luP8F+56Tesl1s4C1y9MiaLmCwKmkGjXjkv7k6eDzQT2Hh7ER2stfc30uWhZSScyiJvwL6QTZuJAuRAkx31o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023133; c=relaxed/simple;
	bh=upcIhJYceZKRwOyEyllusoaKePEh0EaGJ0ueVoiqDBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqDfMQ71afLYaWJncsNkvokd3L+uoWmyIdSLRJ4ZAyIHE9AuC0lhWDyt7+96vKNHJFihdJdz7MeKK5OL4UGfRTw+JdaN1kgBZUQYVY82NlVTvocWGKM6GfpdlZfq/siacdc4onFmAgjPi3YzAIoA7fLGfcAHI7j78sWdV/wg7Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PMpnYZHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PMpnYZHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD4AC4CECE;
	Thu, 12 Dec 2024 17:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023133;
	bh=upcIhJYceZKRwOyEyllusoaKePEh0EaGJ0ueVoiqDBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PMpnYZHLpj4wHM2pzKX2Vu35+u7k4ZvPhIv9uY732yD++zVlHZyCDvytkbg30NUck
	 xO67+53t2Yis23KaC3IaZUcbf0O2mKXnLD8mmjMJtsruDjTQIdqKiYEDeyuYWVvzzP
	 iWOCijnIiVVsF/FAO6bkAvIzi+/YUuSo6vKCy/PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Raphael Gallais-Pou <rgallaispou@gmail.com>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 434/565] drm/sti: Add __iomem for mixer_dbg_mxns parameter
Date: Thu, 12 Dec 2024 16:00:29 +0100
Message-ID: <20241212144328.839523078@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 86e8f94789dd6f3e705bfa821e1e416f97a2f863 ]

Sparse complains about incorrect type in argument 1.
expected void const volatile  __iomem *ptr but got void *.
so modify mixer_dbg_mxn's addr parameter.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411191809.6V3c826r-lkp@intel.com/
Fixes: a5f81078a56c ("drm/sti: add debugfs entries for MIXER crtc")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Acked-by: Raphael Gallais-Pou <rgallaispou@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/c28f0dcb6a4526721d83ba1f659bba30564d3d54.1732087094.git.xiaopei01@kylinos.cn
Signed-off-by: Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sti/sti_mixer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/sti/sti_mixer.c b/drivers/gpu/drm/sti/sti_mixer.c
index 7e5f14646625b..06c1b81912f79 100644
--- a/drivers/gpu/drm/sti/sti_mixer.c
+++ b/drivers/gpu/drm/sti/sti_mixer.c
@@ -137,7 +137,7 @@ static void mixer_dbg_crb(struct seq_file *s, int val)
 	}
 }
 
-static void mixer_dbg_mxn(struct seq_file *s, void *addr)
+static void mixer_dbg_mxn(struct seq_file *s, void __iomem *addr)
 {
 	int i;
 
-- 
2.43.0



