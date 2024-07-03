Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0315617C238;
	Wed,  3 Jul 2024 10:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003966; cv=none; b=KUX/8tcH/URx2XDuCI9XquUl7gjc3W44g4HMxdnWOI1ha5144hiufiOIYzmZebKEoF7ZNknBCWTClf7Kv/xCxTrXeuusvQyEByIU+D3foLDD1B7bQaTg1FHpSc3RpCovE+y1XrDmxx3pyMg7i4WhH9kVjoNKHfKJJ23vmVbcohk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003966; c=relaxed/simple;
	bh=PoHAxRSrYg4tlnKA9MXxF+l7/z4ILGriF96yqBbE2bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J3aePAhHwakT6K+qRCoyrkjvdOt7rL6pNQwe8oY0GRob8EPpey2EnrHSewI6N864+u5GMZZS8pEh6bWxekyzNRkWqjQIRt2aLCm461KQQ5ugjVyZa3W120SLKq26NwqY0WSZuHfhhKAcMcEPZGQzx/4wKwR9ye3R6D08oHWtc8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KH8O/Fff; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KH8O/Fff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF9CC2BD10;
	Wed,  3 Jul 2024 10:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003965;
	bh=PoHAxRSrYg4tlnKA9MXxF+l7/z4ILGriF96yqBbE2bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KH8O/FffvCTHuWSprOp6lv27SK/ZvgWqWKm85mqKbBHPbJHZ/P0v2qYfYsJ7SdvWj
	 AlM5108Hwu+1ztYVZijNMV5F891V6vimDK6ola0a481L1Vo2lCMTtoekSwqiojStiF
	 1l3NoksZn5npvlY16i1PcVR6uQrHiVzohfhuVKTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 079/189] intel_th: pci: Add Meteor Lake-S support
Date: Wed,  3 Jul 2024 12:39:00 +0200
Message-ID: <20240703102844.486053134@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

From: Alexander Shishkin <alexander.shishkin@linux.intel.com>

commit c4a30def564d75e84718b059d1a62cc79b137cf9 upstream.

Add support for the Trace Hub in Meteor Lake-S.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-14-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -295,6 +295,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Meteor Lake-S */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7f26),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Raptor Lake-S */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7a26),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


