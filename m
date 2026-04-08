Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EDD32A3FD;
	Wed,  8 Apr 2026 18:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674682; cv=none; b=bMtjuAO00oXXxUz4eBT9OkIzpFhowf9Z+B0aSHgliDFqmY3i3nbMG1PBBTgI6hbX8iv8KobqCBLRhCG0NzU1aKwWa+cULWdKxw+cPzE1fSuTOEwI6csDQ/bJt+a2YZgYbHw7ccEHnPHYC51Ag0iR2fbDI/XOdAw0B2Cgx7gt1sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674682; c=relaxed/simple;
	bh=kcUEr8rTVWEGl3ypOJDFBKrCa744+MM7moQX3uKrxPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZvUqlM38OmDbvyXVZFe6vU2Vf67kYk+aeva0RZWZAwbc/QxKKj++f2PnRLkoOLgrPTgogE52kvt9uEEmYNgNBnLsOzS81HyX2Y0W0nKTRN4UwWKJCZI1iL/dY8Z6S0KmA4PvTGVNXJ+Vf889Nd7tlGiziJVxCBxMFu+dptVxuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rGsM4Ejl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rGsM4Ejl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37205C19421;
	Wed,  8 Apr 2026 18:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674682;
	bh=kcUEr8rTVWEGl3ypOJDFBKrCa744+MM7moQX3uKrxPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rGsM4EjlnWp+IvI23Ha6VF6FPH+YADckbym/ti0SqqwXuLxx1KZKGuoQAJM9DnaIT
	 DTUHNanZSZ3WiUyLPctlWlCoC/kXBtpGcFs+ywoVTBi9KsWNpn2FyLPYEBwOb8CBxj
	 Jz/WSG7f0VCk+g3X/vGAZHlBMOgX4lOp2kTjlyAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lixu Zhang <lixu.zhang@intel.com>,
	David Lechner <dlechner@baylibre.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.19 192/311] iio: orientation: hid-sensor-rotation: fix quaternion alignment
Date: Wed,  8 Apr 2026 20:03:12 +0200
Message-ID: <20260408175946.579212580@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

commit 50d4cc74b8a720a9682a9c94f7e62a5de6b2ed3a upstream.

Restore the alignment of sampled_vals to 16 bytes by using
IIO_DECLARE_QUATERNION(). This field contains a quaternion value which
has scan_type.repeat = 4 and storagebits = 32. So the alignment must
be 16 bytes to match the assumptions of iio_storage_bytes_for_si() and
also to not break userspace.

Reported-by: Lixu Zhang <lixu.zhang@intel.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=221077
Fixes: b31a74075cb4 ("iio: orientation: hid-sensor-rotation: remove unnecessary alignment")
Tested-by: Lixu Zhang <lixu.zhang@intel.com>
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/orientation/hid-sensor-rotation.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/orientation/hid-sensor-rotation.c
+++ b/drivers/iio/orientation/hid-sensor-rotation.c
@@ -19,7 +19,7 @@ struct dev_rot_state {
 	struct hid_sensor_common common_attributes;
 	struct hid_sensor_hub_attribute_info quaternion;
 	struct {
-		s32 sampled_vals[4];
+		IIO_DECLARE_QUATERNION(s32, sampled_vals);
 		aligned_s64 timestamp;
 	} scan;
 	int scale_pre_decml;


