Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063440;
	b=0eDq2Vrddwe1VBRXIHgs+5FvIWSxAXeiATbwmtnfiQVLazmaV/0/syyDSVDrG4DTsSwM
	 bils8JQ4m0BZWw7Wmu/seYygIeP9jjL/Ipy3XnEJwjpLntRIo8dSkhEwVuvkcokS1A+Ce
	 I7ZGj6h8THmkl9loKi1BUzKodLRygDrq6lR05HXbZRHrnb/opE8TwVUdP961BBH92dr8k
	 KyT5Fo1ItanjXjZKohP+37+YxBOBgiEzqY1AZpRXzXlsTrPeAVFzwuPZWQL0CI0IhPkuT
	 ZNSOhrWFrBpwprHL6kjSxC7Qzlt63bJQ5SAze/weRSmozI19toQCNGRpBXTBubLVujQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gkb3LLXKS/kW2fP3zgSQxpbF+LCDiB+yC/XoSjmoubY=;
	b=EgJRlD1ZXCwTlSA+jBA3eqC4KagRyt9FnrJlQ6LmzHO56EN1mhfafqnsx8Pm6FzdZowt
	 FWd4kWW45F9M8txdWnmyFRFA1jWVonP1wC2hM5Suhj/O5kPimNIVeUQeWVznOn1PrdSSI
	 JaaYPOBgOeq8wcuA8QIqvSmkU62BoRp/f0xgvW1K+QrL7KqzPRtur0/fBdxWA9CpaHLmN
	 2tjrBRW+MfTZoODxbB6omAv7EjVaJVcRi4CwlOquyIs4yu3onM+Kf+42o+4rqPjceoRHh
	 YGjHeUyVERVP5//u/NkcxSCPi8XOs7F41OfIGUOcSAWK3H99cIxqftuyCu4N/ydBIbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cd3BO0l6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A0606A337;
	Sat,  7 Nov 2026 14:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cd3BO0l6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0391F0089F;
	Sat,  7 Nov 2026 14:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063440;
	bh=Gkb3LLXKS/kW2fP3zgSQxpbF+LCDiB+yC/XoSjmoubY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cd3BO0l65TzTNdR0Bt7DF0qee725BjuQMl/NH0pzz0l6VNpB5LQdJuiBUR2J0F816
	 AeUxmDkDuyyIqKqKzAPaiJquOInG78mu7edY5/lGqN7g4jgWK2u8xWuy3Zb65kV1CQ
	 LY3/sJBsMmHL7z/rEzv/k6s4LpU33/4mhd7yaWCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 565/869] Bluetooth: 6lowpan: Pin module for 6lowpan_control debugfs file
Date: Sat,  7 Nov 2026 08:54:07 -0500
Message-ID: <20261107134912.435084786@linuxfoundation.org>
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

From: Bui Viet Dung <dungvn2345@gmail.com>

[ Upstream commit 8368f0c2cde48c09ed70644059f24172b0c59f52 ]

An open debugfs file retains lowpan_control_fops in the debugfs proxy
state. However, lowpan_control_fops has no .owner set to THIS_MODULE.
As a result, full_proxy_open_regular() calls fops_get() which succeeds
without taking a reference to the bluetooth_6lowpan module.

With CONFIG_BT_6LOWPAN=m, a userspace process can keep the debugfs file
descriptor for 6lowpan_control open across module unload
(delete_module / rmmod bluetooth_6lowpan). When the process subsequently
closes the file descriptor, full_proxy_release() accesses the already
freed and unmapped lowpan_control_fops table, causing a kernel page fault
or oops.

The issue was discovered via manual code audit of
net/bluetooth/6lowpan.c.

Set .owner = THIS_MODULE on lowpan_control_fops so that debugfs pins
the module until all open file descriptors have finished.

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Cc: stable@vger.kernel.org
Signed-off-by: Bui Viet Dung <dungvn2345@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/6lowpan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index 3733f408d2e40..0660d306cf4f7 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1207,6 +1207,7 @@ static int lowpan_control_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lowpan_control_fops = {
+	.owner		= THIS_MODULE,
 	.open		= lowpan_control_open,
 	.read		= seq_read,
 	.write		= lowpan_control_write,
-- 
2.53.0



