Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2F2313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301027; cv=none; b=dRzRVpzy8Ldg23b2a2tbCznep4190x+L4KgOZ48AHSmkN6VDCz6w7y8cJbEymBadf/241UzbVp+Dse4AIcSC2gHvPDUMz5KpdB14L+P5BA5GxyNO6CI8PU+8iVT6tvpYnUwimy6a1AvidQW55JUxz4zZl3ynBOVtR0uSb8Xks4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301027; c=relaxed/simple;
	bh=BBUwYGkDHEA9nFogQT8RlI8i8H4jWBnv6RO+uElcGJI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k95tL/g8A466F2DoHQsoFx+7Zdg7802cchq9s/xablnVsSya5HpQBbanpB1uTTD43rBqQMdy7qsS1x4du+eiCVAdoq99NPv0TuyoyfuNIfxbqU+x1XB5Vhxhrj/wefB4wS6oMBrXdPNoaoxgTpyDNhGDLHjn64ZlJaTf3EyaFEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QoDS0b/Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QoDS0b/Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627EDC116D0;
	Sat, 28 Feb 2026 17:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301027;
	bh=BBUwYGkDHEA9nFogQT8RlI8i8H4jWBnv6RO+uElcGJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QoDS0b/ZY+KEeVcQ/AM43S01r3IBtxgJJjEHmg8KgHowQIvpo+kbURfjnaKA7LBKI
	 T7nw0+h3YC857Lg21Gxp1wP34j+qZUbC+KuVno5lSBBQy5eBsec6QIhHW7uZ2Wg9ul
	 4DPyYRIqi2TaDx+ZIXFjfqi5lVeXl0vUytLPALKIwIez0usuBIHSy1a3UtgYutNBB2
	 44V+epbgcZj0bezWo5D5rqr994fyUpvJ2y2u5QA/dDkkS2aqGFErrRgOYO66ddioC5
	 SffF4isegZDyZYXT/dQhlfvTTPSAo1WShQXnf2nHAUqhxktY4LucudQDti7bZQpuG0
	 iMSLjhLP4YyRw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Bingbu Cao <bingbu.cao@linux.intel.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 164/752] media: ipu6: Always close firmware stream
Date: Sat, 28 Feb 2026 12:37:55 -0500
Message-ID: <20260228174750.1542406-164-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 2b08b7007e55bd1793a58478d3ecea4fd95849a5 ]

Close the firmware stream even when disabling a stream on an upstream
sub-device fails. This allows the firmware to release resources related to
a stream that is stopped in any case.

Suggested-by: Bingbu Cao <bingbu.cao@linux.intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Tested-by: Mehdi Djait <mehdi.djait@linux.intel.com> # Dell XPS 9315
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys-video.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/intel/ipu6/ipu6-isys-video.c b/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
index e1815faeb80d7..b96ae563b82f0 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
@@ -1022,11 +1022,10 @@ int ipu6_isys_video_set_streaming(struct ipu6_isys_video *av, int state,
 			sd->name, r_pad->index, stream_mask);
 		ret = v4l2_subdev_disable_streams(sd, r_pad->index,
 						  stream_mask);
-		if (ret) {
+		if (ret)
 			dev_err(dev, "stream off %s failed with %d\n", sd->name,
 				ret);
-			return ret;
-		}
+
 		close_streaming_firmware(av);
 	} else {
 		ret = start_stream_firmware(av, bl);
-- 
2.51.0

