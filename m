Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E37315785;
	Mon,  4 May 2026 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904357; cv=none; b=GcxmRMU83CRbJNtCnanlO4eHUZlx8dPLP3vVrRj7+J3XXQMKqu/EuaDEbx6DI8cJnRFm+u4udDRwasQnSgaZWLsGfqgspA99tA4pZHPeQtLD+sXN/U30GBOQlxPe6xAv7JkMGVtGRGUpuoN5kJHqEBTDFFEhTXN2iyDhMyyMqgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904357; c=relaxed/simple;
	bh=4ZQ+QUpgs6mmqYuE94NQEBzCDkR9Asdx397Kc3tI16s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzoDjC75MSzSgf/R3QOOeCVafqZUqMmufnWuRZoaZMVLrKDs2sAPZvgW6LGthiJsvHdtsFufZctcfYvPG5IujojQrPUZbW6B4yFWyvD12NUId9+bEC5aGre+P/R+/GVwFZ9QfX6Y3vI6snwFuRXjMOP84nKm7Df6UOSuhmf5nYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tsPURPC1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tsPURPC1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D616C2BCB8;
	Mon,  4 May 2026 14:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904357;
	bh=4ZQ+QUpgs6mmqYuE94NQEBzCDkR9Asdx397Kc3tI16s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tsPURPC10D1fJddXCTzdajCM/QD4T8AMDKZtzKSIjnd36IW8kM0ub8YZu1zFtyin9
	 PlZGPWDau44EOcA/lcKPe4IWF6X/ogBNl1eaVDbLG5TXBhcTIY6RkR5bBHLMJmgQvQ
	 jzu0r6VoeufcRNw+AlrQ19Y7ghe/VpMTz9ydkyUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Douglas Anderson <dianders@chromium.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 264/275] driver core: Add kernel-doc for DEV_FLAG_COUNT enum value
Date: Mon,  4 May 2026 15:53:24 +0200
Message-ID: <20260504135152.848886929@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -485,6 +485,7 @@ struct device_physical_location {
  *
  * @DEV_FLAG_READY_TO_PROBE: If set then device_add() has finished enough
  *		initialization that probe could be called.
+ * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE = 0,


