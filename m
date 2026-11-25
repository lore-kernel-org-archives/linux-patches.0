Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620572;
	b=pyvmHpsA0F57jTBaQoVj9mZ+giQm30wAoFFoEBSWw4ikk5zGBTKTa+7v+oiyfKG2frUJ
	 UD/OY3zCerd1n8rU6bWHfRY9t5Jxvq3PZUnQrhyJbr1D2UGXpeXjV61cZH5iypHjf2g2U
	 oC3Ayh4o6J5QD4oTwf1Mk95sFXhaQXOToTx1hyyZDbGjQGalvW8QtAJuqa3R6pUjhE0e3
	 8GrH65TILvU1BSJCJAxKBPFSODaV/u206Hu6QsvdAYRGih6n0vxGsRwJpEQB1pbLvEUvj
	 yA341+ev/0E6lxj26SyWevOjXhrAoc3enrVYcGSn7GkSF7b3sCTaJJcooos7xm0a/jQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iGjQEp3tPscIvkN0HjGJDTHgTFey50o5muGHI2wuDZ4=;
	b=FSp7Toa7U+/HnHrS52qh6/TgKI+FXVILA0pmQHwOY0/A0HXn0fFtKHxqD3zQCPEzOKBx
	 CB6Kc96hph04XWdSIshv05scKPg9FBLY9jiSiRnwOCt1Gd3VGi11eHco4SUqV65UwubaH
	 /hBWeg2zGhnOiv+yLIhMhWizX+6QAL/c0EIY85Svzwb0VwN/mmGYcts4GDuFNtLzsmcO3
	 X6KnAb3+BL5EDUgnWzXnM+FsxgZ2Sr0dNfAjzBdn9/y9hAlWW3tUpqksxsITMi5KBaB4l
	 YAQDKi8/SkTn+qh6XuunIAAFuw7ry3J+6wUgCDIUpBZS/17DGHWsADcyeJNKhKUYTwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUMLFO4e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC5A606A323;
	Wed, 25 Nov 2026 15:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUMLFO4e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADC61F000CA;
	Wed, 25 Nov 2026 15:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620571;
	bh=iGjQEp3tPscIvkN0HjGJDTHgTFey50o5muGHI2wuDZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUMLFO4er6Abl2l/wqA0Vd9dyNKSaE1SzMnnVLEaHQYZYPodgJ+zwl02aBQRZC4/G
	 7tGln2G1Sm63K7YyrKqoEU1KOeXdiownXSKN9KIiUWCHdfW1sU/UZwVJpM0Yc8zTnb
	 XZVJysTghO6s1RBwI4vuFmFZE4cpMVJumqv8iGSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.3 0935/1005] usb: dwc3: gadget: Recover from End Transfer timeout
Date: Wed, 25 Nov 2026 15:37:53 +0100
Message-ID: <20261125143843.586840730@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit 61575534fb05d52d36979f38976ece74649f091a upstream.

If the End Transfer command times out, the endpoint resource is never
released and every subsequent Start Transfer to the endpoint fails with
"No Resource". Schedule an error recovery to reset the controller.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/7523e9a11303a33acd0b92a092fb0e8218d509d2.1792542945.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1754,6 +1754,8 @@ static int __dwc3_gadget_get_frame(struc
 	return DWC3_DSTS_SOFFN(reg);
 }
 
+static void dwc3_schedule_err_recovery(struct dwc3 *dwc);
+
 /**
  * __dwc3_stop_active_transfer - stop the current active transfer
  * @dep: isoc endpoint
@@ -1797,6 +1799,9 @@ static int __dwc3_stop_active_transfer(s
 		dev_err_ratelimited(dep->dwc->dev,
 				"end transfer failed: %d\n", ret);
 
+	if (ret == -ETIMEDOUT && dep->dwc->err_state == DWC3_ERR_NONE)
+		dwc3_schedule_err_recovery(dep->dwc);
+
 	dep->resource_index = 0;
 
 	if (!interrupt)


