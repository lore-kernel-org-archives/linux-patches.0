Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E872566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:35:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71F8EC433EF;
	Tue, 18 Apr 2023 12:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681821340;
	bh=Yhm+Z3ghf28Txu5U4EDPDvJCHdXz/Wi72geABR1nzsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g8nCXTMb/fbO1hPUp/M1v/Z4QSfsxVsKEMTZaooIlZ3djbI4dgPW2YBTESrvNg0gH
	 IBIEpnHOrGYvyePqlk2U8rnH4m+aivX1jk4FPJpXhAcGAwyyM9VGJVSR99Cj9XlxGl
	 oD64a68i6gtKr5Wsw4YI19Mmdcsi7kUydbTn4Ltg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Nikolay Borisov <nborisov@suse.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 061/124] btrfs: print checksum type and implementation at mount time
Date: Tue, 18 Apr 2023 14:21:20 +0200
Message-Id: <20230418120312.076822318@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
References: <20230418120309.539243408@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Sterba <dsterba@suse.com>

commit c8a5f8ca9a9c7d5c5bc31d54f47ea9d86f93ed69 upstream.

Per user request, print the checksum type and implementation at mount
time among the messages. The checksum is user configurable and the
actual crypto implementation is useful to see for performance reasons.
The same information is also available after mount in
/sys/fs/FSID/checksum file.

Example:

  [25.323662] BTRFS info (device vdb): using sha256 (sha256-generic) checksum algorithm

Link: https://github.com/kdave/btrfs-progs/issues/483
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Nikolay Borisov <nborisov@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/disk-io.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -2246,6 +2246,9 @@ static int btrfs_init_csum_hash(struct b
 
 	fs_info->csum_shash = csum_shash;
 
+	btrfs_info(fs_info, "using %s (%s) checksum algorithm",
+			btrfs_super_csum_name(csum_type),
+			crypto_shash_driver_name(csum_shash));
 	return 0;
 }
 


