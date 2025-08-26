Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA5634166B;
	Tue, 26 Aug 2025 13:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213909; cv=none; b=thR018THg93DvGeSmO5t9j/DAcZecqmBHc62HztWqOuLZXbEPbsX3lY77208LVK13ZyoMgcYfddwLDhIjWovOFdoefXfFpfQAywZhtf/bd8DfwjV7pPvnv3DbKEo0I5+RPZPqh41GZfRRzOePn9LhjDDI445HovWcaudT7pw2fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213909; c=relaxed/simple;
	bh=qBPG9AzAdegdbbdm28Pr5+vICqigl801Yf4q59bKgdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lo7sg/mydftwQJBS/Ffbl68qlKY6ZpePjeeTzdaGdl5trnN1mikp24LRY5p/t4GGg+fI6WTtxo7Pi1obY7Waeh/rySdiuoxJV/LSZApk+Rv9rll14bwJh2aKs6+OtGqQPzewlCyN1DcGcbgJGb+4GgXP1pcPaDaSuow7B0x8ggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=McW1Fkln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="McW1Fkln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6FBC4CEF1;
	Tue, 26 Aug 2025 13:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213909;
	bh=qBPG9AzAdegdbbdm28Pr5+vICqigl801Yf4q59bKgdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=McW1FklnAC8D1byBHQQyGSejzvCno7ek3Ul2xumzx+ufi9wMKSGi/Z4Ci/+iwaFNL
	 bDBVsBgJKQDdvQkiHHNhotQAVdaIKWlxgUGo/0xGZXx/iKjwuePFUoYWuwA+KNIonT
	 4Ov4VsZi3F84oXUvqe2490jey1x5Ut3JX5mxXBXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 6.6 526/587] usb: storage: realtek_cr: Use correct byte order for bcs->Residue
Date: Tue, 26 Aug 2025 13:11:15 +0200
Message-ID: <20250826111006.381996715@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


