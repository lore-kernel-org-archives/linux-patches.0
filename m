Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620709;
	b=sYU85XUIrN4HVfRzOEJ3pAPYrEw2UZ+qSor3nVWICaxtZ3YRvbCcaCfXUQmhJVFo8DkU
	 +C4P00KjzyRpfeXvRqpvKwmNnU+n8mC5aE61XafhGrpnW96gRvbuiS3SbD59TBBoGSunZ
	 +HDMR68sOKF/+gEpmb9EeAVqJyBh4yQSiYhXs+aevmZoQDJcdChdQLtB8EHJlY2JBpEPB
	 LDrsU+GYFfRCen2zmL2zRDKgYAy/ptWtOyl8l1iNhx84b6ACw7eB0nl0FTndu0FVaKpH6
	 ohAS14E0ktJBnFhqAKtJY1Dt6EV+bct0PXGiWHk8k0EEq1oXrV6wq0HmamuWwnJh5Xg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UhWew5L11wYC3FJLyccuYMMRCD4862MyKKjQBQCSM3k=;
	b=RcZ2+aHMRzxuYffpdEizud/xYMHwIrCyPrzB9n0SfmzDktB5oXft4OnVjK9Yok0XQRZJ
	 AoNm2QDlJFdooGYmde+3mpzLL7Zzu0SwWr0t1Jxt2nPU0dI8aEO7nDg8mN2WqLt3y1xaQ
	 jOFuFlH6GC005P6gAe+KK01e2A6y/iIHcBHYP89g0P2iVKxDVQp0NNXYRxxrISYeeqajn
	 dgXwHuAMbxL382FnCSQVFRgP/FY03fem2xIs/CLi6RjCH5JI1k9psSL8dfrfaarQeqsTI
	 tGW//Qje0OVxLMp/xdyLqVHjhJKby64KrzEpRovEk9tog3hzmhQlZd7JpxnUi/K0YJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rIFzk1bk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C69606A31E;
	Wed, 25 Nov 2026 15:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rIFzk1bk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876431F000C6;
	Wed, 25 Nov 2026 15:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620709;
	bh=UhWew5L11wYC3FJLyccuYMMRCD4862MyKKjQBQCSM3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIFzk1bkA0g5yXeyHuVoDw7whDda+sqxhVN45hgZX/rG+hraMV/uExqM6Hy1glgsQ
	 oRGAVRYWjccqDUtfZ0VeTbR8WYOkTYxH0qhsPwNGliTEMR24nVPYM7RA1B+qhs0Yak
	 D2e8YenL7GRgZnhDRKv0h9pCZWLNDmc7VqwGpG8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sarmanow <as@discnull.de>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.3 0984/1005] iio: light: vcnl4035: Fix reversed ALS mode bit
Date: Wed, 25 Nov 2026 15:38:42 +0100
Message-ID: <20261125143844.708873641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sarmanow <as@discnull.de>

commit 6bcabc30b89f31e2925647d1ffa5a0e4b7919829 upstream.

According to the datasheet (table 2) the ALS_SD bit behaves the opposite
way the current ALS mode defines are set, writing 0 powers the sensor
and writing 1 shuts it down.

The current driver thinks the ALS is up while it's actually shut down
and it's down when the systems powers it up.

Fixes: 55707294c4eb ("iio: light: Add support for vishay vcnl4035")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sarmanow <as@discnull.de>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -44,8 +44,8 @@
 #define VCNL4035_DEV_ID_MASK		GENMASK(7, 0)
 
 /* Default values */
-#define VCNL4035_MODE_ALS_ENABLE	BIT(0)
-#define VCNL4035_MODE_ALS_DISABLE	0x00
+#define VCNL4035_MODE_ALS_ENABLE	0x00
+#define VCNL4035_MODE_ALS_DISABLE	BIT(0)
 #define VCNL4035_MODE_ALS_INT_ENABLE	BIT(1)
 #define VCNL4035_MODE_ALS_INT_DISABLE	0
 #define VCNL4035_DEV_ID_VAL		0x80


