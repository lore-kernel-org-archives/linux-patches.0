Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064001;
	b=dqvcqiPy6ooOqmkkA/XKgKpDqiYGOwHkFO5kdJLH8xR0T03T12nm7RO+6OJWF1UeP/Lk
	 x85GKH7vPBPQc47Ak4nRLCI1AhAXmJ7jLDayhwnqq4G4puBWNLVp4o90OL0Qw3yZGcDfN
	 P1oZ5TRoi1hHGXiYEFTEmw1LxFcVT263xyz98PSvmsIr4g7cbP11+9q/MwAJaU9Z/jISO
	 cUu7TLcbv87y+Zg6suCnuasjEWUnsq33s9cdVTJVFg7/4qUKhWZ3OrlVnSF1/+GLOwFgf
	 4BMiA7NbCS+E2xqmde7PUhBqw0QHAVzypzENvLK2pj2A8FTiXbD7nJvGJgYIMjPxrCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cGJLuEgpH8Uz3mLNZSlMSlTI2wShI5X1eE2QYPUVu9U=;
	b=eAjPRK7zWsiG/ZxmVAilSiANyi12DeM6/jiNvSfgePd3g05YHvRXlSPkEcMeaSSwPReB
	 PNOLtoWm+wvQWCttXNxJMUY7NkM0zkni3WlzXG1jR9z4iI7pLDxW3ZEVwrUTtbFIfBQhk
	 wEwiCjfXsGY1SeuwXXRmDgx5FP3gO2D5OegTQlaA3IU4Yu07oVWgTQoLYXGX8ihPdRq3+
	 oTMD9SzXKtur0Ds+1lq7eZRvpjnCCc4WCF1wRsMC4rBw0H1n/08yvjUIBCUlNMM85JOZy
	 GU9A4trM5nrCQ4zjZVHRtc2tSYZtB9tjNvDmfys7O+ii+an8Y7mKXrOjBhV/ABu/m1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWxxhlcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261F960A2636;
	Sat,  7 Nov 2026 15:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MWxxhlcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8F241F008A5;
	Sat,  7 Nov 2026 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064001;
	bh=cGJLuEgpH8Uz3mLNZSlMSlTI2wShI5X1eE2QYPUVu9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MWxxhlcO4vv/so/f93thDFS8dEcwO3VJeS5djW+Pvu5sk7OSjOhoYtsTE0BCnaHSb
	 PLlrBYtMr9zdj3obPKrwuYUBlWedC1HwVu/Wk4Vt7QvIjN4x/UJAYRmE4RDt22DX1s
	 6zBhM7sKb4GqgMjQUb9THdoTF7smG9C/l50HWp+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0182/1257] iio: accel: kxcjk-1013: Disable autosuspend on remove
Date: Sat,  7 Nov 2026 08:41:18 -0500
Message-ID: <20261107134944.479595296@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 8994c9e8e048d..b3d753bd94761 100644
--- a/drivers/iio/accel/kxcjk-1013.c
+++ b/drivers/iio/accel/kxcjk-1013.c
@@ -1547,6 +1547,7 @@ static void kxcjk1013_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 
-- 
2.53.0



