Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97FF3C8C65;
	Sat, 17 Oct 2026 17:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259867; cv=none; b=BFjUoFvlRlEMR7Qz1qDaBZTfPHrQDA09ITbnT38QJ+Bq5wsEdRgsY8yJ2Z8AKqnCDYPMP4VU2nPgGVZALyjamLoCgRKvlC0BVOmCb1ibQNUSEq+1zE6hAXP0CzqDNcCAa6T8kCehj4CjB6rQlE6MdrQZY5+BU7bDNVZmt05uEZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259867; c=relaxed/simple;
	bh=IBR0EAwbJ/iVWths+f0JE4+gWcDtwyVAqK51XQWajt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VpmI2L++dQM7e0m9Ihgu5w/Nyo2tg3AOQ6X921jzgDwQFl2L2ZcPewfIkm1I1AqkodfaY4wKxJ0JfVgbie2CAaxeSAE9PV2L+6gR4HYlRIs8FLajnCILn8Zifb1DrLxF4k39JgR6C2J7O1xKCq0j/Unbjd0Er3dW0OFUs+HUaKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UL1F86iN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UL1F86iN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017AA1F000C4;
	Sat, 17 Oct 2026 17:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259866;
	bh=S3gjpr6L1m1EJsW9vR2lmPIA+fDPfXmGquAaMkImLQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UL1F86iNX3R7KGeiPUf8ysSw0Mri4AOIxdMQQMaNVMrwWydRa19npc7NGzb6fcB9Y
	 nnJ6oyb0hiH/eK8ZmjjQ/FaYBtVxe9bv6LmqCKihLyy1Fxr3KykNzcoFs68xfz/1nb
	 pw7pjTz6YwqjnuMRdUyYdRMf33D/dyWNVOlQzbSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreeya Patel <shreeya.patel@collabora.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1355/1674] iio: light: ltrf216a: Return floating point values
Date: Sat, 17 Oct 2026 18:00:27 +0200
Message-ID: <20261017160505.943733721@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shreeya Patel <shreeya.patel@collabora.com>

[ Upstream commit 00799564bafdd73db1bb0482eefbe1aba7d5e15f ]

For better precision of input light intesity, return floating point
values through sysfs instead of an integer value

Signed-off-by: Shreeya Patel <shreeya.patel@collabora.com>
Link: https://lore.kernel.org/r/20231107192005.285534-1-shreeya.patel@collabora.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: c132aef0e757 ("iio: light: ltrf216a: fix runtime PM reference leak in error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/ltrf216a.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/light/ltrf216a.c b/drivers/iio/light/ltrf216a.c
index 8de4dd849936d..68dc48420a886 100644
--- a/drivers/iio/light/ltrf216a.c
+++ b/drivers/iio/light/ltrf216a.c
@@ -234,7 +234,7 @@ static int ltrf216a_read_data(struct ltrf216a_data *data, u8 addr)
 static int ltrf216a_get_lux(struct ltrf216a_data *data)
 {
 	int ret, greendata;
-	u64 lux, div;
+	u64 lux;
 
 	ret = ltrf216a_set_power_state(data, true);
 	if (ret)
@@ -246,10 +246,9 @@ static int ltrf216a_get_lux(struct ltrf216a_data *data)
 
 	ltrf216a_set_power_state(data, false);
 
-	lux = greendata * 45 * LTRF216A_WIN_FAC * 100;
-	div = data->als_gain_fac * data->int_time_fac * 100;
+	lux = greendata * 45 * LTRF216A_WIN_FAC;
 
-	return div_u64(lux, div);
+	return lux;
 }
 
 static int ltrf216a_read_raw(struct iio_dev *indio_dev,
@@ -279,7 +278,8 @@ static int ltrf216a_read_raw(struct iio_dev *indio_dev,
 		if (ret < 0)
 			return ret;
 		*val = ret;
-		return IIO_VAL_INT;
+		*val2 = data->als_gain_fac * data->int_time_fac;
+		return IIO_VAL_FRACTIONAL;
 	case IIO_CHAN_INFO_INT_TIME:
 		mutex_lock(&data->lock);
 		ret = ltrf216a_get_int_time(data, val, val2);
-- 
2.53.0



