Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590232;
	b=p+sGJLgIsU6IDmR1dEdaV8eYSchsbDjgnmDGVRfQNDz54GQx1Wk7RvP0Stbu00qC92Ix
	 Mk0Ep0TnuMmFLMXUD+L7z1rVgn2puNJJwUVJNQDDyozT/sRZlLAyOmN91A/J3oDBN3blR
	 vAkDVFyE5SU/e0S5F6bRbsB/vsQ9I/tMF7Na+jEacBXLlNT2Ov3ULcT0to1bOL/h9srTY
	 ZbED0YGm4SCetVPIRDb0hndVursL8+0DADboJHrfs/wDw8Mnrv14bLezDpmX4uUWtOhqW
	 mRnrGKHy8cXMjdXRE1QYL7+7+zsvnX1vjZYDoII04zg0PvMC7C9tlg6Wr+pgjp2P6DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q1f7wZy9KKxWs98M2HW25hRKtROknPetANu1d8o2fJk=;
	b=kL9o0sRxLEzyTk/Gui+l5dO6iLrqT4CX6r/Zrs8W4PmXec86+41Cnwma1g0jjcDkrP0W
	 NpKufk2A8m8NQUP6MgFohsITNOUOtJ33nz0UbndUL3yXQ92EGmuoIpcYQihr7yManAEca
	 xY1/jhpg+JXjU+0Z65sgrjYjf8Fc2YeTCirgR7XdFj4hkNr/MXvyzVe6rwDFXD8on0Oz0
	 +wAh7bO3GdgtnyfRNtUMns3NONiKRW7WMgbrTqvGQagsvASYU5pzORts6dVH1WnOboj5K
	 x4IJVcVTHuETM+lCVFZb+iHLUPRTkc+YBZZoJ8Dab/QlGvz/gZPGkY10bGz3Ae+7FWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2e/IWy9E";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE19606C0BC;
	Fri, 13 Nov 2026 17:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2e/IWy9E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFF81F000C8;
	Fri, 13 Nov 2026 17:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590231;
	bh=q1f7wZy9KKxWs98M2HW25hRKtROknPetANu1d8o2fJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2e/IWy9EvUdOGiVfmiA9UiWUmUNQ3TGNBVPSE8VoM23p+ZRFlAqXUnDfZPL4rlHoa
	 FFjXCF10To8glUEicx2c3SVxhuzWhnALwjxkjYXfjvEmcsFGaDDn4Q5nyg++hRQlXs
	 S6kwkZpbwC22eBgfWCy8GoZf3oeBDqUiF8wtbqjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <mgr@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 189/686] net/9p/usbg: call disable_usb9pfs() from usb9pfs_disable()
Date: Fri, 13 Nov 2026 10:45:22 -0500
Message-ID: <20261113153827.409307070@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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
index 0b04363c39793..c58d57232369e 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -756,6 +756,10 @@ static void usb9pfs_disable(struct usb_function *f)
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



