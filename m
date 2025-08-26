Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7366F352084;
	Tue, 26 Aug 2025 14:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219183; cv=none; b=jD3VtIVvdUPMfUOmVWraO8ocglfxEzfI5EbOxjm6AGv26bsn6eCe3wfl/5Z2D2+E174+SnCfHWqs3pO3DRrrSfE/sJv0MVy7LcZSTB6S/wZ43Ald5z/V1j2Cw4uJyFe4nxMgYO9rP6nv2mF3TpaJ0AbFUgnc1LbCVALt3PaskfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219183; c=relaxed/simple;
	bh=Lm4nrumM6k+eVJ3wjg9szAdJj5gPE1+j1gIsIb40tro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FOwGbLo6NM9uXab0902+9rzAvS3nSptmlEDZ7pYgLkm/U0wMxJKMVWIHGmr5XpQMATKjZa6sTZMzrMLtbqFTsx9zdPiTqgrStm2zeRVAUwbmObe+ar+QjrMAynuqLkOmmo5rLxECS9ftkGW2fIsIVqkF/KY9FemO0uO0gr/s59k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jZmEuEHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jZmEuEHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9822FC4CEF1;
	Tue, 26 Aug 2025 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219182;
	bh=Lm4nrumM6k+eVJ3wjg9szAdJj5gPE1+j1gIsIb40tro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jZmEuEHC+1ifzMCl0D9x4lgQO95I0hvNyHWjpYt0A9RijjIYtuWHjBwKa31hO/dSs
	 jkVwVlJteVcFg9+yOP0U94Yxtx0xDKADg/jR5Ah2KFjZfTjBvIFYPKUCIO501GtydO
	 7QaS7CgqyPFoZ2fsl2fjd7eQhzwDfhQukZjxpEHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Wolfram Sang <wsa+renesas@sang-engineering.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 254/403] i3c: add missing include to internal header
Date: Tue, 26 Aug 2025 13:09:40 +0200
Message-ID: <20250826110913.840670594@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

[ Upstream commit 3b661ca549b9e5bb11d0bc97ada6110aac3282d2 ]

LKP found a random config which failed to build because IO accessors
were not defined:

   In file included from drivers/i3c/master.c:21:
   drivers/i3c/internals.h: In function 'i3c_writel_fifo':
>> drivers/i3c/internals.h:35:9: error: implicit declaration of function 'writesl' [-Werror=implicit-function-declaration]

Add the proper header to where the IO accessors are used.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202507150208.BZDzzJ5E-lkp@intel.com/
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20250717120046.9022-2-wsa+renesas@sang-engineering.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/internals.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i3c/internals.h b/drivers/i3c/internals.h
index 86b7b44cfca2..1906c711f38a 100644
--- a/drivers/i3c/internals.h
+++ b/drivers/i3c/internals.h
@@ -9,6 +9,7 @@
 #define I3C_INTERNALS_H
 
 #include <linux/i3c/master.h>
+#include <linux/io.h>
 
 extern struct bus_type i3c_bus_type;
 
-- 
2.39.5



