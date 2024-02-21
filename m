Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2AF76C99;
	Wed, 21 Feb 2024 13:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523915; cv=none; b=Bt7IM4cnPq8B3/QhWBmJV0+yNy2rfm9xTWQnL2kOezH3vhFj396PlNpFEaJofsMkmBDPX5blsxumiZzc4whnhZCN+3NDTXmu3A8R5XSHUwz69RAuj00hxwo5i4oQiQkg0gtvaewKGb5DhUyTYAJCO8aRgA6Em2dot9/bhoVYEP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523915; c=relaxed/simple;
	bh=gzG7TaMasnPo353MKC3UGmxt22wPGwszCUtIOtUNs44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMZw0NCoh7Bu3S48SZ70lRdAtS37LFiTL2qcMeDY8dDHc+4Tay7VDAbTwus9HIwCwL8UN2uaguTCI3FhMvk5gLeFiruGlZRtZK0AuPgeNq1y/XbFGGAvrEDl5RGsdPkp7kN72QHvRgI4d0tS5IASuuA4PYLkpcHW2A+u4wVbG0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V2WpX2+P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V2WpX2+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5E4C433C7;
	Wed, 21 Feb 2024 13:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523915;
	bh=gzG7TaMasnPo353MKC3UGmxt22wPGwszCUtIOtUNs44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V2WpX2+PYZLdYcpnL+nAZvqMaQNsl4oTOy5AbLIpFfM6AmfgNKKsKPvBdLtHdCLbf
	 8TGd9iqclFjmZsaVjiDJCsBQSpn7dayXoYKlma/TJ0RtCysbehvkLBGJz8YL9WZ3LK
	 5Jo00kVTC8n1nP5kNPpJ8FZSW9TzBytF9UMY+Fsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	Chung-Chiang Cheng <cccheng@synology.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 5.10 063/379] btrfs: tree-checker: fix inline ref size in error messages
Date: Wed, 21 Feb 2024 14:04:02 +0100
Message-ID: <20240221125956.776359261@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Chung-Chiang Cheng <cccheng@synology.com>

commit f398e70dd69e6ceea71463a5380e6118f219197e upstream.

The error message should accurately reflect the size rather than the
type.

Fixes: f82d1c7ca8ae ("btrfs: tree-checker: Add EXTENT_ITEM and METADATA_ITEM check")
CC: stable@vger.kernel.org # 5.4+
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Chung-Chiang Cheng <cccheng@synology.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/tree-checker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/tree-checker.c
+++ b/fs/btrfs/tree-checker.c
@@ -1334,7 +1334,7 @@ static int check_extent_item(struct exte
 		if (ptr + btrfs_extent_inline_ref_size(inline_type) > end) {
 			extent_err(leaf, slot,
 "inline ref item overflows extent item, ptr %lu iref size %u end %lu",
-				   ptr, inline_type, end);
+				   ptr, btrfs_extent_inline_ref_size(inline_type), end);
 			return -EUCLEAN;
 		}
 


