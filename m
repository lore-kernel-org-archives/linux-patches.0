Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037284;
	b=dGEV5dtSyk1XMPiotZu7VQu/+nLeZokJvmcAkumUIejHZGj05HRZZV1ncHhzpJG3wc9z
	 lLWN4eO15G6chlmGAoSsbzffqB2DN2G8NaLbCHMPLuuNRbGG3tSubPPI/HBCBMLCGpyCj
	 PQD3SqQ2ilaDa6SsDbELPh/MLj80uH2onJE963lecsjtlbmVrKqrCOLIckamjkVf1xW1H
	 Fgu6ecaWu6tuBbQNq43cLtthKtJU39TR6GhoikX/wvUFKuWq/s3i8Ecj66hGCjYUF7xd8
	 +fwl3c7pThkV9Ks9uYdVGYSqYmPij3lCwGyZjC83CYGZqiyLf+wnkGfoV0HcyRtx0ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L7O5A6A9E5FDJZNSRGZF7pXiukrvbtXubeHA9Fnx2zE=;
	b=l+6u533foqtHMLDjmctVk97QEL8YZylRTy61bo7PIIElKw5xpxai0UXt1DECjsYCl/6s
	 pMIByKSvP4tJNjx1OsTdE2aPpxg6rnw/1V7MTqmIjaIQOwzR1r8S8MhiCslHt55+HRX1W
	 qyD927Ui9lAXkNW6J+TaGLmtyd04rrePC56jKoacenUaT1/B7Sx1YPQ+lUMyk6TIFssNs
	 MIHrx6Xm2Ax2JBRTOq2XtPv/UkZ+p/qQlUl8y4WAFNkprSvLynNk/fWoRUZiOgVxqA7/h
	 NU5ov1Vwe1hMlRSp8pW48DmNzDeat0R2gNrZtLLUvRQo0zjDVSG1Sc2JJVFseNOshug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhB3UcaJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48029606A31C;
	Wed, 18 Nov 2026 21:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DhB3UcaJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B861F000C4;
	Wed, 18 Nov 2026 21:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037284;
	bh=L7O5A6A9E5FDJZNSRGZF7pXiukrvbtXubeHA9Fnx2zE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DhB3UcaJYPiKYFMUEDPqdKhHgn4kJARFOpDZcfelv/JkHariusyTg5EQ+OucKmwVC
	 Gh369l0e1cUc7qtGASlfPGRhfClKHVMFljulGiP6+U6YaGoloE+2Z2uZRD+Z5uAN+O
	 te0wjl7nX0Ekeuox8eLiD7EbS/tzNhhpmgGj/OlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Breno Leitao <leitao@debian.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dust Li <dust.li@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1336/3318] net: free_netdev: exit earlier if dummy
Date: Wed, 18 Nov 2026 15:32:38 +0100
Message-ID: <20261118150400.435784051@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit f8d05679fb3faae478d604177b0c188b340371cd ]

For dummy devices, exit earlier at free_netdev() instead of executing
the whole function. This is necessary, because dummy devices are
special, and shouldn't have the second part of the function executed.

Otherwise reg_state, which is NETREG_DUMMY, will be overwritten and
there will be no way to identify that this is a dummy device. Also, this
device do not need the final put_device(), since dummy devices are not
registered (through register_netdevice()), where the device reference is
increased (at netdev_register_kobject()/device_add()).

Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 19d3149d320db..5840a526af08e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11099,7 +11099,8 @@ void free_netdev(struct net_device *dev)
 	dev->xdp_bulkq = NULL;
 
 	/*  Compatibility with error handling in drivers */
-	if (dev->reg_state == NETREG_UNINITIALIZED) {
+	if (dev->reg_state == NETREG_UNINITIALIZED ||
+	    dev->reg_state == NETREG_DUMMY) {
 		netdev_freemem(dev);
 		return;
 	}
-- 
2.53.0



