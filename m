Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618316;
	b=TZ2b9dhDMTLyxrgX0IVtslhFCojNw75H9wsTz+YtZF2egVQYDQd3skGC6ZOx0knQxDKZ
	 jqBRKHHVL7eG7ulJ3X6DK9xOASkcwmIcYkuDXWwQB8kRgpVgxgzcti9zqgJo7/CZRUofU
	 kUUYx6EfKaZD6Pij0ujODmCxzUH7R1i1NETdeU3dMmr5nnWD18+ZGpXTYMBJJ7AlkPybM
	 NLLnQhYuv0fdBRwMiSJ1j6PmFQSrriA7Pp1FUo9ksDCVrypFTFfXlW+hQvof9EE4CfBiZ
	 yC3qmHAs8P8XKxstVKrplvjmEjRFzz/UVOy9EdwBftpQSZgosB5hQVG0g2idswrAkBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=knlVmxEmoxKIcmjvWOolzlt3FpWJE0dpPvUwWDWMX9M=;
	b=vHj3E/6bN1ilWY24zqnB9FbOEBcPAf+MaIwEP6kr/YFhF/LbcQ8o602M7HZ962IiiS52
	 8U0totwhR5lgQctffOJKDjjrzTdq1BK/bBJvrr775rxBsCvM60fGZEj0wExQvo2auJAyQ
	 GZoO3ZubdqDuiFKXxfwUUpKoaL7izBjRVKjJe7v8sAWDgB88sDleCDj8IbCJehGB4oERe
	 XRupa8fbOEm9yChBAVBSugXCDTu5RPNLMLW3DctPoGZnEqT+yliajgkOd5EgmiMgiVgmE
	 1u31jrUVY//cmn3QHFBIqqvdz15brPxeKBogREksMyoiXPaF8h5CgvOVXXxMNbKcezA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wUqwlYyC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5985C606A31E;
	Wed, 25 Nov 2026 14:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wUqwlYyC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E70D1F000CF;
	Wed, 25 Nov 2026 14:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618315;
	bh=knlVmxEmoxKIcmjvWOolzlt3FpWJE0dpPvUwWDWMX9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wUqwlYyC88uTYRXuWU0JXqVleq2TSZtivGEd/ySvfKAri4sJE7jO09M/Im4+z++E7
	 r2VUzmZ93GRUsIJL9NWoGY6p5/5UDgsvMefGdYTZt5ZL1WeAjk56zthuUw10Y4dmbt
	 7+issyI/KEAQhEqZb4N6VuAVsX38s2P0JbYCDJNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0241/1005] block: report the correct discard alignment in sysfs
Date: Wed, 25 Nov 2026 15:26:19 +0100
Message-ID: <20261125143827.382960884@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 2516f0413f8704a7370ef8a2eeae26c9bc438978 ]

disk_discard_alignment_show() reports the physical I/O alignment offset
instead of the discard alignment. Devices can specify these offsets
independently, so the discard_alignment sysfs attribute can report the
wrong value.

Use bdev_discard_alignment() for the whole-disk attribute, as is already
done for partitions.

Fixes: 4e1462ffe899 ("block: remove queue_discard_alignment")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261031102023.3644494-2-thnkslprpt@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 10ca8b4d6eea7..69204d44adae1 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1146,7 +1146,7 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sysfs_emit(buf, "%d\n", bdev_alignment_offset(disk->part0));
+	return sysfs_emit(buf, "%u\n", bdev_discard_alignment(disk->part0));
 }
 
 static ssize_t diskseq_show(struct device *dev,
-- 
2.53.0



