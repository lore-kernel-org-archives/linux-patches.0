Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061643;
	b=KsitSPfQeGfJBjYTnJJntC2pRGBh7Z5AUDh1Q4q7nDtuzTuZrIpREeH6D9Ad0PTC4ZUq
	 lDo3v5FTgqXKYlYKFBeyOi3H+Fr1j4nkPDAfIRFjMaecL4sPQwKcweedWXfKfVPDb2su+
	 7/GjBWeQoplPROzDupsEKfrErBidV/k+VKOp7/8UQLPTCVUhWxINYkdbJ09eSDYbSD70L
	 cL3c1pbH1vEhl15soC1ERbAgSPoChl9gBC3bbM+/GN7i81W2WqYfrD6/JNYkiVN3ILePi
	 EhEC/3jcAWdaTNQMsTITlpT2YQfFTOj71nWWft1TLyi4QTarCACZKv6k7NHjYjUi8uQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r/Jr9sXuPLmsXnW+ekDOQ3wUptqCY7qZEpANNV2c3k8=;
	b=5IUIKwwdg+O+KMuJVOIc2sNUgbr3dppZ9PAMi0KhT3fkkNK3tHzyYXWUsmcS7jlNCa+l
	 Nz+2X4JtZwdir79hA6xPsV8lvh/VRUlRjrzvuwbNQItLTC93epMaZwYLTSbtxuyuQkgqn
	 INaR32hZkPx+Oyj7heDpfRAt9Ertzw7pVXxiDP3gUFMAgWcwDwHSwfFiQMXaYY6gA+W0P
	 AAnf7oq3ywKy0BjvDGKsyDyFoV/NLbT92z+6pJYylJoKxZk9grWBs7+s5HMJzZsJJTDDk
	 oZdnGK1aMa0oWWdyi+FzJz4mzj0X67IV3d8H881p7+OgbsypP593PA94Lc38sTYsv+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkYlnzOM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB0A606A336;
	Sat,  7 Nov 2026 14:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkYlnzOM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D30F1F0089F;
	Sat,  7 Nov 2026 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061643;
	bh=r/Jr9sXuPLmsXnW+ekDOQ3wUptqCY7qZEpANNV2c3k8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkYlnzOMBDcLg0lQr8aw0mhnpiJfeXX/YSzEFpednsisnCkPf0kk8fv4GOiivhoDp
	 9b5Sr4+8BXGLN3b2TX3CVQ8cl5vU5yHP97d7eJxOEFPUvlBIpDCuIEbre+++BksSDs
	 5vqknj6DPNN13wGzIs1/nDdNXcBi7V+ssUW/E2bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0666/1536] media: rc: After rc_unregister_device() timers can be re-armed
Date: Sat,  7 Nov 2026 08:44:42 -0500
Message-ID: <20261107135016.202377323@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

commit ef41a67979aed4d7d4f393c56c1e25b6754e2b78 upstream.

If rc_keydown() is called after rc_register_device(), then the timers
can be re-armed. Delete them again for a final time.

Fixes: dccc0c3ddf8f ("media: rc: fix race between unregister and urb/irq callbacks")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Acked-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/rc-main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1742,6 +1742,11 @@ void rc_free_device(struct rc_dev *dev)
 	if (!dev)
 		return;
 
+	if (dev->input_dev) {
+		timer_delete_sync(&dev->timer_keyup);
+		timer_delete_sync(&dev->timer_repeat);
+	}
+
 	input_put_device(dev->input_dev);
 
 	put_device(&dev->dev);


