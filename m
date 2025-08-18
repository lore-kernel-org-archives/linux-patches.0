Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29087335BDD;
	Mon, 18 Aug 2025 13:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523247; cv=none; b=szDE7+e9ki7eLBMd8j52oLTS+0/jtx5ZxYVou2+CXMcEmw/+plHcatHruKr8jXxzrypXG0fcWxpZqtNIyvi/R3i/pGmhpoUmLveS1H4KwmK8RdNjfmg76lnCQN+EzQAxcPp/hvcHDIXmdzkkfbQr9gwwBAFdYS2u9jur+MFkAG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523247; c=relaxed/simple;
	bh=Y2GP4WYfTlakUBxbe1XO2TPJrY7kfewTZlU8i9nE3kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r27KHsPGVk8ENvpplBkDI0GGtjq4CzIXkDKNv8CSdlYHhVCvZngP5r0di34+wzeh7p3coDXIOy5bKS4T2Pgh9RMDFiQ2XcqHaAq+6bE9GBeeuMADyf87Na1so0EQhfkcMdJSw7m+Sc9l4mAid6SUdevH6AHGrVy2Ykx58ak1CDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+xGBjRx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+xGBjRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4D4C4CEEB;
	Mon, 18 Aug 2025 13:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523247;
	bh=Y2GP4WYfTlakUBxbe1XO2TPJrY7kfewTZlU8i9nE3kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+xGBjRxnijCbaNWyDbViOXPPbSr57KNrWCkvbAXD+tWrPF9JPEI+iAP4trhwc2ga
	 dlGLNFT1BJqsko+2vxXsmua0sZdDuyeWqFTHqo4tSWWZ2Yew809GSEtGW6aHsmGh9h
	 IjXsYf4S36YALi9N+v0C53FWz7BtRttjopeCgP0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Penkler <dpenkler@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 113/515] staging: gpib: Add init response codes for new ni-usb-hs+
Date: Mon, 18 Aug 2025 14:41:39 +0200
Message-ID: <20250818124502.704153568@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

[ Upstream commit f50d5e0c1f80d004510bf77cb0e1759103585c00 ]

A new version of a bona fide genuine NI-USB-HS+ adaptor
sends new response codes to the initialization sequence.

Add the checking for these response codes to suppress
console warning messages.

Signed-off-by: Dave Penkler <dpenkler@gmail.com>
Link: https://lore.kernel.org/r/20250722164810.2621-1-dpenkler@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
index 9f1b9927f025..56d3b62249b8 100644
--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -2069,10 +2069,10 @@ static int ni_usb_hs_wait_for_ready(struct ni_usb_priv *ni_priv)
 		}
 		if (buffer[++j] != 0x0) { // [6]
 			ready = 1;
-			// NI-USB-HS+ sends 0xf here
+			// NI-USB-HS+ sends 0xf or 0x19 here
 			if (buffer[j] != 0x2 && buffer[j] != 0xe && buffer[j] != 0xf &&
-			    buffer[j] != 0x16)	{
-				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x2, 0xe, 0xf or 0x16\n",
+			    buffer[j] != 0x16 && buffer[j] != 0x19) {
+				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x2, 0xe, 0xf, 0x16 or 0x19\n",
 					j, (int)buffer[j]);
 				unexpected = 1;
 			}
@@ -2100,11 +2100,11 @@ static int ni_usb_hs_wait_for_ready(struct ni_usb_priv *ni_priv)
 				j, (int)buffer[j]);
 			unexpected = 1;
 		}
-		if (buffer[++j] != 0x0) {
+		if (buffer[++j] != 0x0) { // [10] MC usb-488 sends 0x7 here, new HS+ sends 0x59
 			ready = 1;
-			if (buffer[j] != 0x96 && buffer[j] != 0x7 && buffer[j] != 0x6e) {
-// [10] MC usb-488 sends 0x7 here
-				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x96, 0x07 or 0x6e\n",
+			if (buffer[j] != 0x96 && buffer[j] != 0x7 && buffer[j] != 0x6e &&
+			    buffer[j] != 0x59) {
+				dev_err(&usb_dev->dev, "unexpected data: buffer[%i]=0x%x, expected 0x96, 0x07, 0x6e or 0x59\n",
 					j, (int)buffer[j]);
 				unexpected = 1;
 			}
-- 
2.39.5



