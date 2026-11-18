Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049136;
	b=V0Lsf6B+fQ3mOezzIbkl+ocgyIuzLHHTQKT5GqYL7EbX2P4be48TNXEkIbYfUK65udrV
	 R0+s+LVfbgxP7USnE1McoqLQYCCpmTNBDpcscG+EZpPBfGK5g78lVzPbLuEDAv4ocuA04
	 SEdYwRPLHfQpegpW/xJ4XZUg3elzVVc0bz69JuwxxN5u9/QzgXkPMBBKVJZr0ey0yevQZ
	 3I87TR2oxTA7fvuzjOXN2bt91aQ7NxcR9Ri/ID1IYPBoA9H1oPzoU7Gc7rwoGTxD2xbtK
	 wJ0gH0L27NJ73jqt3LXx3ePiau2ZnH/NxEUxwkLf83j9S4R3d+f0A6tblw2fUE9rUxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jiYrkIlrZ+uBE6b9CA1eAQq2OE2QlNrlkO/+vCFej4Y=;
	b=jjzJ1M5g0qaccR7M/emr5dba5kLZ2GtlLJ4LOt3+4aZPNXwaGwiE0mB0rRaNpGL4BnXu
	 lrdz4OYuoPoObm0g2uXym9giaL21XzxNiCh1vrUGb56TpwDNhRp8eUoiueWgPqxVYQHf+
	 W6tpD5l1ugFflCLHz76JsAqDvw2VlvlUroh6RFUdAcc7SWSP4uXfOZt3CRUwFrtr9AXjs
	 ov4tGn0gdIHV2wsB3DqWt2O+mkFkGQBUhDlRyndx/9jaUvip00Ht3y90dw9erjd5NUTWr
	 pFqcOW25I0ms5RYyAeGNrpPADAEhHOQbtESOXvE7Lj3MXoUzcEaS7ZhWcdtjzVlLZxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGhEbDde;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A9C606A32F;
	Thu, 19 Nov 2026 00:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mGhEbDde
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3FB61F000C7;
	Thu, 19 Nov 2026 00:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049136;
	bh=jiYrkIlrZ+uBE6b9CA1eAQq2OE2QlNrlkO/+vCFej4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mGhEbDdeWPzEpftQv8MnZLjfIo5hstpoe14YAz9SNwvO7p0TNZIkQaMLckWFElQqz
	 7muGXiyaKc9DrN+/kXLIeO9Qc9O82lngnTmgH25WlHPSQjSv21ekffa5AS+A2VYC8l
	 37U+mxEbSWIaxBjJ8qoIDORMH9BFGt6iD3ZeSZFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	"Denis Efremov (Oracle)" <efremov@linux.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2245/2857] floppy: unregister platform device on add_disk failure
Date: Wed, 18 Nov 2026 15:54:39 +0100
Message-ID: <20261118150322.272106199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit f1e72d80ad4ac5ff3573796d07bd1a1e74909f94 ]

The change referenced by the Fixes tag reverted a previous fix because
that fix added incorrect cleanup for the platform_device_register()
failure path.

However, reverting the whole change also removed the cleanup for a later
failure path. If platform_device_register() succeeds but device_add_disk()
fails, the current floppy platform device has already been registered and
registered[drive] has been set.

The common out_remove_drives path uses while (drive--), so it starts from
the previous drive and does not unregister the current one. As a result,
the platform device registered for the failing drive is leaked.

Unregister the current platform device directly on the device_add_disk()
failure path, where platform_device_register() is known to have
succeeded. Leave the platform_device_register() failure path unchanged.

Fixes: 895a9b37917d ("Revert "floppy: fix reference leak on platform_device_register() failure"")
Fixes: 47d34aa2d211 ("floppy: add error handling support for add_disk()")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260708105703.747262-1-lgs201920130244@gmail.com
Signed-off-by: Denis Efremov (Oracle) <efremov@linux.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 36efe7dd2d4e6..7f71fc3aaf283 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4731,8 +4731,11 @@ static int __init do_floppy_init(void)
 
 		err = device_add_disk(&floppy_device[drive].dev,
 				      disks[drive][0], NULL);
-		if (err)
+		if (err) {
+			platform_device_unregister(&floppy_device[drive]);
+			registered[drive] = false;
 			goto out_remove_drives;
+		}
 	}
 
 	return 0;
-- 
2.53.0



