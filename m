Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214782;
	b=fltfWH3AKTyCkALLUfKlLzbjAx365ze78rWLTDKHO8IUTxxqWqqO3ikeiRSXsaYLPa7A
	 jIcQsZOrDSN4WVSiU2DVnjnfqHMervKj6WwdIzQMxH7cTbsswcj25tJqQAmnOXVxhkTNZ
	 H8VNqHN/57WfvyqKtQzTnwsbkeOG0wjUg+Lj0v00DSZqzy8PX75LPsrvj+dyYVCr0gJQZ
	 +ZiY6iF5WlqTSAYmeDoZ/7cFJMPHDTotNHwyGjPpdWeEdxtoh+GjLrzWWMALueoexklL1
	 tYyi+2JDEKxesy1yYVpjzzbEEA7TbiEnJWNvdjRiSKsEbTaOq5/lR5BArMXhqdAmZBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214782;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=xI0heFA8g2SN0Swp/v19/MjTFiQKmiaSa6GZtI0GIdQ=;
	b=zOh0R8MJmd6gzORrvvLnrKvatek2ZFkmOebgoED9EC8lNADN/4++AE/+BpMwVN1UNNes
	 BC3KIdNoElFsuTtE+rQMxWYEJ9XIw+6Pzjt5e9sRp56sLtzwvAWb5BPmo1MwNZeCvO2Ty
	 SyEg2Stc4Nl3k8oYofQYDOlBnze3eT3iCDboJd2SiY720QTTV4q8w3uvKQEmBB7LoPMap
	 K+A9P9fEcKEC3TihoyuypNX9svQ88iinpfd2oQmUv0bcC8dyDlDiPhaYEbDKAyc1Dxq+x
	 fEwLreuwbOL/k1LpL3P0LVrVwZSRkM0dOuQJwHX2gGvc7LMRDnOkP1C4DVjOfOlHN2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvI5L7+m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72AC0606A31D;
	Wed, 28 Oct 2026 19:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JvI5L7+m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBF81F01828;
	Wed, 28 Oct 2026 19:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214782;
	bh=xI0heFA8g2SN0Swp/v19/MjTFiQKmiaSa6GZtI0GIdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JvI5L7+mp/i47Lh6vd4378sWs2BAe7KoqgkCDILW5Irw8mZOVTkFsntPyUBxIpr7o
	 /zwaiWFJEZFJmtsfzgC52hxlQWNxHmXkcEDj/iVQR0lNpW5SUjfdxAcCwwl6YPZ0e8
	 2JB0L+M+BmHjxdzYgef5q4+NjgSJXw7Fl+WTK78w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0979/1887] HID: logitech-hidpp: Prevent use-after-free on force feedback initialisation failure
Date: Wed, 28 Oct 2026 17:51:15 +0100
Message-ID: <20261028170521.688598689@linuxfoundation.org>
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

From: Lee Jones <lee@kernel.org>

[ Upstream commit f7a4c78bfeb320299c1b641500fe7761eadbd101 ]

Presently, if the force feedback initialisation fails when probing the
Logitech G920 Driving Force Racing Wheel for Xbox One, an error number
will be returned and propagated before the userspace infrastructure
(sysfs and /dev/input) has been torn down.  If userspace ignores the
errors and continues to use its references to these dangling entities, a
UAF will promptly follow.

We have 2 options; continue to return the error, but ensure that all of
the infrastructure is torn down accordingly or continue to treat this
condition as a warning by emitting the message but returning success.
It is thought that the original author's intention was to emit the
warning but keep the device functional, less the force feedback feature,
so let's go with that.

Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 37fe852dd2da9..ebaca3588342f 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4278,10 +4278,12 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920) {
 		ret = hidpp_ff_init(hidpp, &data);
-		if (ret)
+		if (ret) {
 			hid_warn(hidpp->hid_dev,
 		     "Unable to initialize force feedback support, errno %d\n",
 				 ret);
+			ret = 0;
+		}
 	}
 
 	/*
-- 
2.53.0



