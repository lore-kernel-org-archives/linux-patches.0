Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CBB3C0B;
	Tue, 11 Mar 2025 15:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707587; cv=none; b=KoWYZOUCL921xV8l0p5v8Qy4DnLNotdG7RcbH6lrceJ/ERnuq1wGHTSj3LmPrboCd+qttAE+i9tNDx7hLCLLHQ0vS8bzTz5/jnJpmIxCKzcJaUy/Z32iWvSLoZAweaO0WrPTYqqtMumq4Ft857uYhaSduc+RT5oBVZ/VOUsiH8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707587; c=relaxed/simple;
	bh=KmK2QCtsscrE5hp4q5Vqh5+8dwdQIar4WXKPhlx9n4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4IeMEuZfA6nVO5/mNZA7FrpL4H0OqWqoAshvhur2se79wHZkH8hu9GiQvNRslXICR+8zdTgV+a+VC/qGtdRlC85TBs0L90sQ1AZk5IWs22GXPWVtD4Pns47+maFuuiu9ksV2lCief7KnA13P/l/J49vvYVF22JD/LT/qo34rmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ukIJXQS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ukIJXQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1EDC4CEE9;
	Tue, 11 Mar 2025 15:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707586;
	bh=KmK2QCtsscrE5hp4q5Vqh5+8dwdQIar4WXKPhlx9n4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ukIJXQSzv0otmYBKgFZUV5GYSkkK1Rpl1cY8HaXsQdMjZ2rYi5Z6qaR+NcN1QvGi
	 Q6cNwkRbyRXV4faQp2m8D3FK0qXDV9Q+dOY8UJHVJMMI6ISOoZqF+PXIGE9j+NUHBJ
	 JVbA9f0EOEcmGhyt5Tp7pLJkoSJdzActuhsqCf/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.10 439/462] intel_th: pci: Add Arrow Lake support
Date: Tue, 11 Mar 2025 16:01:45 +0100
Message-ID: <20250311145815.672914951@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pawel Chmielewski <pawel.chmielewski@intel.com>

commit b5edccae9f447a92d475267d94c33f4926963eec upstream.

Add support for the Trace Hub in Arrow Lake.

Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: stable@kernel.org
Link: https://lore.kernel.org/r/20250211185017.1759193-4-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/pci.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/hwtracing/intel_th/pci.c
+++ b/drivers/hwtracing/intel_th/pci.c
@@ -330,6 +330,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Arrow Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7724),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Alder Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x466f),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


