Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC9A34A32E;
	Tue, 26 Aug 2025 14:01:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216909; cv=none; b=lsNcFPcL8BMxLKjFqmppcGqXXzTm+t8TeyJsRkvh9nqSpVxQlqXtuToMv8LpA565Lu/Z6oMWrtvXMBq1d8W10KdU4t8P1AeZPaTyuqTLbTbkNSWl+6bBlMIdkJef+CiS0fL/O36HE4I0Za5GUifqBVooxsbr+jvDhc+yS5elnhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216909; c=relaxed/simple;
	bh=ZxrWSs5X99FtQiQLMX4aIWdAn1mWIEyPRbrbywvTsG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8x6b5j45TXjvW6vGQcOB5mnKGIh84qnp2gCxQueOVu1ztz2ukmY5pMiu9/IeRzmvU9P3cHoCrXM8cQvTZuAbdpARmDDAkB6bfddlE+XI8OYgqQrlMvW44HU2JC/YC9Gs868D7uG9zWWNt6AOHjosVoknVa5U9MUeUeo0Dn/c2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjMuIYho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjMuIYho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67A2C113D0;
	Tue, 26 Aug 2025 14:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216909;
	bh=ZxrWSs5X99FtQiQLMX4aIWdAn1mWIEyPRbrbywvTsG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjMuIYhoQ+dGoeRYextmro2in9Y7wvSxiby9aD+09ZM9P5Diz5bnwZOS+3rZ9t4Xd
	 p2lmnSa0xn7UKnQuh1TPFQp73NYunlEBbUHz5BTlDtobOn0I3Nl6w3ApYMgZy5Ag3B
	 aTkhaH5SqHZPx7G4nXQHBf+0IBKWA5czVBuWJnug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 5.15 588/644] usb: storage: realtek_cr: Use correct byte order for bcs->Residue
Date: Tue, 26 Aug 2025 13:11:19 +0200
Message-ID: <20250826111001.107467349@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 


