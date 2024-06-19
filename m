Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB132AD58;
	Wed, 19 Jun 2024 13:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802998; cv=none; b=jOR6fvZWdzOt7oC5Jh0OxPwx7DA+bM0BKLHsz60gKeUcklmcIpacSyEpByqQXWOjVLBRVFpLlrQL3y2e9s2Z1+KJYWPU3qxk9wu54FBUWh7luxofZ3dw/kOEvMfUif5pLbBu1tpOAinjeN7gJMx+Br+nd1odQuOr6Y+63OrPMwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802998; c=relaxed/simple;
	bh=NB6pQCHZbchV5M5+VgVEHk415t0PLuSZhPhgAQzw07s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qic75jgneBqRoSAvFOjc84CMQhlz+c1qy9gDSHhOOE8UBC0ySnwxvQleJy9gS2PHGainFPAQI25+7TiMG07ABGKdoOE8eP5VwgqU+vI9f6RZvJhwsXxcSg6Qp8kmz0/xoc5Y3yNE1PrrItcP4IpJT6igv2UPJ9PBetojas3OFTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iAz5+TO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iAz5+TO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62941C2BBFC;
	Wed, 19 Jun 2024 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802998;
	bh=NB6pQCHZbchV5M5+VgVEHk415t0PLuSZhPhgAQzw07s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAz5+TO6CYxIm7AXyGnUVvVCa0tgxXPKn1G1+7e2kf2/90lIYSys59b5jzHn9AEYq
	 EGBqR5r7Tg0QiGP3yOpvSNbtCS5zVMYjjHLeUdpGHOjkqkwv+dFrQ5W4/9nEBW9/MM
	 IY5FtNZl1NkbSGpUdRIOeR3CkHvgf5gljD5jxy6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 119/281] kselftest/alsa: Ensure _GNU_SOURCE is defined
Date: Wed, 19 Jun 2024 14:54:38 +0200
Message-ID: <20240619125614.425610756@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 2032e61e24fe9fe55d6c7a34fb5506c911b3e280 ]

The pcmtest driver tests use the kselftest harness which requires that
_GNU_SOURCE is defined but nothing causes it to be defined.  Since the
KHDR_INCLUDES Makefile variable has had the required define added let's
use that, this should provide some futureproofing.

Fixes: daef47b89efd ("selftests: Compile kselftest headers with -D_GNU_SOURCE")
Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/alsa/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/alsa/Makefile b/tools/testing/selftests/alsa/Makefile
index 5af9ba8a4645b..c1ce39874e2b5 100644
--- a/tools/testing/selftests/alsa/Makefile
+++ b/tools/testing/selftests/alsa/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 
-CFLAGS += $(shell pkg-config --cflags alsa)
+CFLAGS += $(shell pkg-config --cflags alsa) $(KHDR_INCLUDES)
 LDLIBS += $(shell pkg-config --libs alsa)
 ifeq ($(LDLIBS),)
 LDLIBS += -lasound
-- 
2.43.0



