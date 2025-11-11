Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AE526E703;
	Tue, 11 Nov 2025 01:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823054; cv=none; b=ZfUqqc8V4TutpH2BaCcqqQ6WY/FXnR/FlWLD6mM04LH4reGi+ZTT/2SVlHMkxjVJwTY11HHmX1pSQGdWO5ZKwR6ByCiWimPuanumxcZ7Rp6bWSTfzzQru39hkfYT3762nxePEFOalLF7oX/cECZYThlU22+fZ4V+PbG8xZtCosQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823054; c=relaxed/simple;
	bh=GbQX32j92UdVHxDE0m1f8+ensratgMT6qazyzZzL/zI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lC2GQOy/KrREgQaYpGL7Cfpc4ckrk9rff2nRa6eUCI615emkBj+QJNdwqP+xyOCpzfhauVHTpR/hLMgV3WKXJFVK4CqJeJiABI4kGgSzwSXx2Rv9mQgqQjXbuUVA+bu8h+8Qgj5tIQ4oqsqIpWm2bVfpBkd5XgW0n6Ka78G+DT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sqpisoNb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sqpisoNb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF2E3C19424;
	Tue, 11 Nov 2025 01:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823054;
	bh=GbQX32j92UdVHxDE0m1f8+ensratgMT6qazyzZzL/zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqpisoNb2/qkjTaLZiN61TtQUr9k26QSzwhFwr++FmDqg4vPrhSYnlmz7vMC1arkE
	 Gxlbtox0HMHcwr3oI8nzkzyetDUPuthrDsJGxd8BDvywFg722KWfX/7pugJC0jXD7r
	 zNMY3flbjsxvEIMBAejrTqzZM8PyPW9M+4ipsVUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Stuebner <heiko@sntech.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 222/849] mfd: qnap-mcu: Include linux/types.h in qnap-mcu.h shared header
Date: Tue, 11 Nov 2025 09:36:32 +0900
Message-ID: <20251111004541.810904936@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 5e1c88679174e4bfe5d152060b06d370bd85de80 ]

Relying on other components to include those basic types is unreliable
and may cause compile errors like:

../include/linux/mfd/qnap-mcu.h:13:9: error: unknown type name ‘u32’
   13 |         u32 baud_rate;
      |         ^~~
../include/linux/mfd/qnap-mcu.h:17:9: error: unknown type name ‘bool’
   17 |         bool usb_led;
      |         ^~~~

So make sure, the types used in the header are available.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20250804130726.3180806-2-heiko@sntech.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mfd/qnap-mcu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/mfd/qnap-mcu.h b/include/linux/mfd/qnap-mcu.h
index 8d48c212fd444..42bf523f9a5b0 100644
--- a/include/linux/mfd/qnap-mcu.h
+++ b/include/linux/mfd/qnap-mcu.h
@@ -7,6 +7,8 @@
 #ifndef _LINUX_QNAP_MCU_H_
 #define _LINUX_QNAP_MCU_H_
 
+#include <linux/types.h>
+
 struct qnap_mcu;
 
 struct qnap_mcu_variant {
-- 
2.51.0



