Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052252;
	b=mGX9VE+PZKeHbwRvK5FhxMkeWyhV6BBtqc9AWa0eE9qfvu1sBvsMkKAMf6wwnx8rsq7G
	 AlheyyMFTLuBk3Z3IfkCD9apYnNW0IhbjJnJQwb6CaRa5bjovW0isg7PKmnD9IRZkPkDu
	 jJ4h6YSSQYYVqFEq0D0jQJKM9tL4U+kNAJM3Kr4O3/ta2djmdTkaUv0kMACHPH3vhoeK5
	 ZNwi4+2EGZYz8WdvoV7kF1sKTicufkDN5q2LG7V4kyBRijbfV40zZjEXQyVdtqhBU/LYJ
	 Zc/9QNt8s/WobMk47Ft9KfpErpP+tAlJ5/9lKD8T/1gQ/6e2m0ILSBlPJj8tGV7V8+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052252;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XKTbxlrUqKbjRwhFfbq2tKk0roo4xgtWRTapF3Kiesg=;
	b=lgwpNNv35cXgfIaWM9T1D0P3D/RN+MAYQjyGExZJ5lwaJe3F8f+yYlnJLvvdm7j36VA2
	 NbRP7yJBkhh6XLDhSxTInaCs6keHNB6JgdXsgGFr7Ru86BCEhAGsazSROOc2jxpnPlIge
	 qYONFbkr/2Whz55qBpVsSxW1kS/lSTgShr3O4sh/8g2vpHd9PMp7EgEmanEAxknXuN7Zz
	 DffrTP+16CybqkOQtv+7D3ik6QMKICFGsy2qs8MgCE1H3G2YL/bTT+zGzbuBSv01Kfqhl
	 1oEFU0TxLzLyjaGVtsJEG/tAP7d9Ci5h5HHUE/tGwyxgkcr5WMNf4XaWbWVfZ7VSv/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jk/oX4Vy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418F0606A31C;
	Thu, 19 Nov 2026 01:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jk/oX4Vy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 923A71F000C4;
	Thu, 19 Nov 2026 01:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052252;
	bh=XKTbxlrUqKbjRwhFfbq2tKk0roo4xgtWRTapF3Kiesg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jk/oX4VyyiTz1u1YSj/1o10Zh8MFB/zgk7jJV9xNMNLZijpVL6i0my+aScIEfSaRp
	 1u34xcEfkQb5thDMsbbSFRLh93Xb2eDsbHc4rmwhwF4eLlDE/PmCGGe/8VPdWyP3T+
	 nNBVLn8E4MRMvzz/LnRdYeAky6Q7NqNpK+uFaIWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0497/2214] iio: accel: kxcjk-1013: Disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:36:13 +0100
Message-ID: <20261118150031.047176762@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 1de1206a42741adfb72ca8b37dc71a6bc80cb074 ]

kxcjk1013_probe() enables runtime PM autosuspend with
pm_runtime_use_autosuspend(). The probe error path correctly undoes
this setting with pm_runtime_dont_use_autosuspend(), but the normal
remove path only disables runtime PM.

The runtime PM API requires pm_runtime_use_autosuspend() to be undone
with pm_runtime_dont_use_autosuspend() at driver exit unless runtime PM
was enabled with devm_pm_runtime_enable(). Leaving the autosuspend flag
set therefore leaves the runtime PM state incompletely cleaned up after
the driver is unbound.

Add the missing pm_runtime_dont_use_autosuspend() call to the remove
path.

This issue was found by manual code inspection.

Fixes: 124e1b1d0924 ("iio: accel: kxcjk-1013: support runtime pm")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kxcjk-1013.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/kxcjk-1013.c b/drivers/iio/accel/kxcjk-1013.c
index ea5a2e09e60db..82798948853a1 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1617,6 +1617,7 @@ static int kxcjk1013_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



