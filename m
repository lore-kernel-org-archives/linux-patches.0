Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468FF481B8;
	Mon,  1 Apr 2024 17:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991364; cv=none; b=sAmeB117AJPZiMFdVQ2uEZIQtiL9/VfFn46dHgsm0CYxHgbByDW8FLByrKTJkMIJDCmvbroH81IXyTLimRPprkr061XXI3rk8vWTKR2pSSiFLSLN4ePjAPJ2OrlCSdlCmJ19kLPuW3DYkkkDLGEzsEtVh0V/N0ej3V9VBm+yA48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991364; c=relaxed/simple;
	bh=wGfWwCn1ksKH+JzruNpumiHp81rDhRCIwQblmXUYx74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THmsKqCL8GmOqff1EoiP2CO/JEzXmzMm2QIChgYvAHaaX2uyDuLiJs254pOnzHD2XdhJTAieGIyAExFmFIVbvKHKKPTrqn96bXPkJVz/f4z9ReChWpKAHZKwmfRgBK6flCuMyGNphvVu7v2J6Moe6GDov/3TPGJqyUcA0Yn7t3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UAfY8vzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UAfY8vzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFACCC433C7;
	Mon,  1 Apr 2024 17:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991364;
	bh=wGfWwCn1ksKH+JzruNpumiHp81rDhRCIwQblmXUYx74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UAfY8vzUsqf3/m7RJIiRD5qMkLBH3bHwVoTTikBGVA+uZsTFYgP4M7ImybKuWPLR6
	 18boi2iaJ32hv/MOoN8EuTf83UdjKihKXdVKL6D9pwr7y1WgjkkfzXxlbBLp1M5+6O
	 dpBRV+2L1MVM2mqtEaVYIjEg3izRHB6fmCgcUSx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WA AM <waautomata@gmail.com>,
	Qu Wenruo <wqu@suse.com>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.1 214/272] btrfs: zoned: use zone aware sb location for scrub
Date: Mon,  1 Apr 2024 17:46:44 +0200
Message-ID: <20240401152537.613706752@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit 74098a989b9c3370f768140b7783a7aaec2759b3 upstream.

At the moment scrub_supers() doesn't grab the super block's location via
the zoned device aware btrfs_sb_log_location() but via btrfs_sb_offset().

This leads to checksum errors on 'scrub' as we're not accessing the
correct location of the super block.

So use btrfs_sb_log_location() for getting the super blocks location on
scrub.

Reported-by: WA AM <waautomata@gmail.com>
Link: http://lore.kernel.org/linux-btrfs/CANU2Z0EvUzfYxczLgGUiREoMndE9WdQnbaawV5Fv5gNXptPUKw@mail.gmail.com
CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/scrub.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -4177,7 +4177,17 @@ static noinline_for_stack int scrub_supe
 		gen = fs_info->last_trans_committed;
 
 	for (i = 0; i < BTRFS_SUPER_MIRROR_MAX; i++) {
-		bytenr = btrfs_sb_offset(i);
+		ret = btrfs_sb_log_location(scrub_dev, i, 0, &bytenr);
+		if (ret == -ENOENT)
+			break;
+
+		if (ret) {
+			spin_lock(&sctx->stat_lock);
+			sctx->stat.super_errors++;
+			spin_unlock(&sctx->stat_lock);
+			continue;
+		}
+
 		if (bytenr + BTRFS_SUPER_INFO_SIZE >
 		    scrub_dev->commit_total_bytes)
 			break;


