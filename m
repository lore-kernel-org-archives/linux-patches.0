Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A651D254871;
	Tue, 29 Apr 2025 17:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947307; cv=none; b=frP2GwmFwfwOCKWSFJgZntrP/3Lb6NlPQ+2f2T0nxo0hD5eVR5pnrRro+NJcnAZoSTUZTcj/EVFjV/UdktSOF369uX0TysSBQS0KAPDeqV6tRhF/xItzI/97nLHeGyZIlU8vreI1YbCYKY045NoMQL6K5zI89G8I10pMbc58gq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947307; c=relaxed/simple;
	bh=zD7TfDMr1g2WU4oew8hDGdlB8oFjm1SwFjpD90jnGbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzBrbXQ72vookScny0afuBI7bmkxcZyNPjqa/wayQq3INGgA73DGjmal0sRHKBV1o7kiN5Xeyu0kZWOIZluzIf4EuHC1/CQq/2q1ay6zrh7XjN+w2DUZYAuQpCfyYrL/du4GXsiN42izUbpTN0m4pAs7DxFTU3OncYPrrW3r164=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fw/A9++L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fw/A9++L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFE3C4CEEA;
	Tue, 29 Apr 2025 17:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947307;
	bh=zD7TfDMr1g2WU4oew8hDGdlB8oFjm1SwFjpD90jnGbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fw/A9++L+Zqv8iqU0UV0yj5NhPVTT1Y3fFy7nnEAaMxUjLzC1y+nZEQ5Fi84NLNPg
	 wrsnX4qShTP/MVU6V5/a6wxc/v22jYMG2nW8ElzGlOR/ID8dvO+rvVUXvSHoLxyT5p
	 Jby7NJishoRG6naqmVY3JhUekiPh7ZznZehc676Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 5.10 240/286] USB: storage: quirk for ADATA Portable HDD CH94
Date: Tue, 29 Apr 2025 18:42:24 +0200
Message-ID: <20250429161117.799239162@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 9ab75eee1a056f896b87d139044dd103adc532b9 upstream.

Version 1.60 specifically needs this quirk.
Version 2.00 is known good.

Cc: stable <stable@kernel.org>
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20250403180004.343133-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -83,6 +83,13 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
+/* Reported-by: Oliver Neukum <oneukum@suse.com> */
+UNUSUAL_DEV(0x125f, 0xa94a, 0x0160, 0x0160,
+		"ADATA",
+		"Portable HDD CH94",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_NO_ATA_1X),
+
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",


