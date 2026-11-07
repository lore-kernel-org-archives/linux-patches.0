Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060760;
	b=Szm1xLTAeqYWtKIkYvDzHWhTXOiNfxT1DTYwKTOSh6OEmpV4KeaXGG3uJrL4hYvJajdf
	 BJl8TlaEf+5mKultpySuwhupU4fh3Kzmnzqhd71/Cqkk5eXFpoZkns4ekM55Zf4OF5QFR
	 hxJxb6QOM9QAakmwVVI9jnI7sBTpkW3fu6GNJY5xjBgzxTgBgSGPM4T/+GdTx0waeRNZG
	 Tk8cmHzU7cXdDyV6L+9iIQREMSoOQgKaJJPQ+mrWcKsLbqgyld81pzkVLlC2iAo0izFjm
	 rM24AYmYU9S2vG4xcsT8AnO7Mm6xXu7nYiDDU4favQsjHRanTNF1cpYjnyeqUINSxVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a+x+d/4qw+X2OFE6zNgT826QbErSXlVMZ0jOjh1R0P4=;
	b=RRtdNSn77LFKDllpDpF/gRX/Iq7AEnlbgyJfcaZZ0Mg1zEypxzA83KJtPz16FNTh0Lsc
	 dPyPdCZNLZ9AAAs9h4rDmcVtOiPJThzXsILyHGEDKCkXQK6THWacivsPirmrklWSXqP4D
	 anL0f5KP8MjBzKdz8AVuO8P2VJVmxTmXIwFRpz5Bn7TN8fH4t+DvdBdtNWSGwgND2LBB7
	 vm4XU4/VNCAHEt7NdPNYehQFFUTurxUctJz8A5U6UTVo2pCtbxdlerY7asOa+k0PJupIv
	 sut5O7tUT2BgSx/bWoOeTy+cx5Xoy88ThlVQJM4qvoL+epyv6Q94+kAoZ43qMevSydA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMPDp4Kk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E67606A326;
	Sat,  7 Nov 2026 14:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LMPDp4Kk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37701F0089F;
	Sat,  7 Nov 2026 14:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060760;
	bh=a+x+d/4qw+X2OFE6zNgT826QbErSXlVMZ0jOjh1R0P4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LMPDp4KkFa0L1V1nanzAk4B5ebRdKdbMz6S9BWMSq5PBZppz5XfVUmu8uXoTfTG5O
	 zGoKQ//nExFW7GYvjgt4b9s5Oev82kmsvIbPFRuNFGQtlF2mDrDG7zg6tVO0gcv+Tb
	 GYI4rXl6NfvioNuhjZJ0DQ9zurs74EZTREZMMmvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0173/1536] ext4: reduce max cluster size to match documented 256MB limit
Date: Sat,  7 Nov 2026 08:36:29 -0500
Message-ID: <20261107135002.519422169@linuxfoundation.org>
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
index 3e0c29434ae38..18d6a8a4915a6 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -328,7 +328,7 @@ struct ext4_io_submit {
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



