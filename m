Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D597F200112;
	Tue, 26 Aug 2025 13:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215270; cv=none; b=qZc/OaQcVTvM0E4Slave4gEKRzgvq6kgv0Tgh8J07oq0YanbO2SDqti69nnJF23xM8G5bzlVfjAWlcBQSmB8jpa0lbpB5BdRQxRFsJofmoj+Pkcgkhr+CtyIQXigoFvxiSRfLPZYn36CDVYKCmyysbmW3zHPtScIdN9qs01wjCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215270; c=relaxed/simple;
	bh=vCF385YApu+OBBn4jkqkrBtTDaGcQJjBlUUdeL6uzSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2dVMG9R20Wl4ucalYGyVYSdXmy3VL9eGpu9IdNj2B8lE8bQoD1gGEZhmSzPbqV0u0/kUf65hP/1JwHdolgIaPmBsKJxEX1lSJ7SIyF1vfQMTt7Cil+QS42bTv+XvfRlL3pW4icp/JZZ1ipfC+5wr8o68tkFlhUzbBT1I8axcQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAQLpXdu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAQLpXdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B9E2C4CEF1;
	Tue, 26 Aug 2025 13:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215270;
	bh=vCF385YApu+OBBn4jkqkrBtTDaGcQJjBlUUdeL6uzSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAQLpXduiWzvqITa32OckeUBe/aTm/4i5d75JbwSmPvqT7kop9dVe9ptGdHWMlM96
	 xD0yNPGVbB0dhvMeaTSMPiukSIdMIOkEh13QD8JlNNYi9Ro96LPRE/YiMhKh+mzQnv
	 iynxS9lf32DS+Kok8voLJto8lHu9+CQIfPytEDhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 6.1 420/482] usb: storage: realtek_cr: Use correct byte order for bcs->Residue
Date: Tue, 26 Aug 2025 13:11:13 +0200
Message-ID: <20250826110941.203064655@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

commit 98da66a70ad2396e5a508c4245367797ebc052ce upstream.

Since 'bcs->Residue' has the data type '__le32', convert it to the
correct byte order of the CPU using this driver when assigning it to
the local variable 'residue'.

Cc: stable <stable@kernel.org>
Fixes: 50a6cb932d5c ("USB: usb_storage: add ums-realtek driver")
Suggested-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Link: https://lore.kernel.org/r/20250813145247.184717-3-thorsten.blum@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/realtek_cr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/storage/realtek_cr.c
+++ b/drivers/usb/storage/realtek_cr.c
@@ -252,7 +252,7 @@ static int rts51x_bulk_transport(struct
 		return USB_STOR_TRANSPORT_ERROR;
 	}
 
-	residue = bcs->Residue;
+	residue = le32_to_cpu(bcs->Residue);
 	if (bcs->Tag != us->tag)
 		return USB_STOR_TRANSPORT_ERROR;
 


