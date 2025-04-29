Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C29224234;
	Tue, 29 Apr 2025 18:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950775; cv=none; b=Dprgikj5OSsHbOYmx3mHHkDQR3rLnuheoGzuuIs3Ppg3cF7N0QiCYgFyhmjq8MmAGr11Qqhi7ZoTCvvH18A1vkfikinqrpi18zKVLOf4viiPP3aIyYZariywCus7nKCl915rH6uA8lCAIwTodmLigMFCfYUZrocoaV1gQ0s9KyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950775; c=relaxed/simple;
	bh=edBKqXEMKe+AXAxSs3PWMpNe8qM+/bXqO94wTB3i4Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qag8szq8amnaw6t3Rw/hn2suJ/FhenBmIKb1OJsHcnpxQFwlFVGpPIqMOVsArluMs4JNXsaUdqTFUpHtHqAaB8v8qBdsPkA1DWF5ThLGM0qlAYCSJQUHwNYlvWyVzn6IMimW66fNPxJzt8K/OicKgGLwK5bJ2rxNO8FGKQ/QvUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MlvsmFc2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MlvsmFc2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C166C4CEE3;
	Tue, 29 Apr 2025 18:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950775;
	bh=edBKqXEMKe+AXAxSs3PWMpNe8qM+/bXqO94wTB3i4Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MlvsmFc2serMWZ0A5VwrMXT6cFfG0L7Szap0GzibTLD+fJ83sDw21YOTlXjMni7cQ
	 /DXqPotIldFu/gZccwK6ZRCJw//PBrerzkxcKbS1XBufpVyaEZmDrvCmxyW+noxviY
	 Snd6K16EC8fWTT0TsDxT1u8ehuE31UBEwWlZl0Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.6 201/204] MIPS: cm: Fix warning if MIPS_CM is disabled
Date: Tue, 29 Apr 2025 18:44:49 +0200
Message-ID: <20250429161107.603439074@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

commit b73c3ccdca95c237750c981054997c71d33e09d7 upstream.

Commit e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
introduced

arch/mips/include/asm/mips-cm.h:119:13: error: ‘mips_cm_update_property’
	defined but not used [-Werror=unused-function]

Fix this by making empty function implementation inline

Fixes: e27fbe16af5c ("MIPS: cm: Detect CM quirks from device tree")
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mips-cm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/include/asm/mips-cm.h
+++ b/arch/mips/include/asm/mips-cm.h
@@ -104,7 +104,7 @@ static inline bool mips_cm_present(void)
 #ifdef CONFIG_MIPS_CM
 extern void mips_cm_update_property(void);
 #else
-static void mips_cm_update_property(void) {}
+static inline void mips_cm_update_property(void) {}
 #endif
 
 /**


