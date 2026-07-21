Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0AE946D091;
	Tue, 21 Jul 2026 17:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655392; cv=none; b=JKqqUuDAvfYWhSf8VkK4h0TxgQBckjEn0kjZmkoJ/h+TiQIkdzEBKkdhztUSWeXrP0FVQjKyAoX/HldhdZSv8E7MToFOL48T+ojT+Um8FnVUqJu+gxJQ9aRzp/u2/gPFSEYbvJ0vX96elAXB0P1N+O2hOLjCPmhpM5Jnx37b1m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655392; c=relaxed/simple;
	bh=B1rcSe88eSb6SEHPDdyuUGEvBnnB9MEmgCP9PJ/Xqmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEbF2nY983B/4U8F9m/eGNtn3uOZOGFyoi2qEhswBQSje3YIGxEiUVPtS6smgrKKf0YozPXcNd+PlXeR3V//IOvkAVZ9ylTrKCbJ6OoNG2gop+mQ5yymAVcz/X5Xh49b19cXMKWVWbDneUpTnfCBtBRRdPUy8L2nDN1f74lPg5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLps9nYl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLps9nYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C291F000E9;
	Tue, 21 Jul 2026 17:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655390;
	bh=xG6a/9XSt4s5gIhMfRUMXa65+PyFIqHzg4SvLJ/qr/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLps9nYlnZjhrBks6M95WqC4+e24PzSNAjaFo35vLYXhyPkB82FL7rvWS71TcMk+k
	 UYR3VLSOkFqax737bQE3fZSaPMeP8HWSftgktDmriGECmqDSbloryMXZMaHfi0J/TD
	 mzCK/JgHug3j2y4NQ5/PKlBsmjIlokJkEk7vXWKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2065/2077] usb: atm: ueagle-atm: use dev_dbg() for device found message
Date: Tue, 21 Jul 2026 17:28:58 +0200
Message-ID: <20260721152641.407202305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2590,7 +2590,7 @@ static int uea_probe(struct usb_interfac
 	int ret;
 
 	uea_enters(usb);
-	uea_info(usb, "ADSL device founded vid (%#X) pid (%#X) Rev (%#X): %s\n",
+	uea_dbg(usb, "ADSL device found with vid (%#X) pid (%#X) Rev (%#X): %s\n",
 		le16_to_cpu(usb->descriptor.idVendor),
 		le16_to_cpu(usb->descriptor.idProduct),
 		le16_to_cpu(usb->descriptor.bcdDevice),


