Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044838;
	b=V1ifhr2aj0x/K4bsdLVVK1mke3EquPGmnlUZ/GsSaF41t5GAK7q7VCFScABKfOGGfOw0
	 IvSTGW+Se656fdjFovUtQTD5YuwJ7Jv4FlVeZBU7gA6RUbTIQ7OKPlS+MskQy97siJ4Ya
	 Yqs3WFMNPGadNr4opsa8Jp8J1SQMvacDJWiy9Wpfan2VPQOvMrdhi5vcGeSFlNQmX0Md4
	 bLov85XQRVJqbSgc4g3sIbSf9+PgpdYrroHRPagxysPfKOaBaZKU6QrwCEHpRt0qcU0Xb
	 VqHpMNcWnvHHRlHGF0hsN/Q71y7+0Q2+QC12in3QKfetlUHZs6eXcl6geCC2niTYflg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rPGXlxB1ri/7n0EawDJQlxtm65AOy66wjlfsYc0OSjg=;
	b=jRLjE7mQXGKPPqOxOmt+3ZEWabOITPymVk0h4KVdyobEeNC2KCIoh9z7/QVXYnP/33h0
	 3OYzhL73iWE7amy/Vz2VVGDDtpGOq3i3DDIx08VQaKpcVSYeDL7pQ3W3Wh6KexB3yYGEZ
	 7v11/KFIM/mvF8GTRBtFWpuKV2qbTVhlq/LXehTvtKbxqhu077LyULssABLpkWB8hEdMN
	 7eOq0ZlSzmlkaXhXystSr4kagWSU/oley8Bzkv1Ei5wWCpAQbajXpxvdN9Vxf1PUgYEl+
	 6Aap/XhZs11G61KVGFiT6cwbPOp3zwvcWbB/PzrR9cIQGjtknyWfbIcGCODC+2iFRHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9o4dzsM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D641F606A9C0;
	Wed, 18 Nov 2026 23:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C9o4dzsM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE831F000C4;
	Wed, 18 Nov 2026 23:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044838;
	bh=rPGXlxB1ri/7n0EawDJQlxtm65AOy66wjlfsYc0OSjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C9o4dzsMGwEsaX7R624S1nI/zc5dolKfQlJEQzHAIQl2cua4umYaBZcyY9IFavMMg
	 cexDfzPCVXmDSDfW0VWU+BnFpOxp7Xs+oxg0zMMFiniu+93D/uXHhYlmEOoGDlj4R6
	 ZsnrkJlE/x+f2A+6RB/eAsdavBy3b+JdYeUh61JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0709/2857] media: streamzap: Add missing rc_unregister_device()
Date: Wed, 18 Nov 2026 15:29:03 +0100
Message-ID: <20261118150227.078463569@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Sean Young <sean@mess.org>

[ Upstream commit 3982d2eeb1bdf7a9c14e4ff69015cb456f11da51 ]

If usb_submit_urb() fails during probe, then the error path is missing a
call to rc_unregister_device(), which will leak various things like the
input device.

Fixes: 42844992664f ("media: rc: streamzap: Error handling in probe")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index 8e9b156e43002..6ac6f1eee317d 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -365,6 +365,7 @@ static int streamzap_probe(struct usb_interface *intf,
 
 	return 0;
 rc_submit_fail:
+	rc_unregister_device(sz->rdev);
 	rc_free_device(sz->rdev);
 	usb_set_intfdata(intf, NULL);
 rc_dev_fail:
-- 
2.53.0



