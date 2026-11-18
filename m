Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051177;
	b=TcxsubDuRUCoPhtIo0C98MFA6gbugyZDUBGzRZj0cKfrOkc3j1V4JuG0WRtOdYiEQBu5
	 QEqlF0PqXHFInm5JL2CLRwsYZmzG3vzOeZA7DpVxQVFngAUjM0egX23W1TVdcFy5tezXQ
	 XA3rG3j2nR1s3I0QP1RXOtcNo1SI0rzUtoDX+OfBd02koODWCtg+UdknMNqZrc8J1R97X
	 rQCptpwvSK0qC6B1qIrPCx6y63FLVTKfj/QA2usQyPwovu7rE8+BrxH6pkAd5VMtGAPGh
	 sTveWdXHcAuo5NceqsUxFl5Gv2YaHp3JpiLpidKvuCpTurh0N9lQhHcGwaCP3qo5AlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+NUwmyL83qQpvyn+znOdQrQX1dQ+guT6sVPOfJdKyhg=;
	b=DCRBehP8D33F2NIonxMljhRMT5atN1jh5Wf3qkNT6u2D2GOJTNaNS0eTQnhseQ9FQME9
	 G2hd30JvYz67ch6fh8u5KKooiPkwsET/J7YQTFC66uDDJypIA1+fgVdwoHiwhNQaCogEe
	 O45hbQaNnJVy0hCniPpax1DMpRcXzkBnssWy2EcOU1xPQjGgbY4ZACCXSGFwnlQgF7frr
	 Dmv6vbk6LXfFye2liTNU+nqterG6NbvJRrvcdTsx+T1a+5j8KkshwKcFhLKhZOPK0leR4
	 zBF7fUcmSylTZHbE34A3KY7g3veYAEhHpgkiyaqatPiI6dMMpPcvpPQsUrn1B3F2pag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uU8CJodO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 097B9606A325;
	Thu, 19 Nov 2026 01:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uU8CJodO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59F821F000C5;
	Thu, 19 Nov 2026 01:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051176;
	bh=+NUwmyL83qQpvyn+znOdQrQX1dQ+guT6sVPOfJdKyhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uU8CJodO8rgZNtgX5ltzXfUnY/b4WtXttRQiGnpfVIrXYAzT7mk4nDwZVnoICbCol
	 luIgm0zMteV9NjymXWxgnYVRHj09BE2yh1xzJoqeYZ7DpJQS/U21B5jQO4BxrKZZC3
	 jpakvuVLmAVtHpUtSD+3nBaDyLfJbXAccm6owcxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0115/2214] ext4: reduce max cluster size to match documented 256MB limit
Date: Wed, 18 Nov 2026 15:29:51 +0100
Message-ID: <20261118150014.566998852@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index d99eabf846b8e..f8de0cc489529 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -279,7 +279,7 @@ struct ext4_io_submit {
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



