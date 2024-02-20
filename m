Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D597F152DF4;
	Tue, 20 Feb 2024 21:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463704; cv=none; b=pvhrtLIfr9zSrgvNmrgbw3h2wed7vkunQ+AaDkqsqGEtDlcdval6QBsr/KZCzyqbbEZTH5tUW9yCVak6Zu/YDhcAWRZa82tjWUXlDwDdt4QjIBsONLsXsNdnLypAN2dLZ7Y0WtG3xGiG1ulhdJ+uJCVhC2p/8Rz0G1jnFyLWrrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463704; c=relaxed/simple;
	bh=Wk/vea82LoD1TToJfYXtnX3HTy+8flk17rlBskL/W/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBV/cEOIrz4aV6pgS8DhVicKSswCZOgQEw19G8G6vC12dDxFTWwEOVGO0RGc5+OJhkyy4vmPGLhhS3h6atdMyEDvuvHEk+0obVVwjhj2HZ8R9yj1N86ObYaVFTMr/moNzNwyYdrA1HK/nQ+gTMzA6KHVq/lLa6+sN2Gl0NYmPTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dtI/sw/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dtI/sw/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C98C43399;
	Tue, 20 Feb 2024 21:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463704;
	bh=Wk/vea82LoD1TToJfYXtnX3HTy+8flk17rlBskL/W/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dtI/sw/tjtTb/oNK1h8CB+T6FIsclO5+a1rBg5cSi9f9Z4D3NHOHXQSsJW37Rhozf
	 IYpp1UQfRTEk8LWtv1izU8Cey3Ag5L4+VICfBWVVWZU+G0fnR95gSBXVIJA1SdGi+u
	 u/lRvgTyPrL++OcIUfZfXP44anUO3snU+qwgYoJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.6 127/331] firewire: core: correct documentation of fw_csr_string() kernel API
Date: Tue, 20 Feb 2024 21:54:03 +0100
Message-ID: <20240220205641.579449131@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -100,10 +100,9 @@ static int textual_leaf_to_string(const
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


