Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA67315D54;
	Sun,  7 Sep 2025 20:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277362; cv=none; b=Szg4eAf61pL3xxa75WDEhaqDD6x9NJ278/P2vm2fXc+FVTf4j5wYM9rNykyCuGoNRO/2kW2qxSdCQp/Se0wE93bLcUD2NRMTTAQqrjX6l3AHx8/DVmnOzahDt+wVZDjjbItw/D80tVK4y17G/9kRztA7VY4JlVPmvEXqGURqfoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277362; c=relaxed/simple;
	bh=hCGesd9M3tOlhljLjyjBbQkQimo6E4Gkqlj4siE7V4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j0pdSQuGkzSrqogJkfivJAo/GV4bcC2tlP6Ez1D7x5w3Juum0BWMtHfyZDRnRzD3sqPHO0uDx8d79oowPyy1I4+uSJoSU2tFEj1MBRGhrLGJlCW54RDFXGxtut28pzUWNEeR8k/vRaovzt6lYkuE/VkXOKoKswp+ZBNcqNSSOxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjKaZLie; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjKaZLie"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24903C4CEF0;
	Sun,  7 Sep 2025 20:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277362;
	bh=hCGesd9M3tOlhljLjyjBbQkQimo6E4Gkqlj4siE7V4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjKaZLieqbImhps2l3cUo+qAU5u2z5xgN1KQAUNar2sGkj2sTrR19SS4XTyGYOdzM
	 wnd+6kytKduW6VLmSnWZrMH82Qd59YGKMflWfTJtL6rknpuqRxjWyXTYPPg1MExPG8
	 W7EMrcubAlh7ODjovBKKDEXOs9pDkD8mv8FA2g9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Jiao <zhangjiao2@cmss.chinamobile.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/175] tools: gpio: remove the include directory on make clean
Date: Sun,  7 Sep 2025 21:59:21 +0200
Message-ID: <20250907195618.783948441@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit ed42d80f3bae89592fbb2ffaf8b6b2e720d53f6a ]

Remove the generated include directory when running make clean.

Fixes: 8674cea84dc6 ("tools/gpio: move to tools buildsystem")
Signed-off-by: Zhang Jiao <zhangjiao2@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20250903063621.2424-1-zhangjiao2@cmss.chinamobile.com
[Bartosz: add Fixes tag, improve the commit message]
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/gpio/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/gpio/Makefile b/tools/gpio/Makefile
index ed565eb52275f..342e056c8c665 100644
--- a/tools/gpio/Makefile
+++ b/tools/gpio/Makefile
@@ -77,7 +77,7 @@ $(OUTPUT)gpio-watch: $(GPIO_WATCH_IN)
 
 clean:
 	rm -f $(ALL_PROGRAMS)
-	rm -f $(OUTPUT)include/linux/gpio.h
+	rm -rf $(OUTPUT)include
 	find $(or $(OUTPUT),.) -name '*.o' -delete -o -name '\.*.d' -delete -o -name '\.*.cmd' -delete
 
 install: $(ALL_PROGRAMS)
-- 
2.51.0



