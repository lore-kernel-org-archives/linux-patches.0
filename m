Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E36E1DF258;
	Tue, 11 Nov 2025 00:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822370; cv=none; b=AUp8nvVj1XkEtuXnnGcMBZNfHuuFdgb3xplK/iHxHDkTdCieo/dwCniMfh+9Td93dEuyo0aNS8yVfw1MYN46+Fai8YiqnfZTaOlYpoQdKKN+u1w9EPrdMtD9t3VYr4BPo8hu9JizFWQEiht5pcAtulRIAm3eEOQ2RPlh7EThGIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822370; c=relaxed/simple;
	bh=w2xmTnw6AY+hXemi7IJDnzkN17N2v+LQmgMnP46c5l8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ed6CcdzE5ow0tYByHVVVKAmNgzUZ3PaYWttBiUuH4B+LNR9QJAVM9aHHz3qKDJcGMJUwv8lEw//V6hqhMgSDm5nVLhXxlmlgmKA9nSmhGa2VSaYvBiZeGvQ/H44s1HsJd7I/LiK3aa2+/NKFFDXHB2tyOcr18NuVDKR74IfuWyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rAlPBAyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rAlPBAyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47D70C4AF09;
	Tue, 11 Nov 2025 00:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822369;
	bh=w2xmTnw6AY+hXemi7IJDnzkN17N2v+LQmgMnP46c5l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAlPBAyHMhIofhQXsAfzyexFB+XFJlNOJD2YbMcNVFTGFVYdxQmh2KWYIgzpkSvXe
	 PBs0OARpR7EGfK0CjUid4QkAG1xVhWk3YeZsnKib8FzyCC7QvDKVmeyVzIzAy54eaM
	 c6/Jl5T9O28HtNstpS9lZInu9lZQ6V/8hxFcXjbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shawnguo@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.17 094/849] regmap: irq: Correct documentation of wake_invert flag
Date: Tue, 11 Nov 2025 09:34:24 +0900
Message-ID: <20251111004538.684457266@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawnguo@kernel.org>

commit 48cbf50531d8eca15b8a811717afdebb8677de9b upstream.

Per commit 9442490a0286 ("regmap: irq: Support wake IRQ mask inversion")
the wake_invert flag is to support enable register, so cleared bits are
wake disabled.

Fixes: 68622bdfefb9 ("regmap: irq: document mask/wake_invert flags")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Link: https://patch.msgid.link/20251024082344.2188895-1-shawnguo2@yeah.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/regmap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/regmap.h
+++ b/include/linux/regmap.h
@@ -1643,7 +1643,7 @@ struct regmap_irq_chip_data;
  * @status_invert: Inverted status register: cleared bits are active interrupts.
  * @status_is_level: Status register is actuall signal level: Xor status
  *		     register with previous value to get active interrupts.
- * @wake_invert: Inverted wake register: cleared bits are wake enabled.
+ * @wake_invert: Inverted wake register: cleared bits are wake disabled.
  * @type_in_mask: Use the mask registers for controlling irq type. Use this if
  *		  the hardware provides separate bits for rising/falling edge
  *		  or low/high level interrupts and they should be combined into


