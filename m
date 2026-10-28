Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216654;
	b=3+cImA/BJZVl+e6BjPxUDmHb/UmS03pLgYYbSvuSKVShLirKTx/xkc3p90ijdx/pE3fY
	 6RHM/exBU3R1OQBnN+KuABaWbGU0T+RFtOCbVHGzQuSBU/dH1SYU3V1SwrS5Io16w0k+p
	 NdvOD+34S7LZKWfKHIkRd1pdpCwTt0QnL/mlG8ZY2L4IZru3jgfKrjuF60+k4A2S9S+Wq
	 6LnzNue0/zIh9OBFo6++RA16ABz5ryiddFg0KZhFSg1c33k/vvfKIqXtE9RWOSyZDvPTf
	 Qb45H/s30yEIt3utDZYnrOGLXzB53BIFH0pWRuE3gs7AXmBDXJpYhQ8Qjzk1WP5nbWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xmO2r12IhRLXCIil/mNqVZpSpH/784kjKhZWin+3qe8=;
	b=gYQ9/UfzeVHUtQE4ZeAFqZwBXXU/IyGotlsx2EA/3gorFFeeDM7hNMdLvhdc+v2nO09o
	 VjzX2fqXj4QqdPFjjMTJBgiqGIesYJu43DgMvEWmjlAc/ddst9dRhJEp0ELmM0/xTle5w
	 Vn7PGXg1gN6bkf76rTIi1ia0YVJP092Ga7aZI2+WsrbkguUUTJigZromrx9wdY4xRS5VZ
	 vposQasAa4nYeWBv4N/aumpJsJ3qFJKR9kBTAnPS5C0IauTwrowsLYQbXROar/KLsM5Hl
	 BIuxW96Tkr942cShwhcYYKy+/jkMP72tW3qoMNNGgmy/LDaTtgCqJlSNMG+CCg7s3pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBkTPU2u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409F9606A31A;
	Wed, 28 Oct 2026 19:44:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lBkTPU2u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ACE1F01825;
	Wed, 28 Oct 2026 19:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216654;
	bh=xmO2r12IhRLXCIil/mNqVZpSpH/784kjKhZWin+3qe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lBkTPU2uoO9zP/ZIZ+V6umI6K+K0+YZCwxxegrofRejukqK8dGhECeDilS9Vmfj12
	 0eDo61AfwI21FgzNjIUowZexagq8oaHST6KfpDUIGls+iJPXoyQUJ3AhDyWcPzLTTm
	 f57lJW89DL5/skGR0P3C/2YrXLOq8gWFBRZB/gQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1631/1887] platform/x86: dell-wmi-base: Fix handling of ultra performance key
Date: Wed, 28 Oct 2026 18:02:07 +0100
Message-ID: <20261028170536.581014008@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit adfd6846bea13667ff28f8aaf00c32fbd69825ab ]

The commit message of commit 5fbd827eb9c2 ("platform/x86: dell-wmi: Recognise or support new switches")
states that the ultra performance key contains additional data
after the type and code fields. The event data passed to
dell_wmi_process_key() is already parsed, so "buffer" already
starts after those two fields.

Use the correct index for accessing the first data field to avoid
a potential buffer overread.

Fixes: 5fbd827eb9c2 ("platform/x86: dell-wmi: Recognise or support new switches")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20260612173451.467629-4-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-base.c b/drivers/platform/x86/dell/dell-wmi-base.c
index 713ec2c12a04e..4838992ee5f99 100644
--- a/drivers/platform/x86/dell/dell-wmi-base.c
+++ b/drivers/platform/x86/dell/dell-wmi-base.c
@@ -442,7 +442,7 @@ static int dell_wmi_process_key(struct wmi_device *wdev, int type, int code, u16
 				      SW_TABLET_MODE, !buffer[0]);
 		return 1;
 	} else if (type == 0x0012 && code == 0x000d && remaining > 0) {
-		value = (buffer[2] == 2);
+		value = (buffer[0] == 2);
 		used = 1;
 	}
 
-- 
2.53.0



