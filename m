Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F392FA642;
	Tue, 17 Jun 2025 16:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178741; cv=none; b=HBaPTkv4codmBIrFZ6GcrFaX08AFthO/vHSjV0IysO8Xk7VgjvJuPsj0mJ3OPe4ZRB2TcCFC4/A6mp74UD/74C51xHJHKEsXBdzXh2wC59XuKqnBzHXmgyum0sDgOu5clyzOw69dFIz1SJS5AuaZ+g8hjCl6PjGa/wBSrtrTZV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178741; c=relaxed/simple;
	bh=YdZIk6G604W+8yTtfkySuQdGFhXu9bpdkeJuxVitE6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANG9aiOoZeisDmAcZBisYVx3byhVN3UxF4rHVvOZSeGjX+wOPJy4GMdyONt1g61BW+lYYb1576L/5US1HgNIEMyOii07o6jUYI2qqF2cwG1Nd/PXCTykl+qW25qbU5kYLJyeHnQBOptahhMX5tJ9G4tqzB+g2mKAj2Qt47vP9d0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fZL/4Z1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fZL/4Z1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DA6C4CEE7;
	Tue, 17 Jun 2025 16:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178741;
	bh=YdZIk6G604W+8yTtfkySuQdGFhXu9bpdkeJuxVitE6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fZL/4Z1sRZINnZxSD7T88MRXHZ3JxvnQY0+30nvm6CID6LL40y9MgyYOuDo0ZV6O8
	 s8Yx2gh/uzrsKlf6II+qFuXngMk+jAD4AUBnnS2pwI/Z/PeBA1pUGRNpztIWplSbSE
	 sQxV2Lo3qfVCPHhaRDShS0amfT+2DiqwfWDeGa9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 538/780] staging: gpib: Fix PCMCIA config identifier
Date: Tue, 17 Jun 2025 17:24:06 +0200
Message-ID: <20250617152513.420709545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Penkler <dpenkler@gmail.com>

[ Upstream commit 034a456869a071c635a9997e0bf3947a6cb20b25 ]

The PCMCIA config identifier in the ines_exit_module function
was never changed because it was misspelled in the original commit.

Update the config parameter to use the correct identifier from
gpib/Kconfig

Fixes: bb1bd92fa0f2 ("staging: gpib: Add ines GPIB driver")
Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250502072150.32714-2-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/ines/ines_gpib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gpib/ines/ines_gpib.c b/drivers/staging/gpib/ines/ines_gpib.c
index d93eb05dab903..8e2375d8ddac2 100644
--- a/drivers/staging/gpib/ines/ines_gpib.c
+++ b/drivers/staging/gpib/ines/ines_gpib.c
@@ -1484,7 +1484,7 @@ static void __exit ines_exit_module(void)
 	gpib_unregister_driver(&ines_pci_unaccel_interface);
 	gpib_unregister_driver(&ines_pci_accel_interface);
 	gpib_unregister_driver(&ines_isa_interface);
-#ifdef GPIB__PCMCIA
+#ifdef CONFIG_GPIB_PCMCIA
 	gpib_unregister_driver(&ines_pcmcia_interface);
 	gpib_unregister_driver(&ines_pcmcia_unaccel_interface);
 	gpib_unregister_driver(&ines_pcmcia_accel_interface);
-- 
2.39.5



