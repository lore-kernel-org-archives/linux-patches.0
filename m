Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1272676CF;
	Tue,  8 Apr 2025 12:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114245; cv=none; b=GgOFZGeJ8++e9kwzJXDDobMh3oxi0CUKnGeSIsSIp41ec2ECBjgGMrwopAw2JBnGn9QpIRLxftUbW3vCNOwUO9FYjOsj9skcDpOVksyALNRyQPxlE7PFhYmJ9F0hH+ssXBT0ZixEDYPFfRrrEZHvlXGnoF8OjOGXshMW65flEdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114245; c=relaxed/simple;
	bh=HoOD9KfmspIpdOeVOJbyhi1Kh2oAzSZ+YDi9yJvbVh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyDX84OuvMvs1msLnR1fHjn/1u9r9NzgNAU6EPeVYQQaKa702qp8Sidpv5qPOhkGcXLrdxg5rtrBl+i4Icph3cZhqtRcJP+R1QnjribIei8jaE1ZoHtMhzapPJkSPLKJ5lAUKzez+zrIWXFsaO1Nswcre0b1TfzDCIW7j9hMTgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fL8/rQsZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fL8/rQsZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBBDC4CEE5;
	Tue,  8 Apr 2025 12:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114245;
	bh=HoOD9KfmspIpdOeVOJbyhi1Kh2oAzSZ+YDi9yJvbVh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fL8/rQsZfr1R+zpTpiTyB7cf8cZfw7LtlgGUVtE9RcU+H83pj9Ju/GZO2l0S2N6wN
	 4RO4HNa3lppzR2AY1z8wjgxsg8BafD/T6Uzcm6hUtX1qiMVg0rBofX+P7VzdXK7Btc
	 OFTQnAV1MIiwhJAP6lyOEyshxchoQzjl27m6ixYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 034/499] thermal: int340x: Add NULL check for adev
Date: Tue,  8 Apr 2025 12:44:06 +0200
Message-ID: <20250408104852.095953498@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 543b03960e992..57b90005888a3 100644
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



