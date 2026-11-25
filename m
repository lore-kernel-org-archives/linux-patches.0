Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618067;
	b=pxmndlIOmjQ8OT9rFwsWhn7PDWCoG/tNhIKrTw/eBrHr5P0BcPsC5VbycuUiqDh2jb0z
	 mbAzA8JbXoY3lk52nnsNN1cNMWPaDuASSYJVKqj+ZUQtPq/zt2SUnH/TUuBSshZaLuPxj
	 uNS52Jg5OdDRuklRGFeoLiN8pFkHsdDU7gYyLN89NRmPepqnaMwL9WkobC2tmsBOanUC+
	 vZ5LOAtiNTaKUMR+2IShFw8bEPiiPnK+s0VZ1wfdYFmxlDEMGggODTwm4E+PRkcy1zdRo
	 0Vay40WRJL1HPGAi1k7b2AVykuL/28JpPUxB+uvq1rtP85SX43aS9ZCTIkjCA90OmZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618067;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dB6YfCfhe1RVK9QyhV8S9X0EwPuq1bA2AIErUP6kw0I=;
	b=1wbJAHUCLrtftdje8OvVzAXngO0IQHWNymt1hFr1yyIf5o8gXh2GgCqkS9wr9JnkQqcd
	 S8KQCtAvc9NwBbdVipSR3ZNIrPH/0MgJreqnE8WpRTOX3naJJ8bL+exRO8g0m+H7nENMZ
	 5ImbbNfcFu3mBZILehzCHU/y9NKQZTHWShalwUPfYYwd9CSaHRagFyyImMQrz5iOIgokp
	 8DvclfD1FLw+uPHnNr6FeoQsw2YHqj8vquV+1bwbTjXJ0i1EawfkR5cGLd6psh8h5pd60
	 OKGTK8wV9suE+rrpC1OXTdQDmqA5qT+0UW3ygA9yrbXTInstF7V42Yd+14z3bXLKYUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1tJPGp3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC61606A31E;
	Wed, 25 Nov 2026 14:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z1tJPGp3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF951F000D1;
	Wed, 25 Nov 2026 14:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618067;
	bh=dB6YfCfhe1RVK9QyhV8S9X0EwPuq1bA2AIErUP6kw0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1tJPGp3vWd+smAxX5IQZXsmACGlObpgvAh573BRQnVjWwqwbG/CckKQb+bYYidOH
	 8n7vol1SwD4XMNkHRK6O7RpX+pCX9Me36xrVbsQf/b1GxdSwBn2ukHvRMCRsUTBYPB
	 62Eswc4mYz9BJ1hPDACctC5aQvk82y954IFYFcuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linfeng Sun <linfeng.sun.dev@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0160/1005] vhost: reject invalid IOTLB update permissions
Date: Wed, 25 Nov 2026 15:24:58 +0100
Message-ID: <20261125143825.488252600@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Linfeng Sun <linfeng.sun.dev@gmail.com>

[ Upstream commit b179f21d2d8a60ede29a00472bffdefb0284ef39 ]

vhost_chr_write_iter() validates the type and size of an IOTLB update, but
does not validate its permission field. An invalid permission can therefore
reach perm_to_iommu_flags() and trigger its warning in vhost_vdpa_map().

Reject IOTLB UPDATE messages whose permission field is empty or contains
bits outside VHOST_ACCESS_RW before dispatching them to a backend.

Fixes: 4c8cf31885f6 ("vhost: introduce vDPA-based backend")
Signed-off-by: Linfeng Sun <linfeng.sun.dev@gmail.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260913-fix-vhost_chr_write_iter-v1-1-76bf1f436cfe@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 86126e2ea8cbc..8afdd43d313c1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1750,7 +1750,8 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
 		goto done;
 	}
 
-	if (msg.type == VHOST_IOTLB_UPDATE && msg.size == 0) {
+	if (msg.type == VHOST_IOTLB_UPDATE &&
+	    (!msg.size || !msg.perm || (msg.perm & ~VHOST_ACCESS_RW))) {
 		ret = -EINVAL;
 		goto done;
 	}
-- 
2.53.0



