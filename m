Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705567;
	b=lys5hZIpNUkRS9aBdSro6Y2vo16PQ61HZcBFp+2WrF9YBzIdsRsiBv0j2AoAPP07ukb2
	 dVV9QOMr0CGOZjHpz1gHjgxObS1HtowwGap9j7wj+hHjrPATppXfXVi/V7d66Ub8LNdK8
	 ctHYgexHrV3MqXwiJ7l1X6drHh8sxtnC2AWkc/tTovDdw2Sxue29KYgEuSYC+XnT8+aTO
	 igMrhcoWexGCTq+bLT2MfC96ojEScUp749asF4qhxJ9lw2Dco6GQyfFZ4YwK6tRNobwgm
	 7PommQsyqrlrOf46XLNKNhGWVDPU5EumM60q/bPWlUdP00NdHUTNxUbviu790eHyISg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aoPWAm+VIRESDUl6ewzIyOY4iZRW/oJETQ+xvU9kJ/c=;
	b=KHyeYtMnXTFcF6L1vSXczYkdjshvb0NOsuXCpgLhRjMvLwVcNj+8h9KwzUUN2JITW5PM
	 Obes3rVbA/aAYJIB0skh+cg4bluMRcZt+PmAeo14r+zJ6iOQ5bMXSQs2b06T9AhGLi/OR
	 qr+StxUpva9T0+xE4rEsANIbP5hcCTpOYuusmccEVohyoSEHB1nE4Gi77Ejt8F8P5igVI
	 Pjef5mT2DLRsIv8TW3wL+BwHOz9BNc7+Yko+MYFWsLVeXMlCDCfDW/rFiKUXUZ1FWxZ0n
	 mvqAm8vwN37N/ZvPaBD1rDH9Wu0iOc/7/O0Vz3PkWa6saaxipp05oSU6wUrBchKmbfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ry6fiW2Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A2F8606A31E;
	Thu, 26 Nov 2026 15:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ry6fiW2Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF8F1F000D3;
	Thu, 26 Nov 2026 15:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705566;
	bh=aoPWAm+VIRESDUl6ewzIyOY4iZRW/oJETQ+xvU9kJ/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ry6fiW2Q9DrzNq3IsxwDjPbCyxZRgBsw7k9Gv0cvcwtH0mOaNVM3r+ooiyDyZjBja
	 KQgPQks1VZ6dOczip6yRYVIfkL0W7n6CfOji6y30mTZerBkGHRV2yIiJkldef9U3Aw
	 qSvmGV1pcRqyTQ8JGPxgXP1NW2Wh+DkUyY98uRDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com,
	Edward Adam Davis <eadavis@sina.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 5.15 241/319] dm cache: reject kcopyd client destory if it setup failed
Date: Thu, 26 Nov 2026 15:40:09 +0100
Message-ID: <20261126144012.184997815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Adam Davis <eadavis@sina.com>

commit 8b97b168eb4d3affcf23d2980a0c3f35ed9262e2 upstream.

The value of cache->copier is -EINTR when failed to create a rescuer
kthread for wq kcopyd, in cache_create(), the code jumps directly to
__destroy(cache), it merely performs a simple check to see whether copier
is NULL, potentially hitting:

BUG: KASAN: null-ptr-deref in dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
Read of size 4 at addr 0000000000000174 by task syz.2.19/6560
Call Trace:
 dm_kcopyd_client_destroy+0xae/0x480 drivers/md/dm-kcopyd.c:980
 __destroy+0x172/0x2f0 drivers/md/dm-cache-target.c:1973
 cache_create drivers/md/dm-cache-target.c:2604 [inline]
 cache_ctr+0x1674/0x2bf0 drivers/md/dm-cache-target.c:2649
 dm_table_add_target+0x58d/0xc70 drivers/md/dm-table.c:749
 populate_table drivers/md/dm-ioctl.c:1602 [inline]
 table_load+0x325/0x8a0 drivers/md/dm-ioctl.c:1645
 ctl_ioctl drivers/md/dm-ioctl.c:2221 [inline]

Set copier to NULL to avoid destroying a invalid kcopy client.

Cc: stable@vger.kernel.org
Fixes: c6b4fcbad044 ("dm: add cache target")
Reported-by: syzbot+a2626a25eb2595e3ec3c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a2626a25eb2595e3ec3c
Signed-off-by: Edward Adam Davis <eadavis@sina.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-target.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2512,6 +2512,7 @@ static int cache_create(struct cache_arg
 	if (IS_ERR(cache->copier)) {
 		*error = "could not create kcopyd client";
 		r = PTR_ERR(cache->copier);
+		cache->copier = NULL;
 		goto bad;
 	}
 


