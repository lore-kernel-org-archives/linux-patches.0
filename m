Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 341DC4D9EA;
	Wed, 19 Jun 2024 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803433; cv=none; b=YSHMRfXvm7EWyDVylYFttO1LNH8XlQg0IGof0o6ksozlJSNCugZHX2rxblkwWxE5/rrzAgIqddqDjGOijxn5KEb6kJy40BLpEfYk2XqUvVFzmsz1fsS48xALzkG06AGCbBy15ujweTkJnDeKNVKacFhgec7Uj1p8yzDLnAXTr9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803433; c=relaxed/simple;
	bh=7OO/H04QhQf3O0WOjnBtsrJqTTJuQl1S1A6wDDvY24w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LX3kTPo/AMKSSkD/tErqciakze+RlbVUroivFhagqPsYDqtfx5OKU9Ghqh2/f34BdMiMzKOTH5dkIP2QPwcYZqE1wwETxcDmSplXyMrv9WCcDrfi+vRGDPih8GK+1X1B6BC1gEiWo/Ik+KINyXiUh32v7zDUCYDgMIEaInI7Mn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Q+b6hrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Q+b6hrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA380C2BBFC;
	Wed, 19 Jun 2024 13:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803433;
	bh=7OO/H04QhQf3O0WOjnBtsrJqTTJuQl1S1A6wDDvY24w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Q+b6hrrCKgMCzVSA4UKqzMWLO4EHCqbdqhp0CBRF/I1aLIm3AV+UP7o1pIdT+O4B
	 jH+l1G5loY0rW15Z3q+GEq+VfUlNs5zvn33E73MY10GhVhEqRDfadnLYkVhtTpseJ7
	 mwUD+osgq+h3UT6PdgiYInJxauzCCMhBRuXIY5+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.9 265/281] intel_th: pci: Add Lunar Lake support
Date: Wed, 19 Jun 2024 14:57:04 +0200
Message-ID: <20240619125620.174411966@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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


