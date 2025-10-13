Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D02417A2EC;
	Mon, 13 Oct 2025 15:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369427; cv=none; b=aiaKorGIsv5u3R9xkch/HeJL1l8lQgLawQvJEJ13y0uavw+qGXSpM+LPKBade0gYXoVsajg10i6vLK9MTT5zAaITK22XIdmjHVxMN+Y3zzJC21mt4L1whw76mjmp7kLWScfVjc1dM1G5VOxXgcVeyoCCY0KgVF0TXbanMS+e5TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369427; c=relaxed/simple;
	bh=AWl1SMHAV9j5M5UpJhC0RVbs/fzQhHRs+eWiqO5lpKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQ0dLDuRDUNxqxQaN/z0oZjwqR3Es2OazwqGXcW2zIzDkJCIUrOHGoYv5juGq0fh4Lng+dDNzLJLKfZ1dXwmf4lZMxQB5sZM4eoU1983aAwS5bdF52KY/WO1Mkp57G6oirQPcHqzYHh8a2o0bKvQml86v91a//x/m0An7bQciyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1LwxrM6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1LwxrM6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228ABC4CEE7;
	Mon, 13 Oct 2025 15:30:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369427;
	bh=AWl1SMHAV9j5M5UpJhC0RVbs/fzQhHRs+eWiqO5lpKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1LwxrM6le9cMeC+4waFdeJuuYrL0NRkpAqTgRRzQjOIn8vSAq91bQm3AOFgqBOR1
	 UE24cFWsfkuVHBgkFuPNlA53LaDjMLXqNZcnNcNOnn+7lRioL/xaXVzVSBI5eCgZeh
	 IwM2MEJR3Yhi26rgLZam2jchMVR7XWsHHU9JJfxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Marques <jorge.marques@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 243/563] docs: iio: ad3552r: Fix malformed code-block directive
Date: Mon, 13 Oct 2025 16:41:44 +0200
Message-ID: <20251013144420.088344131@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jorge Marques <jorge.marques@analog.com>

[ Upstream commit 788c57f4766bd5802af9918ea350053a91488c60 ]

Missing required double dot and line break.

Fixes: ede84c455659 ("docs: iio: add documentation for ad3552r driver")
Signed-off-by: Jorge Marques <jorge.marques@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250818-docs-ad3552r-code-block-fix-v1-1-4430cbc26676@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/iio/ad3552r.rst | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/iio/ad3552r.rst b/Documentation/iio/ad3552r.rst
index f5d59e4e86c7e..4274e35f503d9 100644
--- a/Documentation/iio/ad3552r.rst
+++ b/Documentation/iio/ad3552r.rst
@@ -64,7 +64,8 @@ specific debugfs path ``/sys/kernel/debug/iio/iio:deviceX``.
 Usage examples
 --------------
 
-. code-block:: bash
+.. code-block:: bash
+
 	root:/sys/bus/iio/devices/iio:device0# cat data_source
 	normal
 	root:/sys/bus/iio/devices/iio:device0# echo -n ramp-16bit > data_source
-- 
2.51.0



