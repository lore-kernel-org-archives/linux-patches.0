Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041171;
	b=p0fKhYxOM8VTOikT+RY/TAuAjy50R6hNY6dInM6BcJWZwGUCuGs9TAA3NC3H/elROCw9
	 vVdM+S7YVuDDcQ4K0gL5HeMx+HdMjg9X3+JO+J0uCPqu+0mdyeKfv/JJywCHNYDtFa8QL
	 9dxIiVop6TXEYFQ8B5YFteTiBzdVZOpyEcKkyMdj8jPB3lJ7aJzeKAXp9k8sPIf2Y6nLY
	 5NYSUk+RcT+qWJCpjk9NZjr6/6asqGuaW918NbqDI5qycMQU+DhHXu3PU7JRobW79grFw
	 A0q5RFd40deNpXV5xsoCO3zNwIslwY6sp9RJqVRVG2J+oMM8/nXX6NX/2Yx/sHp0XFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NVSU9xxLZ+wmrKIpJ1yGgEViOkKZ6KtbBGOlomIXiuw=;
	b=0lvvizMD9+OeZlIrRXWHWqGjaYLJxRcKFK6bP5ryQCwaOTPsj1jAKKK55B3iRMHgoAl8
	 R83TzKAeU6qRnEDw6ILPSe6BGvVDsblMhOxWzx0yDl5tkdknIBiHheaUeZZCOQmAxCkSb
	 WZbs/YR39r2fiYeKF8sGMkzBiExnZR2SCfaxyy5fsj8NA96n3A9i2b9wliGr5kM+fF1Du
	 aP/iWBmcw52Km7aPl5KSFhxQrdndite4/VGjUb8spROEtKNxh2+jLD9KXdVHpef2bwHtG
	 4gi7hDynf7RUg2IY2xxVMd5xnyoNlFfz/XqmfsCXJ1Se4tEse+j+vSJGemf9uqcQlWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CYAd9eHY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4552606A31C;
	Wed, 18 Nov 2026 22:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CYAd9eHY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFECB1F000C4;
	Wed, 18 Nov 2026 22:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041171;
	bh=NVSU9xxLZ+wmrKIpJ1yGgEViOkKZ6KtbBGOlomIXiuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYAd9eHYoyAeVjfOi0BESJjpc5OyUWFbHp35yq1AOlgp5+I58NAqSwKDa8/oujR8O
	 +zdKvaOEEVJw8FF4fhs0Bh/pnluavmtoMoYjXa0/TnKceS+d9XbJdeSeW/jPjXM6Yn
	 CX1Lj108rTnWDojQTOjWdImFbU/AButZRnXSWr/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2677/3318] kobject: Fix the kobj_set_name reference in kset_register() kernel-doc
Date: Wed, 18 Nov 2026 15:54:59 +0100
Message-ID: <20261118150441.307626199@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3aac49b236c137fa77b97968d25338a28c49f0f8 ]

The kernel-doc comment of kset_register() refers to kobj_set_name, which
does not exist. The name is kobject_set_name. Say kobject_set_name.

Fixes: 1662cea4623f ("kset: fix memory leak when kset_register() returns error")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260911222029.7267-1-kmehltretter@gmail.com
[ Also drop the misplaced braces in "allocated by()". - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kobject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 72fa20f405f15..1d930092a3f44 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -851,7 +851,7 @@ EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
  * kset_register() - Initialize and add a kset.
  * @k: kset.
  *
- * NOTE: On error, the kset.kobj.name allocated by() kobj_set_name()
+ * NOTE: On error, the kset.kobj.name allocated by kobject_set_name()
  * is freed, it can not be used any more.
  */
 int kset_register(struct kset *k)
-- 
2.53.0



