Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615331CA8F;
	Mon,  1 Apr 2024 16:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987556; cv=none; b=RQQXmJqr1iDyVQs2SDeFIFFQyRzWi9c/jNhT75x8l+LIwh/l78+v43n3tEdceX/KNbIeKhxB8qTWZYfeh5vDY2QjPai6LZiF7PCB0xTnVFarugY5NWUfGuSyVpTnYnJ4Et0E7IMW9GFJCHHvVcHX98DzVIQBtp0ExVKY/7nUNHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987556; c=relaxed/simple;
	bh=3uSLwXPE+ie4Erd1ycRWXi/yq80cHJvgNRSAuHoHhtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CijgqlvnVkTT2Ofz7mYEKugaIPx5TV8ednIWr0xq/GYCMGbxR7pxgv/dLH3XD+ETnRAcygACRR7kbyQWm862KONiZjICbyMvR1HMZ1H/TSfMRI41V9i5D1w79zcT+XrO7GyQgwlfv8XgwhdFTHaKdGvzggqHIa41i433E7Og8Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yNj0FjOb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yNj0FjOb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C814AC433F1;
	Mon,  1 Apr 2024 16:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987556;
	bh=3uSLwXPE+ie4Erd1ycRWXi/yq80cHJvgNRSAuHoHhtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yNj0FjObO1Vl0DCeI0hpR1+Ykuj2BsncSVK44BgJGi+hagZhtaUSW4KEhWTaN9d48
	 QXjlWpTVggXPInqyMI6cKCSX+ewJH2mWZ3yIedhJqXpyll/tC3al+iMktg21o2LEJS
	 9dMQydsYim5URpwokk583+VLjmvBEMyZfylSBaGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Herve Codina <herve.codina@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.8 321/399] net: wan: framer: Add missing static inline qualifiers
Date: Mon,  1 Apr 2024 17:44:47 +0200
Message-ID: <20240401152558.763852494@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit ea2c09283b44d1a3732a195a9b257d56779c8863 upstream.

Compilation with CONFIG_GENERIC_FRAMER disabled lead to the following
warnings:
  framer.h:184:16: warning: no previous prototype for function 'framer_get' [-Wmissing-prototypes]
  184 | struct framer *framer_get(struct device *dev, const char *con_id)
  framer.h:184:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
  184 | struct framer *framer_get(struct device *dev, const char *con_id)
  framer.h:189:6: warning: no previous prototype for function 'framer_put' [-Wmissing-prototypes]
  189 | void framer_put(struct device *dev, struct framer *framer)
  framer.h:189:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
  189 | void framer_put(struct device *dev, struct framer *framer)

Add missing 'static inline' qualifiers for these functions.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202403241110.hfJqeJRu-lkp@intel.com/
Fixes: 82c944d05b1a ("net: wan: Add framer framework support")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/framer/framer.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/framer/framer.h
+++ b/include/linux/framer/framer.h
@@ -181,12 +181,12 @@ static inline int framer_notifier_unregi
 	return -ENOSYS;
 }
 
-struct framer *framer_get(struct device *dev, const char *con_id)
+static inline struct framer *framer_get(struct device *dev, const char *con_id)
 {
 	return ERR_PTR(-ENOSYS);
 }
 
-void framer_put(struct device *dev, struct framer *framer)
+static inline void framer_put(struct device *dev, struct framer *framer)
 {
 }
 


