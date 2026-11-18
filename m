Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036062;
	b=oIphOBlCHy1pSEPUHKpCe9IScEnCt36zXws6t4wUQ+CMSRw85xZNHZ95BoFEztz+IA54
	 wCAYgp3RUXMYysGwhwwDqZdLsKJEXF3bCqxONZYFnZrTj+c1WLYL8sbKQP8mAvW1ShyxL
	 6rnGX0jzn8Pbo29H64ywtjbjpY7xWxm3uuMowJ4CiBCcYAlA+DUi8y2paIty4tBbxajuM
	 ClKuk1RonGGK22nLwUKIJnbLG9doJf/ZBT/ARCEFYuGLOpW1CQY4z6jJjV+qZMrDnfOTN
	 Urmh6mDPHA1rDPYuCXKew+6IrQuYJKQTmDFkomLnV3SbJAtagC9OLQh84/VupeeLKvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FzOccP4n7mkHohAu622JT56pgjMIK/w7j9gypmw5enc=;
	b=XuGpOQ4p4LobogrY8lW0ySDyKAkUdLYSI5m0moiE3Fc7AlsV1qMgBT6cnh/5ojx/Bhm9
	 qh70k0GGHithLccm3z1q97JpdPszbcvogpo7rnQRNVDsWUkYvt5CxRcRRMmaFkIcwnnbU
	 drav6T4DchqLZwhOvUgBRpKX9L1LgjwXQouOC4jgxcELAGqMHy/+KdzXjmkFPzz/XFqqa
	 4xJZbJFOCizIXEEtFg9o2psVSwZj71lxaHm2bFmBekYnmRy98smJ3hiXewokGbSLJ4nP7
	 u8HXo12vQSFlCtSwg6cBOCBcNJhNENbvC8dU2jMQ0gO+N6VotGlacmsfFhpGY0AEyog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfKdNlnO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE27606A31C;
	Wed, 18 Nov 2026 21:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DfKdNlnO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738191F000C4;
	Wed, 18 Nov 2026 21:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036062;
	bh=FzOccP4n7mkHohAu622JT56pgjMIK/w7j9gypmw5enc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DfKdNlnOyeyQn8Pk64ckhB6MKVPNVqW+n9RYmpdhBPtiOBfZa7klCpdGnVE1XB2sE
	 jcbXrq+bomzklX3nzqcOarRnRvcpPF2DL/c+4l8RINE3Om6yhLd3KDg27O/i6Mjby8
	 8R6YJDbZpbCMRuSQLSCu3aFdbJ5ermVser/9P1Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0882/3318] iio: accel: kxcjk-1013: Disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:25:04 +0100
Message-ID: <20261118150345.812866867@linuxfoundation.org>
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
index f3b912c2d39ca..6513d101614c0 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1601,6 +1601,7 @@ static void kxcjk1013_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



