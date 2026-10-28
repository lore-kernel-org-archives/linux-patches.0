Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213124;
	b=ZGB64gaBfK10S48ODMmmVary4LNUtt3TTWStfGmxMn8trgiDcU6TeA3eFb91pxKabmlW
	 UJAabJFjiNEoCJwFbrjhSLB5K+EzDWksPZF3DIY5ALhZ4WEGwznwmNVvb7UWQ6qq+EANg
	 SNhME749ISCreoBo32qWfe9ZvTmXk4fW4ki9ZNiW/rjBSup/FTlDBRv/kcqqfzLIW7FGx
	 KV+JPfihje0bVFlaDTRI0J6CFNKdXxhLOGeUxa0nozuBYPZqC+p8azaTzkqJGvBqHDQ47
	 cXDij8e/bz8UafGzBtbICemS4w7+yUK5U1ncRV7774hP5seqAJxVoqcGorQ9EWWDJGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1PcfGOEaoNRiWMwjoBYFMYNRtQ1PoV+YDARDJXz4aF8=;
	b=jVINnqhah2KzvZITmVPBJoCI3xXiawqwIjX8704lDKCNt32NueZXsR9tbL1IV1hDwPfi
	 5OcXKILVU5mCrxLKhkwZoo9r3UfSphb/G3KpxzoTmJVg87L/3x1dACPcoIENIhKjSp+vC
	 POjMOCsBKpScTQkY/61jO7as1Dmb+EE4pz4TqrP4Mn6y3mt+k8HrG6ezdZeLzkJeSL2yf
	 vtqZV7hNQXUfqgA8guepIyZH8/0YYi9GbzqDd53dWUDMzagS702pMuxNfyC7SzrdUFqm8
	 9j4akSImGGNlyRPbEMqaSOze+P9BhQCCfrA2iA0vbi1TYlxSLMpScY5E8xA4wxmJzUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=haGWjxWl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16606606A31E;
	Wed, 28 Oct 2026 18:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=haGWjxWl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B3D1F01825;
	Wed, 28 Oct 2026 18:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213123;
	bh=1PcfGOEaoNRiWMwjoBYFMYNRtQ1PoV+YDARDJXz4aF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=haGWjxWlLyD7pfKVVzBx/VGOBCoGE8qVQkmSjpwdXJCdxJoGhhQGjRifoZp9K7Bs4
	 bnRCuY7vmWbTietRIy0eDqhJwglSty1U1U+9AGWjy8kaus1625UmbChctO+kG3vuaz
	 PT21v40fTzPGUl9ByXI342HJoDxKeTCfj58uIXOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0341/1887] iio: imu: adis16480: fix unprotected debugfs reads
Date: Wed, 28 Oct 2026 17:40:37 +0100
Message-ID: <20261028170506.986644234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arka Mondal <arkamondalofficial@gmail.com>

commit e1dea54496f90a62318cf4eeaa1e9ef8316e92b6 upstream.

The firmware_revision and firmware_date file operations are open coded
and never call debugfs_file_get(), which debugfs_create_file_unsafe()
requires. debugfs_remove_recursive() therefore does not wait for a read
in progress, and unbind frees the iio_dev underneath it.

Use debugfs_create_file() instead.

Fixes: 9bf94f836e32 ("imu:adis16480: fix debugfs_simple_attr.cocci warnings")
Signed-off-by: Arka Mondal <arkamondalofficial@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/adis16480.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/adis16480.c
+++ b/drivers/iio/imu/adis16480.c
@@ -302,9 +302,9 @@ static int adis16480_debugfs_init(struct
 	struct adis16480 *adis16480 = iio_priv(indio_dev);
 	struct dentry *d = iio_get_debugfs_dentry(indio_dev);
 
-	debugfs_create_file_unsafe("firmware_revision", 0400,
+	debugfs_create_file("firmware_revision", 0400,
 		d, adis16480, &adis16480_firmware_revision_fops);
-	debugfs_create_file_unsafe("firmware_date", 0400,
+	debugfs_create_file("firmware_date", 0400,
 		d, adis16480, &adis16480_firmware_date_fops);
 	debugfs_create_file_unsafe("serial_number", 0400,
 		d, adis16480, &adis16480_serial_number_fops);


