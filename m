Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036240;
	b=Gf73MdrwidcuGUxNd5VV0WKHoCPvzjQQpnpTGro/bkmJQsRbFAgheTi6Qo/VMChjuKhh
	 ydFocZGh2RGxtIgD+mroEoiWuVcbpa9thK1xZAeWatD0jVTgBaUJ9ALiBtLMCCUqWV0b6
	 TSolMQM4zEtYVp9zrdQ+NCbd0C+k5NTFncFJEKLoNSE20Ubi87g1smeOWVS6SVO3596Yq
	 KBPRzOyafHPhrdCRihIi+aKz9dXuZfYc+GS55Q/r0I7BIlU9HvBQGMsfrW3+L4e+M/g5a
	 AzJEXmaHvYYDyLTJAMiVBYIbbASRp/AuPpYAIO+PVoXBJtqLEtDS/4C98zKyn5qluYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=26fpIqUKznk996z9ZxpNztKL1Goj2g065KB+IbywM6M=;
	b=M2TMj/DodTXaQlKj+Xh/nQIQPzF+wPoHCtRJOMSFdPEBhI8pihS+2bJnkojZ9n+8xP0g
	 JPTSU4usLQsi9IIN7RSjZn9UmXcoEh78JZxciiCuQu8dijTz1PlqB/PoT2W5vMHCYLoQH
	 r1Ld8htA8yIU/UueuDmvxF0MSWBly/EserZJnGX8DnE0RB0/JUlJcR2mbm2KRHvgLHIh+
	 arkbA+MHyWVWcl8oRCUmdBOk5Tr07zuEFyhcD8JFYbToxKpQQVHTWxdgoTQYVMllmkG8R
	 K3qcSjP4w66OOWIobSAuIkZ7uGGfBv3l05v7tPncXwJ7kwBe+e5ZO7GrdWUXChJC/7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ANdD25Vc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924F4606A320;
	Wed, 18 Nov 2026 21:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ANdD25Vc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2331F000C4;
	Wed, 18 Nov 2026 21:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036240;
	bh=26fpIqUKznk996z9ZxpNztKL1Goj2g065KB+IbywM6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ANdD25Vcvi6fGZw+uEh5OK+QIp6iIAnYgSDL/4NxyiE16nm3D3VlpYo2tAXo1b2NG
	 m7DTlV3wI2dGO9wx9ZBzftQpm9ONKirVQCCvXauLSCAIEq5hejB9/FFC6Ck87CCSmw
	 rUSFBTSYfxou1uBD+JegUq4DDQXKB3tpZGeUIoA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0989/3318] hwrng: core - reject unknown RNG names
Date: Wed, 18 Nov 2026 15:26:51 +0100
Message-ID: <20261118150349.466907472@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 7e7be8815143751c20260f80cb4e7fe14dd24b74 ]

In rng_current_store(), err is 0 after successfully locking rng_mutex,
and if the requested RNG name cannot be found, the function reports
success even though the current RNG was not changed.

Set err = -ENODEV before searching the RNG list to reject unknown names.

Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index e3e730dc64c42..44617f51e5655 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -386,6 +386,7 @@ static ssize_t rng_current_store(struct device *dev,
 	if (sysfs_streq(buf, "")) {
 		err = enable_best_rng();
 	} else {
+		err = -ENODEV;
 		list_for_each_entry(rng, &rng_list, list) {
 			if (sysfs_streq(rng->name, buf)) {
 				err = set_current_rng(rng);
-- 
2.53.0



