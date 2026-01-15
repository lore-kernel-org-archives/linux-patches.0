Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A473D333E;
	Thu, 15 Jan 2026 17:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499448; cv=none; b=NqnCUPiYf/2ou56eCD4YL3/2FvGumwOZ01MfuvLfd4nudqzE8DV31P/pYJzXritRKe+E82TxZFbTx/hd21Pph+DCVqcQ0pkRIVxDCbEBqRVBbrUwZjmxwnSMB1+J6H15LLKMqWPj/3bnIyjPBvHEbsKlePjXfmpsHplFIv/KiY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499448; c=relaxed/simple;
	bh=G7lx/NKOx0uBBRA3uHTCTBUwD9oCvdXeWiTaLYAN/98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fG2zBW2exNZP2MMVbh6+cS5TtBGfQrKEJezq5TMZMzHqnLrLCpjnQya2c4ElZP9aUx8VVuYVoQqi8p9uYDqr+k0/HMgxOFNEu2ByN1JjeE8v+Pm3DqFNfXYS2rvQrbm5NfibGQyarU+03YSp1wnUVVOe5yf/hkghv9Q2X7Rhx7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zQENt65k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zQENt65k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B63C116D0;
	Thu, 15 Jan 2026 17:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499448;
	bh=G7lx/NKOx0uBBRA3uHTCTBUwD9oCvdXeWiTaLYAN/98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zQENt65k2xsrP7tcHwoa4HLizeJaVIPG72OcOwJj7sSg4ulWsjXzTJCicwJCL3cmx
	 siLvP10eoEpOFzuUjFNjPiHJcl/oXfluaoK3H5tnyr8ttUhWhh6ZdlBDy4p2501oAU
	 KzWLGk1640reqMTopt2LU6WtkIkMTWg6264TIKSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>
Subject: [PATCH 5.10 229/451] usb: usb-storage: Maintain minimal modifications to the bcdDevice range.
Date: Thu, 15 Jan 2026 17:47:10 +0100
Message-ID: <20260115164239.179196862@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Changcheng <chenchangcheng@kylinos.cn>

commit 0831269b5f71594882accfceb02638124f88955d upstream.

We cannot determine which models require the NO_ATA_1X and
IGNORE_RESIDUE quirks aside from the EL-R12 optical drive device.

Fixes: 955a48a5353f ("usb: usb-storage: No additional quirks need to be added to the EL-R12 optical drive.")
Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Link: https://patch.msgid.link/20251218012318.15978-1-chenchangcheng@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -98,7 +98,7 @@ UNUSUAL_DEV(0x125f, 0xa94a, 0x0160, 0x01
 		US_FL_NO_ATA_1X),
 
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
-UNUSUAL_DEV(0x13fd, 0x3940, 0x0309, 0x0309,
+UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x0309,
 		"Initio Corporation",
 		"INIC-3069",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,


