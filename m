Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E181DF27F;
	Tue, 12 Aug 2025 18:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023342; cv=none; b=KLdumLJECzqMM8E2c1dlrf6Qvte6/al9HRy+UVe+/MDsjshTiVUgfyco/S9jZ3+kYeZfcfxZtfHS7t5+K8sJZw0gSs2RPZ8oVG/scm2++1in3kbLMvJ4tTU98OpYjoaroB9c/qD/CopqpL0ocdu9ugnZAeG6MpzmZG1AiPTT46Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023342; c=relaxed/simple;
	bh=B0T4SU7bpoCbetXSM6YQymEBIYcNR5fI1l//+8+FpiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ro8am/GR5HOPGsf4vgqQ1plSgpDkajv0d1UWJtE43Ajw78e7IKWAsaDuxFfXQIpcvErQQePhhbtiBYMQ7xxAwWV1wFgKRKr6LvlsunZwSEjzRo1wkm3qZsxq4TymGxH44/WCzJaqC+yFJKYj1MI0vTVHdxIeaKEbcd9rnXZ5FDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBAJ3DYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBAJ3DYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D72C4CEF7;
	Tue, 12 Aug 2025 18:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023341;
	bh=B0T4SU7bpoCbetXSM6YQymEBIYcNR5fI1l//+8+FpiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBAJ3DYMftsHJ0+IUxqjLQ+VS01HwC3rJ8StBQLaQCrolR+2W8w2SiQ3oQ8ta7MhE
	 jAJ5sU1X1MdHud+EfZgB63cv/mNhbc5N41DfaspaXB/+HCbuQuj903PmnZFayO9pnO
	 INxqU3inl+CyjPSMHHFjM1x6vPM0DLYzKqqdm+2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Seungjin Bae <eeodqql09@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 051/627] usb: host: xhci-plat: fix incorrect type for of_match variable in xhci_plat_probe()
Date: Tue, 12 Aug 2025 19:25:46 +0200
Message-ID: <20250812173421.272769714@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seungjin Bae <eeodqql09@gmail.com>

[ Upstream commit d9e496a9fb4021a9e6b11e7ba221a41a2597ac27 ]

The variable `of_match` was incorrectly declared as a `bool`.
It is assigned the return value of of_match_device(), which is a pointer of
type `const struct of_device_id *`.

Fixes: 16b7e0cccb243 ("USB: xhci-plat: fix legacy PHY double init")
Signed-off-by: Seungjin Bae <eeodqql09@gmail.com>
Link: https://lore.kernel.org/r/20250619055746.176112-2-eeodqql09@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-plat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index c79d5ed48a08..5eb51797de32 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -152,7 +152,7 @@ int xhci_plat_probe(struct platform_device *pdev, struct device *sysdev, const s
 	int			ret;
 	int			irq;
 	struct xhci_plat_priv	*priv = NULL;
-	bool			of_match;
+	const struct of_device_id *of_match;
 
 	if (usb_disabled())
 		return -ENODEV;
-- 
2.39.5



