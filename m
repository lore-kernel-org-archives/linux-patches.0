Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590436;
	b=k5KybyhGz8ppESnTe0I4vzzdY6eEYX4s8noopO8YaUirjxnJiusZORyLSU5YE2rckVwN
	 1hb5M6uyENHvueDS2SBnI1sCK4UUuJPuhehuRDtPOvhUE60AVljXw3EoAu1nfZ0nsGm/G
	 Yv8gUr4LSjG0GcEljeMKzzD8zNRwUocSEpagr1w9gJLCVG5ShRkbWQXCk8SNBZj2qKYt0
	 qcpYlvdygR3Y80B9JZxb/dBKoySf43YJBGvyKtAOZXSbK7WuC8JX7E/VRXypAL3Urv3tz
	 9vPm7Ldd+jLBSPa+9YxB12IcnyJjzyKOQ8MmnNM9k0ZWiBOxKGT0vr88v08q6j68pBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590436;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ryWPWX+zYmRfcaNRwDNIPDE7YzZvhTPCYK1iHiOMIIg=;
	b=4hBsPJuGHNN+4Cz8fpz6uS38YIh2weUV8apIOp0ssSfMv0zD+4OabjqqXup+33osREcw
	 iad3u/S732t+N9fvKkXRqCgUTVhGm4/wPXWR2jyMHC4avb8QmRInXjF10l61lC0iR3DMv
	 zXTuyvg5xc2Y/qUBMxuub7fPyUKUZY7Bg8nOxY+9hzkUE2luolvyL50Be/waoy/be5YMk
	 rQFquBittsaLU6PWjUz49fvk9ivqKyjAFYsUdBLRfyT3U0dcnOZIoVuleVloQF4Ym+mFb
	 LYTS41rk8TNNcc5HcQbwvi4W/fzhImCmYk5q3Z/n1Fh0o2r6fJLCcLXRx48wctRNG0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qT367G0t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A234F60703D4;
	Fri, 13 Nov 2026 17:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qT367G0t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC5D1F000C4;
	Fri, 13 Nov 2026 17:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590436;
	bh=ryWPWX+zYmRfcaNRwDNIPDE7YzZvhTPCYK1iHiOMIIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qT367G0tBQW2Qj4PJSVrnIFn5SYMEbMbrDuJ/bwQ80zEn0Fu/I6j5xEhM9mPEE68V
	 QsNhV0lrA2vf0sMza0NS+pD3OW0ag0kEpvIaaIoikKk+yi4QTYF9IXCysUnj4v54TZ
	 FEV3LSlJW/FFcZ6vutXSU0pKhLKFQP209sVEVv94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 396/686] ublk: add missing DEL_DEV_ASYNC to unprivileged permission check
Date: Fri, 13 Nov 2026 10:48:49 -0500
Message-ID: <20261113153834.417402214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yitang Yang <yi1tang.yang@gmail.com>

[ Upstream commit e6ac1da6a53c5f670bf09e60a2500d15be68d2fc ]

ublk_ctrl_uring_cmd_permission() is missing the UBLK_CMD_DEL_DEV_ASYNC
case, causing the command to always return -EINVAL for unprivileged
ublk devices. Fix it by adding the missing case.

Fixes: 13fe8e6825e4 ("ublk: add UBLK_CMD_DEL_DEV_ASYNC")
Cc: stable@vger.kernel.org
Signed-off-by: Yitang Yang <yi1tang.yang@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20260901142438.237586-1-yi1tang.yang@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 8c33a5f86c3d6..6b2035c46daa3 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -3872,6 +3872,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
 	case UBLK_CMD_STOP_DEV:
 	case UBLK_CMD_ADD_DEV:
 	case UBLK_CMD_DEL_DEV:
+	case UBLK_CMD_DEL_DEV_ASYNC:
 	case UBLK_CMD_SET_PARAMS:
 	case UBLK_CMD_START_USER_RECOVERY:
 	case UBLK_CMD_END_USER_RECOVERY:
-- 
2.53.0



