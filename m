Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7173A3F2103;
	Tue, 17 Mar 2026 16:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765984; cv=none; b=bez1PSEftJEDuQL/sbEsgEYHCoEh5+Q6wsNfGY+JdKcvWktn0eWSB3pEyjp0VbQ5imwgZdhvfqgieoJtzNkZmcPuei6sV5Z0JGM6nA740RgPnOnJe/GFFff0Xm/EvC1K5hSJ89W3qB5QXt+nbx3iwb0QbDxEOuK0U/zgLLKyeSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765984; c=relaxed/simple;
	bh=W47H5bDcoBVItdOPbjzqsro59xe47r9FcTCui0VC9l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1/BfYJ4/jKz82KLoGT92iL652IeErSP3oLFyMyW9K/HY9cogM4VFcuYnz/S7k1bWkMvE5NkQYJN492lJxAkyuHeq3Gc7rMHzQeGxbTrz9/FDohOOZulWNdCgVg3VFAjnDZWhQVSs68TYhkX5GCN3D4bDDZpvaqgKfjX1uRYbbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CyxV/IUD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CyxV/IUD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA53C4CEF7;
	Tue, 17 Mar 2026 16:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765984;
	bh=W47H5bDcoBVItdOPbjzqsro59xe47r9FcTCui0VC9l0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CyxV/IUDQiS7Y2T9J0nXFZjVsFK1SIT/dm354EcMWQvIAU+z2hrZRsHMoatIBsmcd
	 hZJnOgSRiFChy5G5NdGH+jejOsbS0EmdRlrlVdjjVG7EyJuaEAieWova6SRm23xdup
	 70WAKuR7H+mhyQh55E0+UI/KV+ZqR5uEmxWvph3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vyacheslav Vahnenko <vahnenko2003@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.19 144/378] USB: ezcap401 needs USB_QUIRK_NO_BOS to function on 10gbs usb speed
Date: Tue, 17 Mar 2026 17:31:41 +0100
Message-ID: <20260317163012.314522580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vyacheslav Vahnenko <vahnenko2003@gmail.com>

commit d0d9b1f4f5391e6a00cee81d73ed2e8f98446d5f upstream.

Add USB_QUIRK_NO_BOS for ezcap401 capture card, without it dmesg will show
"unable to get BOS descriptor or descriptor too short" and "unable to
read config index 0 descriptor/start: -71" errors and device will not
able to work at full speed at 10gbs

Signed-off-by: Vyacheslav Vahnenko <vahnenko2003@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260313123638.20481-1-vahnenko2003@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -588,6 +588,9 @@ static const struct usb_device_id usb_qu
 	/* Alcor Link AK9563 SC Reader used in 2022 Lenovo ThinkPads */
 	{ USB_DEVICE(0x2ce3, 0x9563), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* ezcap401 - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x32ed, 0x0401), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* DELL USB GEN2 */
 	{ USB_DEVICE(0x413c, 0xb062), .driver_info = USB_QUIRK_NO_LPM | USB_QUIRK_RESET_RESUME },
 


