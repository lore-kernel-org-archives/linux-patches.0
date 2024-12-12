Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03A96213E6F;
	Thu, 12 Dec 2024 17:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024700; cv=none; b=itUODtERjWeC4JSv3d7dfgaADxX/ji5kKiEonkKucuK0NYRXIv2fSa99uw3r97HZmqia7cBmjR+Kd/s4McuJFFHJa6a5RTDiD5dyQ6b7D5lgx8NxHJRGj+QkBNpPvfivO1YI3La9ZkL9UHCKS4LceOPFAsO81RfqK98+s0E2HEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024700; c=relaxed/simple;
	bh=g8K2gioxYmzVSFX+OSRWK50wJlWT8C6VCQnm6t0bSVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/QrLc07i613xdMGEbgQpUDkVGMX5Eg/pY5gJwF2rASIGbZAJsnjpf2eB0dTVf8ePSnMQhE3M9msH8fZQWbLI0ceXbJ/27uOp8XYnbvPHhYHj/+HM8z7sj9rRSR0huRNqjx6By+2R5UXrlkxP2vOqDCBySYgNxERJotlMYlWsRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZcdvN6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZcdvN6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7599EC4CECE;
	Thu, 12 Dec 2024 17:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024699;
	bh=g8K2gioxYmzVSFX+OSRWK50wJlWT8C6VCQnm6t0bSVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZcdvN6wbtYsh7JRzxZql32x47ZfP3Cblz5i3P/b1JaNRBQ8Oe3ihxhGFAt/13yW1
	 iNspdMlY+RTnbvlIiyZxC1Jy1tv0GnbPDNbNEsh+Gi/B1DJSXBmhe+55yQZZT6VjrP
	 8T0dFIJXVnbe0N12GV79ZBlRBHmVDrnhPmnf3SHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Raphael Gallais-Pou <rgallaispou@gmail.com>,
	Raphael Gallais-Pou <raphael.gallais-pou@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 353/459] drm/sti: Add __iomem for mixer_dbg_mxns parameter
Date: Thu, 12 Dec 2024 16:01:31 +0100
Message-ID: <20241212144307.601131585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



