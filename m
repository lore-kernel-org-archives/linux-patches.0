Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51D961C3C1C;
	Mon, 10 Mar 2025 18:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741631060; cv=none; b=rfg+Eas3afhwUqmAmjknIkz7FcUynFrbajh61xj8MQo4O1IBw6MrXKOYl2EBwuaGSmDHDjB2ouuOl3KngzdIA6ekzANElHYMu/gz+Nw4XG8roaNR6uw/igIipcUjW9r1OBBoke+3d+eBhw4Jh1VCbBWmBAjeSP/vN+MWwsLJbBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741631060; c=relaxed/simple;
	bh=3l87cfRIJOo+3wh8vsdzVZ4C4PpbVF6mJgZQcLTM8CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIM6EF/LH7dG5/HHcNPJZIpNNkRbKr2OpggDZ19uECSXXaGvpBjmHtdD1SRnW2nFTqlZxDg/aZ9A/1ri35VFNPOzlMhYK6J3nNf8B0bhuBdp+wYjsXVuCm2xa+b/CX8NiAYptCHgzqPxZ2cg1jRC30iL8EVTS6WIQGZCdN7L9ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXNuPI45; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXNuPI45"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB4EC4CEE5;
	Mon, 10 Mar 2025 18:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741631060;
	bh=3l87cfRIJOo+3wh8vsdzVZ4C4PpbVF6mJgZQcLTM8CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXNuPI45baJB43ARhXnjNJp85LIOLjkK0ui6QodQ7djwUPeOJUVvFhpSTuKnYmFvv
	 KLjHKMJyI21eOQvqJFmAiZSJVE+nCrXVPDgRiBLMzO3HrzsMVtR5Qcs9vEJCY1ltK8
	 bCMe1crZQVV7nrtVNkLn7xin1rEHl/l5ZTfzPDOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawel Chmielewski <pawel.chmielewski@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	stable@kernel.org
Subject: [PATCH 5.15 598/620] intel_th: pci: Add Arrow Lake support
Date: Mon, 10 Mar 2025 18:07:24 +0100
Message-ID: <20250310170609.140256591@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


