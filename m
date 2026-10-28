Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208477;
	b=HX864lb+KjgT65VgkeWc0E/gy5wh4l1i39OzIu+v0Cuf51kjRoLgSHvvAmiA6DRAsLoA
	 E28gwBzR8WxHvveYY3XKVPV7V6xhrSQEb0RN5V2gFnbt7gfhBzuGR8HA6+yC2o7iXOEVY
	 xnbDMqPGACQGSXbAZsu2g1w2Peyo7LB7vH/slWLMw9EwRSDEbXGuCjR4pq4cHQ3Otneb9
	 4POTOddD7yJVQjs4/gTZWj0vUjCbHPpIVRru9fRVuHZgO6X0lE0F9+NPUil8LCs66FbDl
	 A4E8YpjkKXKBCwPZ2MyFV+xXHCW0k8MKCux2b9PxgD5iiLRcF9+VdGfifIoXP+zyFpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208477;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tp41+kWzjGbIhf/xhL3eqVe5QB4VXe5fMpNrTeRTKS8=;
	b=krAx+YIE4tWLhcrkNSe0Kg5LNCvpcI4cRTRJ60JJ1vqqGDmxMIP6VeeFI8yr/dQiwOD8
	 aFyXMscQ5OPkXPV38B/nDGvqHoCkU3Ql+UK5mLQtYo/BINQRliE80lfiMDaFCoH3IUvWC
	 HmLB+7xHez66O5428/yaAHFrDXw9NdreeBHQg21nJ8aUYW63NIM2UHiZleTSDz3DtIBSA
	 FldoAS1U0pvcq3eS9FSB9dzZ4ObCk7FYjoSUFgfZ/zReAoQteWZhcyUJz02ZipVFW6c8l
	 mpStMilIo6US7NgWMkpRPxBTMzKPEdDGbNiaIknqJkgmqs4FydDK4fDOOm6B0/ecLew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCGMnrVB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D3F7606A31C;
	Wed, 28 Oct 2026 17:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCGMnrVB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE5B1F01828;
	Wed, 28 Oct 2026 17:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208477;
	bh=Tp41+kWzjGbIhf/xhL3eqVe5QB4VXe5fMpNrTeRTKS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCGMnrVBnTWVeFw3cfmma60PZpe3E4NgFGiybsinjVKpck2ki/C1PvnL9IzZU210f
	 bLVnLi7Cwa9O0DHRTrIexIhqXZ6TUCTnO/pg1wqNxvwISEGHpyaKYCt8RtWVDIhf4L
	 OsUBJzVFcNZ/23jSpu9ZBoUfxJh6TAwXWVW/Dr80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 132/516] HID: hid-alps: Use pm_ptr instead of #ifdef CONFIG_PM
Date: Wed, 28 Oct 2026 17:54:44 +0100
Message-ID: <20261028170006.638852061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit 5e130f58629a2819c9d053507ad368160d25eb65 ]

This increases build coverage and allows to drop an #ifdef.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: aa9dde93e05a ("HID: alps: unregister DualPoint Stick input device on remove")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-alps.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-alps.c b/drivers/hid/hid-alps.c
index 226b504d6c701..754e30f455014 100644
--- a/drivers/hid/hid-alps.c
+++ b/drivers/hid/hid-alps.c
@@ -845,10 +845,8 @@ static struct hid_driver alps_driver = {
 	.raw_event		= alps_raw_event,
 	.input_mapping		= alps_input_mapping,
 	.input_configured	= alps_input_configured,
-#ifdef CONFIG_PM
-	.resume			= alps_post_resume,
-	.reset_resume		= alps_post_reset,
-#endif
+	.resume			= pm_ptr(alps_post_resume),
+	.reset_resume		= pm_ptr(alps_post_reset),
 };
 
 module_hid_driver(alps_driver);
-- 
2.53.0



