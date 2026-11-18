Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057469;
	b=Q7y9/IKEOoL9FO8mHME3MQXoILlqiuKgYoom/lzGwmFfZbbzDpd9lppkyRuLhZFO6fWI
	 sSCGBj8KBPofRbR9vA6pPM8EEejYdYNgnepccbz+FB7+nRV1jtZ/tzfAh9DkmUN2hx1Zd
	 /Ljx/J2hDpzbkiMsBc+rk0bzDdKngqzn30TuX9d1Z2vZey9f30eJlsStmCeu3KRFGHTDk
	 9vwM0rX9bGz3fVz+bJsdtzrRPzVoPaETCldGIvGr3vdD9Cjro0xihgg5mDx6WDJPIJyGd
	 k8H9Hf5AV2DsckAETic/Ukw/6/Kjh+UW3pVcGOBXLruTLcwwc3hahuxPzs9KJ4qyYzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057469;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cpEIAc5RT83pvxhi0GP/Pd2TDOU5ZzmWTM3BirDjqWs=;
	b=erxaS1vwb8FOqz+z+E9nZFAabg2r1IqynYde+qvR84dtEkipie27CFus8CMGN2tMM7Hc
	 hBjwua7UmrpydTuXehLub4tNB1sdwCgjmW1QqRYQMVCoAWdxuB4UXeuF60HoDP75W124d
	 YYLm73VFnOBM4YW9icuBqt44xlidYfsfG1PP2cA/PaJpEjJ6zexZUgmN8ICME7UYC4Czq
	 RHO+T+wijOWfEiasa0flLPScrfuPspW8bX4KuDYGz6G39DgNKMwHMtF9JIt0icP34f8F4
	 h/D999of8VefPyTgHEC9FhM6DbXkB5f7P80uilPylC9zg8qkTZekVMiNsSkp5cLgMgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKu2XNBq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82570606A33E;
	Thu, 19 Nov 2026 03:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UKu2XNBq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20D21F000C9;
	Thu, 19 Nov 2026 03:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057469;
	bh=cpEIAc5RT83pvxhi0GP/Pd2TDOU5ZzmWTM3BirDjqWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKu2XNBqX9VnYiuxIJ8NXhKcwWiGO8Es0C3SgyWfffDThUXEfoBnIzBxEPt+jhwCK
	 kWAUNzjneyzkLDhy4zfOEH8/JE853tqDkETCkw7QrgMP7EyDoXOmZZdpHw4exP/LJB
	 MVyM3yyKOxjWE8YDU1UeOyl5nyAhmuBOl7Ehf05E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0100/1848] ext4: reduce max cluster size to match documented 256MB limit
Date: Wed, 18 Nov 2026 15:35:38 +0100
Message-ID: <20261118145915.257188551@linuxfoundation.org>
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
index 4adaf97d74354..a2fb616b0bd62 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -264,7 +264,7 @@ struct ext4_io_submit {
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



