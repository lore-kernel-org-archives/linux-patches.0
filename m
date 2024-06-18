Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8528115A853;
	Tue, 18 Jun 2024 13:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716786; cv=none; b=Wl2+Lha7KBRZXwwyn97qhCyikD/m37rMuzwxCD+X8a5kBeWzzdBcfLdjvd7VNXLDfYfCsKqK3dtz+ycsxlCMbHWfLZe1I55S/slcXkg2XuPmKpjPhO3s6tcTsZucj5cG2pdRGdfTr6leIdqIibWZgHp0iy7SmwGTKjoGQyT8Tv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716786; c=relaxed/simple;
	bh=vCFaTFG/nS9LI/28mCn8lY7R7cjCUzFCr4/wpxpQ5G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2qbBIKK+kDpGM6z6UOSFpmh1SHY29SWddiAwb9SkFCAbhkb3PspIaGF/9nWq1R3Xzaqc5/6ALnoBDtCXo0MbmURiprKzm7ir4+Rd6rR736C42HBeWVsUvLKeDg1Xx8HaNDJg8KZO1SmyNvj6H1ZGiEKyI6IJFC8Dpnmnjc5jFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUItDRX4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUItDRX4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5E0C3277B;
	Tue, 18 Jun 2024 13:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716786;
	bh=vCFaTFG/nS9LI/28mCn8lY7R7cjCUzFCr4/wpxpQ5G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YUItDRX48CiSBgKNXtyRRkkG2DOXNRjhHcbqo8nJfh2ee/BN6dbYeINhJSSf6HXjW
	 6polVf6nhNjwpSbXWevRoBc5RrWcnaNKKDl6XGqM4YiQoX+0AoT7LuVRzfHEb75XED
	 A17LnsBq42cmr0+ZYew/ksr4a3ApLmTz4JTAzIjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 763/770] Documentation: Add missing documentation for EXPORT_OP flags
Date: Tue, 18 Jun 2024 14:40:16 +0200
Message-ID: <20240618123436.724325994@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit b38a6023da6a12b561f0421c6a5a1f7624a1529c ]

The commits that introduced these flags neglected to update the
Documentation/filesystems/nfs/exporting.rst file.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



