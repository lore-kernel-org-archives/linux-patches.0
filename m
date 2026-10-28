Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210527;
	b=0UHrs2zRxrdwVjrTk04SVPuhE4Ay9dt/Y57vX4NForzq+UdeBKiiBnj6cyIIYwNmMf6n
	 DW+StU19Rix/YLUeBnMWucGfdZAmWDdXP8HItejrdQ+YYQdrLxxuQ+3kCm9Y+9KiOwZ/N
	 WTSsY/qKJhsbl0fWG0oT8PiFCBj3TBlRK5IktmliRb9Hw3eIIE1cz/qLZguFH0B99NGiQ
	 oUskfal9bVlsASzf9CqwbP0njWCDqk6LtkDDbEXNOZD6j/szYH/cD0MPFgFWVNQH63hrx
	 WL9McsySkNxRYgFzPN5+11J/EKLL1O0cqGdXeg2Dz5ijD/du1tAbAaPs4BYVyaWhDaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3nVIh1QOfIM6jwNsnFLdmOzVtgG8ETSl0v8sgThJSVM=;
	b=ADUttI+ErN7PtIqYK0ODtnKmPWU6mTSWpM8qq50Nd9qnx9EKSMKoHuF6nIQjdYBSRSVT
	 u1qTPx49PI8yoGoEFwEnp4GPNXjSbCMNAi6W9+ZCWqY1f6s2tlAzdZq01hLCe7gzAA56F
	 a+e0ID/6Y3w1yd5UZzm6XknInWQcG/6dV9EivhQ7hWy87LArD184pgwT23NYrfHpaKsZn
	 g2uNdpJPMN+0OzFwiH0AHbZyLxyv4Q9vB+ThD5aB5wsUw5uzmOUsBdv37dtT25eg75HtF
	 E6EF5D7v8+u9gjyyNgxKREMRgU0yoQI5lX1IPDsPYUAlEAWpSH1um7QSYWjvKwM61xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFQTY70i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9B9606A31A;
	Wed, 28 Oct 2026 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CFQTY70i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21DD1F01829;
	Wed, 28 Oct 2026 18:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210526;
	bh=3nVIh1QOfIM6jwNsnFLdmOzVtgG8ETSl0v8sgThJSVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CFQTY70iispNtiigQBb8b2z8QX9QW57uVuA7OGnhQiRYVN46IWCRclGS5mdnmZ1Ud
	 QhnnS1fkU3ZagJma/WidlCLV1hhEQSvlkoxF4zthOed0NHFcAQUZAlDApQ4NSF/P5E
	 dTANK2Lf+TB5MH9+wtPb1ePZSEVhNW+WQO++NDT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Miroslav Benes <mbenes@suse.cz>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/571] kernel/params.c: Use kstrtobool() instead of strtobool()
Date: Wed, 28 Oct 2026 17:53:24 +0100
Message-ID: <20261028170009.380810155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit def7b92efd868a6c78da86770704c1a03506016e ]

strtobool() is the same as kstrtobool().
However, the latter is more used within the kernel.

In order to remove strtobool() and slightly simplify kstrtox.h, switch to
the other function name.

While at it, include the corresponding header file (<linux/kstrtox.h>)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Miroslav Benes <mbenes@suse.cz>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Stable-dep-of: 3dfaae04243c ("params: fix charp corruption on allocation failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/params.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/params.c b/kernel/params.c
index 1233673b42ecc..b904bd98dd01b 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -4,6 +4,7 @@
 
 */
 #include <linux/kernel.h>
+#include <linux/kstrtox.h>
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/module.h>
@@ -310,7 +311,7 @@ int param_set_bool(const char *val, const struct kernel_param *kp)
 	if (!val) val = "1";
 
 	/* One of =[yYnN01] */
-	return strtobool(val, kp->arg);
+	return kstrtobool(val, kp->arg);
 }
 EXPORT_SYMBOL(param_set_bool);
 
-- 
2.53.0



