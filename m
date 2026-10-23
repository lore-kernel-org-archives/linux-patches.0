Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774889;
	b=q5197rFfZCHVFT61Hm722SEbDaelQdHkUjH5ALi31WAqROwm10jCsv+IDLEV3tyeTzBo
	 UnC6kFKSJuJRnnHiW+og29zkli7fMVtTMZW5pXaZfTEGDfK0KRJIwHZmTX+wKmKR2X2Zs
	 w8MIHV8MwEIPUqnVclR6nQhWlAFTHBffM8+y5vHjWL4eK6JkboVTM5gfH8lBeXhAQeCQT
	 UTd22a31qYGtVvtD/56XSmkBIiXbc2w0d2O89tBLIWaznWogd2ayaj5l4nb9v62gqKY4F
	 NiRJi/S9UDFAvNkPQl1AJRtPDQr4Z/aplFvc47OVjpD9s+LVvbHMQAtA4rZ/7D6SvsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OEI7l/0tU0Fl79bA0JwROeBVzT2QFT9ly4WyB8xcXgE=;
	b=Pkk3+69fGbiB6RMiuzflGfti3wwZSMxJhxET9WThiOEQQWZZewrfgeSxcODo1ye2rHe1
	 VDmZp0AeHZmg6beL2Ox1LmHgV5rIiWlXcA4trt67Kt1tq1fGO5VtFeFa5cxzGEGSM0wMb
	 QL4/m5Uh1pC9f5hn4YW/6hvQmHgT4ibiuUZVfeAVrMQiBPvabBvKvKVNTHCZfNxHIr+Ir
	 peM0OlOkNfDJL5MiKx46WjsHA4EgUqbACBEtIgT2HndTP9iJ1LZUFKzjISAdIV8johJ4q
	 cLIB0zs/XwU+jLeGbZPB05MlooW6UWSAxG+JHvxioJ86n27gJpDjSjFRz3j9VBX1W6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrwuV2OX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3ED606A31F;
	Fri, 23 Oct 2026 17:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QrwuV2OX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C011F01825;
	Fri, 23 Oct 2026 17:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774889;
	bh=OEI7l/0tU0Fl79bA0JwROeBVzT2QFT9ly4WyB8xcXgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QrwuV2OXyqYKwZazztxY1IM0eEkiwf935fqPJzXCKhVI9NdJhFQR7Quief9I584Mb
	 z2cUESqehgJm6xiAIpbWEghoSLaqddI2RS0TzBnfPwedk9E5FZ+a0rQWvoItVja4Zw
	 11xkVCNwAsAb1QtA2CLY/nnZCP2vXiiXCGUz2JF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrey Albershteyn <aalbersh@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 7.2 192/242] xfs: fix zoned write iomap flags assignments
Date: Fri, 23 Oct 2026 18:40:34 +0200
Message-ID: <20261023163718.333764223@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 4bc67fc800edcaae8a657e4d2fba12e64e856b9f upstream.

Don't overwrite IOMAP_F_DIRTY with IOMAP_F_ANON_WRITE, but ensure both
flags are set instead.

Note that in practice this is harmless as all zoned writes force a metadata
transaction anyway, but incorrectly assigned flags are still a landmine
that will cause problems at some point.

Fixes: 058dd70c65ab ("xfs: implement buffered writes to zoned RT devices")
Fixes: 2e2383405824 ("xfs: implement direct writes to zoned RT devices")
Cc: stable@vger.kernel.org # v6.15
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Hans Holmberg <hans.holmberg@wdc.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_aops.c  |    3 +--
 fs/xfs/xfs_iomap.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -632,11 +632,10 @@ xfs_zoned_map_blocks(
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	wpc->iomap.type = IOMAP_MAPPED;
-	wpc->iomap.flags = IOMAP_F_DIRTY;
 	wpc->iomap.bdev = mp->m_rtdev_targp->bt_bdev;
 	wpc->iomap.offset = offset;
 	wpc->iomap.length = XFS_FSB_TO_B(mp, count_fsb);
-	wpc->iomap.flags = IOMAP_F_ANON_WRITE;
+	wpc->iomap.flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
 
 	trace_xfs_zoned_map_blocks(ip, offset, wpc->iomap.length);
 	return 0;
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1081,11 +1081,10 @@ xfs_zoned_direct_write_iomap_begin(
 	}
 
 	iomap->type = IOMAP_MAPPED;
-	iomap->flags = IOMAP_F_DIRTY;
 	iomap->bdev = ip->i_mount->m_rtdev_targp->bt_bdev;
 	iomap->offset = offset;
 	iomap->length = length;
-	iomap->flags = IOMAP_F_ANON_WRITE;
+	iomap->flags = IOMAP_F_ANON_WRITE | IOMAP_F_DIRTY;
 	return 0;
 }
 


