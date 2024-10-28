Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8D48837;
	Mon, 28 Oct 2024 06:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098339; cv=none; b=R/S5C9LUhZYMelyJsrqCyTlw1ffyDCSGt2Pth/Yx4wBdoIl9qsC14X3ARwEWomr0S5HhFwmVKWazhwMVoGCM6gUaOyu/ceDN64XcXH0wLclCrBn4cJCzBaA7V+bUjCkCWcNhEkuLWU3cbM7T9vosrqlOXym3XQ2o71tDISya14E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098339; c=relaxed/simple;
	bh=llnBL7wGVJe8Cz3QcdLSXCOQDv9MdVpBmjB7X4/JZcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TDd4ZdHuL9uk45UZuJ/7aTghNbX1rHNkj5jtu7TJxWfPRa8zk3DnApAXjUNbCaGt5VGGFbxQClw//bL9M6R0X+fZbq/aHLP9F+WsZJFm2aU2FJXPDqGgZvHdp4K6XW/ihYo6WoLpKsqsM+iqNYrwEP+GrUA2Kk44HadP9rg6tLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECmo39e7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECmo39e7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2684C4CEC3;
	Mon, 28 Oct 2024 06:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098339;
	bh=llnBL7wGVJe8Cz3QcdLSXCOQDv9MdVpBmjB7X4/JZcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ECmo39e7COdW4VOuz7UYKNIh0jLIFG4gxcFL9NUnb2375gp+WUfQJ/bVi6D+nI+Nw
	 3JxYd+x4QLo3n6F6/lyYFuRJdKThS/hfcffZQ4PRHCVsaFzKfCT5esrkDxqF2cSq9S
	 reLvVL0DoGp2PwKqk1pQtuhSIbRe+wbReRP2VmJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 184/261] ASoC: topology: Bump minimal topology ABI version
Date: Mon, 28 Oct 2024 07:25:26 +0100
Message-ID: <20241028062316.620096146@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 9eb2142a2ae8c8fdfce2aaa4c110f5a6f6b0b56e ]

When v4 topology support was removed, minimal topology ABI version
should have been bumped.

Fixes: fe4a07454256 ("ASoC: Drop soc-topology ABI v4 support")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://patch.msgid.link/20241009081230.304918-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/sound/asoc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/sound/asoc.h b/include/uapi/sound/asoc.h
index 99333cbd3114e..c117672d44394 100644
--- a/include/uapi/sound/asoc.h
+++ b/include/uapi/sound/asoc.h
@@ -88,7 +88,7 @@
 
 /* ABI version */
 #define SND_SOC_TPLG_ABI_VERSION	0x5	/* current version */
-#define SND_SOC_TPLG_ABI_VERSION_MIN	0x4	/* oldest version supported */
+#define SND_SOC_TPLG_ABI_VERSION_MIN	0x5	/* oldest version supported */
 
 /* Max size of TLV data */
 #define SND_SOC_TPLG_TLV_SIZE		32
-- 
2.43.0



