Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7922A326927
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224209; cv=none; b=nBtfqSmxzJ3b3SB3DXUiqhNVx+W3nnCVlsfWE78XJl1Gg02XT18pjZl+OpFsrC5pU4+Xq8gGKrc5QBdPAFssmdSgJHPohm2xRU66DI217ywMXPHyUupOfEI+xdre9JREe8HU4nXRRo0grAuxM+Bkh/u7XF2ZohPcmG3A25Aj+po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224209; c=relaxed/simple;
	bh=15UeQyLpmbT4WURDtDVfj7Ro6Jzwn9DwD9ZEJzXPIUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SR9p78jZyxO89ITcEq2SMFbPcxdsfPR62PJOrJvt+fYWeHdD86rp82MCkho48xx2IO6xxHUvqweShJ15NGCTLhDdDHCW3GC3GAIhqxKLTXVSKNcd1e5iHHI1pzEI/E1f0MPlYiNUwLzDfq5JuEnUxFdc0g2d+3KZPy7VNEi3wOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J26gFuju; arc=none smtp.client-ip=192.198.163.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J26gFuju"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789224208; x=1820760208;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=15UeQyLpmbT4WURDtDVfj7Ro6Jzwn9DwD9ZEJzXPIUw=;
  b=J26gFuju7JRLLBkIq/kZAXBYenNF7r9IYHEgLqeT9ogSRtYv8Q1txhQg
   rScET/PDu0sPrG9Y/jFsm2rDY/E94pS9JLfGrXGPDZw92D+9g5ZfI7AIP
   67V/2qMJTkxowzhzIDrpKK96Cz3F0nd4mwoFYbSw2/3VxIVIyU5aucH85
   d/3YwHBHr3GCbM693ZEn3q3TP/+/4NT2cLM9kTzSm0umQg3Njshcgsk64
   BSRDwd9LTjq9YiEqvaomz247zhskRd154GgpUnZyMhPZEHjypJl/YyWWS
   UFTBdvbDJOOUxdVyO0I6telMGj0l71JByp4OYK3FN083wLRdLnGE2Ip0d
   w==;
X-CSE-ConnectionGUID: jYWj5ZJ8QZSr39XB3AQuUQ==
X-CSE-MsgGUID: 475VZXbMSkKbLxYbTNgQ/g==
X-IronPort-AV: E=McAfee;i="6800,10657,11903"; a="169009"
X-IronPort-AV: E=Sophos;i="6.27,99,1787036400"; 
   d="scan'208";a="169009"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa116.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2026 07:43:27 -0700
X-CSE-ConnectionGUID: l/ardDibSmKMB19uHMcwyQ==
X-CSE-MsgGUID: 9Le6i5uLSy+/5mB31Od14A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,99,1787036400"; 
   d="scan'208";a="582203"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2026 07:43:25 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7.2 0862/1815] wifi: mt76: mt7921: validate CLC firmware records
Date: Sat, 12 Sep 2026 22:43:14 +0800
Message-ID: <20260912144314.573358-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912065709.160404014@linuxfoundation.org>
References: <20260912065709.160404014@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 12 Sep 2026 08:43:32 +0200, Greg Kroah-Hartman wrote:
> 7.2-stable review patch.  If anyone has any objections, please let me know.
[...]
> [ Upstream commit 9417c5818a0146980c2608fda94c908e604eb033 ]

Please drop this from 7.2, 6.18, 6.12, 6.6 and 6.1 for now.

On its own it breaks probe on MT7922 with linux-firmware 20260810:
the CLC blob in WIFI_RAM_CODE_MT7922_1.bin carries a record with idx
3, these trees size phy->clc[] at 3 or 2, and the new bounds check
fails mt7921_run_firmware() with -EINVAL. Mainline is fine because
e9f3f1cc133f, also in v7.3-rc1, grew the array to 4. Mikhail Gavrilov
hit it with this commit on a v7.2 tree:
https://lore.kernel.org/all/20260816132325.23007-1-mikhail.v.gavrilov@gmail.com/

The check is still wanted here, today that record is indexed past the
array (UBSAN, https://bugzilla.redhat.com/show_bug.cgi?id=2515420),
but only with the follow-up that skips unknown records. That is on
linux-wireless with Tested-by and Reviewed-by, not applied yet:
https://lore.kernel.org/linux-wireless/20260816174841.1918-1-acharyalaxman8848@gmail.com/

Once it lands the two can go together.
