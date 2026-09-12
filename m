Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8D47886E;
	Sat, 12 Sep 2026 11:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212925; cv=none; b=AbCoK6948Feb13Fc8d/xHRmkKCo8ade/CCzTpYQrZ/C51yCIJ8wpv6xAEDdCuPEanb4grga6FbVYqB0ZNN4dQWr25E/G4emtyHmjuMrL+fgAg2sAgRiWK/PVXPR3yg0ExM+iiSkMyDyRBriVKCpPu28YzYH3S4k77wEjrzOlSGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212925; c=relaxed/simple;
	bh=bBf7r99mUrZ60EzuJCJgaVnIgDIqmmgPDapoOLeAfYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VRlj28CH7vdmS8byAaDhqedqMmvJvcXSUwAJklnG5onT24LLe6u6ckKzFbRdZW6dGyGtzAH4+EYyPjb7L68+xlUpZE7m3RpRW6ODaEkO8y4Tijm/42x1amfW7vXSita7XNGGtMu/4TMRhnFW/0Maz35FvGYeKIuKk1qxmXlv3w4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IKqEmYi0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IKqEmYi0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A3981F000FF;
	Sat, 12 Sep 2026 11:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212921;
	bh=yb4A5WQypsTmgqeEYqqF+cNSGCLbtmjBMlrvVD98kDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IKqEmYi0UcORD6qvukW9/K6OfExELKD9bNtBCp456aVpAfSC3VpX+VcfJHM9BBwdt
	 fc7Xu0fr41F6xaDLZtgv/ZooRZDASBPlJr+m7JCmrnBqe0pAeo2DQc06K1m3CVMQuU
	 +8JYyc1DiWYDD5bJ2fSwFcfV897fv+SP5B07JLrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.12 0017/1376] usb: image: mdc800: change kmalloc() to kzalloc()
Date: Sat, 12 Sep 2026 08:40:43 +0200
Message-ID: <20260912065607.933380342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit 2430eb81e44111b30eeb5273bbcf8b24ca517ef9 upstream.

Change the kmalloc() calls in usb_mdc800_init() for irq_urb_buffer and
download_urb_buffer to kzalloc(), avoiding potential stack leaks if a
shorter message is received in mdc800_usb_irq() and
mdc800_usb_download_notify()

Assisted-by: gkh_clanker_t1000
Cc: stable <stable@kernel.org>
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260819-usb_misc_random-v1-1-43a0dcee3a32@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/image/mdc800.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/image/mdc800.c
+++ b/drivers/usb/image/mdc800.c
@@ -1000,13 +1000,13 @@ static int __init usb_mdc800_init (void)
 	mdc800->downloaded = 0;
 	mdc800->written = 0;
 
-	mdc800->irq_urb_buffer=kmalloc (8, GFP_KERNEL);
+	mdc800->irq_urb_buffer=kzalloc (8, GFP_KERNEL);
 	if (!mdc800->irq_urb_buffer)
 		goto cleanup_on_fail;
 	mdc800->write_urb_buffer=kmalloc (8, GFP_KERNEL);
 	if (!mdc800->write_urb_buffer)
 		goto cleanup_on_fail;
-	mdc800->download_urb_buffer=kmalloc (64, GFP_KERNEL);
+	mdc800->download_urb_buffer=kzalloc (64, GFP_KERNEL);
 	if (!mdc800->download_urb_buffer)
 		goto cleanup_on_fail;
 


