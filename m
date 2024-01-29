Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02267161B45;
	Mon, 29 Jan 2024 17:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548349; cv=none; b=uPSSGOXiPAgCYn0UwXCdRanwS0U4AvYTi7nQfSn/SzndyT/NYoPHdBDxxTutGPdBeuwoAoyzTkZeOm5umQQS6qm5Hisn976K5eoHZsBXgkCG7h0w3cnqCgub4Dz11lqjC+1n4SsHR2jUL3Ue0xDxOhFFq9Mom+m1cOW9af6BM/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548349; c=relaxed/simple;
	bh=OmLsEj9IAD7ysjDOaIWEbmJ7QB6NxRiVs0lW8hi1U1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ObeKZEplGk0kAzNwxOjjOsvB47PHj6eLf3bQ8rZWbEvYNvFi+ulbljO5x+wEdJmh9cmCy9xWEdI1Rqtf7n8l9eFsQGMhc5A8tj5c/dZkmCh6CyZY4LBL22cFdrkOWfcMGNGEgTMHpKXIu/mOsKjEuEnXmaeYa87UOV9SULskjvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YB/oTSx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YB/oTSx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC9FC433C7;
	Mon, 29 Jan 2024 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548348;
	bh=OmLsEj9IAD7ysjDOaIWEbmJ7QB6NxRiVs0lW8hi1U1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YB/oTSx2/yMj0YZ2QnCcGa5fcDLFaQy+1ckqne1/a+QzC4rkWFokORnXU+A6v0Rwh
	 8AAGdAEOdS0V6DIidOumYczSPGUBq7eZoCbpBytdSpW+fQSZWsMPubww7BeIy0iQtM
	 uaNKh78buZK+H5M9zuJ0qPoFUby0lwYsnoww+Ulk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Jithu Joseph <jithu.joseph@intel.com>,
	Ashok Raj <ashok.raj@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 340/346] platform/x86/intel/ifs: Call release_firmware() when handling errors.
Date: Mon, 29 Jan 2024 09:06:11 -0800
Message-ID: <20240129170026.501275283@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jithu Joseph <jithu.joseph@intel.com>

[ Upstream commit 8c898ec07a2fc1d4694e81097a48e94a3816308d ]

Missing release_firmware() due to error handling blocked any future image
loading.

Fix the return code and release_fiwmare() to release the bad image.

Fixes: 25a76dbb36dd ("platform/x86/intel/ifs: Validate image size")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
Signed-off-by: Ashok Raj <ashok.raj@intel.com>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/20240125082254.424859-2-ashok.raj@intel.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/ifs/load.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/ifs/load.c b/drivers/platform/x86/intel/ifs/load.c
index a1ee1a74fc3c..2cf3b4a8813f 100644
--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -399,7 +399,8 @@ int ifs_load_firmware(struct device *dev)
 	if (fw->size != expected_size) {
 		dev_err(dev, "File size mismatch (expected %u, actual %zu). Corrupted IFS image.\n",
 			expected_size, fw->size);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto release;
 	}
 
 	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);
-- 
2.43.0



