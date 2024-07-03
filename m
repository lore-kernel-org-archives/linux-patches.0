Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C382417C238;
	Wed,  3 Jul 2024 10:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003962; cv=none; b=m5F4CLPzvkEfCspWVguqiaVoLt5a7nOxNUMuqipRLIBUkVUMmmqvPNG8P0K5mStIuZa7cDAnX0X8BOkpPupGijdewgRaTNS6hVyBe1JkT9h12GY9UvbJKMR1HozDfCt32zgJBsDv8hpErMzSxESh4tGH1DwKjUWBglaStPaVvY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003962; c=relaxed/simple;
	bh=KNEJL3tBFwhdziibjODxoqjL5uhp55SIg7J/Vxrto7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8Vz5VohEFFWr+vYdVF4uRfA6WrJwLkig+j0p/UYiEHsy2fXex3CanYCTqn7fydjGF+mfwuJictqGdZeYmb0HG0Wo36i3Nhd9G+oAKz1WHFN3t1+1ZzAPkUFVnFLINzX9pb4pk03+uy9deXKH8zEdDltheBdh1U5cJKviecQ88g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V88rJ2jf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V88rJ2jf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E02C2BD10;
	Wed,  3 Jul 2024 10:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003962;
	bh=KNEJL3tBFwhdziibjODxoqjL5uhp55SIg7J/Vxrto7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V88rJ2jf8+vcNUBV/MsNpoa+88p1Pk/75MP23SMZR+5Jc2cfh7kDbD4Ln7RXF+oAp
	 L6z+zMLCowayDnTnHp2Lh4TyCEX1a4rSY8Fg+v2XVzpkunqVE01HTxCDUCASIy1z0J
	 6hMZiTvUxAgmD8uoh0G8ke35Y1S6jRapL1zpr5ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 078/189] intel_th: pci: Add Sapphire Rapids SOC support
Date: Wed,  3 Jul 2024 12:38:59 +0200
Message-ID: <20240703102844.449195737@linuxfoundation.org>
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
@@ -310,6 +310,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Sapphire Rapids SOC */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x3456),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


