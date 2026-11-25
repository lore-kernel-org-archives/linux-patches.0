Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617927;
	b=41TdD2fnwYc5xwaiebqcMxww4P0+Bcf6tb0Ip4uXZOq65GagIO9Jsf5BcqYKgVMjgYP1
	 CKU48SZ3Sne8Fkl5FwwLPrXVet+WPcJCj15VSDjE5VvPU9iqMahjQnK0cWP3BFKSnjBn2
	 xNNBjdJ89Ujdyk4KHqEAmVYkxo5lq41TJrnDKj1ZJ3OmMw72owOKpO51Hh4IQeU2lhne0
	 eXHo/8FJrczLcKt4goSYS5BqvwV0q/lT3vUybxeSkO7bGSBa9omWdrUJBlqVrqoqeThPg
	 yElzXRIIxwvmEpmeY7H6o7nR6S4i0U1O4xTHnEReRg1rYd4giN2zck2rifJ1Kj1X6Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nh0IJuAMcmdPtGJeYmulsze1ZW9C8RyFusSdGryYrW0=;
	b=tATm1GZnE9PgSPkWeMetCEpjc51qw3PwVbsLPLN3oRCCZbUWEHBfG/Yg5C3ctaGPMhP/
	 LxNVLga5a8QN3Gzi7BYkE+A9ndGKyGNwYBDlsrhqFMVuofriS4pw8tjtYUJ2CgSU1qlR9
	 XvzsaTh8Ll1H0eWubAtWIjP+b1Pemi+3vCKKtBv1R1XNnTxx+suwOipmHXhLMI5qeJ+iF
	 QKBSa+MxC1t0uncMo7RGINWPmFmxI12d612MK31t1KLINnnFcz0e50gxUB6h7fSAiWY9d
	 FBIhonKWeHRBE3zJHrKdCpCQSJor5tj/pInpQGDbcePHKTTk9ASVSps6n5r80MdEpYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cW0RnS+6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525F5606A337;
	Wed, 25 Nov 2026 14:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cW0RnS+6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C6C1F0093C;
	Wed, 25 Nov 2026 14:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617927;
	bh=Nh0IJuAMcmdPtGJeYmulsze1ZW9C8RyFusSdGryYrW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cW0RnS+6aBxna1H08zzMoxfckBTMrXvfBLU6vDiU+vdub8SoYkcMTP0/TmdGtuHBF
	 IFukznRjXmmsoPEWQBo3xPivShW6V+KB7qReCHn10AFEc0cZQCczmaAwbJt33ku9lf
	 DkhCD7FcCmRvG1fMzKlXi6NWKm5PwimCzhoAQ9Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Thomas Fourier <fourier.thomas@gmail.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0074/1005] btrfs: zoned: fix double free of bitmaps on clone failure
Date: Wed, 25 Nov 2026 15:23:32 +0100
Message-ID: <20261125143823.473650959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 8c66a6aa59a5df1d672d72b7cd379d897ff73200 ]

btrfs_clone_dev_zone_info() duplicates the original orig_dev->zone_info
with kmemdup(), which also copies the seq_zones, empty_zones and
active_zones pointers. The clone then replaces them one by one with
fresh bitmaps. If one of the allocations fails, the error path frees all
three pointers, including those not yet replaced, which still point to
the bitmaps owned by the original device.

Clear the three pointers right after kmemdup() so the error path only frees
what this function allocated.

Fixes: 21e61ec6d0bb ("btrfs: zoned: clone zoned device info when cloning a device")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/zoned.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index 3b41e964d2096..a64af9d5d2376 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -645,6 +645,11 @@ struct btrfs_zoned_device_info *btrfs_clone_dev_zone_info(struct btrfs_device *o
 	if (!zone_info)
 		return NULL;
 
+	/* Don't let the error path free the bitmaps still owned by @orig_dev. */
+	zone_info->seq_zones = NULL;
+	zone_info->empty_zones = NULL;
+	zone_info->active_zones = NULL;
+
 	zone_info->seq_zones = bitmap_zalloc(zone_info->nr_zones, GFP_KERNEL);
 	if (!zone_info->seq_zones)
 		goto out;
-- 
2.53.0



