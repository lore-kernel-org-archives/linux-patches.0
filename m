Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590994;
	b=23mc3sfSIr7hhs4vGiB5vR+29BEaCjP5s61c6WTDGTHYWIH4a7+nC0rymHhIJh1/9BOu
	 VjAkMwPZhkFKVEtYW+Y2Uz0kNIitcvHmnOc6rHYuXg+4sA6mQgDuYlouGbygyHcU/CEMp
	 0gP91XhEzktDKzhXaIoBEqILNeIppcptmgAuMoLsvJWpx8xbSSqfzOWxbX2fgan+bz7tW
	 CtUIyLtupEG+q3gxqf9lTXB+rSTxtQq4gZHsyDnIrj0JXvcYtEFYH3LtCHr1ip/TWteFZ
	 071EZCeO9mSh8PK2qMPZrEERftjvgFmrYzSUpR0Gj7t+w5xnbPHTy0owMX0kM7m5GHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590994;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GzzMvfSo17WWnZaMIRU54/BzBRHBh1RTeTJD8ALem6c=;
	b=35F88AnzZ0Fc5gACzRySe7YF3mZK0jn8DGBdKS3GfeavC/0DGRYq5etqMXGzIRQChD13
	 JZcLotOezVfkmOX04mJ23+5jAkb+4fuWNOEcA1zixBxGW+3kZy5Y5nRpaXwT01d9m+Uu9
	 +CB7qKLW84Lq2wqxmB8qayAVoNjWOg4f5exhwHr2d01Y64ayn2MI8XTsNHAD4Z38UXtca
	 Hf1MmEm76XU9/MtpJkytUC0M6h5r4EnjhxeMcKKq1CATQ6RzlpVsiXuMsWAYpC0+HwgZ0
	 mNs8Gv64VwRid1bP/uIwFaDuXxWrrP2J5D6E4SVZ+go3cqUUMkIwJG61Tt19HcqLj9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzSx0YzM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ACA607140C;
	Fri, 13 Nov 2026 17:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DzSx0YzM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5110D1F000C4;
	Fri, 13 Nov 2026 17:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590994;
	bh=GzzMvfSo17WWnZaMIRU54/BzBRHBh1RTeTJD8ALem6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DzSx0YzMe1krhlQRvjaYlKAdGQBCLET4rFr0Toc+gry364SGfLTCoBLESUV32cezd
	 w0kDjMLadcF3FSEY+khousCrWE7VlmiIUl2tmwU8XGpMwh4r+dPezjR4JdZufmsfjH
	 yKJ6gXlGV2z+A/SMTAFksQhw/JYAhd3xOqS72YYs=
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
Subject: [PATCH 6.12 168/670] net/9p/usbg: fix prefix matching in device lookup
Date: Fri, 13 Nov 2026 10:45:32 -0500
Message-ID: <20261113153817.767297261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 468f7e8f0277b..59505d2388f52 100644
--- a/net/9p/trans_usbg.c
+++ b/net/9p/trans_usbg.c
@@ -389,7 +389,7 @@ static int p9_usbg_create(struct p9_client *client, const char *devname, char *a
 	guard(mutex)(&usb9pfs_lock);
 
 	list_for_each_entry(dev, &usbg_instance_list, usb9pfs_instance) {
-		if (!strncmp(devname, dev->tag, strlen(devname))) {
+		if (!strcmp(devname, dev->tag)) {
 			if (!dev->inuse) {
 				dev->inuse = true;
 				found = 1;
-- 
2.53.0



