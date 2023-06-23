Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE220D524
	for <patches@lists.linux.dev>; Fri, 23 Jun 2023 17:06:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B637C433C8;
	Fri, 23 Jun 2023 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687540017;
	bh=WwUAoDe1qGuOfw155KXTYh/KRnfqrV4XWxHYNAtmomk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LcGp9wcOQaQm7BPBHgU7IPqII4NTvhH6O8SwQYB+lxMj4Lwb7CKkLsMFYdHyOsqzn
	 3IQyJMWLW9O5TQqJTRt3F1FYd1I/DndkoSyHDntXIQZPmUVTUa00wxqsm0ZZmjSkCb
	 tinVjh2R0tRpVTYyk0/xkzKOs5gdAR3WXmspLNj8=
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Date: Fri, 23 Jun 2023 13:06:37 -0400
Subject: [PATCH WIP v2 1/2] README: rename Linux to Lunix
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230623-test-resend-prefixes-v2-1-72becbfc3fb1@linuxfoundation.org>
References: <20230623-test-resend-prefixes-v2-0-72becbfc3fb1@linuxfoundation.org>
In-Reply-To: <20230623-test-resend-prefixes-v2-0-72becbfc3fb1@linuxfoundation.org>
To: patches@lists.linux.dev
Cc: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
X-Mailer: b4 0.13-dev-87aac
X-Developer-Signature: v=1; a=openpgp-sha256; l=428;
 i=konstantin@linuxfoundation.org; h=from:subject:message-id;
 bh=WwUAoDe1qGuOfw155KXTYh/KRnfqrV4XWxHYNAtmomk=;
 b=owGbwMvMwCW27YjM47CUmTmMp9WSGFKmXtSfdvKXg2jOw+VFNaYpYfny1kaar622fTDc1R93P
 9TUpii6o5SFQYyLQVZMkaVsX+ymoMKHHnLpPaYwc1iZQIYwcHEKwESeZTMyvN30/lWPfJSYTOqB
 3S8Vcmb86eVYJ7llRsTFGWneDeducDEy3HeNsGt12PXKWCYm9FIh16PIv/HWPwUPL22WsMn52vC
 PCwA=
X-Developer-Key: i=konstantin@linuxfoundation.org; a=openpgp;
 fpr=DE0E66E32F1FDD0902666B96E63EDCA9329DD07E

Test commit, please ignore.

Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
---
 README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README b/README
index 669ac7c32292..c482329b5b58 100644
--- a/README
+++ b/README
@@ -1,4 +1,4 @@
-Linux kernel
+Lunix kernel
 ============
 
 There are several guides for kernel developers and users. These guides can

-- 
2.41.0

