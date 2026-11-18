Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062213;
	b=mAriNxBvnkDMiTTh+nM6ISBWkOiFSuyIi/yKy/f2cycZYXfjvkGc45zAzzgehJVKV4vB
	 7q+0H0W5pdKSYI4rsMKSVzxgSMhZi7qYUEKAHq6/deYtmdlJd2BadR9t3rNc5wLyTHPUm
	 FsDevuCtl7gLyBYyOIw3Id3tDA5NuiUrzHISbtzC+e4Y8pSY+kwwdRPKnS1sSCIDNa045
	 wS8ZmEcvajva+60t9qZNUlggZTsozHQWsKTAMsf3Rs18oKNSWx81CFTXpBfytnjU4vMpm
	 e9qbGuZblHD67Q/8OA7KAnA3QvP0WUuoPFGSFSPZc+fCgycjJRy9eqO4MEpHOv3oikg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x35/UmiFpLHLaphtgmwugk6xQ0bvAhoa8e9bk/HwH9M=;
	b=XilWkcQcV8Fu4y3nk/OXLv1cfraFO/ECf9bAlZCVU0uhr67YmUkh0kBPZ8W0N5/e5rG2
	 Ig6pudbMiCF0gpycjK49j28nWKOuJi9uHL6IOCQzlmnwX8frdxn5hnw8jgyH/caVLBJfn
	 fbmVMtvFARVUbJW/ezI5G+aC05WpcKPDEw/8sWoBmMeLDm8wZVqZ6VI2GUapRZim3L4GG
	 Kf87FA8yBqxfnuR39SaDfMgySdjWUi0/5VnCxrQnQco9wRLAle72LFE3a0ZmVW9jFTupO
	 SRHgkz9/ToMGgTHqwOFdkFYtjpHgKq5jq/50xujXrwlnZWJHlytjCW8xndP+Lcinm2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=isBTtpsA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBFC606A320;
	Thu, 19 Nov 2026 04:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=isBTtpsA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7461F000C4;
	Thu, 19 Nov 2026 04:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062213;
	bh=x35/UmiFpLHLaphtgmwugk6xQ0bvAhoa8e9bk/HwH9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=isBTtpsAoWG+o0b72W0EkmlU+2m+HQZoLGVGy6QE5BFo3e+VxuzI9V1QO82qAzyVf
	 asjDZeDXRVxEGOYyOojo2N7p0WU91YkZICg1GjGgXANnFKTCgbfb/7K8oHbKhkwx9T
	 GcyKDmXxC3WU6dGwuI9H2Mv7Lu4POIqwVDM0UhzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 5.10 1831/1848] nvmet: do not return reserved for empty TSAS values
Date: Wed, 18 Nov 2026 16:04:29 +0100
Message-ID: <20261118150036.291106630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Hannes Reinecke <hare@kernel.org>

commit f31e85a4d7c6ac4a3e014129c9cdc31592ea29f3 upstream.

The 'TSAS' value is only defined for TCP and RDMA, but returning
'reserved' for undefined values tricked nvmetcli to try to write
'reserved' when restoring from a config file. This caused an error
and the configuration would not be applied.

Fixes: 3f123494db72 ("nvmet: make TCP sectype settable via configfs")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/configfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -373,7 +373,7 @@ static ssize_t nvmet_addr_tsas_show(stru
 				return sprintf(page, "%s\n", nvmet_addr_tsas_rdma[i].name);
 		}
 	}
-	return sprintf(page, "reserved\n");
+	return sprintf(page, "\n");
 }
 
 static ssize_t nvmet_addr_tsas_store(struct config_item *item,


