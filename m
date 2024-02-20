Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4371F14F9DA;
	Tue, 20 Feb 2024 21:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462920; cv=none; b=YtsARKg//rhUaK6g9hNfn9SZyIeTWiM2Ij/qihvaWFI/BM1/bwLcX+wmcN4Sg+Cy6TCzm8zE88v2HvKimDLZ413Q/iJZ9m7dF6WuK0AcM9hYIIA1VBIJBnrjcfgEnXCHpf0SzDdnCOktG5qPv0wTyo16+H0UYug8ut4y5x1WP1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462920; c=relaxed/simple;
	bh=qbiqHUSPjE8IsFFPy8vQN/fZ7UqzWHsEBirI07rma+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c05CruWqGUgrIlp0BP8Iyy5WV60Ip6ceeaTD85gI+B+9vmladNmxADCuWt8pxVRVSGvK96za8eY+e4jQsJ31o4C0kN1s4k0umjb4M4mL4pbHyQS0vs1LEPBQEHpfLySDGtn/h5uYZC+w0onID7UNiGqFeL7O64tEBonVOF56ZY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RkJ81ZSe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RkJ81ZSe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6427C433F1;
	Tue, 20 Feb 2024 21:01:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462920;
	bh=qbiqHUSPjE8IsFFPy8vQN/fZ7UqzWHsEBirI07rma+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RkJ81ZSe4WD+0PF/ZdJXBOKTfzvZ5JqxJFwErykoXs8DYL3y5ix2WhLSR4jvgxgqb
	 cfFdFjNd7buhttJWTtkYWJfmIe4po7GVLQBVW4j6xhlwHhk8hfdEzXVoGgkVo/NDRG
	 sc3SEpfjindV3InWl6yUfDvjuLKIb1BYb6/bRTuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.1 079/197] firewire: core: correct documentation of fw_csr_string() kernel API
Date: Tue, 20 Feb 2024 21:50:38 +0100
Message-ID: <20240220204843.450877215@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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


