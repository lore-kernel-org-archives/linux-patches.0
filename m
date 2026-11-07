Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062712;
	b=LjtI+6nJAeFU83WUEUEUdhCd4wDhWKkNX5qkdfUS6bW3jvrThigwTzYqRsDGINkW2DlF
	 rL6z6w/wTq9q8AvS4+hRnfIXuOw0s7Cfxa71vgxwPtmYUSxRKtDHuzjfyxrzLGeGfMag+
	 STwIdBvzueLuxmSZ/XBA5t5ALxW8jo9qrnfoCtJkbXN6Lwa4wNzAqvve1hMtlb7Erpgiv
	 SQYrIhNxZpr6DT3NCBA2SRXoO0vjAjVupoiIegQqpdnN49rwUQnkumPPenOwCuufXOK/h
	 KCh5hauK084V63a1q371rmsEO1HsAglsABKu/I66vUYY2e04X5Cb5b/3Xlp/7tNcY2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BVBInglDYhz21X6f1ZfEokopD6jLbEeLMl2T15Lk7uc=;
	b=s8pBCEwUaHd4t0e6BIxLO8NC6wEX+OeFqhEBa+RaAjqT8KSWRe1KR1tm5U64Jf+D5/bm
	 28jrBY902z9gTVz8zAb0nxNVmNEMuNmWtkcoBk3n1qGyUKzjg5W/fqu0VUMd7Rz++WiL+
	 6tqjhqvHEc/Dyz5dEZZ2OI3dODWnGpICEWRcPWhwdL/vkaOq34DPvNa7w8xlDX0xbvtIu
	 rKUZCHo3bR5tXgOXw0Ewl5u5F0u/jpRakYXxes/1ZWz8clPleN/eZIAwhyEOOxBC74lxQ
	 QTZRThf09oX2YlyOQtT83uejq23X0ihEFRBCQ8D2G7K1H7A49zaUzYVbUt3RlK9qRkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mirw7UR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB771606A332;
	Sat,  7 Nov 2026 14:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mirw7UR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E9B1F008A1;
	Sat,  7 Nov 2026 14:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062711;
	bh=BVBInglDYhz21X6f1ZfEokopD6jLbEeLMl2T15Lk7uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mirw7UR0/zCvKHBkstw+9i1o9+4f+t90VbK1/Lpx6sMcPkyfZuosbtN0KmIhk7/8l
	 vvV+Swt5JFhcU+Qf/yjUg7dOURDAMsWYBTlWRr7L0d+deavGNMj+y/owD/7ce4q98W
	 jKFBJOnu2VnvC836nL42auiErQ3Utl06/eSlKtR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/869] media: redrat3: Ensure all urbs are suspended
Date: Sat,  7 Nov 2026 08:45:15 -0500
Message-ID: <20261107134853.295201765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 1582f545273f2aa4eb4ee6f3a89b433f5c85c68f ]

Ensure that the learn urb is stopped before suspend.

Fixes: c49fcdde38cb ("[media] redrat3: enable carrier reports using wideband receiver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/redrat3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/rc/redrat3.c b/drivers/media/rc/redrat3.c
index 4cbbe16a8ac47..c9a5c030f7726 100644
--- a/drivers/media/rc/redrat3.c
+++ b/drivers/media/rc/redrat3.c
@@ -1170,6 +1170,7 @@ static int redrat3_dev_suspend(struct usb_interface *intf, pm_message_t message)
 	usb_kill_urb(rr3->narrow_urb);
 	usb_kill_urb(rr3->wide_urb);
 	usb_kill_urb(rr3->flash_urb);
+	usb_kill_urb(rr3->learn_urb);
 	return 0;
 }
 
-- 
2.53.0



