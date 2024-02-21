Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A8078B60;
	Wed, 21 Feb 2024 14:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525657; cv=none; b=ZVlWkbccYvqxzzXa/Qy/rlofYp/hooo09CqDoVRWDEE1orqPl4uzQeVbN8Cmkd8qLainrb7MlDKusc2DYJ3lwqXG3W1pQIFvyXX37v3qQ1rcjCexCue05Mtk5Y/N+fpYkk0xfq+PFv+8l8fBf5awZ05eCwNQTrcRnSD27MA/bH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525657; c=relaxed/simple;
	bh=uiRoZuQCN+CiOVN+FsFrh6BPRy5HnQQk+tbCzE0GDSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+c1a/R2ThPiGQAG0oCCflvLfuKhnhgFqy2eqI+ThP3zZD+RPenvLeShnkh265hmEmvXyNYXexsdEhuHiCdCW5fkQYVn3ODV5rNZmfj3a2bcWZ6sDgAgb74RfTY1beTXHOJHapbCpkGD2iGlN21yPxnZJDyi6aNj/U7GJvwLzG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zh6bJAuv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zh6bJAuv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4FDC433C7;
	Wed, 21 Feb 2024 14:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525656;
	bh=uiRoZuQCN+CiOVN+FsFrh6BPRy5HnQQk+tbCzE0GDSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zh6bJAuvBUybTweycWCD0g+B7p3K1Ytj6Pu5oIdgObor6nUmpQnzqznoXpuhyN/m2
	 BrpJZRa8R/52MwlCGRZAuXzedwtorPPyZUbRUC3V2BcjhmZL8IVKYALvYcXp9FdyOg
	 MsWtzEmGwAEr3EweOBwIK9jl4d8jvhIIAzVYMY0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 5.4 222/267] firewire: core: correct documentation of fw_csr_string() kernel API
Date: Wed, 21 Feb 2024 14:09:23 +0100
Message-ID: <20240221125947.196736741@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


