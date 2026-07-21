Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1A344AB9F;
	Tue, 21 Jul 2026 22:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674582; cv=none; b=guA6h65rfzspB5GIpRxNlh2vu/vAw497yiA6n994IONSlVk126CFOa8JExrEGsqen/EB7c/yBxYS1KGr86rv4ribtDylPFZIa6U66y3TPs5UPswoIj+c6fBnZV19rIujw7Ja7AtGUCxpEVYPbhgWT/LhgLxI4Fo3LglyZk9qz4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674582; c=relaxed/simple;
	bh=IkeLDGii8spFmE/D7W6f74peVuficdYOf1U4CUeSswQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcDKZiJP0jrdo5hwkZs2YRANfnx8MwqMYR2iqVdJ+vmHYhIsmNy4TtvoVTou0GDzCXRIxMqHRnqzZIMogE6fJlHiDR/yoG3mldwbwn5CMebXke6VYJ20YtNt3jP08g4tWtwB6i1wSgy8bHpha1kr3mYKqoxm7zPPuxHle3L71gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJ2kvJRc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJ2kvJRc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7971F00A3A;
	Tue, 21 Jul 2026 22:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674580;
	bh=gScrHaXR0TB/51R7JspLB+7QFwMNxpzu7w+BD98o+ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wJ2kvJRc/QIgoEReFTpwy0gUIKsY11hryZtuhm14n7eYJ323wL2BCFeHquMePLfyk
	 HN3tLtJxVGN15IiBXq83NErT9dlnxLeCQslS903viEDc3uJMR1pc5sQUgz8nzKOsDQ
	 JJVpqlUk4Pa8chyLm3YmjoyYqMgcMnj9g7R5u/1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 588/699] iio: invensense: remove redundant initialization of variable period
Date: Tue, 21 Jul 2026 17:25:47 +0200
Message-ID: <20260721152408.986133952@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit b58b13f156c00c2457035b7071eaaac105fe6836 ]

The variable period is being initialized with a value that is never
read, it is being re-assigned a new value later on before it is read.
The initialization is redundant and can be removed.

Cleans up clang scan build warning:
Value stored to 'period' during its initialization is never
read [deadcode.DeadStores]

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://lore.kernel.org/r/20240106153202.54861-1-colin.i.king@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: affe3f077d7a ("iio: imu: inv_icm42600: fix timestamping by limiting FIFO reading")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/inv_sensors/inv_sensors_timestamp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
+++ b/drivers/iio/common/inv_sensors/inv_sensors_timestamp.c
@@ -105,7 +105,7 @@ void inv_sensors_timestamp_interrupt(str
 	struct inv_sensors_timestamp_interval *it;
 	int64_t delta, interval;
 	const uint32_t fifo_mult = fifo_period / ts->chip.clock_period;
-	uint32_t period = ts->period;
+	uint32_t period;
 	int32_t m;
 	bool valid = false;
 


