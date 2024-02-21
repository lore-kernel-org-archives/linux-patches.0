Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F1F69942;
	Wed, 21 Feb 2024 14:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524766; cv=none; b=cH02evgdgg5ShFHZekURpepI3dQGgfGbS0uBvqo2KCuPZNXobF/fzX4A8JHG3T/U5stuXvTBzNYXOexae3lIJuUZSjhgiE9LN3lYvHwJj3FI6QKHUzPRwE7q7m/uMQaENENwQoxwv5B5OVlYjYIrqEU1dilgTm0nZIqF0gxB+zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524766; c=relaxed/simple;
	bh=yG6RRrJMZRYLCWTGFysbI3Dh282Bz+3LnYzQxQKGmkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsnO5+WVwh6sjiTwSJ+g+11aH/4LXjfV69n+df5ZBGIDAxDRxE62/2U+vOS+fHvwc0na880CuH6piv4Wu5M8q6Et3AFYOYXvWnlwF8CMkGg4xyd41H6auAT0BTpJ6KGtowgWZEfPFg7YVJ4DBZyE3vN6zG/CLhbCrkUccl5E62g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbMGhC7p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbMGhC7p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61A2C433C7;
	Wed, 21 Feb 2024 14:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524766;
	bh=yG6RRrJMZRYLCWTGFysbI3Dh282Bz+3LnYzQxQKGmkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbMGhC7pxmZmYOEgyUhmtrJYl7T3l11wCUZJXH1abslT839EbNpBo05mZtYDa107e
	 yggX5EQm4d/qm3zlLVeSUTx/sdK2E7NrIosVX3BqH8GGrWvYEpRbp1JhmWPUNCv3m/
	 eY8+zOD/+FUg25N3w4d0RQlITqX0HurnGcxnkLeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 5.10 313/379] firewire: core: correct documentation of fw_csr_string() kernel API
Date: Wed, 21 Feb 2024 14:08:12 +0100
Message-ID: <20240221130004.182702999@linuxfoundation.org>
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


