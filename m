Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585368;
	b=pvPsryNgche0e8O/RdzL3+nhHXGLMpqXJD+p3hKYvU9unAeDRuZvGx6IZGrxo9CjdkMX
	 RJy5nf0OxObko9xR11SD1lv2JsS1TsoKCamJVNLj3updOBBL3TJFR1YAuXn6X5Rmq5sqo
	 e9lSeGG+hUn7p18GjKZCg1Q7AQl87rHVXCpgRt8yMHrPG0t3YY7uiA6XIVApaXBRrRUUB
	 huSLnLyn4zqjYmY+ZntULRYnOhbls6tJml5EX1Wx4MipKZqvpuz+UNRYUOgXUGBoTEHMx
	 nPDDt00xxPs8PJ/SXvUPoIe1A34HIYuKP1X86XKNL8URV97U6hkLGVQ0uj+PKp+bP1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PR13jOuUkQOmOjX92MGZKFmrRpslXALHsfsScNsRmAA=;
	b=UR1xLav9dC5oSetg7YPniYPEkHWy0z6/bbLi0LZRVY5v8f6+suUbhagWCh1xGhHwihwr
	 MCQnHSTfPfTejUECjK+teJFXkcxCGHIP82L9j9r6S2PKSbWOrQunxZmQXb+yNQRerSmLg
	 vZWVtLHqPzA4tzHJR4LdDFGxV0tQHYd1eMFKZ6x44W/xKvrPxa2yRi7hu55xbNNIZruqT
	 DZArxIJSoVspYOQKSSe2CQmkchDVK8fH5Ai/DQ+nFy+fCxGbCCUZoV/q1Op2QYOwapG8M
	 rkqWZeMR/DTDUZaGRZWYuhZwTm4XzK45RGMKJ/R9ZfRRXaU+EfoMCFGZ1Ssaxk6RvZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNPxGc7U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D968606EBBC;
	Fri, 13 Nov 2026 15:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNPxGc7U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51D31F000C7;
	Fri, 13 Nov 2026 15:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585368;
	bh=PR13jOuUkQOmOjX92MGZKFmrRpslXALHsfsScNsRmAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNPxGc7UbEW0Aps7d8Vyu3mF776jdPdpb60qjEPV9VsfFdcgShkHw9VEBfPvMSuAz
	 wx0QDVz3XJZCqBYf3+d/vNghbx2fXDdsWEMi6XhcI3EoMGp5ZX0+nXuVd9uGI/xVGO
	 fziu/mDguUSAncAJ9OgQtaLgzkQnifaEwxfibHTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Ao Wang <wangao@seu.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Jackie Liu <liuyun01@kylinos.cn>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 044/507] net/9p/usbg: fix prefix matching in device lookup
Date: Fri, 13 Nov 2026 10:45:48 -0500
Message-ID: <20261113153755.048296849@linuxfoundation.org>
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

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

[ Upstream commit 9ee83ef8d24f11feb55fd0d222c0ec19f09dbd3f ]

p9_usbg_create() matches the mount source against registered usb9pfs
instance tags with strncmp() and the length of the caller supplied source.
That accepts any prefix of the registered tag.

For example, a gadget instance tagged "secret_channel" can be selected with
"s", "sec", or any other non-empty prefix.  Once selected, the instance is
marked in use and the client is attached to that transport.  This differs
from the configfs tag lookup path, which uses strcmp() and therefore
requires an exact tag match.

Require an exact tag match in p9_usbg_create() as well.

Fixes: a3be076dc174 ("net/9p/usbg: Add new usb gadget function transport")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Ao Wang <wangao@seu.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:GLM-5.1
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Co-developed-by: Jackie Liu <liuyun01@kylinos.cn>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Message-ID: <20260607121907.12588-1-zhaoyz24@mails.tsinghua.edu.cn>
Message-ID: <20260719040346.88295-1-liu.yun@linux.dev>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_usbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/9p/trans_usbg.c b/net/9p/trans_usbg.c
index 419cda13a7b56..884d6f4af50c0 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -391,7 +391,7 @@ static int p9_usbg_create(struct p9_client *client, struct fs_context *fc)
 	guard(mutex)(&usb9pfs_lock);
 
 	list_for_each_entry(dev, &usbg_instance_list, usb9pfs_instance) {
-		if (!strncmp(devname, dev->tag, strlen(devname))) {
+		if (!strcmp(devname, dev->tag)) {
 			if (!dev->inuse) {
 				dev->inuse = true;
 				found = 1;
-- 
2.53.0



