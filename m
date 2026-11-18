Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058321;
	b=pBmwL+ItcIJh7qpQmNZ82vaAvEHGPQQyYEPoQWpbZc9jWAMZkg0qzlswFadQ4dfRtjf8
	 dBlXvJyL7VgVxskECydbJmUR59aBUWODd2qUAi/MzxkZlg2D2do7Sk2M7ktza3lk3kE1m
	 esMBwIpF1Cp2iIcVTeMzAYRHUIQN+wjFnr1AAtz8RYSPOu7f5yfCk1m1vbYqK/mIwNVXZ
	 +HPeGsyfoZtiKklmLKvcCdse/fdYilrzkiRFnyq9nw/sueVIDSkOYTL2SUa6BOTQTYPvT
	 eiFGIl/TumOMiZzRMr9gyuuYaqFi7Z2uZXRtcwffqZvaRSxwcUSXGFi4FUheqoRpf0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058321;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=giTqvtAmUxQ8SHIl7z2tgFAv5OqNGUs4ACIKMy8tXFc=;
	b=VDdbJ29HEngwHB0PsKVz75gQoiueV81o5mo9K8S70AKwY+5DiW7GgRfBwA0ETNfUrA+P
	 +BDDMd/9tAqa0Cibr4r8tYSJB2gdaQxchaVhcRHWD+IKbStQau6w8L3fXrx0Hlr6aSxij
	 RRpmXpKyMFicsVbrvC12UBLEr245kFQuB4FQTLeklC47JFpXRXZGJVp4h/YLrvsGhpaTp
	 MMO4YjHJua90RMifWdsfImI3oz72M4LNarDzicLO6iUY/L/pKpIfo3Tv8bvZ3SLPA96J6
	 u69X8lPs9pbssrWBP45LIHu25W/dweQSruCb7c5rfTwua/4gTBYLVY9G3crodWos2UQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtW+MFvu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AFCC606A31C;
	Thu, 19 Nov 2026 03:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtW+MFvu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CD861F000C5;
	Thu, 19 Nov 2026 03:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058320;
	bh=giTqvtAmUxQ8SHIl7z2tgFAv5OqNGUs4ACIKMy8tXFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtW+MFvunQ0xLpfkHya5V3PiNAuSSkP+XDhJ+W0XympPBm4vEn1r4uky1ubcr67q+
	 HE08zqMJlfn7dgIPFvMG/W/F312CAaxojTSgN/bURgJYsc5iC0qfHiqhuHcrrBDL9x
	 p87e7QTou16grCw6rfITDqrdEgKrt9+lZUDLO+68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0402/1848] iio: accel: mma9551: disable autosuspend on remove
Date: Wed, 18 Nov 2026 15:40:40 +0100
Message-ID: <20261118145930.660692863@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 26421e8e82639..4771fa4323a32 100644
--- a/drivers/iio/accel/mma9551.c
+++ b/drivers/iio/accel/mma9551.c
@@ -516,6 +516,7 @@ static int mma9551_remove(struct i2c_client *client)
 
 	iio_device_unregister(indio_dev);
 
+	pm_runtime_dont_use_autosuspend(&client->dev);
 	pm_runtime_disable(&client->dev);
 	pm_runtime_set_suspended(&client->dev);
 	pm_runtime_put_noidle(&client->dev);
-- 
2.53.0



