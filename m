Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212868;
	b=LWv+GT3aA7UWI6wkzr0ijvmmJy6uy8fxHl2Djt9aZaRLhTXRzZC7TOcnzCfECmVo2Q5o
	 AtiJlNhM8v3kQxMAa2HUX1gKmGNu3AWiigHD9q0nP1VPkR8YUURBUtxR/Egz815PCCDQo
	 K7rqvNQc2xx4l1/s+F6LfbbTuustqendYy9A1KiN4YamBYtanqVxzjgZq6xs+HhZidkPf
	 kgBQKKiDFAMECu3KOBZRvDZ9RtC1vKpUhCJn88/ZPFaYBtUFewr2DayIypBR0CoSCcBEe
	 Xz6tW0RtlG9p4loYIHr/D5aTm7Lyu3uIWv5qFTBe8nBRMEWuAzjA0ho1Y5imHQAF2pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xsLAjhgB1RXyAbdwcPhC+yYA9sP3hUE19Hqgfzgr27s=;
	b=wuZnX4XhX2goXIgq1BISZ2DitbPIZnhwNna2p9sk7MItlFQdbfEs0J4wUgNtk6KCjZbR
	 pIMggiTUqRm+4aN+VZzEdr4jO0KOmH+A4DCONGbWKD9nlT4N+1HbQB5CBF1nJJFu/inqc
	 SwOXDRI1d576w8uSn/fB8nTz6JLv9MeOdf/QrVYlrd+ISnSPh+4JPrD60HSsX7MWy5om7
	 ZCRZLXN3jIbD8VbKaTYRjzpD4qBgzFpf/nBP+dAjs7vvyhnhVZ/gbj3lnagMF/HdGgxV0
	 uXbJ/rFQ4wD/EkC1IDboC72lWZfQwgZ1/Ig+6ooTU+qqkxv27DqJpyqBLb7USZ/+QgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9kBBoyk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67319606A31E;
	Wed, 28 Oct 2026 18:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o9kBBoyk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52C91F01828;
	Wed, 28 Oct 2026 18:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212868;
	bh=xsLAjhgB1RXyAbdwcPhC+yYA9sP3hUE19Hqgfzgr27s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o9kBBoykuixyanyzlhZQ6W//jxrLDI9TB2LQRq/kqOqWdBwX58Y/1t7ao08iQwPuH
	 S3B7ziJPzNY57k608PVMPLH4iAtYoZm0YjG0JA5PkQ1mpd8CRamlKuEPgJlqQ5WOgh
	 ZfAfaVPbWmuXSn63mAQUMAzghVItWixP0dNcMpbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 0306/1887] Bluetooth: btintel: fix buffer over-read in btintel_hw_error()
Date: Wed, 28 Oct 2026 17:40:02 +0100
Message-ID: <20261028170506.193181282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>

commit 40eb4b18ad167b63644c27fa67a7400ba050379a upstream.

The "Exception info %s" print uses skb->data + 1, but the 12-byte
payload is not guaranteed to be NUL-terminated and can be read past
its end.

Bound the print with "%.*s" and skb->len - 1.

Fixes: 973bb97e5aee ("Bluetooth: btintel: Add generic function for handling hardware errors")
Cc: stable@vger.kernel.org
Signed-off-by: Chandrashekar Devegowda <chandrashekar.devegowda@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -248,7 +248,8 @@ static void btintel_hw_error(struct hci_
 		goto unlock;
 	}
 
-	bt_dev_err(hdev, "Exception info %s", (char *)(skb->data + 1));
+	bt_dev_err(hdev, "Exception info %.*s", (int)(skb->len - 1),
+		   (char *)(skb->data + 1));
 
 	kfree_skb(skb);
 


