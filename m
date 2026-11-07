Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062849;
	b=IiWq4kh+nmVUP4O46UebwIzNqOl0cK2PVrtQfSu/XAu1/f0/6s4AC4gxjlELOck/tO9Z
	 35dDLSxGvyRz6mDMBCagKBgHF+XlFpKiwSrzDrwOxEe37JhGpiCKuAhqs0sSATr3Mh/nT
	 xCdPd9INyVEQ+3q2B4kAR3X5uXubKeiQlaxWAO+Qdr7RBLIzVoNNeYFiNgND0JPwlIwOZ
	 p/r3jeNowII1E7XyZeodYagjem1ECkRGlT1Hf552k1zpXLnVGipnDXuu/mmzPbBDCONlV
	 32VSdjNIrDMWxHUg8+kyFOFQ1k0zVEylcxDc6zXevZ3dxDR8cDKEit9eG1HlMGhwYzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=twrJnkv4EWZgxiFm7y3jzJ28Bh6LtW1+n2F81cueVW8=;
	b=oh5lbCz9LjiGxMW9//LRENdNiNhNjYtM+j9mLylali33KpZ7n6PsYKQbTGb3/V92PrSK
	 xHqyWKKeKebsiNc60lsQxIEY9ZP+LJY8uh/lgG5IkAyN1bZUpM8zpg0Q3u8PIj9Tuqvqn
	 PYvyv4OY/hXSWBm/2RzAZpttS11EqmyUTcwdtXJrpGA4UxCc7VqI2IrNG98E7FYhcPdmh
	 7TtY589n9coj6njKy2YzabHOVvlCiXo//JrIOTlZi/N/hfH7QemcDG55Xswre9RsfUAKo
	 oumM/Ucf+eckey7TcXs1qTo0fOk1FWGuddxpVdpBdKm/ypWwJnl1OKNh3fcdZKCiApw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srZTnVdk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2651606A33E;
	Sat,  7 Nov 2026 14:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=srZTnVdk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F85E1F0089F;
	Sat,  7 Nov 2026 14:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062848;
	bh=twrJnkv4EWZgxiFm7y3jzJ28Bh6LtW1+n2F81cueVW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=srZTnVdkjcvbjQWp1jwEP6VKtHB855dCYhMT7R3xb7PJ7m75QMGOpWkYDYajtIiKp
	 OZFILKZ8OL8F7PgoygYCsF9xoXisFNpgklg4Gb8hrVtFnK3Ke336+mONM9aInQaaDq
	 dWfr2hJVH+O/5AC/Mqqs35pTDp/xrreQdj2e3wN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 141/869] media: i2c: alvium-csi2: balance runtime PM usage count on remove
Date: Sat,  7 Nov 2026 08:47:03 -0500
Message-ID: <20261107134857.179940057@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 0d2ca640318612402ae1c640d2da56b2914ff994 ]

alvium_probe() increments the runtime PM usage count with
pm_runtime_get_noresume() before enabling runtime PM. The probe error
path correctly balances this reference with pm_runtime_put_noidle(),
but the normal remove path only disables runtime PM.

pm_runtime_disable() does not decrement the usage count, so a
successful probe followed by driver removal leaves the runtime PM
usage count unbalanced.

Add the missing pm_runtime_put_noidle() to the remove path, matching
the existing probe error cleanup.

This issue was found by manual code inspection.

Fixes: 0a7af872915e ("media: i2c: Add support for alvium camera")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/alvium-csi2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/alvium-csi2.c b/drivers/media/i2c/alvium-csi2.c
index 3d399af013222..d08d01098a9a3 100644
--- a/drivers/media/i2c/alvium-csi2.c
+++ b/drivers/media/i2c/alvium-csi2.c
@@ -2523,6 +2523,7 @@ static void alvium_remove(struct i2c_client *client)
 	 * make sure to turn power off manually.
 	 */
 	pm_runtime_disable(dev);
+	pm_runtime_put_noidle(dev);
 	if (!pm_runtime_status_suspended(dev))
 		alvium_set_power(alvium, false);
 	pm_runtime_set_suspended(dev);
-- 
2.53.0



