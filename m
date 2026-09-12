Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF7B37E5C4;
	Sat, 12 Sep 2026 10:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209616; cv=none; b=YKSUcciefWTjaQYeMMu7b7crOY4A5pr7IqchpGboHallbtUK8uxcvsUqyDdkTB70nMOFDg617i/VXWa5v7EMtibYmalNpOXc55CLZ//vPwHl0vFL9ruyi0x/MXNoI8eIQ8W2GvBPhRz6nc/mHyfFuwuRDEv7KWaeQp9trtl8czI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209616; c=relaxed/simple;
	bh=UwMHLcDQq/efmoPaOY2DlEL7zsBIUtpbcUqQ1XcqqD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2ZrY7zzM7wr/M6WlIblH7KUjXn86kPrDNXgVC61QRufRxOegXnd76tItddWffYHQ5c9TdBfK9Uy37IBHkT79As7zluJxGLms2kV0/E4XS87593kUTHKMRH9XTfS9AKTr9p0eumwLov8xy28OiHfXHnpiyN+4pKIwUzDuZnJFGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSKS7wRx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSKS7wRx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123431F000FF;
	Sat, 12 Sep 2026 10:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209615;
	bh=0PVU4QN0kdespAnoQ5qYAkbsqD51h8xBktqJwutj16Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSKS7wRx9QGZtRtIIMoOjVKbTp20Utzo4bzH7cJ7DR5UPD/fhJir1CP9tj6bRpogt
	 YQirfESUh35xP7CdLgkLdte5KvsU+liWCVtrOWfAF2F51dC3eN7tblfFBqRIwDdzmz
	 tjQ7M3xc+B5SVfTcfFYfZX28AMXrg85mNvsxMgTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Brian Masney <bmasney@redhat.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0856/1518] iio: light: isl29028: return zero in write_raw() on success
Date: Sat, 12 Sep 2026 08:50:25 +0200
Message-ID: <20260912065642.815115834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Heon Jeon <ekffu200098@gmail.com>

[ Upstream commit 55b75622829779223b9e32aa9600a8651d3e2df4 ]

isl29028_write_raw() returns the value of pm_runtime_put_autosuspend(),
which is 1 if the device is already runtime suspended.

In that case write() on the sysfs attribute returns 1 instead of the
number of bytes written. Make isl29028_write_raw() always return zero
on success.

Fixes: 2db5054ac28d ("staging: iio: isl29028: add runtime power management support")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/isl29028.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/isl29028.c b/drivers/iio/light/isl29028.c
index 374bccad9119a..f89c5d9ee5240 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -409,7 +409,7 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 	if (ret < 0)
 		return ret;
 
-	return ret;
+	return 0;
 }
 
 static int isl29028_read_raw(struct iio_dev *indio_dev,
-- 
2.53.0



