Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABF13C277F;
	Sat, 30 May 2026 18:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165840; cv=none; b=cIOUKE3fJtEPpS5jpMG/IOJsnOb1uNRPb4kwCcQVSCg6gUao8XGqI8F54I6ORyfrAhUNdns34PsxZqjTQMu6lBzWqcKwW533hsb/ut/RZhnTYOhQ2WXvQMYgAklN1W2//9xypGw4OH7gGOmg8eB9AUCPUHxEoJH+/1f5DgbeG0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165840; c=relaxed/simple;
	bh=6C2ET5+hU8/kuNYRKdMZOIJjo1LZBehjsbmsWRahkOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGZZ/MIs7LmHou2tyuuWq2si5oadPFNsoRCqgveHhol3KdoJlT+waNkSBala8HKd5xfgcowMg9tJ07i42JGC9WhT9QcfEqizveGuixFHDQLTU/eoys+G8owtEmCGggbtSYQgv9fo+pnyqzC+EPNCYBQfuDTQp+QU5oM12a5ZkT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Htgkf1q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Htgkf1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB6E1F00893;
	Sat, 30 May 2026 18:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165839;
	bh=SW9astYTSrEqMUYR1Tn2nS1IVfHCG9/1iyNGUFDwT68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Htgkf1qFwXB5TPMeGKk6PMi+S3tlohshNo4ArLtC5+WzJmgkJ8KbAQ5AysG2SM6X
	 +ZLhALEIpV/imjB4PENkk+YgOH5NqL04nhGc60qUr0ARarXzeZQwzvFv2qFNtmaHwu
	 sWZmLtnVkbI8uMXZ0noiaytT9uadQfwUzgcwHN7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Douglas Anderson <dianders@chromium.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 5.10 197/589] driver core: Add kernel-doc for DEV_FLAG_COUNT enum value
Date: Sat, 30 May 2026 18:01:18 +0200
Message-ID: <20260530160230.087528869@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Douglas Anderson <dianders@chromium.org>

commit 5b484311507b5d403c1f7a45f6aa3778549e268b upstream.

Even though nobody should use this value (except when declaring the
"flags" bitmap), kernel-doc still gets upset that it's not documented.
It reports:

  WARNING: ../include/linux/device.h:519
  Enum value 'DEV_FLAG_COUNT' not described in enum 'struct_device_flags'

Add the description of DEV_FLAG_COUNT.

Fixes: a2225b6e834a ("driver core: Don't let a device probe until it's ready")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Closes: https://lore.kernel.org/f318cd43-81fd-48b9-abf7-92af85f12f91@infradead.org
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Reviewed-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://patch.msgid.link/20260413195910.1.I23aca74fe2d3636a47df196a80920fecb2643220@changeid
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/device.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -393,6 +393,7 @@ struct dev_links_info {
  *
  * @DEV_FLAG_READY_TO_PROBE: If set then device_add() has finished enough
  *		initialization that probe could be called.
+ * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE = 0,


