Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F53D1DFF4;
	Mon,  1 Apr 2024 17:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991102; cv=none; b=kXc8XKP4esMUtc3TXUXcY3LH2g/my+3VXtXdn3P9MHfPvpNuEZQBhbGj/f0XQRvfuyFJeuYpadzR+0GD7bJDVi3RfUpB3QE3ML1wsQulsupzkGIrqYkyFtfdyR2E/66+5Mywu90w6ve5W1j7gcYoZ/0HBLZaza4oBapFeK0tepY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991102; c=relaxed/simple;
	bh=12GgLQ0jm5EVWHyLvalqr3jS75+c5/EWXxFm2SOvAA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfmIEpDu30KN6/CO4Jowr+CtJlljKVNIEmiY0mxQdtA626JmyYtv3XFjeRDSM2feuEccMnEj9wk9xL4ZamV/PIfC58yMVvvB+JrQO1hilU53RQ0/4nhAomNme9XKoJ2mH4JSEqr3MUN3AQvxMzcZ7gNfXrnTbfwMYe+dfjjlvAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7SeZeIR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7SeZeIR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBD1BC433F1;
	Mon,  1 Apr 2024 17:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991102;
	bh=12GgLQ0jm5EVWHyLvalqr3jS75+c5/EWXxFm2SOvAA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7SeZeIRBbEEj7Ad3iVjDFnTTSq89fSc3OhS0dN37rkpIZzdj6n2Ejb7Walw9Lz47
	 7pFpFFyC3xvoGKa2jQQCS7zz8i3R68d+Pgt5nOan+plUuim0KHLODnVRV9WY4hCC2b
	 hcGfeU1FLVSV6flb4FICnwT/fTYX4MSCU/Zjjjd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 6.1 164/272] mei: me: add arrow lake point H DID
Date: Mon,  1 Apr 2024 17:45:54 +0200
Message-ID: <20240401152535.863773036@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 8436f25802ec028ac7254990893f3e01926d9b79 upstream.

Add Arrow Lake H device id.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240211103912.117105-2-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -113,6 +113,7 @@
 
 #define MEI_DEV_ID_MTL_M      0x7E70  /* Meteor Lake Point M */
 #define MEI_DEV_ID_ARL_S      0x7F68  /* Arrow Lake Point S */
+#define MEI_DEV_ID_ARL_H      0x7770  /* Arrow Lake Point H */
 
 /*
  * MEI HW Section
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -120,6 +120,7 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_H, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */
 	{0, }


