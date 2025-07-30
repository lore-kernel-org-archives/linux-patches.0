Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E424419D065;
	Wed, 30 Jul 2025 09:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868488; cv=none; b=patvTT5q4h79gWzZNFJzfgr/SQSSvahlW3kRsPMCCGWzHiKMmN7h6t071vanABpA1RvkcZxvTv9yi0TORxt3pb5wh+jvFWuEnwx5srMFAEeAQ3Af/H9g3GybY8jUT105VcP4HJHq49zqGV+Tv/YJk2VASSmNCTzzF1sVoy08a88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868488; c=relaxed/simple;
	bh=5u29Rk0LFsc5q+8MqE+ae2vxx9nR6cmnjyZD8k3Rt2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwbIHFcE9GLMqzVMfb2J2prDMIPewvbLDgIoWhM03yHNyhI6ylgbI9kJKZdQkOfnKepWEV3DrJ6KgRVK2KnMni4OWkY5ciWU+JANR6mPYSVivf+apyg8q0Tl27A0WXgEfYfg1BqHLGMfBs0PHQi6XifUYYPNLbbZORijNUBnEdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc+UU/A3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc+UU/A3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DAE6C4CEE7;
	Wed, 30 Jul 2025 09:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868487;
	bh=5u29Rk0LFsc5q+8MqE+ae2vxx9nR6cmnjyZD8k3Rt2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xc+UU/A30Hyv3wOg7ESybTWpakwR93HqoRCSkd8aI9FdWJV95OnPy33VEO0JKyTq4
	 HV72k9nV/Z7j2hd9Wx4ACgCBUKasQlSTnWsNszsCxwVTNN5rbiytyXGzGkY8BirNcI
	 GIrqTvQgr5a+uaoCwW1kKSqqlML7VKAZ+O9PLwfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 63/76] iio: hid-sensor-prox: Restore lost scale assignments
Date: Wed, 30 Jul 2025 11:35:56 +0200
Message-ID: <20250730093229.309836007@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 83ded7cfaccccd2f4041769c313b58b4c9e265ad ]

The variables `scale_pre_decml`, `scale_post_decml`, and `scale_precision`
were assigned in commit d68c592e02f6 ("iio: hid-sensor-prox: Fix scale not
correct issue"), but due to a merge conflict in
commit 9c15db92a8e5 ("Merge tag 'iio-for-5.13a' of
https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next"),
these assignments were lost.

Add back lost assignments and replace `st->prox_attr` with
`st->prox_attr[0]` because commit 596ef5cf654b ("iio: hid-sensor-prox: Add
support for more channels") changed `prox_attr` to an array.

Cc: stable@vger.kernel.org # 5.13+
Fixes: 9c15db92a8e5 ("Merge tag 'iio-for-5.13a' of https://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio into staging-next")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250331055022.1149736-2-lixu.zhang@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ changed st->prox_attr[0] array access to st->prox_attr single struct member ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/hid-sensor-prox.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -226,6 +226,11 @@ static int prox_parse_report(struct plat
 	dev_dbg(&pdev->dev, "prox %x:%x\n", st->prox_attr.index,
 			st->prox_attr.report_id);
 
+	st->scale_precision = hid_sensor_format_scale(hsdev->usage,
+						      &st->prox_attr,
+						      &st->scale_pre_decml,
+						      &st->scale_post_decml);
+
 	return ret;
 }
 


