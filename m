Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743897BB02;
	Wed, 21 Feb 2024 13:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521684; cv=none; b=T27P9emOPD86vAoYfp4mdhHMpdhT97JbZploZOGknXq6W/oQmMPRT6YpN/JMbVFwEZdpStdbwEUnM5L6divqVTuH5aWyx3xFAjub6V3ylNOV01mJnSrl/O0wgz1gWrOacAVzWbwLnGu1rE5B5ZR2aN2tA5RgQ6aXUjCi/B9LTtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521684; c=relaxed/simple;
	bh=9YHTKauxD/edZYNeXR2I0jEEeMooEc7sdLULlQKoMIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNY/SX4CKtgu8ca0zpYdA0j+xZ7gFrJ30j/N7HWE/7PV956D9aefYSmeYezwug5bQOrA1mzGDciPXqNAN/Az2ReEmZbTQYw1npN3frq6za8x/YPhyRso3PB75ceMm0bT9Fb/PxkJCYIt8giELP4hDSYnTE6OeSdiuwsiZJIuEwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSC9lCha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSC9lCha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A82C433F1;
	Wed, 21 Feb 2024 13:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521684;
	bh=9YHTKauxD/edZYNeXR2I0jEEeMooEc7sdLULlQKoMIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qSC9lChaa/tX4zuPzz642fxpD2eCqfUQgR1vc1DXv/G/p8N48S4XGkh7KsoqCBtd2
	 F5nPkau/eq+NeD0LhXjjqw9Ni7mu0o19zMQKPnact/beaH8iPZPY0OJ0bvjKfvIoVk
	 XavCwlzmcQfjYl5gEtAJqDsqlUNmPmQSj4ZM6FkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 4.19 180/202] firewire: core: correct documentation of fw_csr_string() kernel API
Date: Wed, 21 Feb 2024 14:08:01 +0100
Message-ID: <20240221125937.642506619@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit 5f9ab17394f831cb7986ec50900fa37507a127f1 upstream.

Against its current description, the kernel API can accepts all types of
directory entries.

This commit corrects the documentation.

Cc: stable@vger.kernel.org
Fixes: 3c2c58cb33b3 ("firewire: core: fw_csr_string addendum")
Link: https://lore.kernel.org/r/20240130100409.30128-2-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/core-device.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -113,10 +113,9 @@ static int textual_leaf_to_string(const
  * @buf:	where to put the string
  * @size:	size of @buf, in bytes
  *
- * The string is taken from a minimal ASCII text descriptor leaf after
- * the immediate entry with @key.  The string is zero-terminated.
- * An overlong string is silently truncated such that it and the
- * zero byte fit into @size.
+ * The string is taken from a minimal ASCII text descriptor leaf just after the entry with the
+ * @key. The string is zero-terminated. An overlong string is silently truncated such that it
+ * and the zero byte fit into @size.
  *
  * Returns strlen(buf) or a negative error code.
  */


