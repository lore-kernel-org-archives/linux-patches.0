Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043211;
	b=hw1Wl2pQqBH3e4agaIiaeOReP7AfN5qWr7JA9HYBUTyVWKbGqQ/r+P3/J9Sz2aIUaqKr
	 dc0VX7a/jGnQTsz+VmpVDLbukJhm5L8bCRM8kVOsHQSc/vLX9DOmcbRTTgTjUFImr/XNf
	 p7gd+E+zX2nQT0ofWhcMkZXds8z6UxSrbRF0qcl/v79d3Ip3L/tvJ9QhwpwEUDEnwkrPk
	 Sk7Bko7/hWeL1YNjYInImFe0rBhePq9hrUR2IviqZQJ5MsouCCMNM0NX6I+oPBhIOIk32
	 C81OyirCG//qW/0Skd3Kpe9im3JRFhD61ierLwJ1hTjTirPxVf00AEjPpxoip+tuo8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=89x+KkNAb/7urHZ6cV+eZwVWoOqzveRngE9M+nD+0YM=;
	b=LQ6qhQDJ6KkzQdfleE82wmESO6jGypkMuQa9XcuxGsM1oQnxZ2MLtSjdxDDgz2qQVLzv
	 xwWwPpx/Z6LaOm5ri3C9TWYteGkmq7gfJ/w2OvDflYTxhwF67Wi2XAeIPp/23sXge+v1i
	 AFfcp7Iv/CoRL57cO4JmvwTdY8IE4lyDXrm1hs/E4VxgxMM5aWbJ3VoQG59PJkjL+ImcR
	 we+dAbpCvkruiNmyA72zxo6nN0w8AXcUPeAcHXDpfN/mlhcux6fUZryWwYkL3YrTNJxdg
	 HzFZdvLsad2JM2MXKDq3EJF6Blma563H1ed0RcbAf70PsLegz85aNlNQ3wH5LoF+GVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+Z6fdX7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3752606A31C;
	Wed, 18 Nov 2026 23:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B+Z6fdX7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00AC01F000C4;
	Wed, 18 Nov 2026 23:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043211;
	bh=89x+KkNAb/7urHZ6cV+eZwVWoOqzveRngE9M+nD+0YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+Z6fdX7/Rl2MiD5gYBBS07iWsFRPrVuaczoRxR+NiVnUZRuulYrWYF/rQzHbpJzo
	 8boXTyWUBjlJ6xSh17B88gHJTh8U/0BqdpKLHqdwvtr56Z+EEggLT2lmVNlsRzh6Ah
	 LD1FFWZs8dQ5iVpo6bUGCBaVSWhdvr+BJxqmd7A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0130/2857] ext4: reduce max cluster size to match documented 256MB limit
Date: Wed, 18 Nov 2026 15:19:24 +0100
Message-ID: <20261118150206.029925787@linuxfoundation.org>
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

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit afa3caf2fbc417f755f36e271c4b3c2d45ccda9d ]

The mke2fs man page documents:

  Valid cluster-size values are from 2048 to 256M bytes per cluster.

but EXT4_MAX_CLUSTER_LOG_SIZE was set to 30 (1GB), allowing crafted
filesystem images to specify cluster sizes up to 1GB.

On 32-bit systems with bigalloc enabled, the consistency check in
ext4_handle_clustersize():

  s_blocks_per_group == s_clusters_per_group * (clustersize / blocksize)

can overflow when the cluster ratio is large enough. Since
s_blocks_per_group is not range-checked in the bigalloc path, the
wrapped product can pass the consistency check, leading to inconsistent
group geometry and potential out-of-bounds block allocation.

Reduce EXT4_MAX_CLUSTER_LOG_SIZE to 28 to match the documented 256MB
limit. With this cap, the maximum product is:

  (blocksize * 8) * (256M / blocksize) = 2^31

which fits safely in a 32-bit unsigned long for all block sizes.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260608061112.392391-1-libaokun%40linux.alibaba.com
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Link: https://patch.msgid.link/20260608111150.827117-3-libaokun@linux.alibaba.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index ae786abecc9a2..0511b84e1a436 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -278,7 +278,7 @@ struct ext4_io_submit {
 #define	EXT4_MAX_BLOCK_SIZE		65536
 #define EXT4_MIN_BLOCK_LOG_SIZE		10
 #define EXT4_MAX_BLOCK_LOG_SIZE		16
-#define EXT4_MAX_CLUSTER_LOG_SIZE	30
+#define EXT4_MAX_CLUSTER_LOG_SIZE	28
 #ifdef __KERNEL__
 # define EXT4_BLOCK_SIZE(s)		((s)->s_blocksize)
 #else
-- 
2.53.0



