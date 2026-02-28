Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D636313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301026; cv=none; b=ncGa/uFCtq8NjFgW0Huzedu5ThTpzEcc9KEzyADm2JkzkL2D6GfpTt7/p6BQUmHk2yaZhF68Ac1UtZUnDRzzx9jlARu9AF3/Rtc/7AAUKhgTfapKK7KEeVIiZsvpZoxn/3dNDvsyL2vWJfTWmOE3J5L1IM7nB/ACwXDFYG4FSd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301026; c=relaxed/simple;
	bh=sNkTFNQlrQ3AC9SEvZnMSbY+Oc5dt/desNxruES3UAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/UMObjEuTwKpnQDLztcBA4qZwIJ9+B5S4YJTdt9n3AicpzgurWHVePG9rHB4pou0rYnHTWh6tOKs+JGg7oFGZnsw107LMTsKujwoMmJ4PvtqbAcC19t+KKjw62eu7GpY88iNyg2KM8jSir3SWpnevLn2IDO47vb6Io8/FdA6U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HuYMdRn8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HuYMdRn8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 752F3C116D0;
	Sat, 28 Feb 2026 17:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301026;
	bh=sNkTFNQlrQ3AC9SEvZnMSbY+Oc5dt/desNxruES3UAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuYMdRn8XWGtPIfc8GYtFgcibYu/TO7+rraS6A6yYFZv00RNNycVQU2/pz94NU77Q
	 2hj4UoccqQJrunDawTpioOuDQOU+8mj9zE6Entz7VR+VJdz7zKFRAZQNxGco7rO9xn
	 +fD06THoBMuxccwJrY1zH73HLChFe2fJ0QLCA0bKLF+mRiG2GYyBh/B6FEzas20moJ
	 iQ8c9k+vb9s5A2D6D/IORRZ3Vd+MfYknllc18jSZcliBeJnDxYOnMp0/WnjXbaNFm1
	 Ovl7imNxMDStnHDORYnAepMiz4CMlNnjkDZKZwwpOPs2iCzCYfrqaJKnPr/w/cEqlT
	 4D8fHPVgBOqUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Mehdi Djait <mehdi.djait@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/752] media: ipu6: Close firmware streams on streaming enable failure
Date: Sat, 28 Feb 2026 12:37:54 -0500
Message-ID: <20260228174750.1542406-163-sashal@kernel.org>
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

[ Upstream commit 5925a92cc70d10c7d3124923c36da09b9c1a6eeb ]

When enabling streaming fails, the stream is stopped in firmware but not
closed. Do this to release resources on firmware side.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Tested-by: Mehdi Djait <mehdi.djait@linux.intel.com> # Dell XPS 9315
Reviewed-by: Mehdi Djait <mehdi.djait@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys-video.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/intel/ipu6/ipu6-isys-video.c b/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
index f3f3bc0615e5d..e1815faeb80d7 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
@@ -1052,6 +1052,7 @@ int ipu6_isys_video_set_streaming(struct ipu6_isys_video *av, int state,
 
 out_media_entity_stop_streaming_firmware:
 	stop_streaming_firmware(av);
+	close_streaming_firmware(av);
 
 	return ret;
 }
-- 
2.51.0

