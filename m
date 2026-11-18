Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052649;
	b=ckpOfkK38HVG+6IMrKbQ/vM1jMA5PQGAWxTBhB661tLilvGq4fRAdzkb3gVDw0iXwdQg
	 UTUDyooIordZYpZeC4VjFtKHpvude7sRJBa6cZ/Ydt2AYcUOIxg8nB/hvI0mtEYLudi/c
	 a6Y6WqMr829U/DTCaIRo0ygWeQkoOjNO+S/3ot+hK0qrQ9NOdHN9m/CpnsOXz68YGmkay
	 je7c1EZkVIrr7YZUbuNCdxmZYe36NqA2u37hLG7GIhnp8a55icrHcsF0IT5+ul4dr9fLl
	 9RprxZ+Ew/+V3n8JWM0sQTCnB78Pgp+3YwaL/bhMLuj6irkoRrPPcIeWx6rPXUG9NLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052649;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ijug4PaV6OtI3bRyTpf74vtA/G2YwPbmrdu9dMH15ME=;
	b=eOlIgvkKFsmPN3BtjYsAwD/PFpkfbHqDE7CoP/MHTM0bwTKqXOT8eYAkb3RqVxEqDbv2
	 72JyAqQNMVxab9NfnpD1WMVNLA3TWL5Nz02z9JVTfPExZM71SvcDncxHhZ/+RNBVQa0Qa
	 nSIOTMYFEeza2ayzGqpnlWfkE9s8GNvm2HZv7RgXOg9PaSmvdo8OKHCF5u++jtJ1XFmbu
	 Ri7YLqLjMUQ2id3szX7uMY1UFSbz2HggpXaT2fBsRnNFmGUxPVWIOHfVfQvhaBMogWQbw
	 cAfNGtnu6FiCnllhR6z2L3c/I6V2OVKGeAu1ac8iCSJFL8p9dFbOfVpRBXzInlQ4LsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6o3PcrE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FF5606A325;
	Thu, 19 Nov 2026 01:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t6o3PcrE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E39DF1F000C4;
	Thu, 19 Nov 2026 01:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052649;
	bh=Ijug4PaV6OtI3bRyTpf74vtA/G2YwPbmrdu9dMH15ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t6o3PcrEAWCIFFI39gAHafTbfZ7fA2vL9KpwgLPisF6mH/mK+y7i1qFiNrn0MdRAn
	 dNsHszaG+nzR2mhLCz2NzoPXJJHrF3InLpUEyAYCie2i5XBowDABSCS+TZuJnUBUDZ
	 u6pX8ss7QjBpoqEDNG76gshZ0c3zIifx46HoiX4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bui Viet Dung <dungvn2345@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0640/2214] Bluetooth: 6lowpan: Pin module for 6lowpan_control debugfs file
Date: Wed, 18 Nov 2026 15:38:36 +0100
Message-ID: <20261118150036.944789265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d0b1882f5b4b7..b5ddd88f411fb 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -1205,6 +1205,7 @@ static int lowpan_control_open(struct inode *inode, struct file *file)
 }
 
 static const struct file_operations lowpan_control_fops = {
+	.owner		= THIS_MODULE,
 	.open		= lowpan_control_open,
 	.read		= seq_read,
 	.write		= lowpan_control_write,
-- 
2.53.0



