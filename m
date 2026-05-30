Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ACC32BF24;
	Sat, 30 May 2026 16:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160294; cv=none; b=m29OUTXvcEJNBlVvfsCg1ua8VZKJmK7fCE8tkvp14NQIfU8BvkUJKemTbsA6vjs9pBofl3B8oj8Po6sZChytmGS9XMHKchpkJLk7CLUYD7SdSg01kGyI4xiNJG2Avb9anNO8qGCs9blsYbb03gJ6ryz7dLn3CcKut95QgOQ7cCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160294; c=relaxed/simple;
	bh=dSOdgsOkONxHcQTSWM8YMBMFwO5Efj6kVSiAz3x8tII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPCOSVOJe4TrTBHk/IerNtqelU51DDACpFqSIKt44AdlDnAHqsyea7ydFTw3mI4vKzkjeppEEJeSfTm4fIqZmdgjBgx9dPMEsy7alxA9Z6S9kkxA5qOf31+jaEuxrjwwNBguzIlMVklNq+0pOvworLmbn57+LHalZ3wQx742PFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=shRupaLc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="shRupaLc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577241F00893;
	Sat, 30 May 2026 16:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160293;
	bh=hcLLBOvbNIduBOPTdK+/n9xVWm6mtOTDLXEwUEJYTSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=shRupaLcswz/n12Zy1naUrgWbbbgfJkqGui2GmXbwQ0jDBYxyKtjoCxsEvTN8Mhwb
	 F+D4XeLjvbptzUK2J+F1u1Ls3Dqv6NCeGz6BcCj8045Zn9AUEGRHaQCA45tZHWTWq3
	 waxPI8elF/ioIlqQ1ayvbofNU3/eLBlhLem+vURk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Douglas Anderson <dianders@chromium.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.1 271/969] driver core: Add kernel-doc for DEV_FLAG_COUNT enum value
Date: Sat, 30 May 2026 17:56:35 +0200
Message-ID: <20260530160307.960718699@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -465,6 +465,7 @@ struct device_physical_location {
  *
  * @DEV_FLAG_READY_TO_PROBE: If set then device_add() has finished enough
  *		initialization that probe could be called.
+ * @DEV_FLAG_COUNT: Number of defined struct_device_flags.
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE = 0,


