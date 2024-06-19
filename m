Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2543813D525;
	Wed, 19 Jun 2024 13:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802556; cv=none; b=Krp61mFIa66EyscRaC2ViK7HUX03x3XIo0FeUp2ktkcnch4nt2EMuYdFzbDi5CYCHhjgxMTQZ9hanoavseyBwBTy/mpqVCcGn357y0Jv3Wcz1eZdkUZH1zf9EI3H9iCdK4hlP8oTRf813e6s8UTeaz2ZBXkA+ydqsPCn+VAu9h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802556; c=relaxed/simple;
	bh=P0ifouM+umPDQ3xz10Q1UXqPxmdJ6n+Bgu92kZA4BCY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KyTn8IE4s86r4OtVnI11Rp81x6mFIT84rwIG/BQY5sJ9/T/BvKPDI9Jd/W+WiJDB9Q94BV73zyElcGnAFXGqPxp5GPF+JkZaw2FfNaR6lEpLSQb/Wj38ZTM91wca1pGk/5uGaWaic260OtI1K8gWULWoRBYQimjqCuBwHff1sUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FRxYk7SB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FRxYk7SB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B029C2BBFC;
	Wed, 19 Jun 2024 13:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802556;
	bh=P0ifouM+umPDQ3xz10Q1UXqPxmdJ6n+Bgu92kZA4BCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FRxYk7SBrgOGn49yB+U34VLE2YrVXhDIQLfgd/gOiNkLGY2B/se+PTl7d9P3sOyMI
	 ZhhyyE5dHYJHCSFwFReQmQG37qx1ZN31I6xOu0Ct6Rbdxb3t+6B7xz9aG1j58IYCA4
	 j4XE4yyJ+OsNHQZgSkrIf6WbL2otPbXBuHjLsnww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.6 219/267] intel_th: pci: Add Granite Rapids support
Date: Wed, 19 Jun 2024 14:56:10 +0200
Message-ID: <20240619125614.733004076@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit e44937889bdf4ecd1f0c25762b7226406b9b7a69 upstream.

Add support for the Trace Hub in Granite Rapids.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-11-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -305,6 +305,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Granite Rapids */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0963),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


