Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209236;
	b=06+l1zW+1vIXPaCnZHQJwTC9IgCTAqeu49W8g4Hit3UxOIUuuY9zSE0SdGB4VL0ZYU0e
	 rUNki92h8rzbwFy22qAU+gOP9vHTue+Ix85i+Xc8FCI2wzrGao9+ZKQy77b9/tlsFMdIS
	 pTcDV97KMSDvNCMN5ZUImihWlOmXvKmCMh1ZJp6huk8DAcbik8HPceahgZoYJuf1cZ3fT
	 IweHtjM4PqABkLEeOPR9F0fJ3WGHaNiALPzIHM0Oz1hTvpWYRs2hCTpxoGLONcdBbcn+z
	 aY7Di3DAo9EmXdTsQuWw8hYu81JQiCw/4QxntyzH8Y1kNyUH/xEChxn09cRoWlrs2rA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3/Xydn463h5hd6TkD29zfS5T/BT7RgZgR8LPzrN5MM8=;
	b=OVoj3+FSNHr6qEfUxAY7WXt6L42qNRKd0J+PYhjH6/m1iL2HZYzP/Nicqt5BPBPwotds
	 7N0Ve7/EECtbqKvfLjf0j6c9YRsAHncjGfQX4nQncNH5xVDg33x2noceoQxlNutbL1ciT
	 m5kC7IVtoKesymbcbFkm+u/r1eWPlX+qfy7Toa80G3cJsGXL5X+0rimkHmvmlkjt5gzRI
	 EftU420AvfUULE4ihyd9Nz6s9LWMKGDs7K65w0lj0r0Mh2G8imjVxeZbh/xCbogHibKal
	 0FojFKDfujQWXZAbi0rWDHZmv0kuhdKGiHFbrrkxIwpBcD2P8MLS8f1As559YrJ5/rw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIQ8iHSF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37519606A31A;
	Wed, 28 Oct 2026 17:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIQ8iHSF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520B21F01825;
	Wed, 28 Oct 2026 17:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209235;
	bh=3/Xydn463h5hd6TkD29zfS5T/BT7RgZgR8LPzrN5MM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIQ8iHSFPbEXWFe9ZxwiLG7ewxzVG75O/Q60b4XLfjPntqePEv7aQ01ctQt4KrHEG
	 ul0gtJPbuWefE//1zIL3vM8qfVPdlKMLA3RSdZiBEugUp507FCikb7jg4lLboGBf3Z
	 6s6b6dktao7ULE8Z5Ulzf4pCE69sPzqdBOpfhWeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 400/516] devm-helpers: Fix devm_delayed_work_autocancel() kerneldoc
Date: Wed, 28 Oct 2026 17:59:12 +0100
Message-ID: <20261028170012.956372337@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>

[ Upstream commit a943d76352dbb4707a5e5537bbe696c00f5ddd36 ]

The kerneldoc for devm_delayed_work_autocancel() contains invalid
parameter description.

Fix the parameter description. And while at it - make it more obvous that
this function operates on delayed_work. That helps differentiating with
resource-managed INIT_WORK description (which should follow in near future)

Fixes: 0341ce544394 ("workqueue: Add resource managed version of delayed work init")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
Link: https://lore.kernel.org/r/db3a8b4b8899fdf109a0cc760807de12d3b4f09b.1619028482.git.matti.vaittinen@fi.rohmeurope.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/devm-helpers.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/include/linux/devm-helpers.h b/include/linux/devm-helpers.h
index 50557f04ce802..74891802200d6 100644
--- a/include/linux/devm-helpers.h
+++ b/include/linux/devm-helpers.h
@@ -32,13 +32,14 @@ static inline void devm_delayed_work_drop(void *res)
 }
 
 /**
- * devm_delayed_work_autocancel - Resource-managed work allocation
- * @dev: Device which lifetime work is bound to
- * @pdata: work to be cancelled when driver is detached
+ * devm_delayed_work_autocancel - Resource-managed delayed work allocation
+ * @dev:	Device which lifetime work is bound to
+ * @w:		Work item to be queued
+ * @worker:	Worker function
  *
- * Initialize work which is automatically cancelled when driver is detached.
- * A few drivers need delayed work which must be cancelled before driver
- * is detached to avoid accessing removed resources.
+ * Initialize delayed work which is automatically cancelled when driver is
+ * detached. A few drivers need delayed work which must be cancelled before
+ * driver is detached to avoid accessing removed resources.
  * devm_delayed_work_autocancel() can be used to omit the explicit
  * cancelleation when driver is detached.
  */
-- 
2.53.0



