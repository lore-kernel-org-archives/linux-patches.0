Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9211B395F;
	Mon, 10 Mar 2025 18:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630996; cv=none; b=UJ8KkXXnzwal3/CS0TYt7Jpth4A+jPGK9FPCowANDEdSGeFQ2nXZnC5X5EL4ywgrfld1HbVE40m6idIaaviuQ3qm0ae/uyXP1p9f+19s+ZjPLYc60gPYMOlA+8qaUZIxtn/FPOGJW/qItwEcdZgc+zbNn+D8++C54Ew83t3IsZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630996; c=relaxed/simple;
	bh=o/qSWwZPaIGOrXWNvB68O65vpC2Pu34qBrir1/gEwt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1SCSocRpl51k86vN3WGQNxYKh517PZk6Zp2KH1AoOmudzM24todXDdPNDJweC2nIimH2KBgDcBh8RbgwG0kd0VBU4DlhuIDkk9wlsMC3fy++BPsWMzxEvBSYrFKUDnO0R10T3IzQIrbFgineSJu6t9Brjc220oIq42sqMTTSi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dREs0a8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dREs0a8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F88C4CEE5;
	Mon, 10 Mar 2025 18:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630996;
	bh=o/qSWwZPaIGOrXWNvB68O65vpC2Pu34qBrir1/gEwt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dREs0a8/Tibxk8Zx9krUWQT8HPv0aMBhVOS9V5T9Mgga3E12ZCC18jeEdkwXhrs9H
	 sA8Vklpv/hRsEmHxrHL0I5Aa+47Lx3gj2n929LYDjzsGkVIutd8c9iGs5QiGsgDH6u
	 OvzSNy3wdVodm4ZgvVvoot4tN4ntwhqsISYULMjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Song Liu <song@kernel.org>
Subject: [PATCH 5.15 607/620] md: select BLOCK_LEGACY_AUTOLOAD
Date: Mon, 10 Mar 2025 18:07:33 +0100
Message-ID: <20250310170609.490012176@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: NeilBrown <neilb@suse.de>

commit 6c0f5898836c05c6d850a750ed7940ba29e4e6c5 upstream.

When BLOCK_LEGACY_AUTOLOAD is not enable, mdadm is not able to
activate new arrays unless "CREATE names=yes" appears in
mdadm.conf

As this is a regression we need to always enable BLOCK_LEGACY_AUTOLOAD
for when MD is selected - at least until mdadm is updated and the
updates widely available.

Cc: stable@vger.kernel.org # v5.18+
Fixes: fbdee71bb5d8 ("block: deprecate autoloading based on dev_t")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/Kconfig |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/Kconfig
+++ b/drivers/md/Kconfig
@@ -16,6 +16,10 @@ if MD
 config BLK_DEV_MD
 	tristate "RAID support"
 	select BLOCK_HOLDER_DEPRECATED if SYSFS
+	# BLOCK_LEGACY_AUTOLOAD requirement should be removed
+	# after relevant mdadm enhancements - to make "names=yes"
+	# the default - are widely available.
+	select BLOCK_LEGACY_AUTOLOAD
 	help
 	  This driver lets you combine several hard disk partitions into one
 	  logical block device. This can be used to simply append one


