Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590AC4D9EA;
	Wed, 19 Jun 2024 13:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803427; cv=none; b=j+E32wqaNs0xJ2IGLWK7bu/hZUCaDdNu1A4h8f0RjPQUFK0FCrWGoeILGnPwBjWUP0LRnQ8X/oJArWeb2TwJT9JV3Sx+FL0lnq18enJujIsYLUDsEyn0Ifbp1XP05Z/brT7CYft9vWsvdPljQJ7PQrp3fJ9MV9TyraBwHwZGmgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803427; c=relaxed/simple;
	bh=HUGAJP8c261pdoqRb3wEyfoyWTbV0mxMplJr8POdJ5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J9FfTVYvXnAJ8WoJDmzgbEr1Ytbmcq4G94jIFu56pjSZLXP1L8DAXWqPwiqOX1e79YYQg5KKdWW0gpxmKZKNMThuQPrcWZvLmJwgdAciYJTQxN67qBrRLM5Kb0GRLquIcyPJ1dzagT3Q+zAQAc2NmZn2GJOoR4wkeDrbYGIUtb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/OQGXP/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/OQGXP/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD322C2BBFC;
	Wed, 19 Jun 2024 13:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803427;
	bh=HUGAJP8c261pdoqRb3wEyfoyWTbV0mxMplJr8POdJ5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E/OQGXP/o7q/H2gzNVNUI6DNGKbAvBsLkhHxr1X4buT4KfJgrx090FNXUA4XXNR6f
	 f/XyJydFq//MljcfI9vU/vWrrXfZDnNDgRE9ZrmSbZ21vvP1HmXShSaUOTy+LB8E4c
	 PkV3M/QDjK//SYZCiNj3Jdpf4eHZ9Uz3zeWS2Grw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 6.9 263/281] intel_th: pci: Add Sapphire Rapids SOC support
Date: Wed, 19 Jun 2024 14:57:02 +0200
Message-ID: <20240619125620.098478335@linuxfoundation.org>
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

commit 2e1da7efabe05cb0cf0b358883b2bc89080ed0eb upstream.

Add support for the Trace Hub in Sapphire Rapids SOC.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20240429130119.1518073-13-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -315,6 +315,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Sapphire Rapids SOC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3456),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


