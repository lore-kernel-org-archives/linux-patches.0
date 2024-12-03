Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62721DFDBB;
	Tue,  3 Dec 2024 16:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242599; cv=none; b=p/+HVmsEDXe1QK/uR9Ugd8e4zS1WtOA1wWsSe7knTUtY0NuV15bsddVjHQJ58WJiGL7Xj4OdnMhqbXwv7CZx4RQFOcRHnce+ShXIpZnSI7+6g7spYGQlUCPxgcftHEDKp8OL55x6+m6hwIJ45JECjE7XX2UesFZhu2zOim1a+4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242599; c=relaxed/simple;
	bh=wrhcQ65ZBpGfaHkbpY5YdHSmGcpfKvVpemJiwoUYFEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SfedbVmp2tqvz16W5+b+EO+C+Q0HdN0CJl0JyAhUrqMjWPVvVtydaQP7OjTG8Ffhh+OVv/B3XMr+wwUiGu5GCG/KnTMAev3W47cce45zmd4SuhSZgtF68rHeKRmaMynkwxLsecktuWvWD96kxN6wE3/j7tnoVdLTwzXPgs7Reas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQN/mNqG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQN/mNqG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 331E9C4CED6;
	Tue,  3 Dec 2024 16:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242599;
	bh=wrhcQ65ZBpGfaHkbpY5YdHSmGcpfKvVpemJiwoUYFEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQN/mNqGEm6ryx2U44qAYPsf7XiK1s6Il54YcoJeeQtmntH2nLiYd4SCCQjvqraZW
	 wCEhihTE509BRQeEjBI1BKgP6C6rJVuHodJF84kBkZS33Zm90ZNnJKZdsnmlb3vlsy
	 zWIEA1a/VR/b1vcwILXoJ1M4e0Vz5xLmlbstim+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 721/826] iio: gts: Fix uninitialized symbol ret
Date: Tue,  3 Dec 2024 15:47:28 +0100
Message-ID: <20241203144811.887174459@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/iio/industrialio-gts-helper.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-gts-helper.c
+++ b/drivers/iio/industrialio-gts-helper.c
@@ -167,7 +167,7 @@ static int iio_gts_gain_cmp(const void *
 
 static int gain_to_scaletables(struct iio_gts *gts, int **gains, int **scales)
 {
-	int ret, i, j, new_idx, time_idx;
+	int i, j, new_idx, time_idx, ret = 0;
 	int *all_gains;
 	size_t gain_bytes;
 


