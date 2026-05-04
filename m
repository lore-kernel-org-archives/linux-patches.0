Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E98453D905D;
	Mon,  4 May 2026 14:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904897; cv=none; b=a1scQ1FVhR4OX508l6nZ4YfjxvPadENWQy6r4AYU97UzjZXtb61LDS+Ujrjaz8RHFoOjeAi78K373Lpbe8aFEJEIKG7SLXkf/GXpQ8IvrmK4H4Q/cLVLymQgu+XgjjKxtdpJwMegjnMCmBQLlguo6VEi1JTGpgWbdD8BMFIzBkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904897; c=relaxed/simple;
	bh=TpU+DYM9HfbyjI3USgPfD+/Snccb1z3EfriDArBMZy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF1P8NkKNhWZq4j7nuwduprVXup9R0TjqNI4dCqr8lSNGfIxOyED8QQjnJpgbpDoOi64CINb7flfAPhwlUAJY7rfaBCHp9a6ZVWTFP56ZrEwK8MPtbXzdfAhuzjWzMoWruj/Xcai3QeggVqwG5TZf7TzmLuxL6m1u0vG5a1m3QU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iSOiB2FQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iSOiB2FQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CC9C2BCB8;
	Mon,  4 May 2026 14:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904896;
	bh=TpU+DYM9HfbyjI3USgPfD+/Snccb1z3EfriDArBMZy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iSOiB2FQPlbVfkl4s8oToH1eW+N7XsvMvj0KUBID1bOaITcq12F9KvC6Gcl8sQbR3
	 aTJ+r1QIJRuP5mmQ10nJ0v9ORut91XEVsALzSLZsVhUH9pKY0zWO+rA4EqKJdddA7M
	 uINTOqH10cnG3DyrHQeypQL8EEKRyYXV0Uu8+KCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Douglas Anderson <dianders@chromium.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 207/215] driver core: Add kernel-doc for DEV_FLAG_COUNT enum value
Date: Mon,  4 May 2026 15:53:46 +0200
Message-ID: <20260504135138.378131810@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -507,6 +507,7 @@ struct device_physical_location {
  *
  * @DEV_FLAG_READY_TO_PROBE: If set then device_add() has finished enough
  *		initialization that probe could be called.
+ * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE = 0,


