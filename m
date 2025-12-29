Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5547626FD9B;
	Mon, 29 Dec 2025 16:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025186; cv=none; b=eVHqZ1wgBozovk77Gg1RuOSsITPVviCL/ge47jzTNf7toEy3LiSHxqsbNmqFTE5zJYIpg/w/7K/uMJ9aikRWNswFTpYM6ycIx7E0LX/r4fegLFwFiy8F00L8N1DOhRF7EfXxfbi7O8u6u3nnO/tMW0Whtr92vseaY7JSQgi0wPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025186; c=relaxed/simple;
	bh=32453DhAUMLeJANLNj0H6q0Yk63c3YdT8gm1J7kGfqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Nkhs+JykshP3A7OpZD1RMZ8WkwLLc1pYrXEtkJHtcBNCAQKBt3Nl/aS84HbeAKHTHhkZdUT8koP8+SYfyrNCJwGMVWH6BrnlDae1Zf8V0b2SzySUHsHJCTPW/X8YbeBtsUSiL9l9QQacnAwXTI9aIVwRbLLNRfum+kGgnxUfcsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhU6zCwe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhU6zCwe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15E9C4CEF7;
	Mon, 29 Dec 2025 16:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025186;
	bh=32453DhAUMLeJANLNj0H6q0Yk63c3YdT8gm1J7kGfqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhU6zCwe66VFOJ0doZA7WSKRi5HWljqbdM8IMmJVlBlMx2ezK5nTiyb6PccR5/TLP
	 5goCEjQb0SHvtEGAJjlRtUC/u526IteL9ErNtd7M8EUdI6f5g1i33QJLcsYVOlTaSz
	 ohLAjUJULs4OPQHi7MJmjWXDTsOXaHE39q40W+gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jagmeet Randhawa <jagmeet.randhawa@intel.com>,
	Jonathan Cavitt <jonathan.cavitt@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 123/430] drm/xe: Increase TDF timeout
Date: Mon, 29 Dec 2025 17:08:45 +0100
Message-ID: <20251229160728.893138578@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagmeet Randhawa <jagmeet.randhawa@intel.com>

[ Upstream commit eafb6f62093f756535a7be1fc4559374a511e460 ]

There are some corner cases where flushing transient
data may take slightly longer than the 150us timeout
we currently allow.  Update the driver to use a 300us
timeout instead based on the latest guidance from
the hardware team. An update to the bspec to formally
document this is expected to arrive soon.

Fixes: c01c6066e6fa ("drm/xe/device: implement transient flush")
Signed-off-by: Jagmeet Randhawa <jagmeet.randhawa@intel.com>
Reviewed-by: Jonathan Cavitt <jonathan.cavitt@intel.com>
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patch.msgid.link/0201b1d6ec64d3651fcbff1ea21026efa915126a.1765487866.git.jagmeet.randhawa@intel.com
Signed-off-by: Matt Roper <matthew.d.roper@intel.com>
(cherry picked from commit d69d3636f5f7a84bae7cd43473b3701ad9b7d544)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 456899238377..5f757790d6f5 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -1046,7 +1046,7 @@ static void tdf_request_sync(struct xe_device *xe)
 		 * transient and need to be flushed..
 		 */
 		if (xe_mmio_wait32(&gt->mmio, XE2_TDF_CTRL, TRANSIENT_FLUSH_REQUEST, 0,
-				   150, NULL, false))
+				   300, NULL, false))
 			xe_gt_err_once(gt, "TD flush timeout\n");
 
 		xe_force_wake_put(gt_to_fw(gt), fw_ref);
-- 
2.51.0



