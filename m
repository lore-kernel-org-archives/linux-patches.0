Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5138F350843;
	Tue, 26 Aug 2025 14:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219349; cv=none; b=NMoeIzQrZ6v9DsJ5n3saTaClFWJ9Z5EQUEEEvzvV+wCvzn7GmfN4Q43Ob2nOAL7dJ5kw7JyaHElvZVbquCqFxUu2d57kmbfA8LM+QSrD/vUaRs/qcuK9Gay94BB/ZjOdKcdfW9jIfuLMU86WO7YfChSwdi5hnlKMBri+QKV9Lao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219349; c=relaxed/simple;
	bh=FVUw5i4ALW4uYXeTQfXAzf2Bl2sKH0/m1wqtQ6HhT9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USVbaK3Om3CmoONYoj+UfC6sCggagI08XMba4I/PZXgQrW0x245unZmov2Enkle3MN9wWR9J+OmfzH2ecXB/r+3LM/l83O7m4qwYuA8w6cIcItaIS1FTHnG2LLicj53FwLSujtFr+ZhoagkWUPV+ZD+uOXCwGpp/Ms++P674p0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr1TR8cC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr1TR8cC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D79E7C4CEF1;
	Tue, 26 Aug 2025 14:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219349;
	bh=FVUw5i4ALW4uYXeTQfXAzf2Bl2sKH0/m1wqtQ6HhT9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fr1TR8cCQfkhJvCUCH68ju/1Habl53A8CpzPc/1Wdbxs8JMFwtaemFhzU0UXylEF6
	 t9tjVRDiveneFOhKjgJuAbxvAICqu0seX9KMjLW1XXANG85YwVuQKjrhkIebu+z+aw
	 txfYQsCBJMHrYaqQHor7Kj/qwAU2hFiGhTsNID+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 5.4 320/403] usb: storage: realtek_cr: Use correct byte order for bcs->Residue
Date: Tue, 26 Aug 2025 13:10:46 +0200
Message-ID: <20250826110915.650373957@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
 


