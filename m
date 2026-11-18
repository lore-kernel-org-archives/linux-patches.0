Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052258;
	b=A+bJNMFiGY9mcuRVDd2ij99B0JAJ5GEYzOvAnU7T+Z6gLh+1IPirJNFbIyD+wb3VbwGo
	 GPtMdSs908eoLL5WF9FvIZYw6N1NJGLbtsD8mFclzkrR81G/vH2XIvuc9TB52Kd1hf76N
	 X4zqz0N8w3SKqV5bWlZ1uyJvaDhN/vO1ftCPMaUNb/7HOk88Of/eDu+Xt025OLxQ19nUI
	 /96HaRaGM28dTUIoTwywn0rDjyWKQuA8slTq/iHkWwmZanE0vV9IQa8ji1wlHpLLXfGIs
	 iPFPaWe6WQ+8VLiYcqOZbYQHBo3VnDP9UnKP8+CWn2Z3ZlJIOS6bB1bGS96cZ2xIPGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SpTOAbhvxfemLrC1Qh6Il1aY2CL+atraGsWgLh3PO3g=;
	b=3+3moxQvWSRCLGUFWzqMvQaIxLRxGIE7hiD1Bmeil+krp884XJTwB8lPe2J4gYGAFd57
	 kOZGmrnRZ3Ps3Ye6VB06cwTp9/Jycou8HYXJtpa9Zm9rNNcKU7lx0A2CnXQf+CS+nY78Y
	 DFVZVSWLGMCAS8l8EGN+jDVmy4ytw31LZZC3oq/aTFanS7BYG9zuKIrDPudgqeb6t1cHA
	 mD2Yh9CSsK5f7o+eUwHPqN189saSLf0v4nBi+5mkJtxzfIqMDPFHdfxTjrA+B0OvMzpKS
	 vMs2Gf5qp5awllb94UgzMHryvVBJXUonDxbOX73McnOWVyEsVfr5qju+IGUaYupOAwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdxkqdbK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A45606A325;
	Thu, 19 Nov 2026 01:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CdxkqdbK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9641F000C4;
	Thu, 19 Nov 2026 01:37:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052257;
	bh=SpTOAbhvxfemLrC1Qh6Il1aY2CL+atraGsWgLh3PO3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdxkqdbKcWe8CUMt8cPFoeauVkrC/VijEK1FAAWTAE5+6Ms+8nTIS6leAa2o5MBCj
	 Zp7TMYlh54WZYVBpvPUv9gSDr7PdtFqJzX+LatC3GQdcZutRYOVeBGqGDnnGpDiC+z
	 SMkhZ3W8gkOf4n/sMpym1g6ZNb9CT3JvY4gK0dhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0498/2214] iio: accel: mma9551: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:36:14 +0100
Message-ID: <20261118150031.082373806@linuxfoundation.org>
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

[ Upstream commit 8061720f6be1811478914f8b6143778d70f6033f ]

mma9551_probe() enables runtime PM autosuspend with
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

Fixes: 6da93a6710a3 ("iio: accel: mma9551: Add runtime pm support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mma9551.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/mma9551.c b/drivers/iio/accel/mma9551.c
index c53a3398b14c4..041f118f869d3 100644
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -516,6 +516,7 @@ static int mma9551_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



