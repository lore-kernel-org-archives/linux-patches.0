Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045530;
	b=sojbcnA9eBYOSbrEuG7thmYl6N/tb9yjnzKBoG/K5JRkaR6K7WvBPDkgNVSNAEpj7FPb
	 4ozzuHDJnKPN9tT9T2nLlF3zp5+/5UYL27IQv5tdMt3F8bhMXJoktyddNy+zrXWbWJQt3
	 fUTn7mnuFCMqpZ6DbtYBwB2+Oj3RM6fWTlnBCSPfIgCcwbL6CRPyMS0seNrL9971WFp8T
	 3TJOp8RzOIzmCer9N5U8tIjov0rleg6wSa0K7UtYS3DDZLXvl9dIaQJv+y4XdTz+6PqsD
	 KqrT/5HfThrnHHn9U8hl8D75B+VaXFsmFb8GFLGPogTZseMuzEo8WSj+y1rQBmA/Qiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7J8dr7GBk0kRCm5xM7RAWlf1VW9+l1VN0T5gok/BxBU=;
	b=mtpvsXTMYM64mKPtbL4/jmTSMztkWgo/Uo8Mma4F+zg9cLtTEwB3sgP976VOEJ9u1J+y
	 dNAMVZUzC0ifVm4GQj1apsBzG2Um4VdFkLwl3h8QsGPn3nQLnPHjeSC733SPAqoFp8U6t
	 9EPFWuut33N6Mn4wWA84FydsFVccwjqOKEGMf5VhiweXLo37KeJboMCnjTa+ngs3DkB9G
	 YJjtXT32zL+Tt88QuImN9OFPLNh58UdoaU9jji2JdaVbrcq0NrM28xB1sOWWi3dd8nZhA
	 cH8EGjrmt2s3xiqjS7euyiKp8A1nGSDiAV7jLegi0APDS+UFS8gIc78CbW6OrcktBxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfOMYKsP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7F9D606A32A;
	Wed, 18 Nov 2026 23:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wfOMYKsP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DF01F000C4;
	Wed, 18 Nov 2026 23:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045530;
	bh=7J8dr7GBk0kRCm5xM7RAWlf1VW9+l1VN0T5gok/BxBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wfOMYKsPII/uEY7qFkonkT07BpnDiGEu7bm4GJXwYzC5dbQkT6m1A4/gkH4FqAagh
	 IZXcMoAFSyD3LWMtrHfM2KijNSkpVem6T42HKHoLUkeDZRP/p3iD6i53NvMLEP6o83
	 Lephq+A0+U/qHgUYkrW0ye2nSZI654/i22VCamF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahsan Atta <ahsan.atta@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0957/2857] crypto: qat - initialise state_lock on every path in adf_devmgr_add_dev()
Date: Wed, 18 Nov 2026 15:33:11 +0100
Message-ID: <20261118150236.060338321@linuxfoundation.org>
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
 drivers/crypto/qat/qat_common/adf_dev_mgr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qat/qat_common/adf_dev_mgr.c b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
index 9bdfa5b1614fe..98aebbe044d56 100644
--- a/drivers/crypto/qat/qat_common/adf_dev_mgr.c
+++ b/drivers/crypto/qat/qat_common/adf_dev_mgr.c
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



