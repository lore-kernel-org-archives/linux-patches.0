Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016617;
	b=heUmESm0HZ2Wtapk5pB4iyIpdfwX1+dZK8YCTVJSYqfQc5EyG+lA1e6zxE7j3nDlxVbt
	 fGH+TqCK7IMcRN5hMimP2I/42GiOMxxFoHLw3zxeLA0sFD/gQolyhgVu8pKMrGzlwkip/
	 lSVqYcQGxXABrzhotZUzAfz5jMNIGsRsEg4ZxNgycXtaZ0WwYHBKP1akCQ+XG4/YLLmTH
	 WajIcKfPIv/Lw6DMjmY1xQB1Nn7KU/FqRY5ARAS48tv4mxyNAz4eep335xJhAecAEwpt4
	 VOLYkrt6PXeVlgXv/2IDPb16PlbVUGO+iH2sloijTOgQzbi5S0lLp1itzJArjCUGKcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VtI9iiNziiq36XABRmc8ydAP//GHT3807AUvUyjEm1w=;
	b=Ftchmp91nP1l9Mf4CGU4E/mVgbGZahxIiymU7nEHo3v8mJidyTVioWMDqtQfnyhjov57
	 YZFCT2YMzpAh4CdhR4LShb9/FuJraz4rD7jF+kTTtors1k9AHsl8Wbe1KWbThLkRn3BhB
	 aLE6grJC7gbhWnb7/E+CWU+NGpG8g/MTZqFIC9EV7VTrIJAxAaO/mbqNQ+9HLauQbATd8
	 1szGRxsMIhdXH/gjGt+o6oGU/IAl1m1QuJ4Lyd1vP3DqrSuZ21kO5gvopnWktnWcJ/Z1e
	 phpy+KV7QuzldRMkPcU7rmIPmgABPNl+4mxXBsGQfmjBD1XAUYOMe22feza/6z5Q52A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N090cgvF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6F1606A331;
	Wed, 18 Nov 2026 15:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N090cgvF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5BF1F000C5;
	Wed, 18 Nov 2026 15:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016617;
	bh=VtI9iiNziiq36XABRmc8ydAP//GHT3807AUvUyjEm1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N090cgvFcORlsiK6b5ezAPCBafa49szRj+mD/91otvvaeZUq3McwljYHqIJZ4YnLM
	 w3qU/36hL37mzrILTppU4oP+xm5yI6lkeU4hd5Cn5ZZ3QCeIMjChBzWn1KEgc8eutO
	 zFfUG0+PamudaLBo3lv/Pl9uqpCRxraXMfLE0OsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shaikh Kamaluddin <shaikhkamal2012@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Guixin Liu <kanie@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0591/2651] cxl/memdev: Fix deadlock between poison debugfs and cxl_mem unbind
Date: Wed, 18 Nov 2026 15:30:31 +0100
Message-ID: <20261118150308.996531067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit 391bc7ab9be6635e77a205591b7d30db797f1a0e ]

The poison debugfs handlers take the memdev device lock so that the
region lookup sees a stable cxlmd->dev.driver. debugfs holds a
reference on the file across the handler, and cxl_mem unbind removes
that file while holding the very same device lock, so a handler that
waits for the lock deadlocks against a concurrent unbind.

The trigger is any teardown that detaches cxl_mem from the memdev
while a poison write is in flight: unbinding or unloading cxl_mem or
cxl_pci, or removing the endpoint PCI device, including hot-remove.

Both tasks then hang. The unbind side is uninterruptible, and it also
blocks the memdev detach work, which runs on an ordered workqueue and so
stalls every other CXL bus work item.

Take the lock with the trylock guard and return -EBUSY instead of
waiting. An unbind that wins the race removes the file first and the
write fails with -ENOENT.

The poison inject and clear files are a debug ABI for expert users,
mostly device vendors, to test the poison capabilities of their
devices. Mixing a poison write with cxl_mem teardown is not a supported
use of the interface, but when it happens anyway the cost should be a
failed write, not a hung kernel.

Found by code inspection. Reproduced by writing inject_poison in a loop
while unbinding and rebinding cxl_mem, and confirmed fixed by the same
test. Also reproduced the same deadlock with those writes racing a
pciehp hot-remove of the memdev; with this patch the hot-remove flow
completes normally.

Fixes: 574eda81d0a7 ("cxl/memdev: Hold memdev lock during memdev poison injection/clear")
Suggested-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260916025453.3532614-3-kanie@linux.alibaba.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/mem.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index 798e5c369cfc2..3959ec9630264 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -50,8 +50,13 @@ static int cxl_debugfs_poison_inject(void *data, u64 dpa)
 	struct cxl_memdev *cxlmd = data;
 	int rc;
 
-	ACQUIRE(device_intr, devlock)(&cxlmd->dev);
-	if ((rc = ACQUIRE_ERR(device_intr, &devlock)))
+	/*
+	 * Never wait for this lock: the debugfs proxy holds a file reference
+	 * across the callback and unbind removes the file under the same
+	 * device lock, so waiting here deadlocks against unbind.
+	 */
+	ACQUIRE(device_try, devlock)(&cxlmd->dev);
+	if ((rc = ACQUIRE_ERR(device_try, &devlock)))
 		return rc;
 
 	return cxl_inject_poison(cxlmd, dpa);
@@ -65,8 +70,9 @@ static int cxl_debugfs_poison_clear(void *data, u64 dpa)
 	struct cxl_memdev *cxlmd = data;
 	int rc;
 
-	ACQUIRE(device_intr, devlock)(&cxlmd->dev);
-	if ((rc = ACQUIRE_ERR(device_intr, &devlock)))
+	/* Never wait, per the inject path above. */
+	ACQUIRE(device_try, devlock)(&cxlmd->dev);
+	if ((rc = ACQUIRE_ERR(device_try, &devlock)))
 		return rc;
 
 	return cxl_clear_poison(cxlmd, dpa);
-- 
2.53.0



