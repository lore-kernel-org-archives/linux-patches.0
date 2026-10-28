Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212752;
	b=Eo4bsbFdo9RbtQThqsqBz1aLXmcTK683vaWS1WBDX8lxO3u73zejWAD7K4YNI/gYlBwC
	 lUdZbO3gYX5uLtwfW508Vhe0gcKsBllRpR9T2hvKMJH6mCMCh9YVKJl6ZwwRNZKzmSU7x
	 udortKNT4DlyzrHUDmzjfcwfNB4xSUKcwk1UtUx5SnJuy0zyfYgdQnYZQ0JHFJcVkAEcp
	 D0YVSLGteIANOH0GJCemqYnvhPbJaoKUrPHBlfNQUwBdGuylldAhYRof95Kuu+RRPbkHk
	 /fJVlS3r+Vq9+nJcdztINKom9MOMTS/aMBMr0z6IQjtP0x/omfgDUXsBfZH1mAHlpsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212752;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=b5VmDvhcrb9PLLsFD1JFwYkRxz32aDm58xJshcAAZwo=;
	b=e6yhn6F6cZsJYEHk6Iex7yj8NdZKlaGDCGDDxxuh0JzOn4ReMVnNCy7wW8WjwwU2/Ews
	 NUlhOuQ+DYL6cHvuDPQhqCnIvIwh/wYs9pUg+FJ92MrlPn97xYxBKRgHEHfIF3gn0xibg
	 I9NLJnD++RBSuMXOnqm0TM10HuCFPH8cMsPli2jpUyKYzb4hZ9ZR82Uy1EOTVRZwIiDVl
	 Dl3D15HZG6Ks+l2UZ7lxYAtFUsAWSPf+AUbFYKK7RkUo8dpIqgb8BcpmhdmxDHuKUB0l/
	 mQX9oRctA/q5foO8V76rITJ4IEAEHFSJ6Rn52/WkcLHWibrnWTreVR+im3fLYiZ67Hg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJsnrrs8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD7B606A31C;
	Wed, 28 Oct 2026 18:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BJsnrrs8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7980E1F01825;
	Wed, 28 Oct 2026 18:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212752;
	bh=b5VmDvhcrb9PLLsFD1JFwYkRxz32aDm58xJshcAAZwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BJsnrrs8Eo9DFpdSSAN7UlC3infBHaTX0pXeAGs0XmXE+gOjkQPJc6+TDKCOIcgv1
	 SED8vXEKXRo+XdMPcssyeKbG+mD54BzLLyyLo9XXeLeoySD71NPkmI8h3PagFx7ujZ
	 n8UgqxEhIj7qzrNY6lY14H2B7ZNLRrSxnye7CNwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhaofeng Chen <zhaofeng.chen@certik.com>,
	Yuxiao Wang <yuxiao.wang@certik.com>,
	Alexander Graf <graf@amazon.com>
Subject: [PATCH 6.1 0265/1887] nitro_enclaves: fix use-after-free on SLOT_ALLOC failure
Date: Wed, 28 Oct 2026 17:39:21 +0100
Message-ID: <20261028170505.259581611@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Yuxiao Wang <yuxiao.wang@certik.com>

commit 9bc184a2eda8b773c88ecbff934001ad649b9cc1 upstream.

When ne_create_vm_ioctl() fails the SLOT_ALLOC request after
anon_inode_getfile() has succeeded, the error path calls
fput(enclave_file) and then frees ne_enclave.

In normal userspace context, fput() defers the final __fput() via
task_work. ne_enclave_release() therefore runs after ne_enclave has
already been freed and dereferences ne_enclave->slot_uid, causing a
use-after-free: KASAN: slab-use-after-free in ne_enclave_release.

The enclave has no slot allocated and is not yet linked into the
enclaves list on this error path, so ne_enclave_release() is expected
to return early when slot_uid is zero. However, reading slot_uid
already accesses the freed object.

Clear enclave_file->private_data before fput() on the error path.
ne_enclave_release() then returns immediately when private_data is
NULL, leaving the ioctl error path as the sole owner of ne_enclave.
This is safe because the file has not been fd_install()'d yet.

Tested on an AWS EC2 m5.2xlarge with CONFIG_KASAN=y. Without the
patch, the reproducer triggers a KASAN slab-use-after-free on every
SLOT_ALLOC failure. With the patch, no KASAN report is produced and
the SLOT_ALLOC error is still returned. Normal enclave creation and
teardown are unaffected.

Fixes: 9c8eb50fe9e2 ("nitro_enclaves: Add logic for terminating an enclave")
Cc: stable@vger.kernel.org
Co-developed-by: Zhaofeng Chen <zhaofeng.chen@certik.com>
Signed-off-by: Zhaofeng Chen <zhaofeng.chen@certik.com>
Signed-off-by: Yuxiao Wang <yuxiao.wang@certik.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
Link: https://patch.msgid.link/20260909124400.27857-1-graf@amazon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1710,6 +1710,7 @@ static int ne_create_vm_ioctl(struct ne_
 	return enclave_fd;
 
 put_file:
+	enclave_file->private_data = NULL;
 	fput(enclave_file);
 put_fd:
 	put_unused_fd(enclave_fd);


