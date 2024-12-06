Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99FE13A863;
	Fri,  6 Dec 2024 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498337; cv=none; b=gxPi+iGMzNt6jLSGUlswtu2bWFp9kC3YoAVWzl1V7MzVPgdIjx1s/dO8thC3x7apLxA6UBfFJ7ZHlaLQvKCsORda0YFq6HMDXxcwJZxJpm0ajNbl8Gs9FeQBO5o9RPqxkJbdKpIFN7MGDFEcGcmRJDwwvbgBb+fC82smo8A9F/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498337; c=relaxed/simple;
	bh=067crZF6AGYoXKQ0/AKIIHP/5DRg3Y+ffIXDWG7a4WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEWKleTlf0CxYlcWZNhl1NsEos8L2XVCWFT1nSkRnu6OGJpK9euG0Ah11nVIeCBB6vBJ6K6Hn14pyr+DshzMg/zT3S2azZBQZVX2/1FXqlGRTR4i8qj2uyAFS+JTH/iDN946tbi7e5qkPvOrHhhYO6O//F2wwLkyfDgyMvhtJeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1EWFe3l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1EWFe3l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277DBC4CED1;
	Fri,  6 Dec 2024 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498337;
	bh=067crZF6AGYoXKQ0/AKIIHP/5DRg3Y+ffIXDWG7a4WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1EWFe3lNIGKPjlvjlihEO+eUTQEDq0XJvFpO22hJ+O5qjYsi4PDlDXmb1wsp3SGA
	 jT1uzgWZHB40l774/lkPJ0pltm4EWQ5ACDK0TdpoBsCx5l6r0BVsPPZrKrwqY+M39O
	 fK2XXmtaD8LU3JKDVoOQ4KAnnKJFIz9t+YxZDBMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 523/676] iio: gts: Fix uninitialized symbol ret
Date: Fri,  6 Dec 2024 15:35:42 +0100
Message-ID: <20241206143713.789140934@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Zicheng Qu <quzicheng@huawei.com>

commit e2fb2f89faf87b681038475d093214f4cbe12ebb upstream.

Initialize the variable ret at the time of declaration to prevent it from
being returned without a defined value. Fixes smatch warning:
drivers/iio/industrialio-gts-helper.c:256 gain_to_scaletables() error:
uninitialized symbol 'ret'.

Cc: stable@vger.kernel.org # v6.6+
Fixes: 38416c28e168 ("iio: light: Add gain-time-scale helpers")
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Reviewed-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/20241031014505.2313035-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-gts-helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/industrialio-gts-helper.c b/drivers/iio/industrialio-gts-helper.c
index 5f131bc1a01e..4ad949672210 100644
--- a/drivers/iio/industrialio-gts-helper.c
+++ b/drivers/iio/industrialio-gts-helper.c
@@ -167,7 +167,7 @@ static int iio_gts_gain_cmp(const void *a, const void *b)
 
 static int gain_to_scaletables(struct iio_gts *gts, int **gains, int **scales)
 {
-	int ret, i, j, new_idx, time_idx;
+	int i, j, new_idx, time_idx, ret = 0;
 	int *all_gains;
 	size_t gain_bytes;
 
-- 
2.47.1



