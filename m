Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1559B297109;
	Mon, 12 May 2025 17:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071970; cv=none; b=RTVmWt80GUU+HDQC3M/UlDYQ9BU2DCRZFgx6Jek71S3hnyHJ3v1EI8BybIPcsWHwocw+UdxxGnvlBNtMfz8eUaM6LEaqtwREvFsTXxmMRgzeNh1sqvrRoS7RW6Bea3E2Rvfv/kc3Pvu8zU4L5AiMZsvpdsxL+RVdI7T1aTaU57s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071970; c=relaxed/simple;
	bh=T4aBCkciOh4lUzl5d35g+zQT3DnpGikr68uEscT6WzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K+aBregJk4uLXVymW4K4EMtHilTTyNxMCUz/8xu4nGYiCodE5Ep0raC1GWRgjcNhQdGmVdD7KZK1kLwsgeJ8oKpgAiChMoN3q3SKCiMP3VYJNZs16SbyIc5bTHbgnFCPnAqtv+b5bkugJjhw3FtAtdWx2Kx/Zk95vsWF/aJ0+z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSgryfRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSgryfRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B3DC4CEE9;
	Mon, 12 May 2025 17:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071969;
	bh=T4aBCkciOh4lUzl5d35g+zQT3DnpGikr68uEscT6WzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSgryfRbsCNNTSKiEjWftlG09c4/mgMr3v/OcqxuanHybqpMTakED9+jEh3pMCM5A
	 8jSOJcJlpQB6OtGxOHC77VW4Z7P8p/hZ9jvAOxDe0wi5yiKcAWGgeGrOfYUW3nFKr+
	 Q7bdzHesfUjfrgZSAGlVErwOMX4MK5/I9Aw7Ncaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.14 093/197] iio: hid-sensor-prox: Restore lost scale assignments
Date: Mon, 12 May 2025 19:39:03 +0200
Message-ID: <20250512172048.169141799@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

commit 83ded7cfaccccd2f4041769c313b58b4c9e265ad upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/hid-sensor-prox.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -257,6 +257,11 @@ static int prox_parse_report(struct plat
 
 	st->num_channels = index;
 
+	st->scale_precision = hid_sensor_format_scale(hsdev->usage,
+						      &st->prox_attr[0],
+						      &st->scale_pre_decml,
+						      &st->scale_post_decml);
+
 	return 0;
 }
 


