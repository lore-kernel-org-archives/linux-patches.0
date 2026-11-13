Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585427;
	b=bez5e09eZIBuKcyAvNyVyHvFSOtQDXJCEOlRNAXjT5zAmN3Zt5CQNBcbJomWjqh/14oZ
	 BhQoEI+pZrUM5qMU5PVHWiXmNoZ5A9JOElrCJ3sILk7SM0/j3mjana1TVcBrQRJB1CdCJ
	 zUrXyNLamyJZ00aYBQkO8rA1kdK48QMNtKT20RJ7HZQSI5JlRyc61XQzNqojpNacVIRJW
	 C32/ctG38PZaBcoj3p0bmiQpoRU5MlBz92TsJ9c3Iri1IuUOfF29hab39fSmN35SgFguh
	 FTCCjG/Ky1KaNU19izB1E4ihsI/MDJ5+9OtOSvF7D6qlUQjLnijl6/4sy6FDEG1mFlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/TB6StBU5PXPCJG539I9Kk3Xu86fr9UXaB0wRYqDYGc=;
	b=quRczws1KoNTwPI1EIrAHitkFIr7JAPWCwVod5htZkG0d/R2kpZ9INp4/ItE29fTVRyM
	 jkOqYSYU3R8QJno1ykiea0gEMykzBX5pFrzt4ZnWWRql44K7kiKlB7TfsT7SImeeRGRMp
	 qlBfZsuItb9uVQ5mJTx1xCSIJ/WBSOka/EK/I0jR+2ffy2ScElFmkr301GFFCQ6F3WHhx
	 fTdSPrPnH1r1l0l9D2BfS+YFfDjD2dsnWtLy+jlXRgddR0MJTkrWTlgSdq9rc1xsC5W4E
	 bc1uFjM/n1HjgWT7NXU/lzpJQ9Lw0UVSIFgrz79VeGvwzsrTAiWY+wwbrlgUYbhP2GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="pLGIs0V/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAE560A3839;
	Fri, 13 Nov 2026 15:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pLGIs0V/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64FE11F000C8;
	Fri, 13 Nov 2026 15:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585427;
	bh=/TB6StBU5PXPCJG539I9Kk3Xu86fr9UXaB0wRYqDYGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLGIs0V/2aYZXAoOvNTWVAAisLfwmF1w+GHg7ne7myAooPiW/bVnEe+fKvJnk537q
	 I6FP5dEIcLzmhnOXieVCUu6NK+W6V3pYtmt2EhiBnkNa4jjwmc5VQk0+i1MZ8BAD7n
	 T8LpEu7Oo623Mx9GEG2hjrEThRiIW8YHx6pwjlfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 054/507] net/9p/usbg: call disable_usb9pfs() from usb9pfs_disable()
Date: Fri, 13 Nov 2026 10:45:58 -0500
Message-ID: <20261113153755.390792857@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <mgr@kernel.org>

[ Upstream commit cd1988cf723c2eae87112b198bf90b0aebfeaf31 ]

usb9pfs_disable() is the usb_function ->disable callback, invoked by
the composite gadget core whenever the host resets or unconfigures
the gadget. The gadget function API requires this callback to disable
its endpoints; every other in-tree function driver does so from its
->disable hook.

usb9pfs_disable() never called disable_usb9pfs(), so the IN/OUT
endpoints and their usb_request objects were left active and
allocated across a host-driven disable. When the host later
reconfigures the device, enable_usb9pfs() calls alloc_requests() again
and unconditionally overwrites usb9pfs->in_req/out_req, permanently
leaking the previous allocations, while the endpoints themselves are
left enabled underneath the function's own idea of being disabled.

Call disable_usb9pfs() before reinit_completion(&usb9pfs->send),
mirroring the same sequence already used in p9_usbg_close(). Placing
it before the reinit_completion() also ensures usb_ep_disable() has
synchronously flushed any requests still queued in hardware before the
completion is reset, closing the same race that motivated resetting
the completion here in the first place.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Assisted-by: Claude:claude-opus-4.8
Cc: stable@vger.kernel.org
Signed-off-by: Michael Grzeschik <mgr@kernel.org>
Message-ID: <20260922-usb9pfsfixes-v1-4-9d8dcc52904c@kernel.org>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index ce952a5de4260..e215d047de16c 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -759,6 +759,10 @@ static void usb9pfs_disable(struct usb_function *f)
 		usb9pfs->client->status = Disconnected;
 	spin_unlock_irqrestore(&usb9pfs->lock, flags);
 	usb9pfs_clear_tx(usb9pfs);
+
+	if (usb9pfs->in_ep->enabled)
+		disable_usb9pfs(usb9pfs);
+
 	reinit_completion(&usb9pfs->send);
 }
 
-- 
2.53.0



