Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590170;
	b=o+76iaGkQrwih3vF7YcL18ijIz2shHikAy5NCu8HYHWD2zvyVQip1+1ML0sf/ApVkPkH
	 ytrDcvPiB6TW3DkC0G3gDZH+HTSe0OeT/Ik6olwlQ3MixivfoOEWBvU/BAFLcIg5RrOoq
	 OnRhY9ZTfI5193TKW5HBuIRIuIycG5Brp3psF6XLjbiC8JNTN4GRrSSgMR7qRclHAxzXC
	 ellgXYm1TGsdyXR30ioGtU4GdLQTOoyRvADsBxmLn1+Xi+HQ+aH1gyVP5rOUQBlQR8Mc+
	 CAydddrF2adrDUI0ncUvcpuryd4SH+YoQAcaB9+iNhdeGyLAS/FpNE+JK+/b4Uyy+xQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ydA2C0cdRr98BkWsJMCVp56p1KMTp33nM/ZfpyfQ04Q=;
	b=d/mH9+FwnXMyaJmY5M0os44eiOqACAN4HrXT31xHVl28uG9B2i99t5DaQCGdEd2FbaF+
	 wvaYVrLJ2645Hf6ECz6ml1F9mFxqUcAHOhU/rtz62nWPUoSoKPArzBuiwomBEU5AiCTXL
	 e1nXf2G8IK4ZZHap2EL5nu+VtcofK/QYz9G2vABtiiTL3KxepTy+eKu5iLbhgaL8LEb6l
	 OoBwqaNQQyZ4K1V40C7bORw7r+q3cNfDHu6rmFX/pNhffWB3Qo+LbQoMGlyVt+AVrG9r5
	 lZeFZRTJvx2N2Ksw88WPvTw2cxmvYHn/Z7W8DeDFTgDUvy9qrEvYH8eJWH46hI+onww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8ltf6AX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CDF606E64B;
	Fri, 13 Nov 2026 17:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d8ltf6AX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD221F000C5;
	Fri, 13 Nov 2026 17:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590169;
	bh=ydA2C0cdRr98BkWsJMCVp56p1KMTp33nM/ZfpyfQ04Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8ltf6AXnFQ9w85duQU8/2T4gTdFSKwTQOZtCwNdHric06VeL9lMcBbYm+qr4v/jb
	 jmjo+pK7sjhxhgdkgFpZ145MChiObvoPbs/VtFUXAMGjAPzlBeJVCURsEORMfxh/Du
	 w9J7VkhW0acWWf5zAUpSCzrbW47gMqvsj5XxryBI=
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
Subject: [PATCH 6.18 179/686] net/9p/usbg: fix prefix matching in device lookup
Date: Fri, 13 Nov 2026 10:45:12 -0500
Message-ID: <20261113153827.077039318@linuxfoundation.org>
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



