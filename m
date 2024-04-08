Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810967F487;
	Mon,  8 Apr 2024 14:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584812; cv=none; b=RkaB6RIl1J2XmTy9chN26lGlggfIVp7UfZeCKNJOULYLcT35+tTeY1HJOiYx8LApAlRWM8yUrgab/uG3YoRkD7rdO9rgK+ShcV2jADNG1Z/kAJR/exshJ+4xgnOc7XUP/CmTxjCbyWb+9uH4FJR/1ULDzjYvbd9TzLRJJu33fno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584812; c=relaxed/simple;
	bh=BnPBss2oVFtKrwxvDhQzXn0jrPiDwwJ0VEnDZ6P6mh8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lo+VVUJmdJR/+ADaD5iN44e1MVtiE47tZbxfLeQkCEA9Pgh7sup67tQIyN4nA6gj1I8eQ7GHJeYC3M3mTVPbpeDtfw2ofTKJGVIdrbHCOszU84swXzHkSHM3Ocf5q+1HXjikN8tCEUb8tY5HrJA4kxaRUUmzCj2UbTNMgWdDK98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UILcStDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UILcStDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3F6C433F1;
	Mon,  8 Apr 2024 14:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584812;
	bh=BnPBss2oVFtKrwxvDhQzXn0jrPiDwwJ0VEnDZ6P6mh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UILcStDbwHaACQXK8SIuSBRd0qEQ2Gg1E4WedoIFRBYsi+rBNcIfInCX9C0T06zUe
	 cQzhPMhBx60x9Bo/rwu5+/blurCqxrsKPZ7ys+BNVMtQhABPPGsU92Fn7K6SNsr0mp
	 u8S1Zor95oc83ALnHGAuK0BqvzBJiqZxv+o1dF7o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 548/690] Documentation: Add missing documentation for EXPORT_OP flags
Date: Mon,  8 Apr 2024 14:56:54 +0200
Message-ID: <20240408125419.489264413@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b38a6023da6a12b561f0421c6a5a1f7624a1529c ]

The commits that introduced these flags neglected to update the
Documentation/filesystems/nfs/exporting.rst file.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 Documentation/filesystems/nfs/exporting.rst | 26 +++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/Documentation/filesystems/nfs/exporting.rst b/Documentation/filesystems/nfs/exporting.rst
index 0e98edd353b5f..6f59a364f84cd 100644
--- a/Documentation/filesystems/nfs/exporting.rst
+++ b/Documentation/filesystems/nfs/exporting.rst
@@ -215,3 +215,29 @@ following flags are defined:
     This flag causes nfsd to close any open files for this inode _before_
     calling into the vfs to do an unlink or a rename that would replace
     an existing file.
+
+  EXPORT_OP_REMOTE_FS - Backing storage for this filesystem is remote
+    PF_LOCAL_THROTTLE exists for loopback NFSD, where a thread needs to
+    write to one bdi (the final bdi) in order to free up writes queued
+    to another bdi (the client bdi). Such threads get a private balance
+    of dirty pages so that dirty pages for the client bdi do not imact
+    the daemon writing to the final bdi. For filesystems whose durable
+    storage is not local (such as exported NFS filesystems), this
+    constraint has negative consequences. EXPORT_OP_REMOTE_FS enables
+    an export to disable writeback throttling.
+
+  EXPORT_OP_NOATOMIC_ATTR - Filesystem does not update attributes atomically
+    EXPORT_OP_NOATOMIC_ATTR indicates that the exported filesystem
+    cannot provide the semantics required by the "atomic" boolean in
+    NFSv4's change_info4. This boolean indicates to a client whether the
+    returned before and after change attributes were obtained atomically
+    with the respect to the requested metadata operation (UNLINK,
+    OPEN/CREATE, MKDIR, etc).
+
+  EXPORT_OP_FLUSH_ON_CLOSE - Filesystem flushes file data on close(2)
+    On most filesystems, inodes can remain under writeback after the
+    file is closed. NFSD relies on client activity or local flusher
+    threads to handle writeback. Certain filesystems, such as NFS, flush
+    all of an inode's dirty data on last close. Exports that behave this
+    way should set EXPORT_OP_FLUSH_ON_CLOSE so that NFSD knows to skip
+    waiting for writeback when closing such files.
-- 
2.43.0



