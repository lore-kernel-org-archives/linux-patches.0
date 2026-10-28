Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210584;
	b=cBlEFiGizBKgnLBPyqGmII6cvABXf2GCUyiblc3xrN5M2R4RG8hofJjA8/9nxX7sn8Dd
	 iYCh5BtJ23agViv8ywwbG6BtjzkTQ4asFM9mV4X1AON3J8y/IZkScFYH+UFI+1tYQ8QQP
	 Vr9gKIT52WUO6oRcUC3iJ0EjCBz+LTaSXymcdzW07b1OcjUJLOsvWYD11gAyjhedEjyfC
	 H2n6iNpf+swzJBZ0W3jgjCE8x69cRcLnVltt12edigS7KPnpeijyhizIwUzITFivo7anM
	 ai+QbXm4b1iWkmA8mYPsI3fgwzkXbaXSMC8+uRSOcrkzlDuklxRvFNLAtrbDDHL8tpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=H2rZge/iPJhJabySBJEsa8h1xfXB1JNoXweLYP4CuaE=;
	b=fE77h90ADrBe+CtZ/9rOs9CGEXLsohYTrlk+M894+3ewe7XU8k8omdIK+R2oM3FVCfKM
	 6AsthsGDlXeR9t5FBAEc98E9ODXBa7v+6mkS/k6QzGBaWWqjNGaZlyzJxDf8jHsn0bSBp
	 IuMszPmB4wu5wVdxnqnkB9yxxirP/ZaqzgsZJLIdCPQy47Z0G0QwrUe1s8kIaepjVXRiN
	 aUZUJy+RWAAreeZcWyLFXOpG8eTeH/Ow2efVfJrcaMT1A/s00pdNHxqBYVNEOMrakyawr
	 y4U9B9sf0ESnzC+o03uMZM3AXD/S2m9/pDNO3OXn3o+zNA+lKGMVtf+T1a0EepvkFcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZLyU4Rk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6457606A31C;
	Wed, 28 Oct 2026 18:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NZLyU4Rk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314841F01825;
	Wed, 28 Oct 2026 18:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210583;
	bh=H2rZge/iPJhJabySBJEsa8h1xfXB1JNoXweLYP4CuaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZLyU4RkalLQCOm2vfTHOu69qctwxr19l1welVQTVubhH7dbSMXDgxoCHpnLcMlyS
	 ZHZ1RwJxpHtRqLUVOmaAXAnEf05Rwoxj+fa24HbCQ3QTIrPQHxQ//gBLGUSlTf6z+6
	 gYXS3fX2gtej4cVCl0YkQj9V414f/PpgX0MBQCKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+791be35f1fbcc85d06d7@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Jeffin Philip <jeffinphilip14@gmail.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/571] usb: gadget: f_mass_storage: fix null pointer dereference in fsg_common_set_num_buffers()
Date: Wed, 28 Oct 2026 17:53:42 +0100
Message-ID: <20261028170009.806879917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeffin Philip <jeffinphilip14@gmail.com>

[ Upstream commit 2c0f5ca48674a5b5f9fa4a9c3325aa48053af0bc ]

Previously fsg_num_buffers_validate() was removed as it was not
necessary due to Kconfig setting the limits for n from 2 to 256 with
default as 2. However, setting the page content in such a way that
kstrtou8() reflects n value as either 0 or 1 bypasses these
restrictions leading to a null pointer dereference if n is 0. Fix
this by adding a check for n < 2 and returning -EINVAL if n is
either 0 or 1 consistent with Kconfig logic.

Reported-by: syzbot+791be35f1fbcc85d06d7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=791be35f1fbcc85d06d7
Fixes: fe5a6c48fd95 ("usb: gadget: storage: get rid of fsg_num_buffers_validate()")
Cc: stable <stable@kernel.org>
Signed-off-by: Jeffin Philip <jeffinphilip14@gmail.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260818035904.10324-1-jeffinphilip14@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ adjusted context to retain the branch’s existing kcalloc() call instead of kzalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_mass_storage.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/gadget/function/f_mass_storage.c b/drivers/usb/gadget/function/f_mass_storage.c
index 42cd7112a89a9..b20aabf3fb2f3 100644
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2592,6 +2592,9 @@ int fsg_common_set_num_buffers(struct fsg_common *common, unsigned int n)
 	struct fsg_buffhd *bh, *buffhds;
 	int i;
 
+	if (n < 2)
+		return -EINVAL;
+
 	buffhds = kcalloc(n, sizeof(*buffhds), GFP_KERNEL);
 	if (!buffhds)
 		return -ENOMEM;
-- 
2.53.0



