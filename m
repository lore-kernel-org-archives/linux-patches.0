Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0222F173334;
	Wed,  3 Jul 2024 10:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720003969; cv=none; b=jYyfw6ksK59IEp6Hp9hDB77HpDEC7VBOyyU9nnaE5bY1zF8yC4CobcigfqTWEs5IIHwRpkYlhlorAtHVnl7eVf/ECkK6AgG/loIPb12rNjobpj2V2Xp3aozO0iS58eqByuTEa5WmCxJ95SjMSnMFPiqm5MEctIEqcxqTg5w9kX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720003969; c=relaxed/simple;
	bh=w6ibvsV+lxmw/JSLH7yf6fEUM/kPP/Vc2h9eCjG/AoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jfGIyVOICGyXRXMTB0hOWJ6X5PuoSrn3cIJTt8ojARIAtjZxYMk4Q13Y7ktW/PbZAA3b4LT/q3LNpz2aZzIM3/GmGX88Bb1Pvq+MwnHjDo67E+4jtyqVIfQ7Ah6xU4F0TDhrh/wmdFz9l0skopm1xAp36KlFbtCw95el+IUnwFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggxrVqOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggxrVqOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF15C2BD10;
	Wed,  3 Jul 2024 10:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720003968;
	bh=w6ibvsV+lxmw/JSLH7yf6fEUM/kPP/Vc2h9eCjG/AoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggxrVqOLe/0vEk5o3VjDnpyYLYUWneq/jtDYIiv13aQShSX9BvG/pdACiLB7kN8g7
	 uT2DMxR9mMQwDe1yeHvywf55RzMoNhLMQnWJwrKo2H7BbCLRwB7FnJhtBxXGQCIoVr
	 vXg321j7F1uefUB1hE2iYklIW3YrhCsPSVsmex/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 080/189] intel_th: pci: Add Lunar Lake support
Date: Wed,  3 Jul 2024 12:39:01 +0200
Message-ID: <20240703102844.522585434@linuxfoundation.org>
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
@@ -320,6 +320,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Lunar Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xa824),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


