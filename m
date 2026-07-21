Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECA4D38910F;
	Tue, 21 Jul 2026 18:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659602; cv=none; b=ib+XRyzKu8NVG/jofZfxPSOAbXmkXQ/CbwzOOX96SFMoyGva7/wP7RjeHwLDg9Yg4waJep/QzcNn086TCa6ZwPFa0An3Sr6IbkHbqtkavTewcjbusqZhvV5pbS2JkZKLvILlvtOl0sCiWtffU1r7SNr3onqYPkwCcQvROYD43r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659602; c=relaxed/simple;
	bh=qI4nxyc4ChhnAQrV7Sgr7bx+5ihhGdrC11S8Si5q6QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwb4Emo00zXafNilLsIFoHceV6xe9En/WQt9I51WxaSF9OHxCJdBJCiB0o/oW06WtExjs0Z/1FbpFyg4o9rvNfk7C+OjQLrwz+WTZ4CtbglLpp/wyR+lOQe2ScitqZOsqNjvJDxRHuvWKPySE0RoWESK4UZuexrY0/zba19g8lU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o49atV4R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o49atV4R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5841F000E9;
	Tue, 21 Jul 2026 18:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659600;
	bh=A1dm0oBbZ5FlEFdG34RjRcUZhdTa2Fz5IQ6/loVopPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o49atV4RAnPh36Deez0IxvreSBSjacy3caJKHrf+k9CalOHuR1Iu0L9qtP+T8toMC
	 Mx7oHv/kv7b7EJEwdmtny9TSd8sbbvPISB2B4tYPYlnKtdE0uCoEtqLCiodBYnRvnp
	 DRHrsOYxSgM+2bwalsFsD5a/zOIAiZQgo1XTl2Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1575/1611] usb: atm: ueagle-atm: use dev_dbg() for device found message
Date: Tue, 21 Jul 2026 17:28:11 +0200
Message-ID: <20260721152550.895433341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauricio Faria de Oliveira <mfo@igalia.com>

[ Upstream commit 05c5075c3115010f97434c53d353d9a0d4b0e64e ]

Convert dev_info() to dev_dbg().

Per 'Documentation/process/coding-style.rst':

  13) Printing kernel messages

  ...  When drivers are working properly they are quiet,
  so prefer to use dev_dbg/pr_debug unless something is wrong.

While in there, correct the verb form and add 'with' for clarity.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/all/2026051628-squatter-stature-c0e0@gregkh/
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260520-ueagle-atm-cleanup-v1-1-010c8bc7b214@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: e2674dfbed8a ("usb: atm: ueagle-atm: wait for pre-firmware load in .disconnect()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/atm/ueagle-atm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2589,7 +2589,7 @@ static int uea_probe(struct usb_interfac
 	int ret;
 
 	uea_enters(usb);
-	uea_info(usb, "ADSL device founded vid (%#X) pid (%#X) Rev (%#X): %s\n",
+	uea_dbg(usb, "ADSL device found with vid (%#X) pid (%#X) Rev (%#X): %s\n",
 		le16_to_cpu(usb->descriptor.idVendor),
 		le16_to_cpu(usb->descriptor.idProduct),
 		le16_to_cpu(usb->descriptor.bcdDevice),


