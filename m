Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84A23557E8;
	Tue, 16 Dec 2025 11:57:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886237; cv=none; b=esuASA9L04t6eqwLdI1pPMG3bNs6o30w4VJDgDn4h6t7RSV4VLz9/YyjYrWFiVZy/8gkh+zm7sB8lXbfFwqzU9wpwrOkLtTTZfAVylhC02v1jnWYS70mZwx8Ax2WkwEm5AnryhA9oyd+UwR9P3YXMYJW2rgM8wCuCNdLUnDHKS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886237; c=relaxed/simple;
	bh=zZJmAVKxlSgYLkQBtn36OYh/HRTC/aqIpXIGCMM7XV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDD1k9YJx+SEztTXVK+hJUlcwmfTZ13X9IRNSZJaqGbLqFOx3EhWdSBezxGXTRHrwM7pfwZIiIszbbzXo/olzF8ubSornlLybhOrbHwJTqURXDjGUjKoTautkqJif0pGwIm4AvgNvF9PaQqBcEUZoFTnEiHMphvCKpK/FVwlKyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ya+Bsp23; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ya+Bsp23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5781BC4CEF1;
	Tue, 16 Dec 2025 11:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886236;
	bh=zZJmAVKxlSgYLkQBtn36OYh/HRTC/aqIpXIGCMM7XV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ya+Bsp23woZR5s2tmBA5MGEFVLhEiBK+7wI3DO7DxPIJ7jf45PdQ8w3FVfEFg1k0q
	 rtaxJSnwQYMzzPyH0US3sXUfn+XazVZW7iS7PXboeSYdU1hKYz8rngMBlAl2DunaKG
	 ftvNOUj2JWULXQZCXpW6FTDmBg256IwO6vEW/FDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 377/507] virtio: fix whitespace in virtio_config_ops
Date: Tue, 16 Dec 2025 12:13:38 +0100
Message-ID: <20251216111359.118507575@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 7831791e77a1cd29528d4dc336ce14466aef5ba6 ]

The finalize_features documentation uses a tab between words.
Use space instead.

Fixes: d16c0cd27331 ("docs: driver-api: virtio: virtio on Linux")
Message-Id: <39d7685c82848dc6a876d175e33a1407f6ab3fc1.1763026134.git.mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_config.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/virtio_config.h b/include/linux/virtio_config.h
index 148dc5056002f..f8a00a780a44d 100644
--- a/include/linux/virtio_config.h
+++ b/include/linux/virtio_config.h
@@ -86,7 +86,7 @@ struct virtqueue_info {
  *	vdev: the virtio_device
  *	This sends the driver feature bits to the device: it can change
  *	the dev->feature bits if it wants.
- *	Note that despite the name this	can be called any number of
+ *	Note that despite the name this can be called any number of
  *	times.
  *	Returns 0 on success or error status
  * @bus_name: return the bus name associated with the device (optional)
-- 
2.51.0



