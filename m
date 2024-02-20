Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A5E446C9;
	Tue, 20 Feb 2024 21:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464798; cv=none; b=X4qBYBA2414OKamHkFM3e7hecYKoUAb65xkyHALDFpRYY8uHgduGes2xneWP24aU63lNIiMTsooqZpirHrYfI1uxArxH1/FqGRqzmt6V0TtF0zClWWxJONk6b9RE1UDCVyRPJS1N31u6nNxzjnH5CA1q2si0Qchze4LxJDbjuI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464798; c=relaxed/simple;
	bh=hCmlTC2fFGLAV0JTau1BOww7ptjjKkHEufYQ08pSUgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+k2VWW3NpTbURdktmKYh4cvYJuam56v91yGQ+d3xGB1KQfYu2FTNYTLq8DNmhi0ytowfciQjwhRpCLeA0I+2D/ZdmrHWTjOjavyjBYhc4UgeI93V8wJ+1coCXOSl+C7qRN8QTKPrTaeMvBHWVSHRA2zARRvuqNnxAQVPSNLgrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqX5Ufaj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqX5Ufaj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D27C433C7;
	Tue, 20 Feb 2024 21:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464798;
	bh=hCmlTC2fFGLAV0JTau1BOww7ptjjKkHEufYQ08pSUgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqX5UfajOaj3O36QBG7RKfpBBheIe1tQ+v8icMRnT4yy/CRqsQaXfBzMy6h88XQXj
	 9525OAtFOH//wOoz4+lxhKa237kVQ2UOLohOoXSTxOlsaX5uaLAW5CdXy4BcjeCZcI
	 /LfQfu3D4n4ZoJJUnwpeYabgLu00bwV9LARIeqOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.7 141/309] firewire: core: correct documentation of fw_csr_string() kernel API
Date: Tue, 20 Feb 2024 21:55:00 +0100
Message-ID: <20240220205637.560951453@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


