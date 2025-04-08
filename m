Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E23F26B960;
	Tue,  8 Apr 2025 12:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116127; cv=none; b=iFzEYC6CxAVYpf0ScnfOD7xuYGzQONb946KBvr/XMKw+BuJB07rvYWcHyog/nzmE3ahYEGsAbW1UYnHms8IqRByjFBggz9xFonpiASUZ/RnrDIdAQ76aSrj6KfoamWrwFxyCqA5YyF8+p49L2FG0RBbDMr8qi5/UEKzdBMhQdMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116127; c=relaxed/simple;
	bh=miZ9XC3WESZtOQtvFNpK/H4TWghfYeqK63bvpHDy3oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pHwrxOlQ/ng+eNsvkiK2TpAioGDbP/bBZFb1lrlG8TAQMS5iuAq1vchG5gUdIJNX7QOPQh6q1+P6fe/F+eYov/SNUVftWlQgQi5jlBZNwqc+aKaTo/+ZdEFXpMC6/JqhoSEfDK7MochniFUJzPG/VhzIpt8fmMocEQF1GA355EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nMLC9/RF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nMLC9/RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EA5C4CEE5;
	Tue,  8 Apr 2025 12:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116126;
	bh=miZ9XC3WESZtOQtvFNpK/H4TWghfYeqK63bvpHDy3oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nMLC9/RFOrWVsrwtEwx9Mk5+cbmVytGw2ulMw8pbU4HWbalmLEL0PwxDyFNo+SZ8D
	 FYag7//3oJIxcjgpCF41RCdkpoqG4vPrMSxV5+FFK057G8Zrk711wo5p/lrcl9bH0T
	 cMuqa4XmNs4NeO0ZD7xWffd7uGra/7MPDT2aD64o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/423] thermal: int340x: Add NULL check for adev
Date: Tue,  8 Apr 2025 12:45:51 +0200
Message-ID: <20250408104846.333902800@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 2542a3f70e563a9e70e7ded314286535a3321bdb ]

Not all devices have an ACPI companion fwnode, so adev might be NULL.
This is similar to the commit cd2fd6eab480
("platform/x86: int3472: Check for adev == NULL").

Add a check for adev not being set and return -ENODEV in that case to
avoid a possible NULL pointer deref in int3402_thermal_probe().

Note, under the same directory, int3400_thermal_probe() has such a
check.

Fixes: 77e337c6e23e ("Thermal: introduce INT3402 thermal driver")
Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20250313043611.1212116-1-chenyuan0y@gmail.com
[ rjw: Subject edit, added Fixes: ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/intel/int340x_thermal/int3402_thermal.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/thermal/intel/int340x_thermal/int3402_thermal.c b/drivers/thermal/intel/int340x_thermal/int3402_thermal.c
index ab8bfb5a3946b..40ab6b2d4fb05 100644
--- a/drivers/thermal/intel/int340x_thermal/int3402_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3402_thermal.c
@@ -45,6 +45,9 @@ static int int3402_thermal_probe(struct platform_device *pdev)
 	struct int3402_thermal_data *d;
 	int ret;
 
+	if (!adev)
+		return -ENODEV;
+
 	if (!acpi_has_method(adev->handle, "_TMP"))
 		return -ENODEV;
 
-- 
2.39.5



