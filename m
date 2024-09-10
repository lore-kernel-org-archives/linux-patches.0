Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE770195B14;
	Tue, 10 Sep 2024 10:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962672; cv=none; b=OOmUDuZSyRCq7wj71w9kJm+O/khimHwoZfjG+5Y9b3AwUyQOsbo4p52WvjIAR4Fa6xjsXXkpDt/NImZNiVfzfo+KY81ugVt2k23EJ9prejg1E+GjJSRoA8k76CvjJm0LfOR2F2M3vkVcL0QSr808GxAMKoY3uuUMesmSkePMVaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962672; c=relaxed/simple;
	bh=8KuC/sTv08vBh26ijzjXZK2axHCa79s/AhWcRuqYWQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnP+F2kkLO3SDx/cbfWro06qSkoocZCeuH5XSHebYhJB0DNGuBYb0WxoBbQOkG0JNfN/oBUoSw+6sZScC1UKoWNTliI2BhH5iL0e0tQO+r+neAhvZOMannEztyIzqTiOhTSo42ghQNaEwyqS4e0IQXiL1JV1VKyfGKOtUBZ2uIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBNTOsZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBNTOsZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462EFC4CEC3;
	Tue, 10 Sep 2024 10:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962672;
	bh=8KuC/sTv08vBh26ijzjXZK2axHCa79s/AhWcRuqYWQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBNTOsZyCGju/9hi0tvtUJvFwJ3Gg6Ujhg7vyIHQHfyUXzMSbcib6i3dI3SxgooCa
	 /4Qhc6UaYKqHLX5FP3psm65L64zGJGZ1uOAcF0RmUOtNppZUCrlTR5Je/bKlsFbjzZ
	 8e4+sn4waSBOhtZqQFJB56b+bW8Nt/CzDPw2Yl9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Gavin Shan <gshan@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/121] ACPI: processor: Return an error if acpi_processor_get_info() fails in processor_add()
Date: Tue, 10 Sep 2024 11:33:07 +0200
Message-ID: <20240910092551.138722953@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit fadf231f0a06a6748a7fc4a2c29ac9ef7bca6bfd ]

Rafael observed [1] that returning 0 from processor_add() will result in
acpi_default_enumeration() being called which will attempt to create a
platform device, but that makes little sense when the processor is known
to be not available.  So just return the error code from acpi_processor_get_info()
instead.

Link: https://lore.kernel.org/all/CAJZ5v0iKU8ra9jR+EmgxbuNm=Uwx2m1-8vn_RAZ+aCiUVLe3Pw@mail.gmail.com/ [1]
Suggested-by: Rafael J. Wysocki <rafael@kernel.org>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240529133446.28446-5-Jonathan.Cameron@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_processor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/acpi_processor.c b/drivers/acpi/acpi_processor.c
index 2c4dda0787e8..ffa10cb4f717 100644
--- a/drivers/acpi/acpi_processor.c
+++ b/drivers/acpi/acpi_processor.c
@@ -388,7 +388,7 @@ static int acpi_processor_add(struct acpi_device *device,
 
 	result = acpi_processor_get_info(device);
 	if (result) /* Processor is not physically present or unavailable */
-		return 0;
+		return result;
 
 	BUG_ON(pr->id >= nr_cpu_ids);
 
-- 
2.43.0



