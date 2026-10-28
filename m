Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208900;
	b=oV+xxZAIW/FG+/ZJx91EOU6iGDlhxQqOWVLOdlcuJTqoThpMMp5CROiBEJj2IpElUXkV
	 X0EXv3x4qvb8Q2T/zFpPXxyPVoA4HVMA+VRXWD8taC44/HK8tx4nRzdiNqhNrEGVQC6/Q
	 S5uUF/rmTuDev9+BcxQ82UWldc8P4vw5blr6OwbGrTIbFup/I6ec+yAhGGnp9A7Z8Yub2
	 LuaE1QXna+gP+MRgOpq8e++McHdaEWXksQimGmAVmkcjm0Zw6L0TbSbGr8akPwqswqbO8
	 kyc/XVwtaLOMaw0iF6dnsr9a1aV7xu4PVUpNN0tCDDqQYLYvaU+QqTYJzUllvsR/Nww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZlJmT7lkiiJp+VeoBBE+n2t9DCVqPqOVfnfrhJJ2RBE=;
	b=uhQO+E8ZsbY3Q16ZzMfJvA56PjaOh+QjWxU0qR22EI62eszArDSLcr97sSRyEeYPJbOe
	 CyUDK3gANlxTKjDeZyiJyWr7gUErLohaCm3/xsIk/hczQljycXc2LDjiL9alWh/bVznTN
	 dua9piDXiu0xhkEtKifTGBQV1BrpcjgRDU1q9wedc8ZissRFiJrZmk3sHmxJwq81YfXVY
	 US3OkRxFRYJsS9IIse32bXPzPOb8OM/4lNXY+4SC5DaEv5fNmWiSOC8dzetmZRRq818bD
	 B7b33L9xcMQ86n50XGp1ZzPF9bpuXZRoRc3PeP+z4Io72sFj5CMoB9gXZ/6mCM8iVzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrjlJfHO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835B6606A321;
	Wed, 28 Oct 2026 17:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UrjlJfHO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D504D1F01825;
	Wed, 28 Oct 2026 17:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208900;
	bh=ZlJmT7lkiiJp+VeoBBE+n2t9DCVqPqOVfnfrhJJ2RBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrjlJfHOWkOQJmwFmDqYLzR4da7M3k9+ZA1mhbUngOxVFh4irkYt/dPNCmGqjjpvR
	 nyQP+JdG9udD9LE5Ms0YuIX+9EmPq85ln+N64RPRdzmFYa/x1e9M7NSEECHpq7gsNt
	 4GCur99lpNuK+GYmIvfTk8PhlKMEbG2FPgXAgDQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arka Mondal <arkamondalofficial@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 239/516] iio: imu: adis16480: fix unprotected debugfs reads
Date: Wed, 28 Oct 2026 17:56:31 +0100
Message-ID: <20261028170009.164164845@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -286,9 +286,9 @@ static int adis16480_debugfs_init(struct
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


