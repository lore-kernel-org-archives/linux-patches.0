Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DA82110E;
	Tue, 27 May 2025 17:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367116; cv=none; b=IjaJnc76SdfnwqnJpVSop7csw2uiw7WL4TlTy0qUIN/a6Z4nZW6lzUwUq/LeH2EiqQPcyDP9FKRzYnAT/1pPQWbR/h9ChbWxeoLnt4YOGSBmBcMyZGBQ4xh/Pz2zGi6g3T0J67b02y0YiZyyCLVpYky73+8lLiipt7jDcAdEixs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367116; c=relaxed/simple;
	bh=cpRFd1KXXODB/1Gv+fRDLzt9E0DQjUgNoFj+qAg/NJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIyIfKwd0I4D0hD/FHOv3bCIzXDPTIjjiRfYTi3S6dXbt7bHTRvOIJCUExGkOMv0KsB5rTr/FfR00WPBZDC6AQ6yTnyyX5NsYRElURGEKPh0R81uyoqXCcMYs5CmwZwcJJ74KAAng0Lb+p54gjmopSLjmoNXsj1X+z9OLZVAIk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTxjF3Yy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTxjF3Yy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE14BC4CEE9;
	Tue, 27 May 2025 17:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367116;
	bh=cpRFd1KXXODB/1Gv+fRDLzt9E0DQjUgNoFj+qAg/NJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTxjF3Yy3dsvDJVlu7QhIWtgj8RqF0aM6IjwAXsT8qj503M4praaWyUZjzQn3lMpD
	 HHeUzLOlot8VfBB3rbYXq0dY3RVINbO5S3tO4Efdtobl+ZkRKj+fvd4OybjHF0pEhE
	 EsU28MwTnh77zNnr/fnC590lec02KbhiRpo8demw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Zhou <tao.zhou1@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 254/783] drm/amdgpu: increase RAS bad page threshold
Date: Tue, 27 May 2025 18:20:51 +0200
Message-ID: <20250527162523.444362091@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Zhou <tao.zhou1@amd.com>

[ Upstream commit 334dc5fcc3f177823115ec4e075259997c16d4a7 ]

For default policy, driver will issue an RMA event when the number of
bad pages is greater than 8 physical rows, rather than reaches 8
physical rows, don't rely on threshold configurable parameters in
default mode.

Signed-off-by: Tao Zhou <tao.zhou1@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 52c16bfeccaad..12ffe4a963d31 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -748,7 +748,7 @@ amdgpu_ras_eeprom_update_header(struct amdgpu_ras_eeprom_control *control)
 	/* Modify the header if it exceeds.
 	 */
 	if (amdgpu_bad_page_threshold != 0 &&
-	    control->ras_num_bad_pages >= ras->bad_page_cnt_threshold) {
+	    control->ras_num_bad_pages > ras->bad_page_cnt_threshold) {
 		dev_warn(adev->dev,
 			"Saved bad pages %d reaches threshold value %d\n",
 			control->ras_num_bad_pages, ras->bad_page_cnt_threshold);
@@ -806,7 +806,7 @@ amdgpu_ras_eeprom_update_header(struct amdgpu_ras_eeprom_control *control)
 	 */
 	if (amdgpu_bad_page_threshold != 0 &&
 	    control->tbl_hdr.version == RAS_TABLE_VER_V2_1 &&
-	    control->ras_num_bad_pages < ras->bad_page_cnt_threshold)
+	    control->ras_num_bad_pages <= ras->bad_page_cnt_threshold)
 		control->tbl_rai.health_percent = ((ras->bad_page_cnt_threshold -
 						   control->ras_num_bad_pages) * 100) /
 						   ras->bad_page_cnt_threshold;
@@ -1451,7 +1451,7 @@ int amdgpu_ras_eeprom_check(struct amdgpu_ras_eeprom_control *control)
 				  res);
 			return -EINVAL;
 		}
-		if (ras->bad_page_cnt_threshold > control->ras_num_bad_pages) {
+		if (ras->bad_page_cnt_threshold >= control->ras_num_bad_pages) {
 			/* This means that, the threshold was increased since
 			 * the last time the system was booted, and now,
 			 * ras->bad_page_cnt_threshold - control->num_recs > 0,
-- 
2.39.5



