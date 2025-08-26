Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E526200112;
	Tue, 26 Aug 2025 11:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208744; cv=none; b=n6b3Qpsw7xMSSKkw5UuhNBzVVzJ+RVvhRLMH0trRSYF7YF0Yn6d0D5llZXP4t+VaCLeyNej3dMMuIfVEw6KZ4VZ8W9cVG43ha8+cZALKjxz2M/3+B0GgqsQ7WqVe2Ce+m420cRSyX6zvM2yUoV+yNWb57Gq9lwOMf3ZQJvY+jXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208744; c=relaxed/simple;
	bh=j1iRxvXlVa+kImOVLxKOQIh0BQ59KOqfcy2ro64F1NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vzg9OK5jn6R9L/XmMG+uFGI0fwFyHF4hVgY7F3EXF9+Ja2VmQUOwXoOLiHFSAxWvsi6ty4/2BELnhHNHBFA8m6e/9oQROw1sssesau+ty0mFKwhv5OtOrA8FfegMWL5QT7dITPFZc3dsrgGmZE5JnCgBBU4bYUkeeZTCpoT+jaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yy3pml4d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yy3pml4d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDACEC4CEF1;
	Tue, 26 Aug 2025 11:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208744;
	bh=j1iRxvXlVa+kImOVLxKOQIh0BQ59KOqfcy2ro64F1NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yy3pml4dQAwnD/4EiQyOZ97D3Q2hlMgbvxsfhopEu53Wb2tlVTKpvHnpymaU8DkzO
	 yqMX8hkSQIuoJ8sWT7DF42XMO4Rn17sO6VGLH8M8ffzypSam3T4JZI1T/UGrYc9cln
	 K48AEXu8k2xgx3rUhPiYKJTXzMzEB2XOtZStcaRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 6.12 228/322] usb: storage: realtek_cr: Use correct byte order for bcs->Residue
Date: Tue, 26 Aug 2025 13:10:43 +0200
Message-ID: <20250826110921.526769370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


