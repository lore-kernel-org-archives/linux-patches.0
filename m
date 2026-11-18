Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055756;
	b=Ed0f9zjbndV1ySEsiusOVrhtDDD2+fc9/mg0oRRG4MaW/QUb7PeAg5DFpztcQi1MVtcd
	 BqkfP/+YzkOoWt83Ey9RC/J2XjQkhAi+hLRGGo38OQ2uc6zmer0uJr+sAa20zUkufWj2I
	 89PS8YJMSr2rxYNiT6RuYKoE+myp4dEj+35jnJBzewAXXNT4hTf3Z34tiTZGjcqNo4ezP
	 atfV42gX9lv/r9QfxGX/NVnCVnezWiMR+C/08FOJuquchx2SNsvFQdzWVn0Gh0Z3eJtKU
	 RHmOVRRNfM99nlTtJhBnSHAKwbWzO1wP+XjchwLvGrw+efb8Dm+YzyhNJeATJE6iBdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055756;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LoRekD0LkFSlgnZyOUc+Zc0vrzDOdPDC7nsZPHfBdoE=;
	b=2jbhx3iqExvQxDZ73NwV3tGdWnpV/GxEOPl5ZFsU+lxlawXR8mkGQ9znuqFUa5s5VEQr
	 OZFUzugHmIlW0Wey7hQtQufkL8Yj3HtCgltbBmZY6463waNS2IvXEjFDS/gAwUU2dK+Rn
	 sB41Xu1OMbAPviyBIzfNs/mNfwmRQ9kXRQxBoHehOY5mQC2dBeCaUSWRFhg8qG4gx7799
	 up9cY3EPbgHr98Gg1d9EadKznmKgY0yHbPksh9fK4SzgSNNz9xIOlWjHkzVKJm15ft8x+
	 8BUb7RSIkNC7mnImwd9IyN14VajAFcuJBsj/2HLBJ5mihYc6vJua2nH1PYODHpzKP7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTf5gZYe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D93AE606A325;
	Thu, 19 Nov 2026 02:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTf5gZYe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ADF21F000C4;
	Thu, 19 Nov 2026 02:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055756;
	bh=LoRekD0LkFSlgnZyOUc+Zc0vrzDOdPDC7nsZPHfBdoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTf5gZYelst8xfYQwPph48NPRo+TFHbw7ua4r3Wv4JABl42W5o9uMTE0lhtd/7T4X
	 vYWICb2m7kj5Vui6GBqtcWitD43ddi2IlXJ5lgEQS0VZzzIWXG4R0r69Vt5dnnUO3q
	 grGPhMahzhYn+sWs39UXWLb1C/qp6qCMNMyH2jIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1745/2214] wifi: b43legacy: debugfs: NUL terminate string in debugfs
Date: Wed, 18 Nov 2026 15:57:01 +0100
Message-ID: <20261118150121.426090599@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit f94595252b318a9ae3c01d78b3bcd33b01b1c082 ]

The "buf" buffer is PAGE_SIZE and allocated with kzalloc().  We store a
string from the user in it and then pass it to sscanf() in the write
functions such as tsf_write_file().  The buffer is only used to store a
number so we never come close to filling up the whole PAGE_SIZE.  Reserve
the last character of the page for a NUL terminator.

This is debugfs so it's root only.

Fixes: 75388acd0cd8 ("[B43LEGACY]: add mac80211-based driver for legacy BCM43xx devices")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/909ea7a88658b5e7c183bf0fda31687a91d73818.1790839793.git.error27@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/b43legacy/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index 6b0e8d1170611..86f0c4b717c66 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -263,7 +263,7 @@ static ssize_t b43legacy_debugfs_write(struct file *file,
 
 	if (!count)
 		return 0;
-	if (count > PAGE_SIZE)
+	if (count >= PAGE_SIZE)
 		return -E2BIG;
 	dev = file->private_data;
 	if (!dev)
-- 
2.53.0



