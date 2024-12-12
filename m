Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BDD2135C1;
	Thu, 12 Dec 2024 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017774; cv=none; b=spx2TqxQvPJzZVAY3aGpfgmsLEKespCZNJoUMy14+k/Xd4c9D8XUaCQ5B70zQuQ3qPy3xsx3HJv8Bnyd7zHvFEX11GZqqhREnyixaAC2y3K2eddE6N2Uj4YCTTGF6bzzbhCerK2Nb9u+sBb5NbkfHgvqw2GCb95kkbUW9YEN5j4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017774; c=relaxed/simple;
	bh=R1JwQa48P5Ros2NoJz45zA876NHi3NixWZjbdvAwhjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MozBxc8eD2PpX9b0egTubHKBxhh37BA16EPrOr5t4QAGWhaxRovC5/oo2PXl0D558fYsDI54pWXFfzavbI54mxazoTacHzKkrQ8uMdrQTLqf3yUySvML2H2tG4MTxYc7Ko/hrZdlKOZ8wOQ6VN8jXdpgx+OtgkEwK5pBs6zs6kE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1SFfb4b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1SFfb4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70722C4CECE;
	Thu, 12 Dec 2024 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017773;
	bh=R1JwQa48P5Ros2NoJz45zA876NHi3NixWZjbdvAwhjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1SFfb4bVdT7CyqBHs6Rj4wjyVtz/3YTDLoMUCHKT6SoG0ooOA8/J8IMaETaHHvyo
	 pwjkj4pbFh0iepgtkUB/3gJOA6ESpPC+Dr7akCK419n+yPcxbpxAYc4BCHll0Jqt5C
	 6/5qQQoU98kb7eiUvFaIMYYVUx3TQzm028Wfgb4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuro Chung <kuro.chung@ite.com.tw>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/356] drm/bridge: it6505: update usleep_range for RC circuit charge time
Date: Thu, 12 Dec 2024 15:57:06 +0100
Message-ID: <20241212144248.864041387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuro Chung <kuro.chung@ite.com.tw>

[ Upstream commit 8814444e62b8a8b573fba2cbbb327d5817b74eb0 ]

The spec of timing between IVDD/OVDD and SYSRTEN is 10ms, but SYSRSTN RC
circuit need at least 25ms for rising time, update for match spec

Signed-off-by: Kuro Chung <kuro.chung@ite.com.tw>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240604024405.1122488-1-kuro.chung@ite.com.tw
Stable-dep-of: c5f3f21728b0 ("drm/bridge: it6505: Fix inverted reset polarity")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 93eb8fba23d42..fda2c565fdb31 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -2614,7 +2614,7 @@ static int it6505_poweron(struct it6505 *it6505)
 		gpiod_set_value_cansleep(pdata->gpiod_reset, 0);
 		usleep_range(1000, 2000);
 		gpiod_set_value_cansleep(pdata->gpiod_reset, 1);
-		usleep_range(10000, 20000);
+		usleep_range(25000, 35000);
 	}
 
 	it6505->powered = true;
-- 
2.43.0



