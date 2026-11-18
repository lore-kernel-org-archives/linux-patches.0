Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019405;
	b=vKrDVElAEBW9L9GgAcn+XRTWxpNSvgPCuiBMK8BfCZxWQKd/n1kptG077Uwy7sd7wipJ
	 sACVID7EfOE6yJitdBuSd1Z8OlgRfc9ffev0IDvm9iYzvUloXxlev+llOzTxbkdWn88FK
	 IXevoljbRSHJsYLlKEbnpY8rVQugicrxwgMt65ZLcejiqYz+4R5Cm4llz6txL69SJQ6q1
	 ku2H0I2OJEPKHa7HrlnkmUQT6F9Jty242M287jYDonS7WxJIgo7tSzS8svPtXQX6g1jJ/
	 Y7TeN7r34Sq4T8xbepevTeIASE13heG+ESma8wWD47M0oFXLtkK3xHzp6UnSE+/zKdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019405;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Id75PH1jnOcx55i/fjVKhvF/ndodjuk8huTWdNSAIkE=;
	b=orqvxKxF5P/SyH6NkUynb84LZ/zPP75DZMdj9tBanfppKaDzh9hUIs8HukRCSUcLrZSj
	 fnDpWRXpsKLxP/w44h6RMVZ/dQYSFCYiLGEo91hHoPaWQFMS37UWvIhlCUxoBU9jUR9iM
	 U/7P+m8KsqDdkarHdzkTxem70GYS3qWyqS8MwIBzeHtY/tsr8jUxZKr+LR8WNsGFXFK/v
	 4OaEtpoluGQ7lw0KAM767wnXRJ+ZOIyx4gMXKiPmCikhcDbANjpVcU0/g9PWZowoXdHjg
	 xXfnByuMI0dP6to781cyTKx+jwG7MsOS9nxdn/War72RSP0lLWP5pstXrfz7PId9dag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKyN2pvX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DCA960A5BCF;
	Wed, 18 Nov 2026 16:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKyN2pvX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018421F000CB;
	Wed, 18 Nov 2026 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019405;
	bh=Id75PH1jnOcx55i/fjVKhvF/ndodjuk8huTWdNSAIkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKyN2pvXkZnvpjZMmq0gk/rOWGOSYWkGarDEJYcivM1OrDOIwHNGb2+okTdoacxAB
	 GJWU3kBdQMuhdbWFqvjsdp0nuAlVgkG1LhMiQ/XNs08XV6FHWDkgfCQ3h1EnLUgRYP
	 ImXSmIf35hHpgtZRMjLBKZeD7ASUiiZdUtm79cGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1585/2651] cxl/pci: Update only the Port GPF timeout fields
Date: Wed, 18 Nov 2026 15:47:05 +0100
Message-ID: <20261118150344.980812111@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit b5d14009bdb1973d54a6ea111a660b3dae115be5 ]

update_gpf_port_dvsec() rebuilds the phase control register from just
the timeout base and scale, so the rest of the register is cleared by
the write. The other bits are reserved today and nothing is lost, but
the full-register rewrite would clobber any field the spec defines
there later.

Read-modify-write the register and change only the two timeout
fields.

Fixes: a52b6a2c1c99 ("cxl/pci: Support Global Persistent Flush (GPF)")
Assisted-by: LLM
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Link: https://patch.msgid.link/20261008034619.28059-4-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index 27dccd4daa0ce..125abb36df7f1 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -855,8 +855,8 @@ static int update_gpf_port_dvsec(struct pci_dev *pdev, int dvsec, int phase)
 	    FIELD_GET(scale, ctrl) == GPF_TIMEOUT_SCALE_MAX)
 		return 0;
 
-	ctrl = FIELD_PREP(base, GPF_TIMEOUT_BASE_MAX);
-	ctrl |= FIELD_PREP(scale, GPF_TIMEOUT_SCALE_MAX);
+	FIELD_MODIFY(base, &ctrl, GPF_TIMEOUT_BASE_MAX);
+	FIELD_MODIFY(scale, &ctrl, GPF_TIMEOUT_SCALE_MAX);
 
 	rc = pci_write_config_word(pdev, dvsec + offset, ctrl);
 	if (rc) {
-- 
2.53.0



