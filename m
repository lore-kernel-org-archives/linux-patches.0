Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF65523C50F;
	Mon,  2 Jun 2025 14:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872992; cv=none; b=u9bm/QtEr4YcvWbPS+ksqTTbKbY6LgCFD/E6uBzelqi9hB8jcDQQwCcpRNkZvbircNiiL66vbyRj3cKUZi1iJFozgZUawuxN+LKzN4khe1NbzJvET/0GaB7vP/DTI+IjW2WnohXIbv3cMRWtqkXX+6dT0J0RTlMxUx+FN1iDD5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872992; c=relaxed/simple;
	bh=6wulQ6QChfk79ln1HPofSLVQZXaX66rrofmJIGsLtxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9aLzyi8YoWiKX3S1LlOvsIzlp4b5Jw9GmslKR8fELE8PNPWtqj/LHWxqnyZpcMRfLnj+gs0LcElmGJx/nvaYRGRK3RTo1/4Oo1bLFcVyJEgSvfYcxM5GHYXiktR6uOIgpxpnvaITPbxyGXuY8FwVoLsNSiW0VWJtLeHOrBmtY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GPCFfSt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GPCFfSt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B136AC4CEEE;
	Mon,  2 Jun 2025 14:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872992;
	bh=6wulQ6QChfk79ln1HPofSLVQZXaX66rrofmJIGsLtxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GPCFfSt6849nzR0JGYprKyc+fb4BgzrGkiuBiPKx9CBWxB/DftupuHXb1HvEupmUm
	 nE314BnrLEbSdp0mzFVCeEtOFui9dxtbx+Ce63bOuXtII+PHy+DauCLoev7GAMaP2p
	 WFuVYFU6H45ilFstyqSsW40BtzE3/3mgbaJLj6Nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.12 32/55] perf/arm-cmn: Add CMN S3 ACPI binding
Date: Mon,  2 Jun 2025 15:47:49 +0200
Message-ID: <20250602134239.547594053@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

commit 8c138a189f6db295ceb32258d46ac061df0823e5 upstream.

An ACPI binding for CMN S3 was not yet finalised when the driver support
was originally written, but v1.2 of DEN0093 "ACPI for Arm Components"
has at last been published; support ACPI systems using the proper HID.

Cc: stable@vger.kernel.org
Fixes: 0dc2f4963f7e ("perf/arm-cmn: Support CMN S3")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/7dafe147f186423020af49d7037552ee59c60e97.1747652164.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/perf/arm-cmn.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -2650,6 +2650,7 @@ static const struct acpi_device_id arm_c
 	{ "ARMHC600", PART_CMN600 },
 	{ "ARMHC650" },
 	{ "ARMHC700" },
+	{ "ARMHC003" },
 	{}
 };
 MODULE_DEVICE_TABLE(acpi, arm_cmn_acpi_match);


