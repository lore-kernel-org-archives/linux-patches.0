Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFE193557EC;
	Tue,  6 Jan 2026 17:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720355; cv=none; b=dGDMr2MWut/OgoIgQ9eqvR9J90v+8vbirXnyRpRXT0UJFiH8csM+bkHQ2emvNM7//NpijsQwA9cXChaItLxJg6omFMds+UlmsaOlOkDSpLyMMy6yqGEfbRMyJPnRUbKVZgTPq5VUhVotLYUrfViDxJ43mgTccudgmS1jyhcYiXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720355; c=relaxed/simple;
	bh=AOwdJ8SJvepWwIaOkOP/P6MP0LdIYPH/YxPRKhSMYB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaT+xaL5Sp/kjV7HGw18M131SFaln/evzc3qtFc4l3A7ZzhPB4Ei+93QcptQ2+Y4HQWtnrSzvywfy2eZAyjwvJGfBteIgsCZGegkDkwr14+Kvl0Ssw3947Xv7io2BuszBgbHUTQ2yWzgvDUXX+DNH59KYpFBfPZSaupzjFLjAXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSluox8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSluox8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 433E3C116C6;
	Tue,  6 Jan 2026 17:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720354;
	bh=AOwdJ8SJvepWwIaOkOP/P6MP0LdIYPH/YxPRKhSMYB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HSluox8vWi7G1Yjv7uK82w+6ITB5P3l+j0NSheuplhu/2oK5xqyiKwbWc2WpZtQo7
	 EMdhjF1wE+PEVGDDxhFNdUE5BuTnqKeDWnUv61pNWg6J9YGX2QCHoYXyPVLQQvNdZ9
	 OndLpbLs+6P3eDXhSzWdlXqCswTuRFYOeekmKhLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Changcheng <chenchangcheng@kylinos.cn>
Subject: [PATCH 6.12 178/567] usb: usb-storage: Maintain minimal modifications to the bcdDevice range.
Date: Tue,  6 Jan 2026 17:59:20 +0100
Message-ID: <20260106170457.912887802@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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


