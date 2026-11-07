Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060650;
	b=Yr+mjq2/H3VVbFm96zqr+1dwY9H3xVAGgDEM0SxxgT8VNALKtju1kHIDkKKKPURf+bRV
	 iG7vyYW7qepCxsndzyX55p8JQHfCmMklRYG2clK/paJoDDVAsnLElhpZ59PrVvR3Opw+g
	 b0N4Zwzd6T5qB+bZ/ThOE9q65W8T2xHDUCWeFrZi6Yybs011li2yn5dmj855Yk+lWUnGn
	 O30x+qpXatibx9Oj2s7++qt75DQWX3a49+A21rdtmsLypjMOpxjDNaEbOE96EgqCWzzsk
	 GEDBwvnnnvS+95oflPl5FMmp1XZ0m+3ZOOC09jLsoDdkdAG3cDkOcB5iIW2JoFwU35A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4GlaA9mf/ltl8PJ11O+vFBoKc916MBStxCGQ1hHDrFA=;
	b=KknWYg4/QGl8QjH25+f09ME9xzj+x09vlqx1tRNxb7Tng52tMSklH4W6x/iQB/0gamf2
	 EmxtMD7kbZNyHlcT+Ix/iHomDFfED3+yd9oE1MLfmBkwsB1hP3+2RnzOHLnvYO174fyj6
	 CoDqZmj3c9bKs4374R3SmLTMSAt13UYWkrIF9P9iykJ+D/FnFZH2TZWyTRhFo2y6yLr92
	 tVpvFGUK7Okn7jjEzZ0VTHmufe7NM4Ol+2FXe+VlIqofbE4fKGdNwcrNVZk/LgDCoVPn0
	 VRHCLG2GPSEitPpxcoYzy551H1ZrCk6AZAVCOoX+F4wqNh6hwftiiXYgPM1r8DH2FXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8D33IZd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0394C606A326;
	Sat,  7 Nov 2026 14:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8D33IZd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40821F0089F;
	Sat,  7 Nov 2026 14:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060649;
	bh=4GlaA9mf/ltl8PJ11O+vFBoKc916MBStxCGQ1hHDrFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8D33IZdMwjgLKQj6q1VcR/RbWSkcneCL88AOk8FlXyXajqz3ePHzrodSjUTiR++m
	 7y4VIiBxWw+YqaRMNPSdyN4BX4Hn77U+P3z59oPGVMiwrHSruTg00VTK6D2SL+7GJ5
	 C6DtFxqOjSKgp/+pbgTuZU9RWPjnZwbx2EEKWCeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.g.garry@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0091/1536] nvme: handle positive error codes in nuse_show()
Date: Sat,  7 Nov 2026 08:35:07 -0500
Message-ID: <20261107135000.223346080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit dd516cd7624648c71d338d99368587f10ecc9f0b ]

Function __nvme_submit_sync_cmd() returns a positive error code for NVMe
errors. Otherwise, we get 0 for success or a negative error code for a
kernel error.

In nuse_show() -> ns_{head}_update_nuse() -> nvme_identify_ns() ->
nvme_submit_sync_cmd() -> __nvme_submit_sync_cmd(), we then may get a
positive error code returned.

Function nuse_show() - being a device attr handler - should return the
number of bytes written to the buffer or a negative error code.

Convert any positive NVMe error code to -EIO.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/sysfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/sysfs.c b/drivers/nvme/host/sysfs.c
index 3a41b9ab0f13c..74f0b9ece0442 100644
--- a/drivers/nvme/host/sysfs.c
+++ b/drivers/nvme/host/sysfs.c
@@ -239,8 +239,10 @@ static ssize_t nuse_show(struct device *dev, struct device_attribute *attr,
 		ret = ns_head_update_nuse(head);
 	else
 		ret = ns_update_nuse(disk->private_data);
-	if (ret)
+	if (ret < 0)
 		return ret;
+	else if (ret > 0)
+		return -EIO;
 
 	return sysfs_emit(buf, "%llu\n", head->nuse);
 }
-- 
2.53.0



