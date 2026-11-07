Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064869;
	b=sAFqsaN0XyB7TFZw24QSJckvHLj2AEl1GvYDrN2HbBrf4fP4DLHa03Y1XG5wXM4kHOzW
	 Vs39Ou+9H5/9JvMmdRK+6wiSE9DbEbiFtC0OyS6aTNc6RsqT0P5PTHEW0OElMi1oNY2nZ
	 pjglEpYanewRjmgxp4R5oRpzJwIjOLnUh5VAg/CeIr9xaMdSlA7zFSmdjKR49HRY+BEnX
	 o9IH7KdnWlby23yAvXPmMWu49r1DOn4hBhdOiREW1x+3PSc5SnIB/FjGsvix/sTT6iz3/
	 DhCOjWxmR0xBsaqu5Wq8qLK5//o0Y/jYQOgITc3gmkMxiYdPG6JNC9rVIbKKxCGTIRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G8N0bG2M+LfKZkEsM/p/+xoB3X4r/Gjq7DP9w6Q027Q=;
	b=y9Md8nhk2NvbtFSSOmtumY9Vo38z7/kwrgIp8P5+bvOhx5HvU9q/HysmJtycTKjTeqTv
	 cO49EEQGMmEdTy/t7FMMb2oj/jYRSGz6Uqzls6yKfp9+6+w2819HEXGNGprmYxdZvtywW
	 scXz7tosDLmiL5l7xzsbGT4ezp/hJX6wVdsw1odwSLRqTVztiLMLmlb8/ljh9tZyuvR3e
	 RutI5CSwREBidYNRURKo9JB5bNqUqZ3sDgBmGirlRZp3+TQ7eI7fmyo648fbkSu1ysky0
	 9MqCPmQ+JK5NWV7Bxf+PUmAYFsAMNO0DrcpbtSwVDByKQgIST99kIidGjafXWe6fQKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFWa2pPG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC83606A9C1;
	Sat,  7 Nov 2026 15:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oFWa2pPG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADBE1F0089F;
	Sat,  7 Nov 2026 15:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064868;
	bh=G8N0bG2M+LfKZkEsM/p/+xoB3X4r/Gjq7DP9w6Q027Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFWa2pPGTpdySRlOTT9abUGrtgfqwU54hG0/pRbnzCE/WQmjd9xtQ298ERf9JLG3n
	 cc2TBNq2szMyIg09oRURvsgmDFVvBTN6fTJGbyFC8bf06nydUV4+nDTYFqLfock1tg
	 qbfSzUsyZZe6p5bG7RULME/EeKwTE1oregSKYtm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0785/1257] crypto: qat - initialise state_lock on every path in adf_devmgr_add_dev()
Date: Sat,  7 Nov 2026 08:51:21 -0500
Message-ID: <20261107135000.998411925@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Ahsan Atta <ahsan.atta@intel.com>

[ Upstream commit 4ad7c1bd5f3dcd3fd6efbb068d6ee2a68dddfece ]

state_lock is initialised at the end of adf_devmgr_add_dev(), but the VF
on host path whose id mapping already exists returns earlier via
'goto unlock'. That mapping outlives the VF, so this path is taken every
time a VF is recreated on a BDF that already hosted one, e.g.:

	echo 0 > sriov_numvfs
	echo 32 > sriov_numvfs

accel_dev is freshly allocated on each probe, so state_lock is left zeroed
and adf_dev_up() takes an uninitialised mutex. With CONFIG_DEBUG_MUTEXES
this is reported on a dh895xcc with 32 host-bound VFs:

  DEBUG_LOCKS_WARN_ON(lock->magic != lock)
  WARNING: kernel/locking/mutex.c:159 at mutex_lock+0x171/0x1c0
  Call Trace:
   adf_dev_up+0x27/0xe0 [intel_qat]
   adf_probe+0x700/0xa80 [qat_dh895xccvf]
   local_pci_probe+0xd5/0x190

The same happens on teardown when adf_dev_down() locks it again.

Initialise the lock next to the other per-device state, before the tables
are updated, so it is done on every path.

Fixes: 1bdc85550a2b ("crypto: qat - fix concurrency issue when device state changes")
Cc: stable@vger.kernel.org
Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
index 161863841a527..26b40dd599652 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_dev_mgr.c
@@ -137,6 +137,7 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 
 	mutex_lock(&table_lock);
 	atomic_set(&accel_dev->ref_count, 0);
+	mutex_init(&accel_dev->state_lock);
 
 	/* PF on host or VF on guest - optimized to remove redundant is_vf */
 	if (!accel_dev->is_vf || !pf) {
@@ -210,7 +211,6 @@ int adf_devmgr_add_dev(struct adf_accel_dev *accel_dev,
 		map->attached = true;
 		list_add_tail(&map->list, &vfs_table);
 	}
-	mutex_init(&accel_dev->state_lock);
 unlock:
 	mutex_unlock(&table_lock);
 	return ret;
-- 
2.53.0



