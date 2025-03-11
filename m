Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D6A7E110;
	Tue, 11 Mar 2025 15:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706281; cv=none; b=m56T7gBEhz0ZOiUZX8zzY6GeulcBu23898ww15Aq8tKrjNQ0QiHoAXSscx1TRmJfjUL8QiZG03EG02kVD4FtRI+1r9Oi1gt+SGUssWbZWyg9KPsK6l0pIN+2KNMRLOebnjp7h3Y+OwPxOuNFmFeWgYuK7Z3VNNPII3qJOL1WtS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706281; c=relaxed/simple;
	bh=Pjjk5WaDTE0hoxOotWuOOdErxQGTwyxwR3+09V/cBaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5hb5Imn0FfckRwM3V5GZ6z+etrqeh7sBjjlfH5qypacGSWyJSX9FnRm2yI+12jewlbnPDl/x9k7HroFHOo5sU0AbweKimAbYMgdFgrM/Kcd2S2furKpKUnBwBTRoTItuhQSt57TlQp4txEKwGee2nzcodH7yNnbgVF6Q6NxcBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fi2tc68n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fi2tc68n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7346AC4CEE9;
	Tue, 11 Mar 2025 15:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706280;
	bh=Pjjk5WaDTE0hoxOotWuOOdErxQGTwyxwR3+09V/cBaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fi2tc68nH94JV/1VqzGslUytQQTfGVvnXDLi4YfqksJr79N9OKUZzBfM9ynDKqlOP
	 zEnk4EERz5O4530/emDyx/JW+p6G0xmjJq3lM8JqSoRt9GUd5AbzSQgw6Gylv3vSYo
	 FBwcZ94554AZ3qtATEWNF6xTWt063J7tyOwtQvs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.4 324/328] intel_th: pci: Add Arrow Lake support
Date: Tue, 11 Mar 2025 16:01:34 +0100
Message-ID: <20250311145727.776171408@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -325,6 +325,11 @@ static const struct pci_device_id intel_
 		.driver_data = (kernel_ulong_t)&intel_th_2x,
 	},
 	{
+		/* Arrow Lake */
+		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x7724),
+		.driver_data = (kernel_ulong_t)&intel_th_2x,
+	},
+	{
 		/* Rocket Lake CPU */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4c19),
 		.driver_data = (kernel_ulong_t)&intel_th_2x,


