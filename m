Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062709;
	b=0j19Ur1YYg6IMhxDVPILG3svLhYGdmu54WPZZ/IvxK5g/XJ75quQOepXsfKDGq0wiyUl
	 I0g0LOjF7Q0BEOgt223xQ68nou5SV17zAUTH94/24Wt3x+Xwt0rWZ4hiY4VyXEHijocLJ
	 kGJqIWLs+p7Vetthsso5Qliqga6g1v2tTIpofWk5mHQCsD0Jfbx1vhKF1fbC7hGQOGZEa
	 SoM0WbdPMMA1Eg+FWjg/9NWBIf/yx8DoEOrXJmDUh+pE+ZqbO4GYktVe8xm7B5cFmTlKE
	 qfEbqoPBC02exfgaOYvfGAltRjeVkmgIiPsLyab9TZsBdcKPc8Bl1pVSMbTjXWaeMgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XFyNqvhncddMVdDuNZg1CNc39milrJ8VSUcM/KuNM6I=;
	b=gtvrzE0wFeB9QwYAFlgHDQFL61nDrf0j0SSd99e5po78T6WXkQ8zwN2p0vKOJdeK0LdW
	 +gdTiUfJk3SCd5ArGZMedjkMENaHeXnpUqX14KxIN6kKaax2rMFUCj9v4jl3YmiDMw/QM
	 Iia0mc1A0ieX45ymS+GuJQki7ssP5JG7zu47IDxgoIGm83sSfClcWMhAX25lE+8pWNMG3
	 Owu+bKmvH+Q+qFB6LRzGh8HdM+3O4Xwyjmq71fwEXkOu3Ca9AcYYYmSwlINn+lWTmeaLB
	 EFoJolAMx/M+7gZnIIv4nY1XPtXgCz4Iy4KYZ2U+RmVR5UNmBfYKF9Of+QgmtZjO6qA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxdVQl+g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD5F606A334;
	Sat,  7 Nov 2026 14:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TxdVQl+g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9EBA1F0089F;
	Sat,  7 Nov 2026 14:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062708;
	bh=XFyNqvhncddMVdDuNZg1CNc39milrJ8VSUcM/KuNM6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TxdVQl+gQHprK1fuNUq4mn5/4B9pWwQTlGKRGXI9uXNNIzs1DXo/r7xX89qd/G6kJ
	 Zad5jcnxkZqfFPBGCPStkjAtTcaO6robijeOOv3MyQfeIFCrQSEixIC6WEz3BrFY0S
	 uzFK9W2QbK1YzZavaLxVwAb6WSQt/a1vP8zKbQgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/869] media: streamzap: Add missing rc_unregister_device()
Date: Sat,  7 Nov 2026 08:45:13 -0500
Message-ID: <20261107134853.221636962@linuxfoundation.org>
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
index 8c85b9f30a3a9..e91cf2ffbc876 100644
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



