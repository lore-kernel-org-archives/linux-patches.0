Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3E215EA9D;
	Mon, 29 Jan 2024 17:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548528; cv=none; b=iSCtYFEyH2GYE1IlbqyUZT0ydstn2bdzo+Mmu84J+cFoqitH2dY3wIXtuDu405IsnlEwTSCp+4gRg/+kzk/v8aWFC/VMRdjmKF+CF6XTESbXDLImnwo4fGBd4nCdpd0fvwNXpqmHI7x8wYTYjRtznWdtArtP6kty3xSJkEh77d0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548528; c=relaxed/simple;
	bh=/vNMii2+Ag+cWaZqETk7TuR1imIoYOCOY8eZa1YiEl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgRjI2HXMGr7EXJNw/ZATpOu5TbgZ/gdMS5jdYyttyP7MTfkVJrYLPDoJ4niauQdOMDha6GvTBCR/C9g7LG2ns6D42G9RoVHXxnNA10iWJtQHL0QHM8tUhqqsqAjngrvBH13QinY7xpIOwfa764CzNNiFimxU7hlbrZJMjn/j/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dudMymdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dudMymdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E6E8C433C7;
	Mon, 29 Jan 2024 17:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548528;
	bh=/vNMii2+Ag+cWaZqETk7TuR1imIoYOCOY8eZa1YiEl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dudMymdJ8NStkEeS3qDsNjKJJxKa/zpKz7LZauScCWKTPE3BeRCUl6NYgo4WPnrBp
	 c/b0pRapVTiElby+Up2zIfh8DL6NFFVDO+pe+K9ESDlMI7lZ0vfq/ZgVdtJJ3AEf8j
	 cnKqg0vtGmGtjztih9nHS1xS48V2bhG8ltkO0T/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Gray <jsg@jsg.id.au>
Subject: [PATCH 6.6 163/331] Revert "drm/amd: Enable PCIe PME from D3"
Date: Mon, 29 Jan 2024 09:03:47 -0800
Message-ID: <20240129170019.699691673@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Jonathan Gray <jsg@jsg.id.au>

This reverts commit 847e6947afd3c46623172d2eabcfc2481ee8668e.

duplicated a change made in 6.6.5
49227bea27ebcd260f0c94a3055b14bbd8605c5e

Cc: stable@vger.kernel.org # 6.6
Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2197,8 +2197,6 @@ retry_init:
 
 		pci_wake_from_d3(pdev, TRUE);
 
-		pci_wake_from_d3(pdev, TRUE);
-
 		/*
 		 * For runpm implemented via BACO, PMFW will handle the
 		 * timing for BACO in and out:


