Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C6B32FA3C;
	Mon, 29 Dec 2025 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025721; cv=none; b=ANn6dGQQNkD0w/edBzM4RaTObbVXiutisK5rtr0Th+IwTA9dfZkKS9Ok3rOM2om7pLs4OeFEI1ndRFTGAal8/GDHYqo5AG0b5wfgGAAiA1BHmvMRQz/R/yfCH22aDRzzDR8eiEDYj4x4exdZKIG1SfkvSFAv7OM9TuDq5BAhHzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025721; c=relaxed/simple;
	bh=nybeZXM+JMaH5NJwIQnb/309uUUiekUb6682YrV7lJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWdtg6STJLAhYm3ZYx45TIXt6mkBSTW+J0i4ovTjR90RzcyMECp6pasYCfBIRqDxOyF+MbMyNwXuJ4zRLNMQ/rMx0cwOG7DkJFwA5UcoyotdC1wcsplurLe1TWtnmBzZRhGq3VrrHCaA3nkQqLZ8FnPL04GC3YFKx72ul6FkUQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwoi8mzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwoi8mzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4B7C4CEF7;
	Mon, 29 Dec 2025 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025721;
	bh=nybeZXM+JMaH5NJwIQnb/309uUUiekUb6682YrV7lJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwoi8mzwIgMedgRGLO0WDIEFjGuWE7TnmcxBqw670vU7cwoXpewuNcdaRr4z6SmUo
	 RvBtxWkOptlyamAkLw0S7JYrZfhR0nNoYnTuUuctl268GgpCs/OPqdGSuEEgxY5Dnk
	 UU0B0B+s8FmRuMt2F7hYASnZA3YTQmpp8T4xCyEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>
Subject: [PATCH 6.18 280/430] usb: usb-storage: Maintain minimal modifications to the bcdDevice range.
Date: Mon, 29 Dec 2025 17:11:22 +0100
Message-ID: <20251229160734.651390864@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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


