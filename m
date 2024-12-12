Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA0C6F2FE;
	Thu, 12 Dec 2024 15:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018726; cv=none; b=W+kpG+wgN6wXf/fEEjbgKJ5tUN55JcMA/rNOPtjoQ9+0D0JjI1/tybNNxDoDNumkDe1kH6ca77pG1u0qKIwqPuW5y7LvfVyDtC40ZVN/ywE6lENNysvDMzzRnVib0Uh3NxP/nd26hML4T8a8pPyDPszJCjpk5LT+VAxvTzjGTVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018726; c=relaxed/simple;
	bh=6H0V/FtE+Ry9z8K+c/ijhKCj2mYZhqenoeuriYDwn20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wl0lhR+aZB+x4RNiYPZ6YoknaVX+eZBI0VtSed1V3IqjpV9+B4zdzP5ThpdD2IKYEhZdSuJsAkRK4EqBNQkGR8ytVMkJLygQYJRoWVJbysWSrchAHXsiFzJgsUyysfK5Z2YKGqG0u8YILz09EoN/vhbu47dn6BWWalw9JRAWc8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WX7Oubox; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WX7Oubox"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45933C4CEE0;
	Thu, 12 Dec 2024 15:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018726;
	bh=6H0V/FtE+Ry9z8K+c/ijhKCj2mYZhqenoeuriYDwn20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WX7OuboxnOAKWSZoousAYDx+bReuSxa2nNStzxbsGbmHy26ajqFBqAE5vz1kEbBDb
	 7kWgHvrFE9BqLebLY0eaGvw3ijxoWJ3mYifoFYbuhyI9aM0BuQBOXkhNJVV6YJSr+e
	 yUGBmrPfkjX15ZzurZkmvIjJrmvyjXjHH8IuKBbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zhang jiao <zhangjiao2@cmss.chinamobile.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/772] tools/lib/thermal: Remove the thermal.h soft link when doing make clean
Date: Thu, 12 Dec 2024 15:49:21 +0100
Message-ID: <20241212144350.617048722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: zhang jiao <zhangjiao2@cmss.chinamobile.com>

[ Upstream commit c5426dcc5a3a064bbd2de383e29035a14fe933e0 ]

Run "make -C tools thermal" can create a soft link for thermal.h in
tools/include/uapi/linux.  Just rm it when make clean.

Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>
Link: https://lore.kernel.org/r/20240912045031.18426-1-zhangjiao2@cmss.chinamobile.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/thermal/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/lib/thermal/Makefile b/tools/lib/thermal/Makefile
index 2d0d255fd0e1c..8890fd57b110c 100644
--- a/tools/lib/thermal/Makefile
+++ b/tools/lib/thermal/Makefile
@@ -121,7 +121,9 @@ all: fixdep
 
 clean:
 	$(call QUIET_CLEAN, libthermal) $(RM) $(LIBTHERMAL_A) \
-                *.o *~ *.a *.so *.so.$(VERSION) *.so.$(LIBTHERMAL_VERSION) .*.d .*.cmd LIBTHERMAL-CFLAGS $(LIBTHERMAL_PC)
+                *.o *~ *.a *.so *.so.$(VERSION) *.so.$(LIBTHERMAL_VERSION) \
+                .*.d .*.cmd LIBTHERMAL-CFLAGS $(LIBTHERMAL_PC) \
+                $(srctree)/tools/$(THERMAL_UAPI)
 
 $(LIBTHERMAL_PC):
 	$(QUIET_GEN)sed -e "s|@PREFIX@|$(prefix)|" \
-- 
2.43.0



