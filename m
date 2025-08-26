Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354AA352FC4;
	Tue, 26 Aug 2025 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218149; cv=none; b=H9LsLQGl0xH3A/gNvdWXbrVe5UvefthJLVu2rDTIOzNknmlUQPpGyakU9gnm4A+SYkcIF80/A5tCOyI82fkNo4/lMk3tYAX0Z4hDXE1FpDZ3m+PdcVeO40dZdbVVa5lViRPTVaisobEcgjxgkOgtBVlp+a5jLZ91sNFfL6BE5gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218149; c=relaxed/simple;
	bh=BrS9rPw621ljwSzFw2W8s/8j7FtglD+4iro5tJ5ZcfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AbMlM+WrLFfESkylyej+Wlfp3Ev9uqc8PGAd36oi3DR+Qn0lbtZUulFiPIDKTCSNOYJxo2SXWzHzGZHtvAUMGWYiriV2tdWDsGZzm4t6tR0RGzBQ5RTcOPwhi3Ty+UgOMpnGuagFSv5aeuIGbq5Cs7tL8G7V2Z6FhTkCKKwxPpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UYStwU4w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UYStwU4w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0B0C4CEF1;
	Tue, 26 Aug 2025 14:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218149;
	bh=BrS9rPw621ljwSzFw2W8s/8j7FtglD+4iro5tJ5ZcfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYStwU4wodpMGvVMgKcehVxsk+JX4JHJq85VzTfTcg73ABccqIso5hl3d+KGZg1e2
	 LYpntiFsJB/0qXfDb3vlrWMZUkqOvije/fvrQSoG9ETlmRLxsYjx1990ODJpxnsV0H
	 uiQ2rFk1k3YtxuXMWzW4N5sU6CH2QaEkWIGsZsO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 5.10 412/523] usb: storage: realtek_cr: Use correct byte order for bcs->Residue
Date: Tue, 26 Aug 2025 13:10:22 +0200
Message-ID: <20250826110934.619767443@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
 


