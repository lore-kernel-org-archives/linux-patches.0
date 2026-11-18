Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033819;
	b=jES52Ak0ckrZ4r960rMBw7JxW3b3aYhi/5Zrz/iUUqzbSpWjJQj2rU9/nd3CGx4lJQRq
	 yaL5jHfYEmEOQhN04ED0SgFmY4UfFi8zuAaj+DMd17jGWdgPClaV6VHKrOwDBvBiJ3Uz/
	 mbFxmGcHcd951uHTgxOjjHMh5zZnn12FY4J1pMeCIUY60V4Wicutn6BxwD89lve756znO
	 x9y5RsvHyJAWUcVvprT/TJr7SUP4PMw/EhtVoecF4veA6X8Gwz7jnFvlJ5JHL1fmQ5SMH
	 6jObmlhSEo7+ViPu1oCZvCn/LNFc38/IEwp28wPynWlkTVgTaAqI3IIwKOdN3P8wGig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033819;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q4HVfhDvl2CpC2efrwjLLN9IdGaEvp4NrFx1NVtju5s=;
	b=j++zhK3Xy51q0nIUFPDXKCPvcHI8Kb27QL0ktxfaOctfvP0GR874kzPpruIrHDBZ+VbX
	 MmzlMrzupPtWg/q3uMNHgPml4fCIXmwAXmDSoix4nlu7Icxrz8uqbKtuggmWIevnNcw0P
	 BIId8reWTbStl6FY63j6iH32t4b7VbViUj81dcnwBhvno27piwDNMODngD/Ll4YqwG6xt
	 cAk0Wl8yLNTTWnvpAo37syBGkX6x+RggHHjawzDfDP3p/nKtDG4m9/m/SzHWEDHMwHoWa
	 cr46LmlG/xqSH1aiNKC6Y5dxS70QcLP5mmin5eWEFRgtCh/SsL6lxfwltG03SKAiBdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRWNFBKL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4591606A31C;
	Wed, 18 Nov 2026 20:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YRWNFBKL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BB01F000C4;
	Wed, 18 Nov 2026 20:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033819;
	bh=q4HVfhDvl2CpC2efrwjLLN9IdGaEvp4NrFx1NVtju5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRWNFBKLM9SeWcbkP3cOThJspQS9ZvOnGZA4RNi9KCCGQ/2kLcLQzbWooxIvW0DRm
	 Lb6hztyJMwiC/EYh+HcWJC/kvv1ywR3/MXg2ZJBi7FPKYvMcyKO+5Xp/I7t57NA3qR
	 eHgyYX9lswL2YgO1unhQCEG/KEVXl0TmHMRw1jHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0149/3318] ext4: reduce max cluster size to match documented 256MB limit
Date: Wed, 18 Nov 2026 15:12:51 +0100
Message-ID: <20261118150318.978686717@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 58746c5130ac6..46b4cac899008 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -332,7 +332,7 @@ struct ext4_io_submit {
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



