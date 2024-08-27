Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC7212B93;
	Tue, 27 Aug 2024 15:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770818; cv=none; b=Z4/KGFyKc+/mImGY3iV45NYLD+ZZyUu/s8GYRTngTr/nxOTAXZsPiUTzm62DbZBS3qc2hVNolnyRWYx9OmIjih0E3qf6Z+n7qE3HiQKZjerD5BU1Xk76Vg4cEBliilM4+1mAIpqUNcO7PFp1/jVA/IW957B1d1Z8/I8lvnmw+Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770818; c=relaxed/simple;
	bh=sa8WFKzUm6gv3fYBcXbcEtA5fnt17twiZs3JKeXi2t0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QVSVULykpiEodCZ7IhwXi910wwBRESkZk1G7v/MJWvzPppfNeM7fIXq0DHxWY+o7kQx2OpLeVIMy4MLFARwHAqHmnNciTuFLypL2ndsxUPBJGv9wtr6qQjBNwj9AF8M9WIcPErgXsXZgl/x+qaGjb12YyvKUvWXzUZVgs4r6KM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DdLCShFM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DdLCShFM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B744AC4DDE6;
	Tue, 27 Aug 2024 15:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770818;
	bh=sa8WFKzUm6gv3fYBcXbcEtA5fnt17twiZs3JKeXi2t0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdLCShFMPxwATJ0T8ax63+UlewMTdHgyXBfrolFwmm6K4p7V+v9i3pVrzQiHLrZnA
	 n5QC3gCOn2L/sNz1c56NoJPE/RtVRSCcO91Ve44mRyZl5IT7kUa93d+S0ndGIU6yI0
	 Z2wtGaeIrURYu8zB+NnzxscPOSm3/n8RldptFH6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Jithu Joseph <jithu.joseph@intel.com>,
	Ashok Raj <ashok.raj@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.6 324/341] platform/x86/intel/ifs: Call release_firmware() when handling errors.
Date: Tue, 27 Aug 2024 16:39:15 +0200
Message-ID: <20240827143855.722850026@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jithu Joseph <jithu.joseph@intel.com>

commit 8c898ec07a2fc1d4694e81097a48e94a3816308d upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/ifs/load.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/intel/ifs/load.c
+++ b/drivers/platform/x86/intel/ifs/load.c
@@ -279,7 +279,8 @@ int ifs_load_firmware(struct device *dev
 	if (fw->size != expected_size) {
 		dev_err(dev, "File size mismatch (expected %u, actual %zu). Corrupted IFS image.\n",
 			expected_size, fw->size);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto release;
 	}
 
 	ret = image_sanity_check(dev, (struct microcode_header_intel *)fw->data);


