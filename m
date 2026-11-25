Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621409;
	b=VeZUgXAHBQTmUr1Ylld7OYmKBSuNFqGSBo82XrGh2zAaSN1pGjc7zHrz/PqpmrPZxeQ5
	 hHZ1Rnkayxsv9F/x/0GzpWsBcibidPOP+IFszAANtiT/E1asMKJiyR2WqwAxn4a8Lw901
	 xRU4Qp8xPd+YkSWCza6Ce5uyy2v2Po9rGuCie7h15GrY3u9sY1fIcZ7OVIxlxKeykXjyH
	 rqqrrUeoeyC6i76MdD8lEpCsFQSd0BJrBjV+xvbssrSIMsrWhUKvBMnpfdl+lfgtSvRKW
	 C/4VWSlw8WUln6G7O5SLMiGx5DKW22ir7tyGnRVgPw7ytQu0h5z7yEzgB+OGzMpUP/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621409;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JLaIIMEJ+S/tY6AuOUf/HrvBiHyHuEgnGwD3L+M82WU=;
	b=41bS0jPGdl9s/9dmFH5VOfTEsMwwRSJh7d4wc0y4nUfqPxfjtMxuFP3hvFfHS3/3EgJG
	 w1BCPbAMZDR1Se9SqEy1DGuF9zB0I2l7mRdrS5KNxoUcyWyHg2crYtYPMrizKZvQiWKab
	 6Gi6rdcSBm+rv9II/teSylCHpZUkBLb6Vvq8Qu16OFRRJP3khLrdVu3bka58fjvJJGgrz
	 p/oEgW1P/g08Xa+Q+R+J8dIyQAOheSBcyKvX/F0+pKYc3jNCDoZl6ATfm79lGChp2itPy
	 7O4XGhgrckNafnm4Zz5Xt0Jj2AlTLZa8H0ya8g3bUwhvGFQsc3iS3yknXX3l2ioqpIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iyy9aUqA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0BF0606A688;
	Wed, 25 Nov 2026 15:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Iyy9aUqA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950821F000C4;
	Wed, 25 Nov 2026 15:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621409;
	bh=JLaIIMEJ+S/tY6AuOUf/HrvBiHyHuEgnGwD3L+M82WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iyy9aUqARX39+/lOvNn4oekJatkV9gPfEi0gfOwxY6B45rFXOs6Y/yGtrFa5oWBv6
	 o/0GGgfVPNLR/gvG1VufNFOOBftsdD/C1Xi5bh4y/3h4dRLcbOOArWmdoyM4xCqtrm
	 Z3xgRe+6FWx8I91mwr3NEn8Yute3Aa8zLLWv3Mos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 217/990] block: report the correct discard alignment in sysfs
Date: Wed, 25 Nov 2026 15:26:24 +0100
Message-ID: <20261125143827.172876473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
index 6ba0e22ce9dff..2bba931bd10aa 100644
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



