Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B64013DDC0;
	Wed, 19 Jun 2024 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718804054; cv=none; b=UFCnNFoI11OTs2OrjskouMkC+xrweOmoWuqDANwWnJ9BcsE97c/rm3jb6zYj+u0epbI59FfP9eTuuxy08JdgEZflUTAyEajEsti4Q+grcoi3hJCaUcCHd5JAAhIwvUTdCccMaTWF5Ud+npvjQiAuit/T0jy3dQrvSO0SoUIQ4Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718804054; c=relaxed/simple;
	bh=OKRZOlHmJh7iiKLrO6ZyR+L5uSv7imK8caXym4RQdDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N2mQOKaOP2rtrK/WdSNmaLonDZ1FN+OoaX5+Ijf/MQGdr0SmE/JXe1oi3GIB+e7S/OKaHKjFFhtBlHg2E35rI1N4puQJN1/v0gCKh6QDuadoQXMy3Jk94arLfzmXoRPm0Gc7j6P/KDDoQLs2RP6cAE5cGxbW36okiftk9HZJwFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3Dh9Cqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3Dh9Cqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860B3C2BBFC;
	Wed, 19 Jun 2024 13:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718804053;
	bh=OKRZOlHmJh7iiKLrO6ZyR+L5uSv7imK8caXym4RQdDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3Dh9CqcmUvvhjJSPGMhPWqQPJA7XC4PXn/tg8oLsfeTTYpTSNjoxdkJiU1VKpdBG
	 y1O8AKkQS2AQ5YsYzv93vz7N2bfd7JpAmESDrU4cdReC96+cr5dB4CJ2tBNDiv4FJ3
	 mL05uUYobmnkWudRq07ifq/znDeV3mStjH+SxHRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.1 193/217] intel_th: pci: Add Lunar Lake support
Date: Wed, 19 Jun 2024 14:57:16 +0200
Message-ID: <20240619125604.130310930@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit f866b65322bfbc8fcca13c25f49e1a5c5a93ae4d upstream.

Add support for the Trace Hub in Lunar Lake.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-16-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -325,6 +325,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Lunar Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa824),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


